package com.lxyg.app.customer.platform.util;

import com.bcloud.msg.http.HttpSender;

/**
 * Created by Administrator on 2015/9/9.
 */
public class httpSendMessage {
    public static void main(String[] args) {
        String url="http://222.73.117.158/msg/";
        String account="jiekou-clcs-07";
        String pasd="Clwh2009";
        String mobile="18625838770";
        String content="您的验证码是123456,五分钟有效哦";
        boolean needstatus=true;
        String product=null;
        String extno=null;
        try {
            String returnString = HttpSender.batchSend(url, account, pasd, mobile, content, needstatus, product, extno);
            System.out.println(returnString);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
