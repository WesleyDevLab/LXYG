package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class OrderCache extends Model<OrderCache> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 108L;

	public static final OrderCache dao=new OrderCache();
	
	private static final String sql_all_page_select="select * ";
	private static final String sql_all_page_from="from kk_order_cache";
	
	public Page<OrderCache> find(int page){
		Page<OrderCache> ocs=dao.paginate(page, IConstant.PAGE_DATA, sql_all_page_select, sql_all_page_from, new Object[]{});
		for(OrderCache oc:ocs.getList()){
			oc.put("OrderCacheItems", getOrderCacheItems());
		}
		return ocs;
	}
	
	public boolean save(String suid,String order_id,List<Record> rs,double lat,double lng,String orderType){
		OrderCache oc = new OrderCache();
		oc.set("u_uuid", suid);
		oc.set("order_id", order_id);
		oc.set("create_time", new Date());
		oc.set("status", 1);
		oc.set("lat", lat);
		oc.set("lng", lng);
		oc.save();
		String productStr="";
		if (rs.size() != 0) {
			for (Record r : rs) {
				int productId = r.getInt("product_id");
				productStr+=""+productId+",";
				int productNum = r.getInt("product_number");
				BigDecimal productPrice = r
						.getBigDecimal("product_price");
				BigDecimal cashPay = r
						.getBigDecimal("cash_pay");
				BigDecimal productPay = r
						.getBigDecimal("product_pay");
				new OrderCache().insertOrderCacheItems(
						oc.getInt("id"), productId, productNum,
						productPrice, cashPay, productPay);
			}
		}
		
		productStr=productStr.substring(0, productStr.length()-1);
		new Order().createLog(order_id, IConstant.orderAction.order_action_robdan, orderType,productStr,""+oc.getInt("id"), null, IConstant.OrderStatus.order_status_kqd);
		return true;
	}
	
	public List<Record> getOrderCacheItems(){
		return Db.find("select product_id,product_number,product_price,cash_pay,product_pay,p.name,p.cover_img " +
				"from kk_order_cache_item oci left join kk_product p on oi.product_id =p.id where order_cache_id=?", get("orderCachId"));
	}
	
	public boolean insertOrderCacheItems(int order_cache_id,int product_id,int product_number,
			BigDecimal product_price,BigDecimal cash_pay,BigDecimal product_pay){
		String sql="insert into kk_order_cache_item(order_cache_id,product_id,product_number,product_price,cash_pay,product_pay) values(?,?,?,?,?,?)";
		int b= Db.update(sql, new Object[]{order_cache_id, product_id, product_number, product_price, cash_pay, product_pay});
		if(b>0){
			return false;
		}
		return false;
	}
	
	

}
