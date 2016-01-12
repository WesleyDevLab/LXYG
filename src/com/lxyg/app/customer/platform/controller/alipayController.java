package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.alipay.util.AlipayNotify;
import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.model.OrderActivity;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.service.OrderService;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.tencent.common.XMLParser;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.*;

public class alipayController extends Controller {
	private static final Logger log = Logger.getLogger(alipayController.class);
	private static Shop shopDao=new Shop();
	private static OrderService orderService=new OrderService();
	private static Order orderDao=new Order();
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
			String alipayNo=params.get("trade_no").toString();
			boolean b= AlipayNotify.verify(params);
			log.info(b);
			if(true){
				String orderId="";
				orderId=request.getParameter("orderId");
				if(params.containsKey("out_trade_no")){
					orderId=request.getParameter("out_trade_no");
					Order o=new Order().dao.findFirst("select count(*) as count from kk_order o where o.order_id=?",orderId);
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

				Order o=new Order().dao.findFirst("select count(*) as count from kk_order o where o.order_id=?",orderId);
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
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		renderText("success");
	}

	public void activtyOrder(String orderId,String payNo){
		log.error("activtyOrder");
		OrderActivity orderActivity=OrderActivity.dao.findFirst("select * from kk_order_activity oa where oa.order_id=?",orderId);
		log.error(orderActivity);
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
			renderText("success");
			return;
		}
		if(o.getInt("order_status")!=-1){
			log.error("--订单状态异常--");	
			renderText("success");
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
		}
		if(ub){
			renderText("success");
			return;
		}
		return;




//		if(o.getBigDecimal("cash_pay").intValue()!=0){
//			log.error("--订单有代金券 修改代金券--");
//			Order.dao.updateCash(o.getStr("u_uuid"),o.getBigDecimal("cash_pay").intValue(),orderId);
//		}

//		if(ub){
//			log.error("--订单分单  正常状态--");
//			orderService.pushBySdk(ConfigUtils.getProperty("kaka.order.manager.phone"), o.getStr("order_id"), 0);
//			List<Record> rs=o.getOrderItems(orderId);
//			String str="";
//			for(Record r:rs){
//				str+=r.getInt("product_id")+",";
//			}
//			str=str.substring(0, str.length()-1);
//			String shopId=o.getStr("shop_id");
//			String u_uuid=o.getStr("u_uuid");
//			String wechart="";
//			for(Record r:rs){
//				str+=r.getInt("product_id")+",";
//			}
//			orderDao.createLog(orderId, IConstant.orderAction.order_action_pay,IConstant.sendType.get(o.getInt("send_type")),
//					str, null, null, IConstant.OrderStatus.order_status_pay,shopId);
//			int account=o.getBigDecimal("price").intValue();
//
//			shopDao.createAccount(u_uuid, wechart,orderId,o.getBigDecimal("price").intValue(), o.getBigDecimal("cash_pay").intValue(), o.getInt("is_rob"), 5, IConstant.accountRecord.accountRecord_type_userPay,
//					account,1,shopId, 0, 0, 0, "",payNo);
//
//			Map<String,Object> res=orderService.splice2Create_2(orderId);
//			if(Integer.parseInt(res.get("code").toString())==10001){
//				log.error("--订单分单异常--");
//				renderText("success");
//				return;
//			}
//			log.error("--正常状态 结束--");
//			renderText("success");
//			return;
//		}else{
//			log.error("--订单状态异常--");
//			renderText("success");
//			return;
//		}
	}
}
