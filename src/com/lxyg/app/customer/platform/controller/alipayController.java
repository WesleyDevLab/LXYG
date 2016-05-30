package com.lxyg.app.customer.platform.controller;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonArray;
import com.jfinal.aop.Before;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.jfinal.render.Render;
import com.lxyg.app.customer.alipay.config.AlipayConfig;
import com.lxyg.app.customer.alipay.util.AlipayNotify;
import com.lxyg.app.customer.alipay.util.UtilDate;
import com.lxyg.app.customer.alipay.util.alipayRefund;
import com.lxyg.app.customer.platform.classUtil.OrderPayLog;
import com.lxyg.app.customer.platform.model.*;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.service.OrderService;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.weiapiUtil.WXUtil;
import com.lxyg.app.customer.tencent.common.XMLParser;
import org.apache.log4j.Logger;
import org.omg.PortableInterceptor.ObjectReferenceFactory;
import org.xml.sax.SAXException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;

public class alipayController extends Controller {
	private static final Logger log = Logger.getLogger(alipayController.class);
	private static Shop shopDao=new Shop();
	private static OrderService orderService=new OrderService();
	private static Order orderDao=new Order();
	private static OrderPayLog orderPayLog=new OrderPayLog();
	public void renderFaile(String value){
		setAttr("code", 10001);
		setAttr("msg", value);
		renderJson();
		return;
	}
	
	@Before(Tx.class)
	public void alipayNotify() {
		log.error("支付宝支付");
		HttpServletResponse response = getResponse();
		HttpServletRequest request = getRequest();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			Map<String,String> params = new HashMap<String,String>();
			Map<String,Object> reqMap=request.getParameterMap();
			for(Iterator<String> iter = reqMap.keySet().iterator(); iter.hasNext();){
				 String name = iter.next();
				 String[] values = (String[]) reqMap.get(name);
				 String valueStr="";
				 for (int i = 0; i < values.length; i++){
					 valueStr = (i == values.length - 1) ? valueStr + values[i]:valueStr + values[i] + ",";
				 }
				 params.put(name, valueStr);
			}
			log.error("------:"+params.toString());
			String alipayNo=params.get("trade_no");
			boolean b= AlipayNotify.verify(params);
			log.error(b);
			if(true){
				String orderId="";
				orderId=request.getParameter("orderId");
				if(params.containsKey("out_trade_no")){
					orderId=request.getParameter("out_trade_no");
					Order o= Order.dao.findFirst("select count(*) as count from kk_order o where o.order_id=?",orderId);
					if(o.getLong("count")!=0){
						OrderC(orderId, alipayNo);
						return;
					}
					Record record= Db.findFirst("select count(*) as count from kk_order_activity oa where oa.order_id=?",orderId);
					if(record.getLong("count")!=0){
						activtyOrder(orderId,alipayNo);
					}
				}
				log.error("----订单Id:"+orderId);
			}
		} catch (Exception e) {
			log.error("erroe",e);
		}
	}

	@Before(Tx.class)
	public void alipayRefuse() {
		log.error("支付宝退款");
		HttpServletResponse response = getResponse();
		HttpServletRequest request = getRequest();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			Map<String,String> params = new HashMap<String,String>();
			Map<String,Object> reqMap=request.getParameterMap();
			for(Iterator<String> iter = reqMap.keySet().iterator(); iter.hasNext();){
				String name = iter.next();
				String[] values = (String[]) reqMap.get(name);
				String valueStr="";
				for (int i = 0; i < values.length; i++){
					valueStr = (i == values.length - 1) ? valueStr + values[i]:valueStr + values[i] + ",";
				}
				params.put(name, valueStr);
			}
			log.error("------:"+params.toString());
			String alipayNo=params.get("trade_no");
			boolean b= AlipayNotify.verify(params);
			log.error(b);
			if(true){
				if(params.containsKey("out_trade_no")){
					String order_id=params.get("out_trade_no");
					Order order=Order.dao.findFirst("select * from kk_order where order_id=?",order_id);
					order.set("order_status",IConstant.OrderStatus.order_status_js_success);
					order.update();

					orderPayLog.addRefuseLog(order,alipayNo,new Date(),0);

					List<Record> records=order.getOrderItems(order_id);
					Shop shop =Shop.dao.findBysuid(order.getStr("s_uuid"));
					for(Record record:records){
						goodsService.addProNum(record.getInt("product_id"),record.getInt("product_number"),shop.getInt("id"));
					}

				}

			}
		} catch (Exception e) {
			log.error("erroe",e);
		}
	}
	
	public void wxpayNotify(){
		log.error("微信支付");
		HttpServletRequest request=getRequest();
		HttpServletResponse response=getResponse();
		try {
			request.setCharacterEncoding("UTF-8");
			response.setCharacterEncoding("UTF-8");
			BufferedReader reader = request.getReader();
			StringBuffer buffer = new StringBuffer();
			PrintWriter pw=response.getWriter();
			String string;
			while ((string = reader.readLine()) != null) {
				buffer.append(string);
			}
			reader.close();
			String notifyJson = new String(buffer);
			log.error("notifyJson:"+notifyJson);
			Map<String,Object> map=XMLParser.getMapFromXML(notifyJson);

			if(map.get("result_code").toString().equals("SUCCESS")){
				String orderId=map.get("out_trade_no").toString();
				String wxPayNo=map.get("transaction_id").toString();
				Order o=Order.dao.findFirst("select count(*) as count from kk_order o where o.order_id=?",orderId);

				if(o.getLong("count")!=0){
					OrderC(orderId, wxPayNo);
					return;
				}
				Record record= Db.findFirst("select count(*) as count from kk_order_activity oa where oa.order_id=?",orderId);
				if(record.getLong("count")!=0){
					activtyOrder(orderId,wxPayNo);
				}
			}
		} catch (UnsupportedEncodingException e) {
			log.error(e);
		} catch (IOException e) {
			log.error(e);
		} catch (ParserConfigurationException e) {
			log.error(e);
		} catch (SAXException e) {
			log.error(e);
		}
		renderText("success");
	}

	public void activtyOrder(String orderId,String payNo){
		OrderActivity orderActivity=OrderActivity.dao.findFirst("select * from kk_order_activity oa where oa.order_id=?",orderId);
		if(orderActivity==null){
			log.error("--异常--");
			renderText("success");
			return;
		}
		if(orderActivity.getInt("order_status")!=IConstant.OrderStatus.order_status_chushi){
			log.error("--订单状态异常--");
			renderText("success");
			return;
		}
		boolean ub=false;
		if(orderActivity.getStr("alipay_no")==null){
			log.error("--订单状态修改   正常状态--");
			orderActivity.set("id", orderActivity.getInt("id"));
			orderActivity.set("order_status", IConstant.OrderStatus.order_status_dfh);
			orderActivity.set("alipay_no",payNo);
			orderActivity.set("pay_time", new Date());
			orderActivity.update();
		}
		if(ub){
			renderText("success");
			return;
		}
	}
	
	public void OrderC(String orderId,String payNo){
		log.error("OrderC");
		Order o=new Order().findById(true, orderId);
		if(o==null){
			log.error("--异常--");
			orderPayLog.addPayLog(o,payNo,new Date(),2);
			renderText("faile");
			return;
		}
		if(o.getInt("order_status")!=-1){
			log.error("--订单状态异常--");
			orderPayLog.addPayLog(o, payNo, new Date(),1);
			renderText("faile");
			return;
		}

		boolean ub=false;
		if(o.getStr("alipay_no")==null){
			log.error("--订单状态修改   正常状态--");	
			o.set("id", o.getInt("orderId"));
			o.set("order_status", IConstant.OrderStatus.order_status_dfh);
			o.set("alipay_no",payNo);
			o.set("pay_time", new Date());
			ub=o.update();
			orderPayLog.addPayLog(o, payNo, new Date(),0);
		}
		if(ub){
			renderText("success");
			return;
		}
		return;
	}


	/**支付宝退款*/
	public void alirefuseOrder(){
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
			return;
		}
		if(isParaExists("order_ids")){
			List<JSONObject> obj=new ArrayList<>();
			JSONArray array= JSONArray.parseArray(getPara("order_ids"));
			if(!array.isEmpty()){
				for(int i=0;i<array.size();i++){
					String order_id=array.getString(i);
					JSONObject jsonObject=new JSONObject();
					Order o=Order.dao.findFirst("select alipay_no,price,refuse_cause from kk_order o where o.order_id=? and o.order_status=? and pay_type=?",order_id,IConstant.OrderStatus.order_status_js,2);
					if(o!=null&&o.getStr("alipay_no")!=null&&!o.getStr("alipay_no").equals("")){
						jsonObject.put("alipay_no",o.getStr("alipay_no"));
						jsonObject.put("price",o.getBigDecimal("price"));
						jsonObject.put("cause",o.getStr("refuse_cause"));
						obj.add(jsonObject);
					}
					OrderActivity orderActivity=OrderActivity.dao.findFirst("select alipay_no,price,refuse_cause from kk_order_activity  where order_id=? and order_status=? and pay_type=?",order_id,IConstant.OrderStatus.order_status_js,2);
					if(orderActivity!=null&&orderActivity.getStr("alipay_no")!=null&&!orderActivity.getStr("alipay_no").equals("")){
						jsonObject.put("alipay_no",orderActivity.getStr("alipay_no"));
						jsonObject.put("price",orderActivity.getBigDecimal("price"));
						jsonObject.put("cause", orderActivity.getStr("refuse_cause"));
						obj.add(jsonObject);
					}
				}
			}
			if(obj.size()!=0){
				String resp= alipayRefund.buildParmater(obj);
				setAttr("resp",resp);
				renderJsp("/alipay/alipay.jsp");
				return;
			}
			setAttr("resp","退款异常");
			renderJsp("/alipay/error.jsp");
		}
	}


	private GoodsService goodsService;
	/**微信退款*/
	public void weRefund(){
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
			return;
		}
		if (isParaExists("order_id")){
			String order_id=getPara("order_id");
			Order o=Order.dao.findFirst("select id,alipay_no,price,refuse_cause,u_uuid from kk_order o where o.order_id=? and o.order_status=? and pay_type=?",order_id,IConstant.OrderStatus.order_status_js,1);
			if(o!=null&&o.getStr("alipay_no")!=null&&!o.getStr("alipay_no").equals("")){
				Record r=loadWXconfig(o.getStr("u_uuid"));
				net.sf.json.JSONObject res= Order.dao.isRefund(order_id, r);
				if(!res.containsKey("flag")||!res.getBoolean("flag")){
					renderFaile("退款异常,微信/支付宝 查询不到退款订单");
					return;
				}
				Map<String,Object> resMap= WXUtil.wxRefund(res.getString("transaction_id"), order_id, r, res.getInt("cash_fee"));
				if(!resMap.containsKey("return_code")||!resMap.get("return_code").toString().toUpperCase().equals("SUCCESS")){
					renderFaile("退款失败");
					return;
				}
				/**修改订单状态**/
				o.set("order_status",IConstant.OrderStatus.order_status_js_success);
				o.update();


				orderPayLog.addRefuseLog(o,o.getStr("alipay_no"),new Date(),0);
				/**退款后恢复库存数量**/
				List<Record> records=o.getOrderItems(order_id);
				Shop shop =Shop.dao.findBysuid(o.getStr("s_uuid"));
				for(Record record:records){
					goodsService.addProNum(record.getInt("product_id"),record.getInt("product_number"),shop.getInt("id"));
				}
				setAttr("code",10002);
				setAttr("msg","退款成功");
				renderJson();
				return;
			}

//			OrderActivity orderActivity=OrderActivity.dao.findFirst("select id,alipay_no,price,refuse_cause from kk_order_activity where order_id=? and order_status=? and pay_type=?",order_id,IConstant.OrderStatus.order_status_js,2);
//			if(orderActivity!=null&&o.getStr("alipay_no")!=null&&!orderActivity.getStr("alipay_no").equals("")){
//				Record r=loadWXconfig(orderActivity.getStr("u_uuid"));
//				net.sf.json.JSONObject res= Order.dao.isRefund(order_id, r);
//				if(!res.containsKey("flag")||!res.getBoolean("flag")){
//					renderFaile("退款异常,微信/支付宝 查询不到退款订单");
//					return;
//				}
//
//				Map<String,Object> resMap= WXUtil.wxRefund(res.getString("transaction_id"), order_id, r, res.getInt("cash_fee"));
//				if(!resMap.containsKey("return_code")||!resMap.get("return_code").toString().toUpperCase().equals("SUCCESS")){
//					renderFaile("退款失败");
//					return;
//				}
//				/**修改订单状态**/
//				orderActivity.set("order_status",IConstant.OrderStatus.order_status_js_success);
//				orderActivity.update();
//				/**退款后恢复库存数量**/
//				List<Record> records=OrderActivity.dao.getActivityOrderItem(order_id);
//				for(Record record:records){
//					Db.update("update kk_product_activity set surplus_num=surplus_num+? where id=?", record.getInt("product_number"), record.getInt("product_id"));
//				}
//				setAttr("code",10002);
//				setAttr("msg","退款成功");
//				renderJson();
//				return;
//			}
		}
	}

	public Record loadWXconfig(String uid){
		User u= User.dao.getUser(uid);
		Map<String,Object> map=new HashMap<String,Object>();

		Record r=new Record();
		if(u.getInt("login_ios_inhouse")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "ios", "inhouse");
		}
		if(u.getInt("login_ios_inapp")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "ios", "inapp");
		}
		if(u.getInt("login_android_in_test")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "android", "in_test");
		}
		if(u.getInt("login_android_pub")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "android", "in_pub");
		}
		return r;
	}

}
