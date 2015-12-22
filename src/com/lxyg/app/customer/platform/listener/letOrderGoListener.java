package com.lxyg.app.customer.platform.listener;

import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.model.OrderCache;
import com.lxyg.app.customer.platform.util.IConstant;
import org.apache.log4j.Logger;

import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

public class letOrderGoListener extends TimerTask{
	private static Logger log= Logger.getLogger(letOrderGoListener.class);
	private static Timer timer = null;
	private static final int timeInterval=300;
	@Override
	public void run() {
		log.error("run --");

		String sql="select * from kk_order_cache oc where now()-oc.create_time>"+timeInterval+" and status=1";

		List<OrderCache> ocs=OrderCache.dao.find(sql);
		if(ocs!=null&&ocs.size()!=0){
			for(OrderCache oc: ocs){
				oc.set("status", 3);
				oc.update();
				Order o=Order.dao.findFirst("select * from kk_order o where o.order_id=?", oc.getStr("order_id"));
				if(o!=null){
					String error_msg="五分钟商户未抢单";
					Order.dao.createListener(o,error_msg);
				}
//				o.set("order_status", IConstant.OrderStatus.order_status_ld);
//				o.update();
//				o.createLog(oc.getStr("order_id"), IConstant.orderAction.order_action_lliudan, o.getStr("send_name"), null, ""+oc.getInt("id"), null, IConstant.OrderStatus.order_status_ld);
				/**
				 * cousor 推送  通知用户下单失败 产品
				 * **/
			}
		}

		String sqlA="select o.*,(now()- o.create_time) time from kk_order o ";
		List<Order> orders=Order.dao.find(sqlA);
		for(Order o:orders){
			String error_msg="五分钟商户未发货";
			if(o.getInt("order_status")== IConstant.OrderStatus.order_status_dfh && o.getDouble("time")>timeInterval){
				error_msg="五分钟商户未发货";
				Order.dao.createListener(o,error_msg);
			}
			if(o.getInt("order_status")== IConstant.OrderStatus.order_status_ld ){
				error_msg="该订单流单";
				Order.dao.createListener(o,error_msg);
			}
			if(o.getInt("order_status")== IConstant.OrderStatus.order_status_js ){
				error_msg="该订单被拒收";
				Order.dao.createListener(o,error_msg);
			}

			if(o.getInt("order_status")== IConstant.OrderStatus.order_status_psz && o.getDouble("time")>3000){
				error_msg="30分钟商户发货未送达";
				Order.dao.createListener(o,error_msg);
			}

			if(o.getInt("order_status")== IConstant.OrderStatus.order_status_psz){
				error_msg="已完成订单";
				OrderCache orderCache=OrderCache.dao.findFirst("select * from kk_order_cache where order_id=? and status=1",o.getStr("order_id"));
				if(orderCache!=null){
					Date date=orderCache.getDate("create_time");
					long diff=new Date().getTime()-date.getTime();
					if(diff>=1000*60*5){
						Order.dao.createListener(o, error_msg);
					}
				}
				Order.dao.createListener(o,error_msg);
			}
		}

//		String sqlA="select * from kk_order o where o.order_status  in ("+IConstant.OrderStatus.unusual+") and now()- o.create_time > "+timeInterval;
//		List<Order> orders=Order.dao.find(sqlA);
//		for(Order o:orders){
//			String error_msg="五分钟商户未发货";
//			if(o.getInt("order_status")==IConstant.OrderStatus.order_status_dfh){
//				error_msg="五分钟商户未发货";
//			}
//			if(o.getInt("order_status")==IConstant.OrderStatus.order_status_ld){
//				error_msg="该订单流单";
//			}
//			if(o.getInt("order_status")==IConstant.OrderStatus.order_status_js){
//				error_msg="该订单被拒收";
//			}
//			Order.dao.createListener(o,error_msg);
//		}
//
//		String sqlB="select * from kk_order o where o.order_status  in ("+IConstant.OrderStatus.order_status_psz+") and now()- o.create_time > "+3000;
//		List<Order> ordersB=Order.dao.find(sqlB);
//		for(Order o:ordersB){
//			String error_msg="30分钟商户发货未送达";
//			Order.dao.createListener(o, error_msg);
//		}
	}



	public static  void begin(){
		if(timer==null){
			timer = new Timer(false);
		}
		letOrderGoListener let=new letOrderGoListener();
		timer.schedule(let, 1000*60,1000*60*2);
	}

	public static void end(){
		timer.cancel();
	}
	public static void main(String[] args) {
		begin();
	}
	
}
