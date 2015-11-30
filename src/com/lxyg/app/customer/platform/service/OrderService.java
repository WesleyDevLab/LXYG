package com.lxyg.app.customer.platform.service;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.*;
import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.util.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.math.BigDecimal;
import java.util.*;

public class OrderService {
	private static Order orderDao = new Order();
	private static Shop shopDao=new Shop();
	private static final Logger log = Logger.getLogger(OrderService.class);

	public boolean splice2Create_1(String orderId, String items,int cashPay) {
		int allPrice=0;
		int is_norm=1;
		JSONArray array = JSONArray.fromObject(items);
		if (array.size() > 0) {
			for (int i = 0; i < array.size(); i++) {
				JSONObject o = array.getJSONObject(i);
				int productId = o.getInt("productId");
				int productNum = o.getInt("productNum");
				if(o.containsKey("is_norm")){
					 is_norm=o.getInt("is_norm");
				}
				Goods g = new Goods().findById(productId);
				BigDecimal price = g.getBigDecimal("price");
				BigDecimal cash = g.getBigDecimal("cash_pay");
				int productPay=0;
				if(cashPay!=0){
					productPay = g.getBigDecimal("price").intValue()
							- g.getBigDecimal("cash_pay").intValue();
				}else{
					productPay=g.getBigDecimal("price").intValue();
				}
				Db.update(
						"insert into kk_order_item(order_id,product_id,product_number,product_price,cash_pay,product_pay,create_time,is_norm) "
								+ "values(?,?,?,?,?,?,?,?)", new Object[]{
								orderId, productId, productNum, price, cash,
								productPay, new Date(), is_norm});
			}

		}
		return true;
	}


	public boolean splice2Create_fbz(String orderId, String items,int cashPay) {
		int allPrice=0;
		JSONArray array = JSONArray.fromObject(items);
		if (array.size() > 0) {
			for (int i = 0; i < array.size(); i++) {
				JSONObject o = array.getJSONObject(i);
				int is_norm=o.getInt("is_norm");
				int productId = o.getInt("productId");
				int productNum = o.getInt("productNum");
				Goods g = new Goods().findById(productId);
				BigDecimal price = g.getBigDecimal("price");
				BigDecimal cash = g.getBigDecimal("cash_pay");
				int productPay=0;
				if(cashPay!=0){
					productPay = g.getBigDecimal("price").intValue()
							- g.getBigDecimal("cash_pay").intValue();
				}else{
					productPay=g.getBigDecimal("price").intValue();
				}
				Db.update(
						"insert into kk_order_item(order_id,product_id,product_number,product_price,cash_pay,product_pay,create_time,is_norm) "
								+ "values(?,?,?,?,?,?,?,?)", new Object[]{
								orderId, productId, productNum, price, cash,
								productPay, new Date(), 1});
			}
		}

		return true;
	}


	public Page<Order> loadOrderByStatus(int status, String suid, int page) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("shopId", suid);
		map.put("status", status);
		Page<Order> os = new Order().find(map, page);
		for (Order or : os.getList()) {
			List<Record> res = or.getOrderItems(or.getStr("order_id"));
			or.put("orderItems", res);
		}
		return os;
	}

	public Page<Order> userLoadOrderByStatus(int status, String uid, int page) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("uid", uid);
		map.put("status", status);
		if(status== IConstant.OrderStatus.order_status_chushi){
			map.put("pay_type","(1,2)");
		}
		if(status== IConstant.OrderStatus.order_status_dfh){
			map.put("userStatus","(2)");
		}
		Page<Order> os = new Order().find(map, page);
		for (Order or : os.getList()) {
			List<Record> res = or.getOrderItems(or.getStr("order_id"));
			or.put("orderItems", res);
		}
		return os;
	}

	public Page<Order> loadOrderByCache(String suid, int page) {
		String sql_all_select = "SELECT o.id AS orderId, o.order_no, o.order_id, o.order_status, o.create_time, o.modify_time, "
				+ "o.finish_time, o.price, o.order_type, o.u_uuid, o.s_uuid AS shop_id, o.address_id, o.shop_name, o.pay_type, "
				+ "o.pay_name, o.send_type, o.send_id, o.send_name, o.address, o.send_time, ua.full_address, ua.province_name, "
				+ "ua.city_name, ua.area_name, ua.street, ua.lat, ua.lng ,ua.name,ua.phone ";
		String sql_all_from = "FROM kk_order o LEFT JOIN kk_user_address ua ON o.address_id = ua.id right join kk_order_cache oc on o.order_id=oc.order_id  where 1=1 and oc.u_uuid=? and oc.`status`=1 and o.is_rob!=2 order by o.create_time desc";
		Page<Order> os = new Order().paginate(page, IConstant.PAGE_DATA,
				sql_all_select, sql_all_from, new Object[]{suid});
		for (Order or : os.getList()) {
			List<Record> res = or.getOrderItems(or.getStr("order_id"));
			or.put("orderItems", res);
		}
		return os;
	}

	public Map<String, Object> splice2Create(String order_id) {
		Map<String, Object> result = new HashMap<String, Object>();
		Order order = new Order().findById(false, order_id);
		Shop shop = new Shop().findBysuid(order.getStr("shop_id"));
		List<Record> rs = order.get("orderItems");
		Double lat = order.getDouble("lat");
		Double lng = order.getDouble("lng");

		/***
		 * 定时送
		 * */
		int sendType = order.getInt("send_type");
		if (sendType == IConstant.sendType.send_type_dingshi) {
			/***
			 * 查找该店是否有货
			 * */
			String str="";
			for(int i=0;i<rs.size();i++){
				str+=""+rs.get(i).getInt("product_id")+",";
			}
			str=str.substring(0, str.length()-1);
			List<Shop> allShops = new Shop().findShopByProductRecord(rs, lng, lat);
			String [] strA=str.split(","); //订单中的产品
			String [] strB= RegularUtil.unionMore(allShops);  //所有店产品的 合集
			
			String [] res_pro= RegularUtil.minus(strA, strB);//缺失的产品
			if(res_pro.length!=0){
				//缺失的产品流单
				 orderDao.createOrder(RegularUtil.getIntArray(res_pro), order_id,
							"",
							IConstant.OrderStatus.order_status_ld);
			}
			if(allShops.size()==0){
				//所有店都没有 这些产品 流单
				orderDao.updateOrder(order.getInt("orderId"),
						IConstant.OrderStatus.order_status_ld);
				orderDao.createLog(order_id,
						IConstant.orderAction.order_action_lliudan,
						IConstant.orderAction.order_type_lijisong, null, null,
						null, IConstant.OrderStatus.order_status_ld);
				result.put("code", 10002);
				result.put("msg", "立即送-0-流单");
				return result;
			}else{
				List<Shop> dShops = new Shop().findShopByProductShop(rs, lng, lat,order.getStr("shop_id"));//查询我关注的那家店 是否有我所需的货物
				Shop dShop=dShops.get(0);
				if(dShops.get(0).getLong("num")!=0){
					/**关注商家的店 直接下单 推送*/
					String [] hstrs=dShop.getStr("pros").split(",");
					List<Integer> hpros= RegularUtil.getIntArray(hstrs);
					Order hOrder = orderDao.createOrder(hpros,
							order.getStr("order_id"), order.getStr("shop_id"),
							IConstant.OrderStatus.order_status_dfh);
					new JPush(IConstant.Title, IConstant.content_order_new,
							shop.getStr("phone"), IConstant.PUSH_ONE,
							M.pushMap(hOrder.getStr("order_id"),
									IConstant.OrderStatus.order_status_dfh),"shop")
					.start();
					//所有店 去除 我关注商家的 店
					String [] lesPros= RegularUtil.minus(strA, hstrs);//去除我关注产品店的产品
					if(lesPros.length!=0){
						List<Shop> lessShops=Shop.dao.findShopByProductRecord(lesPros, lng, lat);//省下的产品 查找的店
						if(lessShops.size()!=0){
							return orderDSS_2(lessShops, order_id,lng,lat);
						}
					}
				}else{
					return orderDSS_2(allShops, order_id,lng,lat);
				}
				
			}
		}
		/***
		 * 立即送
		 * */
		if (sendType == IConstant.sendType.send_type_jishi) {
			List<Shop> lShops = new Shop().findShopByProductRecordDis(rs, lng, lat);
			if (lShops.size() == 0) {
				/***
				 * 3公里没有店面 流单
				 * */
				orderDao.updateOrder(order.getInt("orderId"),
						IConstant.OrderStatus.order_status_ld);
				orderDao.createLog(order_id,
						IConstant.orderAction.order_action_lliudan,
						IConstant.orderAction.order_type_lijisong, null, null,
						null, IConstant.OrderStatus.order_status_ld);
				result.put("code", 10002);
				result.put("msg", "立即送-0-流单");
				return result;
			} else {
				String str="";
				for(int i=0;i<rs.size();i++){
					str+=""+rs.get(i).getInt("product_id")+",";
				}
				str=str.substring(0, str.length()-1);
				String [] strA=str.split(","); //订单中的产品
				String [] strB= RegularUtil.unionMore(lShops);  //所有店产品的 合集
				String [] res_pro= RegularUtil.minus(strA, strB);//缺失的产品
				if(res_pro.length!=0){
					/**缺失的产品生成流单*/
					orderDao.createOrder(RegularUtil.getIntArray(res_pro), order_id,
							"",
							IConstant.OrderStatus.order_status_ld);
				}
				/***
				 * 3公里有店面
				 * */
				return orderLJS_2(lShops, order_id);
			}
		}
		return null;
	}


	/**定时送下单**/
	public static Map<String, Object> orderDSS_2(List<Shop> shops,
			String orderId, double lng, double lat) {
		Map<String, Object> result = new HashMap<String, Object>();
		/**
		 * 遍历所有的店
		 * */
		List<Integer> pros = new ArrayList<Integer>();// 遍历添加下单的产品
		for (Shop s : shops) {
			List<Integer> pIds = RegularUtil.getIntArray(s.getStr("pros")
					.split(","));
			/**
			 * 防止重复产品下单
			 * */
			pIds= RegularUtil.minus(pros, pIds);
			if (pIds.size()==0) {
				continue;
			}
			Order nOrder = orderDao.createOrder(pIds, orderId, "",
					IConstant.OrderStatus.order_status_kqd);
			List<Record> rs = nOrder.get("orderItems");
			new OrderCache().save(s.getStr("s_uid"), nOrder.getStr("order_id"),
					rs, lat, lng, IConstant.orderAction.order_type_dingshisong);
			
			new JPush(IConstant.Title, IConstant.content_order,
					s.getStr("phone"), IConstant.PUSH_ONE, M.pushMap(
							nOrder.getStr("order_id"),
							IConstant.OrderStatus.order_status_kqd),"shop").start();
			pros.addAll(pIds);
		}
		result.put("code", 10002);
		result.put("msg", "立即送抢单");
		return result;
	}
	/**立即送**/
	public static Map<String,Object> orderLJS_2(List<Shop> shops,String orderId){
		Map<String,Object> result=new HashMap<String, Object>();
			/**
			 * 遍历所有的店
			 * */
		List<Integer> pros=new ArrayList<Integer>();//遍历添加下单的产品
		for(Shop s:shops){
			List<Integer> pIds= RegularUtil.getIntArray(s.getStr("pros").split(","));
			/**
			 * 防止重复产品下单
			 * */
			pIds= RegularUtil.minus(pros, pIds);
			if (pIds.size()==0) {
				continue;
			}
			Order nOrder = orderDao.createOrder(pIds, orderId,
					s.getStr("s_uid"),
					IConstant.OrderStatus.order_status_dfh);
			
			new JPush(IConstant.Title, IConstant.content_order_new,
					s.getStr("phone"), IConstant.PUSH_ONE,
					M.pushMap(nOrder.getStr("order_id"),
							IConstant.OrderStatus.order_status_dfh),"shop")
					.start();
			
			pros.addAll(pIds);
		}
		result.put("code", 10002);
		result.put("msg", "立即送-count=1-推送");
		return result;
	}

	/***
	 * 记录完成订单的订单
	 * **/
	public boolean recordfinshOrder(Order o) {
		String orderId = o.getStr("order_id");
		String shopId = o.getStr("shop_id");
		int allPrice =o.getBigDecimal("price").intValue();
		int allCash = o.getBigDecimal("cash_pay").intValue();
		shopDao.updateBalance(shopId,allPrice,1);
		shopDao.createBalanceLog(shopId,allPrice,0,IConstant.balanceType.getType(o.getInt("pay_type")),orderId);

		/**
		 * 积分
		 * */
		new User().addIntegral(Math.round(allPrice),o.getStr("u_uuid"));

//		int allPay = allPrice-allCash;
//		int shopAccount = 0;
//		int shopCommission = 0;
//		String returnCommission=o.getStr("original_order_id");
//
//		if(returnCommission!=null&&!returnCommission.equals(orderId)&&o.getInt("pay_type")!=3){
//			log.info("有佣金");
//
//			shopCommission=allPrice;
//			shopCommission = shopCommission * ConfigUtils.rate / 100;
//			shopAccount = allPay  + (allCash * ConfigUtils.clear / 100);
//
//			Shop.dao.updateBalance(shopId, allPay, 1);
//			Shop.dao.createBalanceLog(shopId, shopAccount, 0, IConstant.balanceType.balance_type_in_dd, orderId);
//			Shop.dao.updateBalance(shopId, shopCommission, 2);
//			Shop.dao.createBalanceLog(shopId, 0, shopCommission, IConstant.balanceType.balance_type_out_yj, orderId);
//
//
//			Shop.dao.updateBalance(returnCommission, shopCommission, 1);
//			Shop.dao.createBalanceLog(returnCommission, shopCommission,
//					0, IConstant.balanceType.balance_type_in_yj, orderId);
//
//
//
//			Shop s=Shop.dao.findBysuid(returnCommission);
//			new JPush(IConstant.Title, IConstant.content_order_ToreturnCommission+shopCommission/100+"元",
//					s.getStr("phone"), IConstant.PUSH_ONE,
//					M.pushMap(o.getStr("original_order_id"), IConstant.OrderStatus.order_status_ywc),"shop")
//					.start();
//			SdkMessage.sendUser(s.getStr("phone"), IConstant.content_order_ToreturnCommission + shopCommission / 100 + "元");
//
//		}
//
//		if(returnCommission.equals(orderId)&&o.getInt("pay_type")!=3){
//			log.info("无佣金");
//			shopAccount = allPay + allCash * ConfigUtils.clear / 100;
//
//			Shop.dao.updateBalance(shopId, shopAccount, 1);
//			Shop.dao.createBalanceLog(shopId, shopAccount, 0, IConstant.balanceType.balance_type_in_dd, orderId);
//		}
//
//
//		if(o.getInt("pay_type")==3){
//			shopAccount=allPay;
//			Shop.dao.createBalanceLog(shopId, shopAccount, allPay, IConstant.balanceType.balance_type_in_xf, orderId);
//		}


		return true;
	}



	
	public boolean delOrder(Order o){
		o.set("id", o.getInt("orderId"));
		String order_id=o.getStr("order_id");
		boolean b=o.deleteById(o.getInt("orderId"));
		int i= Db.update("delete from kk_order_item  where order_id=? ", new Object[]{order_id});
		if(i<=0){
			b=false;
		}
		return b;
	}

	public void fb_splice2order(String order_id){
		List<Integer> pids=new ArrayList<Integer>();
		String str="";
		Order order = new Order().findById(false, order_id);
		List<Record> orderItems=order.get("orderItems");
		for(Record record:orderItems){
			if(record.getInt("is_norm")==2){
				int productId=record.getInt("product_id");
				FBGoods fb=FBGoods.dao.findbyId(productId);
				if(fb!=null){
					pids.add(productId);
					str+=productId+",";
				}
			}
		}
		if(pids.size()!=0){
			str=str.substring(0,str.length()-1);
			List<Record> records= Db.find("select * from kk_product_fb where id in (" + str + ") group by s_uid");
			for(Record record:records){
				Record r= Db.findFirst("select group_concat(fb.id) as pids,fb.* from kk_product_fb fb where fb.s_uid=? and fb.id in (" + str + ") and fb.hide=0 ", record.getStr("s_uid"));
				String pid=r.getStr("pids");
				Order horder=Order.dao.createOrderFB(pid.split(","), order_id, record.getStr("s_uid"), IConstant.OrderStatus.order_status_dfh);

				Shop shop=Shop.dao.findBysuid(record.getStr("s_uid"));
				new JPush(IConstant.Title, IConstant.content_order_new,
						shop.getStr("phone"), IConstant.PUSH_ONE,
						M.pushMap(horder.getStr("order_id"),
								IConstant.OrderStatus.order_status_dfh),"shop")
						.start();
				pushBySdk(shop.getStr("phone"),horder.getStr("order_id"),1);
			}
		}
	}


	public Map<String, Object> splice2Create_2(String order_id) {
		Map<String, Object> result = new HashMap<String, Object>();
		Order order = new Order().findById(false, order_id);
		Shop shop = new Shop().findBysuid(order.getStr("shop_id"));
		List<Record> rs = order.get("orderItems");
		Double lat = order.getDouble("lat");
		Double lng = order.getDouble("lng");

		fb_splice2order(order_id);


		for(int i=0;i<rs.size();i++){
			if(rs.get(i).getInt("is_norm")==2){
				rs.remove(i);
				i--;
			}
		}
		if(rs.size()==0){
			result.put("code", 10005);
			result.put("msg", "无标准产品");
			return result;
		}
		/***
		 * 定时送
		 * */
		int sendType = order.getInt("send_type");
		if (sendType == IConstant.sendType.send_type_dingshi) {
			/***
			 * 查找该店是否有货
			 * */
			String str="";
			for(int i=0;i<rs.size();i++){
				str+=""+rs.get(i).getInt("product_id")+",";
			}
			str=str.substring(0, str.length()-1);
			List<Shop> allShops = new Shop().findShopByProductRecord(rs, lng, lat);
			if(allShops.size()==0){
				//所有店都没有 这些产品 流单
				orderDao.updateOrder(order.getInt("orderId"),
						IConstant.OrderStatus.order_status_ld);
				orderDao.createLog(order_id,
						IConstant.orderAction.order_action_lliudan,
						IConstant.orderAction.order_type_lijisong, null, null,
						null, IConstant.OrderStatus.order_status_ld);

				result.put("code", 10002);
				result.put("msg", "立即送-0-流单");
				return result;
			}else{
				String [] strA=str.split(","); //订单中的产品
				String [] strB= RegularUtil.unionMore(allShops);  //所有店产品的 合集
				String [] res_pro= RegularUtil.minus(strA, strB);//缺失的产品
				if(res_pro.length!=0){
					//缺失的产品流单
					orderDao.createOrder(RegularUtil.getIntArray(res_pro), order_id,
							"",
							IConstant.OrderStatus.order_status_ld);
				}
				List<Shop> dShops = new Shop().findShopByProductShop(rs, lng, lat,order.getStr("shop_id"));//查询我关注的那家店 是否有我所需的货物
				Shop dShop=dShops.get(0);
				if(dShops.get(0).getLong("num")!=0){
					/**关注商家的店 直接下单 推送*/
					String [] hstrs=dShop.getStr("pros").split(",");
					List<Integer> hpros= RegularUtil.getIntArray(hstrs);
					Order hOrder = orderDao.createOrder(hpros,
							order.getStr("order_id"), order.getStr("shop_id"),
							IConstant.OrderStatus.order_status_dfh);

					new JPush(IConstant.Title, IConstant.content_order_new,
							shop.getStr("phone"), IConstant.PUSH_ONE,
							M.pushMap(hOrder.getStr("order_id"),
									IConstant.OrderStatus.order_status_dfh),"shop")
							.start();

					pushBySdk(shop.getStr("phone"),hOrder.getStr("order_id"),1);

					//所有店 去除 我关注商家的 店
					String [] lesPros= RegularUtil.minus(strA, hstrs);//去除我关注产品店的产品
					if(lesPros.length!=0){
						List<Shop> lessShops=Shop.dao.findShopByProductRecord(lesPros, lng, lat);//省下的产品 查找的店
						if(lessShops.size()!=0){
							return orderDSS(lessShops, order_id,lng,lat);
						}
					}
				}else{
					return orderDSS(allShops, order_id,lng,lat);
				}

			}
		}
		/***
		 * 立即送
		 * */
		if (sendType == IConstant.sendType.send_type_jishi) {
			List<Shop> lShops = new Shop().findShopByProductRecordDis(rs, lng, lat);
			if (lShops.size() == 0) {
				/***
				 * 3公里没有店面 流单
				 * */
				orderDao.updateOrder(order.getInt("orderId"),
						IConstant.OrderStatus.order_status_ld);
				orderDao.createLog(order_id,
						IConstant.orderAction.order_action_lliudan,
						IConstant.orderAction.order_type_lijisong, null, null,
						null, IConstant.OrderStatus.order_status_ld);
				result.put("code", 10002);
				result.put("msg", "立即送-0-流单");
				return result;
			} else {
				String str="";
				for(int i=0;i<rs.size();i++){
					str+=""+rs.get(i).getInt("product_id")+",";
				}
				str=str.substring(0, str.length()-1);
				String [] strA=str.split(","); //订单中的产品
				String [] strB= RegularUtil.unionMore(lShops);  //所有店产品的 合集
				String [] res_pro= RegularUtil.minus(strA, strB);//缺失的产品
				if(res_pro.length!=0){
					/**缺失的产品生成流单*/
					orderDao.createOrder(RegularUtil.getIntArray(res_pro), order_id,
							"",
							IConstant.OrderStatus.order_status_ld);
				}
				/***
				 * 3公里有店面
				 * */
				return orderLJS(lShops, order_id);
			}
		}
		return null;
	}


	/**定时送下单**/
	public static Map<String, Object> orderDSS(List<Shop> shops,
											   String orderId, double lng, double lat) {
		Map<String, Object> result = new HashMap<String, Object>();
		/**
		 * 遍历所有的店
		 * */
		List<Integer> pros = new ArrayList<Integer>();// 遍历添加下单的产品
		for (Shop s : shops) {
			List<Integer> pIds = RegularUtil.getIntArray(s.getStr("pros")
					.split(","));
			/**
			 * 防止重复产品下单
			 * */
			pIds= RegularUtil.minus(pros, pIds);
			if (pIds.size()==0) {
				continue;
			}
			Order nOrder = orderDao.createOrder(pIds, orderId, "",
					IConstant.OrderStatus.order_status_kqd);
			List<Record> rs = nOrder.get("orderItems");
			new OrderCache().save(s.getStr("s_uid"), nOrder.getStr("order_id"),
					rs, lat, lng, IConstant.orderAction.order_type_dingshisong);

			new JPush(IConstant.Title, IConstant.content_order,
					s.getStr("phone"), IConstant.PUSH_ONE, M.pushMap(
					nOrder.getStr("order_id"),
					IConstant.OrderStatus.order_status_kqd),"shop").start();
			pros.addAll(pIds);

			pushBySdk(s.getStr("phone"), nOrder.getStr("order_id"), 1);

		}
		result.put("code", 10002);
		result.put("msg", "立即送抢单");
		return result;
	}
	/**立即送**/
	public static Map<String,Object> orderLJS(List<Shop> shops,String orderId){
		Map<String,Object> result=new HashMap<String, Object>();
		/**
		 * 遍历所有的店
		 * */
		List<Integer> pros=new ArrayList<Integer>();//遍历添加下单的产品
		for(Shop s:shops){
			List<Integer> pIds= RegularUtil.getIntArray(s.getStr("pros").split(","));
			/**
			 * 防止重复产品下单
			 * */
			pIds= RegularUtil.minus(pros, pIds);
			if (pIds.size()==0) {
				continue;
			}
			Order nOrder = orderDao.createOrder(pIds, orderId,
					s.getStr("s_uid"),
					IConstant.OrderStatus.order_status_dfh);

			new JPush(IConstant.Title, IConstant.content_order_new,
					s.getStr("phone"), IConstant.PUSH_ONE,
					M.pushMap(nOrder.getStr("order_id"),
							IConstant.OrderStatus.order_status_dfh),"shop")
					.start();

			pushBySdk(s.getStr("phone"), nOrder.getStr("order_id"),1);
			pros.addAll(pIds);
		}
		result.put("code", 10002);
		result.put("msg", "立即送-count=1-推送");
		return result;
	}

	public static void pushBySdk(String phone,String order_id,int type){
		String str="";
		if(type==0){
			Order o=Order.dao.findById(false,order_id);
			Shop shop=Shop.dao.findBysuid(o.getStr("shop_id"));
			 str=",收货人:"+o.getStr("name");
			str+=",联系电话："+o.getStr("phone");
			str+=",收获地址:"+o.getStr("address");
			str+=",支付方式："+o.getStr("pay_name");
			str+=",购买产品：【";
			for(Record r:o.getOrderItems(order_id)){
				str+=r.getStr("name")+"*"+r.getInt("product_number")+",";
			}
			str+="】";
			str+="总价:"+o.getBigDecimal("price").intValue()/100+"元";

			if(shop!=null){
				str+=",下单店铺:"+shop.getStr("name")+",店铺电话:"+shop.getStr("phone");
			}
		}
		if(type==1){
			Order o=Order.dao.findById(false, order_id);
			 str=",收货人:"+o.getStr("name");
			str+=",联系电话："+o.getStr("phone");
			str+=",收获地址:"+o.getStr("address");
			str+=",支付方式："+o.getStr("pay_name");
			str+=",购买产品：【";
			for(Record r:o.getOrderItems(order_id)){
				str+=r.getStr("name")+"*"+r.getInt("product_number")+",";
			}
			str+="】";
			str+="总价:"+o.getBigDecimal("price").intValue()/100+"元";
		}
		if(type==2){
			Record record = Db.findFirst("select oa.order_id,oa.price,oa.pay_name,ua.full_address,ua.phone,ua.name from kk_order_activity oa left join kk_user_address ua on oa.address_id=ua.id where oa.order_id=?", order_id);
			List<Record> records = Db.find("select p.name,oai.product_number from kk_order_activity_item oai left join kk_product_activity p on oai.product_id=p.id where oai.order_id=?", order_id);
			 str=",收货人:"+record.getStr("name");
			str+=",联系电话："+record.getStr("phone");
			str+=",收获地址:"+record.getStr("full_address");
			str+=",支付方式："+record.getStr("pay_name");
			str+=",购买产品：【";
			for(Record r:records){
				str+=r.getStr("name")+"*"+r.getInt("product_number")+",";
			}
			str+="】";
			str+="总价:"+record.getBigDecimal("price").intValue()/100 +"元";
		}
		if(phone.contains(",")){
			String[] ps=phone.split(",");
			for(String p:ps){
				SdkMessage.sendUser(p, IConstant.content_order_new + str);
			}
		}else{
			SdkMessage.sendUser(phone, IConstant.content_order_new+str);
		}
	}

	public boolean  updateOrderStatus(Order o,JSONObject json){
		if(o.getInt("order_status")== IConstant.OrderStatus.order_status_dfh){
			o.set("send_goods_time", new Date());
			String userPhone=o.getStr("phone");
			if(userPhone==null||userPhone.equals("")){
				userPhone=o.getStr("wechat_id");
			}
			new JPush(IConstant.Title, IConstant.content_order_Touser_send +o.getStr("receive_code") , userPhone, IConstant.PUSH_ONE, M.pushMap(o.getStr("order_id"), IConstant.OrderStatus.order_status_psz),"user").start();
			if(o.getInt("address_id")!=0){
				Record r= Db.findFirst("select * from kk_user_address where id=?", new Object[]{o.getInt("address_id")});
				if(r!=null){
					String phone=r.get("phone");
					SdkMessage.sendUser(phone, IConstant.content_order_Touser_send + o.getStr("receive_code"));
				}
			}
		}

		if(o.getInt("order_status")== IConstant.OrderStatus.order_status_psz){
			String code=json.getString("recCode");
			if(code.equals(o.getStr("receive_code"))){
				o.set("finish_time", new Date());
				//new JPush(IConstant.Title, IConstant.content_order_Touser_finish, userPhone, IConstant.PUSH_ONE, M.pushMap(o.getStr("order_id"),IConstant.OrderStatus.order_status_ywc)).start();
				new OrderService().recordfinshOrder(o);

			}
		}
		o.set("order_status", o.getInt("order_status")+1);
		return  o.update();

	}
}
