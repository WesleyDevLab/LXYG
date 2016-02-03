package com.lxyg.app.customer.platform.listener;

import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.plugin.JPush;

import java.util.TimerTask;

/**
 * Created by ��˧ on 2015/12/23.
 */
public class pushTask extends TimerTask {
    private String content;
    public pushTask(String content){

        this.content=content;
    };

    @Override
    public void run() {

    }

}
