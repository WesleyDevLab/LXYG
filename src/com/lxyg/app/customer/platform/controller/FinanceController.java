package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.Controller;
import com.lxyg.app.customer.platform.model.Order;

import java.util.List;

/**
 * Created by 秦帅 on 2015/11/9.
 */
public class FinanceController extends Controller{
    public Order order=new Order();
    public void loadInfo(){
        String start=getPara("start");
        String end=getPara("end");
        List<Order> orders=order.find("SELECT s.name, s.phone, o.order_id, o.price, o.pay_type, o.pay_name, o.finish_time " +
                "FROM kk_order o LEFT JOIN kk_shop s ON o.s_uuid = s.uuid WHERE o.order_status = ? and o.finish_time BETWEEN ? and ?" ,4,start,end);
        for (Order o : orders) {
            o.put("orderItems", o.getOrderItems(o.getStr("order_id")));
        }
        setAttr("orders",orders);
        setAttr("msg",10001);
        render("/finance/flist.jsp");
    }
}
