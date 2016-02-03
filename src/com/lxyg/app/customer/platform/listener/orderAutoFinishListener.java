package com.lxyg.app.customer.platform.listener;


import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.service.OrderService;
import com.lxyg.app.customer.platform.util.DateTools;
import com.lxyg.app.customer.platform.util.IConstant;
import org.apache.log4j.Logger;

import java.text.ParseException;
import java.util.*;

public class orderAutoFinishListener extends TimerTask{
    private static Logger log=Logger.getLogger(orderAutoFinishListener.class);
    public static OrderService orderService=new OrderService();
    private static Timer timer = null;
    private static final int timeInterval=288000;

    @Override
    public void run() {
        log.error("执行自动更新为完成订单");
        try {
            List<Order> orders = Order.dao.find("select * from kk_order o where o.order_status=" + IConstant.OrderStatus.order_status_psz);
            for (Order order : orders) {
                net.sf.json.JSONObject obj=new net.sf.json.JSONObject();
                if (order.getDate("send_goods_time") != null) {
                    Date d = order.getDate("send_goods_time");
                    if (DateTools.getDaysOperationDate(new Date(), d) > timeInterval) {
                        obj.put("recCode",order.getStr("receive_code"));
                        order.set("finish_time",new Date());
                        order.update();
                        Order.dao.recordfinshOrder(order);
                    }
                }
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }

    public static void begin(){
        if(timer==null){
            timer = new Timer(false);
        }
        orderAutoFinishListener or=new orderAutoFinishListener();
        timer.schedule(or,24*60*60*1000,24*60*60*1000);
    }

    public static void cancle(){
        timer.cancel();
    }

}
