package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Manager;
import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.model.User;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.JsonUtils;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.json.JSONException;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderController extends Controller {
	private static final Logger log= Logger.getLogger(OrderController.class);
	
	public void renderSuccess(String value,Object o){
		setAttr("code", 10002);
		setAttr("msg", value);
		if(o==null){
			setAttr("data", new JSONObject());
		}else{
			setAttr("data", o);			
		}
		renderJson();
		return;
	}
	public void renderFaile(String value){
		setAttr("code", 10001);
		setAttr("msg", value);
		renderJson();
		return;
	}
	
	public void allOrder(){
		int pg=1;
		if (null != getPara("pg")) {
			pg = getParaToInt("pg");
		}
		Map<String,Object> map=new HashMap<String, Object>();
		String str=getPara("searchItem");
		
		if(str!=null&&!str.equals("")){
			try {
				map= JsonUtils.obj2map(str);
			} catch (JSONException e) {
				log.error("json2map 转换异常", e);
			}
		}
		Page<Order> orderAll=Order.dao.find(map, pg);
		setAttr("allOrder", orderAll.getList());
		setAttr("code", 10002);
		render("/shopdetail/allorder.jsp");
	}

	/**所有用户下的单**/
	public void allOrderJson(){
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
		}
		int pg=1;
		if (null != getPara("pg")) {
			pg = getParaToInt("pg");
		}
		Map<String,Object> map=new HashMap<String, Object>();
		String str=getPara("searchItem");
		
		if(str!=null&&!str.equals("")){
			try {
				map= JsonUtils.obj2map(str);
			} catch (JSONException e) {
				log.error("json2map 转换异常", e);
			}
		}
		Page<Order> orderAll=Order.dao.find(map, pg);
		for(Order o:orderAll.getList()){
			o.put("sep", analyzeOrder(o));
		}
		setAttr("allOrder", orderAll);
		setAttr("code", 10002);
		renderJson();
	}

	public static String analyzeOrder(Order o){
		//List<Order> sepOrder=Order.dao.getloadInfo(o.getStr("order_id"));
		String str="";
		if(o.getInt("pay_type")!=3){
			if(o.getInt("order_status")==-1){
				str+=o.getStr("pay_name")+"未成功支付订单 |";
			}
		}
		if(o.getInt("order_status")==IConstant.OrderStatus.order_status_dfh){
			str+="商家准备发货 |";
		}
		if(o.getInt("order_status")==IConstant.OrderStatus.order_status_psz){
			str+="商家配送中 | ";
		}
		return str;
	}
	/**获取订单下的分单**/
	public void getSpartOrder(){
		log.info("getSpartOrder");
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
		}
		String order_id=getPara("orderId");
		List<Order> os=Order.dao.getloadInfo(order_id);
		List<JSONObject> objs=new ArrayList<JSONObject>();
		for(Order o:os){
			JSONObject obj=new JSONObject();
			obj.put("orderNo",o.getStr("order_no"));
			obj.put("payType",o.getStr("pay_name"));
			obj.put("payTypeId",o.getInt("pay_type"));
			obj.put("userName",o.getStr("name"));
			obj.put("phone",o.getStr("phone"));
			if(o.getStr("user_phone").equals("")||o.getStr("user_phone")==null){
				obj.put("phone",o.getStr("phone"));
			}
			obj.put("sendName",o.getStr("send_name"));
			obj.put("shopName",o.getStr("shop_name"));
			obj.put("shopPhone",o.getStr("shop_phone"));
			obj.put("is_rob",o.getInt("is_rob"));
			obj.put("sendAddress",o.getStr("full_address"));
			obj.put("orderStatus",o.getInt("order_status"));
			obj.put("orderStatusName", IConstant.OrderStatus.get(o.getInt("order_status")));
			obj.put("price",o.getBigDecimal("price"));
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			obj.put("create_time", sdf.format(o.getDate("create_time")));
			obj.put("items",Order.dao.getOrderItemsByMap(o.getStr("order_id")));
			obj.put("orderId",o.getStr("order_id"));
			obj.put("shop_id",o.getStr("shop_id"));
			objs.add(obj);
		}
		setAttr("orders",objs);
		render("/shopdetail/orderDetail.jsp");
	}

	/**订单监听**/
	public void loadOrderLis(){
		log.info("loadOrderLis");
		String manPhone= ConfigUtils.getProperty("kaka.order.manager.phone");
		int pg=1;
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
		}
		if(getPara("pg")!=null){
			pg=getParaToInt("pg");
		}
		Page<Record> res= Db.paginate(pg, IConstant.PAGE_DATA, "select ol.order_id,u.name,u.phone,s.name as shop_name,s.phone as shop_phone,o.price,o.create_time,o.order_status,o.order_no,ol.error_msg,ol.process_status,ua.name as recName,ua.phone as recPhone ", "from kk_order_listener ol LEFT JOIN kk_order o ON ol.order_id = o.order_id LEFT JOIN kk_user u ON ol.u_uid = u.uuid LEFT JOIN kk_shop s ON ol.s_uid = s.uuid left join kk_user_address ua on o.address_id=ua.id  order by process_status asc, create_time desc");
		for(Record re:res.getList()){
			if(re.getInt("process_status")==0 && User.dao.isExistsException(re.getStr("order_id"),manPhone)){
				User.dao.addExceptionMessage(re.getStr("order_id"),manPhone);
			}
		}
		setAttr("orders",res);
		setAttr("code",10002);
		renderJson();
	}
	/**订单监听动作修改**/
	public void updateLis(){
		log.info("updateLis");
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
		}
		String order_id=getPara("orderId");
		Record r= Db.findFirst("select * from kk_order_listener ol where ol.order_id=?", new Object[]{order_id});
		if(r!=null){
			r.set("process_status",1);
			Db.update("kk_order_listener", r);
			setAttr("code",10002);
			renderJson();
		}
	}

	public void loadOrderInfo(){
		log.info("loadOrderInfo");
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
		}
		String order_id=getPara("orderId");
		List<Order> os=Order.dao.getloadInfo(order_id);
		List<JSONObject> objs=new ArrayList<JSONObject>();
		if(os.size()!=0){
			for(Order o:os){
				JSONObject obj=new JSONObject();
				obj.put("orderNo",o.getStr("order_no"));
				obj.put("payType",o.getStr("pay_name"));
				obj.put("payTypeId",o.getInt("pay_type"));
				obj.put("userName",o.getStr("name"));
				obj.put("phone",o.getStr("phone"));
				if(o.getStr("user_phone").equals("")||o.getStr("user_phone")==null){
					obj.put("phone",o.getStr("phone"));
				}
				obj.put("sendName",o.getStr("send_name"));
				obj.put("shopName",o.getStr("shop_name"));
				obj.put("shopPhone",o.getStr("shop_phone"));
				obj.put("is_rob",o.getInt("is_rob"));
				obj.put("sendAddress",o.getStr("full_address"));
				obj.put("orderStatus",o.getInt("order_status"));
				obj.put("orderStatusName", IConstant.OrderStatus.get(o.getInt("order_status")));
				obj.put("price",o.getBigDecimal("price"));
				SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				obj.put("create_time", sdf.format(o.getDate("create_time")));
				obj.put("items", Order.dao.getOrderItemsByMap(o.getStr("order_id")));
				obj.put("orderId",o.getStr("order_id"));
				obj.put("shop_id",o.getStr("shop_id"));
				objs.add(obj);
			}
		}
		setAttr("orders",objs);
		render("/shopdetail/orderDetail.jsp");
	}
	public void loadShopInfo(){
		Manager user = (Manager) getSession().getAttribute("manager");
		if(user==null){
			render("/login.jsp");
		}
		String shop_id=getPara("shop_id");
		Shop s= Shop.dao.findByShopIdenti(shop_id);
		renderSuccess("获取成功",s);
	}

}
