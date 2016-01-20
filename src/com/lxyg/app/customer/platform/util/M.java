package com.lxyg.app.customer.platform.util;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.alipay.util.UtilDate;
import com.lxyg.app.customer.platform.weiapiUtil.WXUtil;
import com.lxyg.app.customer.tencent.common.HttpKit;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.json.JSONException;
import sun.awt.GlobalCursorManager;

import java.awt.geom.Point2D;
import java.io.*;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.ExecutionException;

public class M {
	private static final Logger log=Logger.getLogger(M.class);
	
	/**
	 * 产品属性
	 * select id as productId,name,title,price,market_price,cash_pay," +
					"p_type_id,p_brand_id,p_type_name,p_brand_name,cover_img,p_unit_id,p_unit_name,descripation," +
					"hide,index_show,server_id,server_name,payment,create_time from kk_product where id=?
	 * 
	 * */

	
	
	public static JSONObject FAILE(String code,String msg){
		JSONObject J=new JSONObject();
		J.put("code", code);
		J.put("msg", msg);
		return J;
	}
	public static String getOrderNo(){
		return ""+System.currentTimeMillis();
	}
    public static String getOrderId(){
		return WebUtils.uuid().substring(0, 16);
	}
    public static String getUUID(){
		return WebUtils.uuid().substring(0, 16);
	}
    
    public static String getCoe(String uuid){
    	String str= WebUtils.uuid().substring(0, 3)+uuid+ WebUtils.uuid().substring(0, 3);
    	return str;
    }
    public static String parseCode(String code){
    	String str=code.substring(3, code.length()-3);
    	return str;
    }
    
    public static Map<String,Object> pushMap(String orderId,int type){
    	Map<String,Object> map=new HashMap<String, Object>();
    	map.put("orderId", orderId);
    	map.put("type", type);
    	return map;
    }
	public static Map<String,Object> pushMap(int formId){
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("formId", formId);
		return map;
	}

    
    public static String getCashItemSql(int cashId,int count,int unit){
    	String str="";
    	for(int i=0;i<count;i++){
    		str+="("+cashId+","+unit+","+ IConstant.cashItem.cash_item_status_h+"),";
    	}
    	str=str.substring(0, str.length()-1);
    	return str;
    }
    
    
    public static String getUserListSql(String shopId){
    	Calendar cl= M.getBeforeDay(new Date());
    	for(int i=0;i< IConstant.PAGE_DATA;i++){
    		cl= M.getBeforeDay(cl.getTime());
    		String time= M.printCalendar(cl);
    		String str="SELECT ('"+time+"'), " +
        			"( SELECT count(u.id) AS new FROM kk_shop s, kk_user u WHERE u.create_time LIKE '%"+time+"%' AND s.uuid = u.shop_id AND u.shop_id = '"+shopId+"' ) AS new, " +
        			"( SELECT count(u.id) AS allU FROM kk_shop s, kk_user u WHERE s.uuid = u.shop_id AND u.shop_id = '"+shopId+"' ) AS allU;";
    	}
    	return "";
    }
    
    public static Calendar getBeforeDay(Date d){  
    	Calendar cl = Calendar.getInstance();  
        cl.setTime(d);
        int day = cl.get(Calendar.DATE);  
        cl.set(Calendar.DATE, day-1);
        return cl;  
    } 
    public static String printCalendar(Calendar cl){
    	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
        return sdf.format(cl.getTime());
    }  
    
    public static List<Record> findsim(List<Record> shops){
    	List<Record> list=new ArrayList<Record>();
    	int len=shops.size();
    	if(len==0){
    		return null;    		
    	}
    	if(len==1){
    		return shops;
    	}
    	for(int i=0;i<len;i++){
    		for(int j=1;j<len;j++){
    			if(shops.get(i).getInt("num")==shops.get(j).getInt("num")){
    				list.add(shops.get(i));
    			}
    		}
    	}
    	return list;
    }
    
    public static void test(List<Record> shops) {
        String [] arry = {"1","1","1","1","1","2","2","2","2","2","3","3","3","3"};
        
        Map<String,Integer> map = new HashMap<String, Integer>();  
        for(int i =0 ;i<shops.size();i++){  
            if(null!= map.get(arry[i])){  
                map.put(arry[i], map.get(arry[i-1])+1); //value+1  
            }else{  
                map.put(arry[i],1);  
            }  
        }  
          
        Iterator it = map.entrySet().iterator();    
        while(it.hasNext()){  
            Map.Entry entry = (Map.Entry) it.next();     
            String  key  =  entry.getKey().toString();        
            int  value  =  Integer.parseInt(entry.getValue().toString());  
        }
    }
    
    public static String mapToString(Map<String,String> map){
    	
    	if(map.isEmpty()){
    		return "";
    	}
    	String str="";
    	for(Map.Entry<String, String> entry:map.entrySet()){
    		str+=entry.getKey()+"="+entry.getValue()+"&";
    	}
    	str=str.substring(0, str.length()-1);
    	return str;
    }
    public static String urlEncoder(Map<String,Object> map){
    	if(map.isEmpty()){
    		return "";
    	}
    	String str="";
    	for(Map.Entry<String, Object> entry:map.entrySet()){
    		str+=entry.getKey()+"="+getURLEncoder(entry.getValue().toString())+"&";
    	}
    	str=str.substring(0, str.length()-1);
    	return str;
    }
    private static String getURLEncoder(String str){
    	return URLEncoder.encode(str);
    }
    
    public static String mapToXML(SortedMap<String,Object> map){
    	
    	String str="<xml>";
    	for(Map.Entry<String, Object> entry:map.entrySet()){
    		str+="<"+entry.getKey()+">"+entry.getValue().toString()+"</"+entry.getKey()+">";    
    	}
    	str+="</xml>";
    	return str;
    }
    
    public static String mapToXML(Map<String,Object> map){
    	String str="<xml>";
    	for(Map.Entry<String, Object> entry:map.entrySet()){
    		str+="<"+entry.getKey()+">"+entry.getValue().toString()+"</"+entry.getKey()+">";    
//    		if(entry.getKey().equalsIgnoreCase("attach")||entry.getKey().equalsIgnoreCase("body")||entry.getKey().equalsIgnoreCase("sign")){
//    			str+="<"+entry.getKey()+">"+"<![CDATA["+entry.getValue().toString()+"]]"+"</"+entry.getKey()+">";
//    		}else{
//    			str+="<"+entry.getKey()+">"+entry.getValue().toString()+"</"+entry.getKey()+">";    			
//    		}
    	}
    	str+="</xml>";
		return str;
    }
    
    public static String createSign(String characterEncoding,SortedMap<String,Object> parameters){
        StringBuffer sb = new StringBuffer();
        Set es = parameters.entrySet();
        Iterator it = es.iterator();
        while(it.hasNext()) {
            Map.Entry entry = (Map.Entry)it.next();
            String k = (String)entry.getKey();
            Object v = entry.getValue();
            if(null != v && !"".equals(v) 
                    && !"sign".equals(k) && !"key".equals(k)) {
                sb.append(k + "=" + v + "&");
            }
        }
        sb.append("key=" + WXUtil.KEY);
        String sign =sb.toString();
        
        return sign;
    }
    
    /**
     *  在交易完成时，如何给商户清分？
		平台实收款 = 订单总额 – 电子现金使用金额
		给抢单商户的结算金额 = 平台实收款 - 订单总额 × 佣金比例 + 电子现金使用额度 ×清分系数
		给让单商户的结算金额 = 订单总额 × 佣金比例
		给普通商户的结算金额 = 平台实收款+电子现金使用额度 ×清分系数  | 订单总额-
     * 
     * **/
	public static int loadInfo() {
		String str= null;
		try {
			str = HttpKit.get("http://1.wujinhaoyu.sinaapp.com/lxyg/lxyg.php");
		} catch (KeyManagementException e) {
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (NoSuchProviderException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		List list=JsonUtils.json2list(str);
		try {
			return Integer.parseInt(JsonUtils.obj2map(list.get(0)).get("types").toString());
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return 2;
	}




    public static void main(String[] args){
		BigDecimal b1=new BigDecimal(1);
		BigDecimal b2=new BigDecimal(100);
		System.out.println(Math.round(b1.intValue()/100));
    }
}
