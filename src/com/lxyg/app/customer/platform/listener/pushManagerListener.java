package com.lxyg.app.customer.platform.listener;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.model.OrderCache;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.SdkMessage;
import org.apache.log4j.Logger;

import java.util.Date;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by Administrator on 2015/9/23.
 */
public class pushManagerListener extends TimerTask{
    private static Logger log= Logger.getLogger(letOrderGoListener.class);
    private static Timer timer = null;
    private static final int timeInterval=300;
    @Override
    public void run() {
        String sql="select * from kk_order_listener where message_status=0";
        List<Record> records= Db.find(sql);
        for(Record record:records){
            int status=record.getInt("order_status");
            pushMessage(status,record.getStr("order_id"));
        }
    }

    public static void pushMessage(int status,String order_id){
        Order order=Order.dao.findById(false,order_id);
        String message="";
        switch (status){
            case IConstant.OrderStatus.order_status_ld:
                String str="    订单流流单    ";
                SdkMessage.sendUser(ConfigUtils.getProperty("kaka.order.manager.phone"),str+buildMessage(order_id));
                break;
            case IConstant.OrderStatus.order_status_dfh:
                str="    暂无人发货    ";
                Date date=order.getDate("create_time");
                long diff=new Date().getTime()-date.getTime();
                if(diff>=1000*60*5){
                    Shop shop=Shop.dao.findBysuid(order.getStr("shop_id"));
                    String shopInfo=",下单店铺"+shop.getStr("name")+",店铺电话:"+shop.getStr("phone");
                    SdkMessage.sendUser(ConfigUtils.getProperty("kaka.order.manager.phone"),str+buildMessage(order_id)+shopInfo);
                }
                break;
            case IConstant.OrderStatus.order_status_js:
                str="    订单被拒收    ";
                SdkMessage.sendUser(ConfigUtils.getProperty("kaka.order.manager.phone"),str+buildMessage(order_id));
                break;
            case IConstant.OrderStatus.order_status_kqd:
                str="   暂无人抢单   ";
                OrderCache orderCache=OrderCache.dao.findFirst("select * from kk_order_cache where order_id=? and status=1",order_id);
                if(orderCache!=null){
                    date=orderCache.getDate("create_time");
                    diff=new Date().getTime()-date.getTime();
                    if(diff>=1000*60*5){
                        SdkMessage.sendUser(ConfigUtils.getProperty("kaka.order.manager.phone"),str+buildMessage(order_id));
                    }
                }
        }
        Db.update("update kk_order_listener ol set message_status=1 where ol.order_id=?", order_id);
    }

    public static String buildMessage(String order_id){
        Order order=Order.dao.findById(false,order_id);
        String str="";
        str+=",收货人:"+order.getStr("name");
        str+=",联系电话："+order.getStr("phone");
        str+=",收获地址:"+order.getStr("address");
        str+=",支付方式："+order.getStr("pay_name");
        str+=",购买产品：【";
        for(Record r:order.getOrderItems(order_id)){
            str+=r.getStr("name")+"*"+r.getInt("product_number")+",";
        }
        str+="】";
        str+="总价:"+order.getBigDecimal("price");
        return str;
    }
    public static  void begin(){
        if(timer==null){
            timer = new Timer(false);
        }
        pushManagerListener push=new pushManagerListener();
        timer.schedule(push, 1000*60,1000*60*3);
    }
    public static void end(){
        timer.cancel();
    }
    public static void main(String[] args) {
        begin();
    }
}
