package com.lxyg.app.customer.platform.listener;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;

import java.util.*;

/**
 * Created by Administrator on 2015/9/23.
 */
public class pushTimerTask{
    private static Timer timer=null;
    private static TimerTask timerTask=null;

    public void cancel(){
        timerTask.cancel();
    }

    public void begin(){
        if(timer==null){
            timer=new Timer();
        }
        List<Record> records=Db.find("select * from kk_push_content pc where open=1");
        Calendar calendar=Calendar.getInstance();
        calendar.set(Calendar.HOUR_OF_DAY,20);
        calendar.set(Calendar.MINUTE,0);
        calendar.set(Calendar.SECOND,0);
        for(Record record:records){
            timerTask=new pushTask("是时候吃饭了！");
            timer.schedule(timerTask, calendar.getTime(),1000);
        }
    }
    public static void end(){
        timerTask.cancel();
    }
}
