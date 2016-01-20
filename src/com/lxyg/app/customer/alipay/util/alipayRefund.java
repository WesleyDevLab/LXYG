package com.lxyg.app.customer.alipay.util;


import com.alibaba.fastjson.JSONObject;
import com.lxyg.app.customer.alipay.config.AlipayConfig;
import com.lxyg.app.customer.alipay.sign.RSA;
import com.lxyg.app.customer.platform.weiapiUtil.HttpRequest;

import java.math.BigDecimal;
import java.util.*;

/**
 * Created by 秦帅 on 2016/1/11.
 */
public class alipayRefund {
    private static String alipay_app_id="2016010401061405";
    private static String alipay_app_method="refund_fastpay_by_platform_pwd";
    private static String alipay_app_version="1.0";
    private static String alipay_notify_url="www.lexiangyungou.cn:8080/LXYG/app/pay/wxpayNotify";

    public static String batchNo(){
        Random random=new Random(2);
        String str= UtilDate.getDate()+random.nextInt()*2;
        return str;
    }

    public static String detailData(List<JSONObject> objs){
        String str="";
        BigDecimal div=new BigDecimal(100);
        for(JSONObject obj:objs){
            str+=obj.getString("alipay_no")+"^"+obj.getBigDecimal("price").divide(div)+"^"+obj.getString("cause")+"#";
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

    public static String buildParmater(List<JSONObject> objs) {
        SortedMap<String, String> obj=new TreeMap<>();
        obj.put("service", alipay_app_method);
        obj.put("partner", AlipayConfig.partner);
        obj.put("_input_charset",AlipayConfig.input_charset);
        obj.put("notify_url", alipay_notify_url);
        obj.put("seller_email",AlipayConfig.SELLER);
        obj.put("refund_date",UtilDate.getDateFormatter());
        obj.put("batch_no",batchNo());
        obj.put("batch_num","1");
        obj.put("detail_data",detailData(objs));
        String sHtmlText = AlipaySubmit.buildRequest(obj,"get","确认");
        return sHtmlText;
    }


    public static void main(String[] args) {
        System.out.println(batchNo());
//        JSONObject obj1=new JSONObject();
//        obj1.put("alipay_no","2016011121001004230041189544");
//        obj1.put("price",0.01);
//        obj1.put("cause","skdjadjas");
//        List<JSONObject> objs=new ArrayList<>();
//        objs.add(obj1);
//        System.out.println(detailData(objs));
//        buildParmater(objs);
    }

}
