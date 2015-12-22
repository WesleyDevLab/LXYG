package com.lxyg.app.customer.platform.listener;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.model.OrderCache;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.SdkMessage;
import org.apache.log4j.Logger;

import java.util.*;

/**
 * Created by Administrator on 2015/9/23.
 */
public class pushTimerTask extends TimerTask{

    private static Timer timer = null;
    @Override
    public void run() {
        pushMessage("start");
    }
    public static void pushMessage(String content){
        JPushKit.send_all(content);
    }

    public static  void begin(){
        if(timer==null){
            timer = new Timer(false);
        }
        pushTimerTask push=new pushTimerTask();
        Calendar calendar=Calendar.getInstance();
        calendar.set(Calendar.HOUR,15);
        calendar.set(Calendar.MINUTE,0);
        calendar.set(Calendar.SECOND,0);
        timer.schedule(push,calendar.getTime(),24*60*60*1000);
    }


    public static void end(){
        timer.cancel();
    }
    public static void main(String[] args) {
        begin();
    }
}
