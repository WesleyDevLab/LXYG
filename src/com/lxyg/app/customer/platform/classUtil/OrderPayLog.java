package com.lxyg.app.customer.platform.classUtil;

import com.jfinal.plugin.activerecord.Db;
import com.lxyg.app.customer.platform.model.Order;

import java.util.Date;
import java.util.HashMap;

/**
 * Created by 秦帅 on 2016/5/30.
 */
public class OrderPayLog {

    public String getErrorMsg(int code){
         int errorCode_success=0;
         String errorMsg_success="成功";
         int errorCode_error=1;
         String errorMsg_error="订单状态异常";
         int errorCode_error_2=2;
         String errorMsg_error_2="订单未找到";
        java.util.Map map=new HashMap<Integer,String>();
        map.put(errorCode_success,errorMsg_success);
        map.put(errorCode_error,errorMsg_error);
        map.put(errorCode_error_2,errorMsg_error_2);

        return map.get(code).toString();
    }

    public boolean addPayLog(Order order,String alipayNo,Date date,int code){
        boolean b=false;
        int i= Db.update("insert into kk_order_action_log(order_id,alipay_no,create_time,all_price,pay_type,pay_status,pay_msg) values(?,?,?,?,?,?,?)",order.getStr("order_id"),
                alipayNo,date,order.getBigDecimal("price"),order.getInt("pay_type"),code,getErrorMsg(code));
        if(i>0){
            b=true;
        }
        return b;
    }

    public boolean addRefuseLog(Order order,String alipayNo,Date date,int code){
        boolean b=false;
        int i= Db.update("insert into kk_order_action_log(order_id,alipay_no,create_time,all_price,pay_type,refuse_status,refuse_msg) values(?,?,?,?,?,?,?)",order.getStr("order_id"),
                alipayNo,date,order.getBigDecimal("price"),order.getInt("pay_type"),code,getErrorMsg(code));
        if(i>0){
            b=true;
        }
        return b;
    }


}
