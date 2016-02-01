package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.M;
import com.lxyg.app.customer.platform.weiapiUtil.WXUtil;
import net.sf.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.*;

public class Order extends Model<Order> {
	/**
	 *
	 */
	private static final long serialVersionUID = 107L;
	public OrderCache orderCache=new OrderCache();
	public static final Order dao = new Order();
	public static final Shop shopDao=new Shop();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	private static final String sql = "select o.id as orderId,order_no,order_id,order_status,create_time,modify_time,finish_time,"
			+ "price,order_type,u_uuid,s_uuid as shop_id,address_id,shop_name,pay_type,pay_name,send_type,send_id,"
			+ "send_name,address,send_time ,cash_pay,is_rob,receive_code "
			+ " from kk_order o where o.order_id = ? ";

	private static final String sql_address = "SELECT o.id AS orderId, o.order_no, o.order_id, o.order_status, o.create_time, o.modify_time, "
			+ "o.finish_time, o.price, o.order_type, o.u_uuid, o.s_uuid AS shop_id, o.address_id, o.shop_name, o.pay_type, "
			+ "o.pay_name, o.send_type, o.send_id, o.send_name, o.cash_pay,o.address, o.send_time,o.is_rob,o.receive_code,o.original_order_id,o.original_s_uid, ua.full_address, ua.province_name, "
			+ "ua.city_name, ua.area_name, ua.street, ua.lat, ua.lng ,ua.name,ua.phone "
			+ "FROM kk_order o LEFT JOIN kk_user_address ua ON o.address_id = ua.id WHERE o.order_id = ?";


	private static final String sql_all_select = "SELECT o.id AS orderId, o.order_no, o.order_id, o.order_status, o.create_time, o.modify_time, "
			+ "o.finish_time, o.price, o.cash_pay,o.order_type, o.u_uuid, o.s_uuid AS shop_id, o.address_id, o.shop_name, o.pay_type, "
			+ "o.pay_name, o.send_type, o.send_id, o.send_name, o.address, o.send_time,o.receive_code,o.is_rob,o.send_goods_time ,o.let_order_time,o.refuse_time,o.refuse_cause,o.original_order_id,o.remark,o.send_goods_type,ua.full_address, ua.province_name, "
			+ "ua.city_name, ua.area_name, ua.street, ua.lat, ua.lng ,ua.name ,ua.phone,u.name as user_name, u.phone as user_phone,s.phone as shop_phone  ";
	private static final String sql_all_from = "FROM kk_order o LEFT JOIN kk_user_address ua ON o.address_id = ua.id left join kk_user u on o.u_uuid=u.uuid left join kk_shop s on o.s_uuid=s.uuid where 1=1 ";


	private static final String sql_user="select o.id as orderId,o.order_no,o.order_id,o.order_status,o.create_time,o.finish_time,o.send_goods_time," +
			"o.modify_time,o.finish_time,o.price,o.cash_pay,o.order_type,o.u_uuid,o.s_uuid as shop_id,o.receive_code,o.address_id,o.shop_name,o.pay_type,o.pay_name,o.send_type,o.send_id,"
			+ "o.send_name,o.address,o.send_time,o.is_rob,o.original_s_uid,o.original_order_id,u.phone,u.name,u.head_img,u.cash_pay,u.uuid,u.wechat_id from kk_order o left join kk_user u on o.u_uuid=u.uuid where o.order_id = ? ";

	public Order findById(boolean lazy, String order_id) {
		if (!lazy) {
			Order o = dao.findFirst(sql_address, new Object[] { order_id });
			if(o==null){
				o=dao.findFirst(sql_address, new Object[] { order_id });
			}
			o.put("orderItems", getOrderItems(order_id));
			return o;
		}
		if(lazy){
			Order o=dao.findFirst(sql, new Object[] {order_id});
			return o;
		}
		return null;
	}


	public Order findByStatus(String orderId,int status){
		String str=sql_user+" and o.order_status=?";
		Order o=dao.findFirst(str,new Object[]{orderId,status});
		return o;
	}

	public List<Record> getOrderItemsV2(String orderId) {
		return Db
				.find("select oi.id as orderItemId,oi.product_id,oi.product_number,oi.product_price,oi.cash_pay,oi.product_pay,p.name,p.cover_img,oi.is_norm  "
								+ "from kk_order_item oi left join kk_product p on oi.product_id =p.id where oi.order_id =? ",
						orderId);
	}

	public List<Record> getOrderItems(String orderId) {
		List<Record> records= Db.find("select oi.id as orderItemId,oi.product_id,oi.product_number,oi.product_price,oi.cash_pay,oi.product_pay,oi.is_norm,oi.activity_id  "
				+ "from kk_order_item oi where oi.order_id =? ", orderId);
		for(Record record:records){
			if(record.getInt("is_norm")==1){
				Goods f= Goods.dao.findById(record.getInt("product_id"));
				record.set("name",f.getStr("name"));
				record.set("cover_img",f.getStr("cover_img"));
			}
			if(record.getInt("is_norm")==2){
				Record r=Db.findById("kk_product_activity", record.getInt("product_id"));
				record.set("name",r.getStr("name"));
				record.set("cover_img",r.getStr("cover_img"));
			}
		}
		return records;
	}



	public List<Map<String,Object>> getOrderItemsByMap(String orderId) {
		List<Record> records= Db
				.find("select oi.id as orderItemId,oi.product_id,oi.product_number,oi.product_price,oi.cash_pay,oi.product_pay,p.name,p.cover_img,oi.is_norm "
								+ "from kk_order_item oi left join kk_product p on oi.product_id =p.id where oi.order_id =? ",
						orderId);
		List<Map<String,Object>> maps=new ArrayList<Map<String,Object>>();
		if(records.size()!=0){
			for(Record r:records){
				Map<String,Object> map=new HashMap<String,Object>();
				map.put("productId",r.getInt("product_id"));
				map.put("productName",r.getStr("name"));
				map.put("productNum",r.getInt("product_number"));
				map.put("product_price",r.getBigDecimal("product_price").intValue());
				map.put("cash_pay",r.getBigDecimal("cash_pay").intValue());
				map.put("is_norm", r.getInt("is_norm"));
				maps.add(map);
			}
		}
		return maps;
	}

	public List<Order> getSpliceOrder(String order_id){
		return dao.find(sql_all_select + sql_all_from + " and o.original_order_id=?", order_id);
	}

	public List<Order> getloadInfo(String order_id){
		return dao.find(sql_all_select + sql_all_from + " and o.order_id=?", order_id);

	}

	public Page<Order> find(Map<String, Object> map, int page) {
		String where = "";
		List<Object> list = new ArrayList<Object>();
		if (map.containsKey("startTime") && map.containsKey("endTime")) {
			where += " and o.create_time between ? and ?";
			list.add(map.get("startTime"));
			list.add(map.get("endTime"));
		}
		if (map.containsKey("shopId")) {
			where += " and o.s_uuid =? ";
			list.add(map.get("shopId"));
		}
		if (map.containsKey("shopName")) {
			where += " and o.shop_name like ? ";
			list.add("%"+map.get("shopName")+"%");
		}
		if(map.containsKey("uid")){
			where += " and o.u_uuid=?";
			list.add(map.get("uid"));
		}
		if (map.containsKey("payType")) {
			where += " and o.pay_type =? ";
			list.add(map.get("payType"));
		}
		if (map.containsKey("status")) {
			where += " and o.order_status =? ";
			list.add(map.get("status"));
		}
		if(map.containsKey("type")){
			String t=map.get("type").toString();
			if(t.equals("web")){
				where+= " and o.order_status in (0,-1,7) order by o.create_time desc";
			}
		}

		if(map.containsKey("pay_type")){
			String pay_type=map.get("pay_type").toString();
			where += " and o.pay_type in "+pay_type +"order by o.create_time desc";
		}
		if(map.containsKey("userStatus")){
			String userStatus=map.get("userStatus").toString();
			where +=" and o.order_status in "+userStatus +" group by o.order_id order by o.create_time desc";
		}
		if(map.containsKey("desc")){
			String desc=map.get("desc").toString();
			where +=" order by o.create_time "+desc;
		}
		Object[] o = new Object[list.size()];

		for (int i = 0; i < list.size(); i++) {
			o[i] = list.get(i);
		}
		Page<Order> os = new Order().paginate(page, IConstant.PAGE_DATA,
				sql_all_select, sql_all_from + where, o);
		return os;
	}



	public Record loadOrderNum(String suid) {
		String sql = "SELECT ( SELECT COUNT(o1.id) FROM kk_order_cache o1 WHERE o1.status = 1 and o1.u_uuid=?) AS count1,"
				+ "( SELECT COUNT(o2.id) FROM kk_order o2 WHERE o2.order_status = 2 and o2.s_uuid=? ) AS count2, "
				+ "( SELECT COUNT(o3.id) FROM kk_order o3 WHERE o3.order_status = 3 and o3.s_uuid=?) AS count3, "
				+ "( SELECT COUNT(o4.id) FROM kk_order o4 WHERE o4.order_status = 4 and o4.s_uuid=?) AS count4, "
				+ "( SELECT COUNT(o5.id) FROM kk_order o5 WHERE o5.order_status = 5 and o5.s_uuid=?) AS count5, "
				+ "( SELECT COUNT(o6.id) FROM kk_order o6 WHERE o6.order_status = 6 and o6.s_uuid=? ) AS count6 ";
		Record r = Db.findFirst(sql, new Object[]{suid, suid, suid, suid, suid, suid});
		return r;
	}
	public Record loadOrderNumU(String uuid) {
//		String sql = "SELECT ( SELECT COUNT(o2.id) FROM kk_order o2 WHERE o2.order_status = - 1 AND o2.pay_type != 3 AND o2.u_uuid = ? ) AS dfk, " +
//				"( SELECT COUNT(o3.id) FROM kk_order o3 WHERE o3.order_status = 2 AND o3.u_uuid = ?) AS dfh, ( SELECT COUNT(o4.id) FROM kk_order o4 WHERE o4.order_status = 3 AND o4.u_uuid = ? ) AS dsh, ( SELECT COUNT(o5.id) FROM kk_order o5 WHERE o5.order_status = 4 AND o5.u_uuid = ? ) AS ywc";
		String sql="SELECT ( orderNum (-1, ?)) AS dfk, ( orderNum (2, ?)) AS dfh, (orderNum (3, ?)) AS dsh, ( orderNum (4,?)) AS ywc";
		Record r = Db.findFirst(sql, new Object[]{uuid, uuid, uuid, uuid});
		return r;
	}

	public Order createOrder(List<Integer> L,String orderId,String shopId,int status){

		Order order = dao.findById(false, orderId);
		String order_id= M.getOrderId();
		Order nOrder=order;

		String shopName=order.getStr("shop_name");
		Shop s=shopDao.findBysuid(shopId);

		if(s!=null && !s.getStr("name").equals("")){
			shopName=s.getStr("name");
		}
		nOrder.set("id", null);
		nOrder.set("order_status", status);
		nOrder.set("s_uuid", shopId);
		nOrder.set("create_time", new Date());
		nOrder.set("order_id", order_id);
		nOrder.set("original_order_id", orderId);
		nOrder.set("original_s_uid", order.getStr("shop_id"));
		nOrder.set("shop_name",shopName);
		int all_price=0;
		for (Integer pid : L) {
			Record r = Db
					.findFirst(
							"select * from  kk_order_item oi where oi.product_id=? and oi.order_id=?",
							new Object[]{pid, orderId});
			all_price+=(r.getBigDecimal("product_price").intValue()*r.getInt("product_number"))-order.getBigDecimal("cash_pay").intValue();
			r.set("id", null);
			r.set("order_id",order_id);
			r.set("modify_time", new Date());
			Db.save("kk_order_item", r);
		}
		nOrder.set("price", all_price);
		nOrder.save();
		dao.createLog(orderId, IConstant.orderAction.order_action_newOrder, order.getStr("send_name"), L.toString(), null, order_id, status);

		return nOrder;
	}


	public Order createOrder(String [] str,String orderId,String shopId,int status){
		Order order = dao.findById(false, orderId);
		String order_id= M.getOrderId();
		Order nOrder=order;

		nOrder.set("id", null);
		nOrder.set("order_status", status);
		nOrder.set("s_uuid", shopId);
		nOrder.set("create_time", new Date());
		nOrder.set("order_id", order_id);
		nOrder.set("original_order_id", orderId);
		int all_price=0;
		String pids="";
		for (String pid : str) {
			pids+=""+pid;
			Record r = Db
					.findFirst(
							"select * from kk_order_item oi where oi.product_id=? and oi.order_id=?",
							new Object[]{pid, orderId});
			all_price+=r.getBigDecimal("product_pay").intValue()*r.getInt("product_number");
			r.set("id", null);
			r.set("order_id",order_id);
			r.set("modify_time", new Date());
			Db.save("kk_order_item", r);
		}
		nOrder.set("price", all_price);
		nOrder.save();
		dao.createLog(orderId, IConstant.orderAction.order_action_newOrder, order.getStr("send_name"), pids, null,order_id,status);
		return nOrder;
	}

	public Order createOrderFB(String [] str,String orderId,String shopId,int status){
		Order order = dao.findById(false, orderId);
		String order_id= M.getOrderId();
		Order nOrder=order;

		nOrder.set("id", null);
		nOrder.set("order_status", status);
		nOrder.set("s_uuid", shopId);
		nOrder.set("create_time", new Date());
		nOrder.set("order_id", order_id);
		nOrder.set("original_order_id", orderId);
		nOrder.set("is_norm",2);
		int all_price=0;
		String pids="";
		for (String pid : str) {
			pids+=""+pid;
			Record r = Db
					.findFirst(
							"select * from kk_order_item oi where oi.product_id=? and oi.order_id=?",
							new Object[]{pid, orderId});
			all_price+=r.getBigDecimal("product_pay").intValue()*r.getInt("product_number");
			r.set("id", null);
			r.set("order_id",order_id);
			r.set("modify_time", new Date());
			Db.save("kk_order_item", r);
		}
		nOrder.set("price", all_price);
		nOrder.save();
		dao.createLog(orderId, IConstant.orderAction.order_action_newOrder, order.getStr("send_name"), pids, null,order_id,status);
		return nOrder;
	}


	public void updateOrder(int id,int status){
		Order order = new Order();
		order.set("id", id);
		order.set("order_status",status);
		order.update();
	}
	public void updateOrder(String orderId,int status){
		Order order=dao.findFirst("select * from kk_order where order_id=?",new Object[]{orderId});
		order.set("order_status",status);
		order.update();
	}

	public void createLog(String order_id,String action,String order_type,String product,String cache_id,String newOrderId,int status){
		Record r=new Record();
		r.set("order_id", order_id);
		r.set("action", action);
		r.set("order_type", order_type);
		r.set("product", product);
		r.set("cache_id", cache_id);
		r.set("new_orderId", newOrderId);
		r.set("create_time", new Date());
		r.set("order_status", status);
		Db.save("kk_order_action_log", r);
	}
	public void createLog(String order_id,String action,String order_type,String product,String cache_id,String newOrderId,int status,String shop_uuid){
		Record r=new Record();
		r.set("order_id", order_id);
		r.set("action", action);
		r.set("order_type", order_type);
		r.set("product", product);
		r.set("cache_id", cache_id);
		r.set("new_orderId", newOrderId);
		r.set("create_time", new Date());
		r.set("rob_shop_id", shop_uuid);
		r.set("order_status", status);
		Db.save("kk_order_action_log", r);
	}

//	public void createListener(Order o,String msg){
//		String order_id=o.getStr("order_id");
//
//		if(order_id!=null&&!order_id.equals("")){
//			Record r1= Db.findFirst("select * from kk_order_listener ol where ol.order_id=?", new Object[]{order_id});
//			if(r1!=null){
//				if(o.getInt("order_status")== IConstant.OrderStatus.order_status_ywc||
//						o.getInt("order_status")== IConstant.OrderStatus.order_status_rd){
//					Db.delete("kk_order_listener", r1);
//					return;
//				}
//				if(o.getInt("order_status")!=r1.getInt("order_status")){
//					r1.set("order_status", o.getInt("order_status"));
//					r1.set("error_msg", msg);
//					Db.update("kk_order_listener", r1);
//				}
//			}else{
//				if(o.getInt("order_status")== IConstant.OrderStatus.order_status_ywc){
//					return;
//				}
//				Record r=new Record();
//				r.set("order_id",o.getStr("order_id"));
//				r.set("s_uid",o.getStr("s_uuid"));
//				r.set("u_uid",o.getStr("u_uuid"));
//				r.set("order_status",o.getInt("order_status"));
//				r.set("order_create_time",sdf.format(o.getDate("create_time")));
//				r.set("process_status",0);
//				r.set("create_time",new Date());
//				r.set("error_msg",msg);
//				Db.save("kk_order_listener", r);
//			}
//		}
//	}

	public void updateCash(String uid,int cash,String order_id){

		List<Record> records= Db.find("select * from kk_user_cash_log ucl where ucl.u_uuid=? and order_id=? and type=" + IConstant.cashLog.cash_log_type_del, uid, order_id);
		if(records.size()==0){
			Record r= Db.findFirst("select * from kk_user_cash where u_uuid=?", uid);
			int allCash=r.getBigDecimal("cash").intValue();
			r.set("cash",allCash-cash);
			Db.update("kk_user_cash", r);
			Record rl=new Record();
			rl.set("type", IConstant.cashLog.cash_log_type_del);
			rl.set("type_name", IConstant.cashLog.cash_log_type_del_str);
			rl.set("create_time",new Date());
			rl.set("u_uuid",uid);
			rl.set("user_cash_id",r.getInt("id"));
			rl.set("cash",cash);
			rl.set("order_id",order_id);
			Db.save("kk_user_cash_log", rl);
		}

	}

	public net.sf.json.JSONObject isRefund(String order_id,Record conf){
		net.sf.json.JSONObject jsonObject=new JSONObject();
		Map<String,Object> map=WXUtil.orderQuery(order_id,conf);
		if(map.containsKey("return_code")&&map.get("return_code").toString().toUpperCase().equals("SUCCESS")){
			if(map.get("trade_state").toString().toUpperCase().equals("SUCCESS")){
				//支付成功，可以申请退款
				jsonObject.put("flag",true);
				jsonObject.put("cash_fee",Integer.parseInt(map.get("cash_fee").toString()));
				jsonObject.put("transaction_id",map.get("transaction_id").toString());
			}
			if(map.get("trade_state").toString().toUpperCase().equals("REFUND")){
				//已经退款
			}
			if(map.get("trade_state").toString().toUpperCase().equals("NOTPAY")){
				//未支付

			}
			if(map.get("trade_state").toString().toUpperCase().equals("CLOSED")){
				//已关闭
			}
			if(map.get("trade_state").toString().toUpperCase().equals("REVOKED")){
				//已撤销
			}
			if(map.get("trade_state").toString().toUpperCase().equals("USERPAYING")){
				//用户支付中
			}
		}
		return jsonObject;
	}

	public net.sf.json.JSONObject refundQuery(String order_id,Record conf){
		net.sf.json.JSONObject jsonObject=new JSONObject();
		Map<String,Object> map=WXUtil.refundQuery(order_id,conf);
		if(map.containsKey("return_code")&&map.get("return_code").toString().toUpperCase().equals("SUCCESS")){
			if(map.get("trade_state").toString().toUpperCase().equals("SUCCESS")){
				//支付成功，可以申请退款
				jsonObject.put("flag",true);
				jsonObject.put("cash_fee",Integer.parseInt(map.get("cash_fee").toString()));
				jsonObject.put("transaction_id",map.get("transaction_id").toString());
			}
			if(map.get("trade_state").toString().toUpperCase().equals("REFUND")){
				//已经退款
			}
			if(map.get("trade_state").toString().toUpperCase().equals("NOTPAY")){
				//未支付

			}
			if(map.get("trade_state").toString().toUpperCase().equals("CLOSED")){
				//已关闭
			}
			if(map.get("trade_state").toString().toUpperCase().equals("REVOKED")){
				//已撤销
			}
			if(map.get("trade_state").toString().toUpperCase().equals("USERPAYING")){
				//用户支付中
			}
		}
		return jsonObject;
	}


}
