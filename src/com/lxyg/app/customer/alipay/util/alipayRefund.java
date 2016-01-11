package com.lxyg.app.customer.alipay.util;


import com.alibaba.fastjson.JSONObject;
import com.lxyg.app.customer.alipay.config.AlipayConfig;
import com.lxyg.app.customer.alipay.sign.RSA;
import com.lxyg.app.customer.platform.weiapiUtil.HttpRequest;
import com.sun.org.apache.xpath.internal.SourceTree;
import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;

import java.io.UTFDataFormatException;
import java.util.*;

/**
 * Created by 秦帅 on 2016/1/11.
 */
public class alipayRefund {
    private static String alipay_app_id="2016010401061405";
    private static String alipay_app_method="alipay.trade.refund";
    private static String alipay_app_version="1.0";
    private static String alipay_notify_url="www.lexiangyungou.cn:8080/LXYG/app/pay/wxpayNotify";

    public static String batchNo(){
        String str= UtilDate.getDate()+"0011";
        return str;
    }

    public static String detailData(List<JSONObject> objs){
        String str="";
        for(JSONObject obj:objs){
            str+=obj.getString("alipay_no")+"^"+obj.getDouble("price")+"^"+obj.getString("cause")+"#";
        }
        return str.substring(0,str.length()-1);
    }
    public static String mapToString(Map<String,String> map){
        String str="";
        Iterator<String> keys = map.keySet().iterator();
        while (keys.hasNext()){
            String key=keys.next();
            Object value=map.get(key);
            str+=key+"="+value+"&";
        }
        return str;
    }

    public static void buildParmater(List<JSONObject> objs) {
        SortedMap<String, String> obj=new TreeMap<>();
        obj.put("service", "refund_fastpay_by_platform_pwd");
        obj.put("partner", AlipayConfig.partner);
        obj.put("_input_charset",AlipayConfig.input_charset);
        obj.put("seller_email","29424467@qq.com");
        obj.put("refund_date",UtilDate.getDateFormatter());
        obj.put("batch_no",batchNo());
        obj.put("batch_num","1");
        obj.put("detail_data",detailData(objs));
        String signBody=mapToString(obj);
        obj.put("sign_type","RSA");
        String sign= RSA.sign(signBody,AlipayConfig.RSA_PRIVATE,AlipayConfig.input_charset);
        obj.put("sign",sign);


        SortedMap<String, String> m = new TreeMap<String, String>();
        m.put("app_id",alipay_app_id);
        m.put("method",alipay_app_method);
        m.put("charset","utf-8");
        m.put("sign_type","RSA");
        m.put("timestamp",UtilDate.getDateFormatter());
        m.put("version",alipay_app_version);
        m.put("notify_url",alipay_notify_url);
        m.put("biz_content",obj.toString());
        String signBodys=mapToString(m);
        String signs=RSA.sign(signBodys,AlipayConfig.RSA_PRIVATE,AlipayConfig.input_charset);
        m.put("sign",signs);
        HttpRequest httpRequest=new HttpRequest();
       String str= httpRequest.postSend("https://openapi.alipay.com/gateway.do",m.toString());
        System.out.println(str);

    }
    public static void main(String[] args) {
        JSONObject obj1=new JSONObject();
        obj1.put("alipay_no","2016011121001004230041189544");
        obj1.put("price",0.01);
        obj1.put("cause","skdjadjas");
        List<JSONObject> objs=new ArrayList<>();
        objs.add(obj1);

        System.out.println(detailData(objs));
        buildParmater(objs);
    }


}
