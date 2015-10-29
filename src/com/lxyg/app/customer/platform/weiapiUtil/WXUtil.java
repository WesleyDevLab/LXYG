package com.lxyg.app.customer.platform.weiapiUtil;

import com.alibaba.fastjson.JSONArray;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.M;
import com.lxyg.app.customer.tencent.common.HttpKit;
import com.lxyg.app.customer.tencent.common.RandomStringGenerator;
import com.lxyg.app.customer.tencent.common.Signature;
import com.lxyg.app.customer.tencent.common.XMLParser;
import net.sf.json.JSONObject;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import java.io.IOException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;


public class WXUtil {
	
	private static final String port="APP";
	public static final String MCH_ID = "1265752401";
	public static final String APPID = "wx66772ad04800ff7d";
	private static final String SECRET="98cfe39598986bc2255b4b3d62ff7e1f";
	public static final String KEY="98cfe39598986bkaka5b4b3d62ff7e1f";
	private static final String body="kakawuyou";
	
	
	public static final String token_url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+ WXUtil.APPID+"&secret="+ WXUtil.SECRET;
	private static final String pay_order_url="https://api.mch.weixin.qq.com/pay/unifiedorder";
	private static final String notify_url="www.kaka51.com/KAKAPlatform/app/pay/wxpayNotify";


	
	public static Map<String, Object> loadPrepayid(String orderNo,int total,String ip,String attach) throws IOException, ExecutionException, InterruptedException{
		Map<String, Object> params = new HashMap<String,Object>();
		params.put("appid", APPID);
		params.put("attach",attach);
		//params.put("device_info", "APP-001");
		params.put("body", body);
		//params.put("detail", detail);
		params.put("mch_id", MCH_ID);
		params.put("notify_url", notify_url);
		params.put("nonce_str", RandomStringGenerator.getRandomStringByLength(32));
		params.put("out_trade_no", orderNo);
		params.put("total_fee", total);
		params.put("trade_type", port);
		params.put("spbill_create_ip", ip);
		
		String sign= Signature.getSign(params);
		params.put("sign", sign);
		String postData= M.mapToXML(params);
		String str=HttpKit.post(pay_order_url, new String(postData.getBytes(),"ISO8859-1"));
		Map<String, Object> map=new HashMap<String, Object>();
		System.out.println("res:"+str);
		try {
			 map=XMLParser.getMapFromXML(new String(str.getBytes(),"UTF-8"));
			 
			 Map<String,Object> res=new HashMap<String, Object>();
			 res.put("appid", APPID);
			 res.put("partnerid", MCH_ID);
			 res.put("timestamp", DateUtil.getTimeStamp());
			 res.put("noncestr", RandomStringGenerator.getRandomStringByLength(32));
			 res.put("package", "Sign=WXPay");
			 res.put("prepayid", map.get("prepay_id").toString());
			 String sign1=Signature.getSign(res);
			 res.put("sign", sign1);
			 
			 return res;
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return map;
	}


	public static Map<String, Object> loadPrepayid(Record conf,String orderNo,int total,String ip,String attach) throws IOException, ExecutionException, InterruptedException{
		Map<String, Object> params = new HashMap<String,Object>();
		params.put("appid", conf.getStr("app_key"));
		//params.put("device_info", "APP-001");
		params.put("body",body);
		//params.put("detail", detail);
		params.put("mch_id", conf.getStr("mch_id"));
		params.put("notify_url", notify_url);
		params.put("nonce_str", RandomStringGenerator.getRandomStringByLength(32));
		params.put("out_trade_no", orderNo);
		params.put("total_fee", total);
		params.put("trade_type", conf.getStr("port"));
		params.put("spbill_create_ip", ip);

		String sign= Signature.getSign(params, conf.getStr("key"));
		params.put("sign", sign);
		String postData= M.mapToXML(params);
		String str=HttpKit.post(pay_order_url,postData);
		Map<String, Object> map=new HashMap<String, Object>();
		try {
			map=XMLParser.getMapFromXML(new String(str.getBytes(),"UTF-8"));
			Map<String,Object> res=new HashMap<String, Object>();
			res.put("appid", conf.getStr("app_key"));
			res.put("partnerid", conf.getStr("mch_id"));
			res.put("timestamp", DateUtil.getTimeStamp());
			res.put("noncestr", RandomStringGenerator.getRandomStringByLength(32));
			res.put("package", "Sign=WXPay");
			res.put("prepayid", map.get("prepay_id").toString());
			String sign1=Signature.getSign(res,conf.getStr("key"));
			res.put("sign", sign1);
			return res;
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}

	
    public static String MapToXml(Map<String,Object> map){
    	Iterator<String> it = map.keySet().iterator();
    	StringBuilder sb = new StringBuilder("<xml>");
    	while(it.hasNext()){
    		String k = it.next();
    		Object v = map.get(k);
    		
    		String vstr = v.toString();
    		if(k.equals("Articles")){
    			vstr = "";
    			List<Map<String,Object>> maps=(List<Map<String, Object>>) map.get("Articles");
    			for(Map<String,Object> m:maps){
    				String Title="<![CDATA["+m.get("Title").toString()+"]]>";
    				String Description="<![CDATA["+m.get("Description").toString()+"]]>";
    				String Url="<![CDATA["+m.get("Url").toString()+"]]>";
    				String PicUrl="<![CDATA["+m.get("PicUrl").toString()+"]]>";   				
    				vstr +="<item><Title>"+Title+"</Title><Description>"+Description+"</Description><PicUrl>"+PicUrl+"</PicUrl><Url>"+Url+"</Url></item>";
    			}
    		}else{
    			try {
    				int i = (Integer) (v);
    			} catch (Exception e) {
    				vstr = "<![CDATA["+vstr+"]]>";    				
    			}
    		}   		
    		sb.append("<").append(k).append(">").append(vstr).append("</").append(k).append(">");
    	}
    	sb.append("</xml>");
    	return sb.toString();
    }
	public static void createMenu(){
		delMenu();
		String url="https://api.weixin.qq.com/cgi-bin/menu/create?access_token="+Token.loadTokenD();

		JSONObject all=new JSONObject();
		JSONObject obj=new JSONObject();
//		JSONObject obj1=new JSONObject();
		JSONObject obj2=new JSONObject();
		JSONArray array=new JSONArray();

		obj.put("type","click");
		obj.put("name","老板娘日记");
		obj.put("key","v1");

//		obj1.put("type","view");
//		obj1.put("name","腔调");
//		obj1.put("url","http://www.kaka51.com");

		obj2.put("type","view");
		obj2.put("name","戳了怀孕");
		obj2.put("url","http://www.kaka51.com/KAKAPlatform/android/kaka.jsp");

		array.add(obj);
//		array.add(obj1);
		array.add(obj2);

		all.put("button", array);
		System.out.println(all.toString());
		String res="";
		try {
			res=HttpKit.post(url,all.toString());
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		System.out.println(res);

	}

	public static void delMenu(){
		String url="https://api.weixin.qq.com/cgi-bin/menu/delete?access_token="+Token.loadTokenD();
		String res="";
		try {
			res=HttpKit.get(url);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ExecutionException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (NoSuchProviderException e) {
			e.printStackTrace();
		} catch (KeyManagementException e) {
			e.printStackTrace();
		}

	}

	public static void main(String[] args) throws IOException, ExecutionException, InterruptedException {
		createMenu();

	//	String str="<xml><appid>wx9e721ab3631bd8bb</appid><attach>[购买] 飞天茅台*1|</attach><body>乐享云购微信支付</body><mch_id>1263785401</mch_id><nonce_str>e8250fefcc084a2d8dd69e0a30bac84e</nonce_str><notify_url>www.kaka51.com/KAKAPlatform/app/pay/wxpayNotify</notify_url><out_trade_no>1439778774303</out_trade_no><sign>210BC6CF328FDD56BB0E50D62D48A9AF</sign><spbill_create_ip>121.42.192.108</spbill_create_ip><total_fee>1</total_fee><trade_type>APP</trade_type></xml>";
		
	//	loadPrepayid("fdfafc67d2a446d9",93000,"121.42.192.108","123");
	//	String str111="<xml><appid>wx9e721ab3631bd8bb</appid><attach>[购买] 飞天茅台*1|</attach><body>乐享云购微信支付</body><mch_id>1263785401</mch_id><nonce_str>81c6eb612c064c00a4ab09f13e82929d</nonce_str><notify_url>www.kaka51.com/KAKAPlatform/app/pay/wxpayNotify</notify_url><out_trade_no>1439778774303</out_trade_no><sign>378DBA2F6B7D27D189E9AB92E3F64307</sign><spbill_create_ip>121.42.192.108</spbill_create_ip><total_fee>1</total_fee><trade_type>APP</trade_type></xml>";
	//	String str=   "<xml><appid>wx9e721ab3631bd8bb</appid><attach>[购买] 飞天茅台*1|</attach><body>乐享云购微信支付</body><mch_id>1263785401</mch_id><nonce_str>44b9aa36521f4b0fb5239c33e26278f5</nonce_str><notify_url>www.kaka51.com/KAKAPlatform/app/pay/wxpayNotify</notify_url><out_trade_no>1439778774303</out_trade_no><sign>378DBA2F6B7D27D189E9AB92E3F64307</sign><spbill_create_ip>121.42.192.108</spbill_create_ip><total_fee>1</total_fee><trade_type>APP</trade_type></xml>";
//		String str11="<xml><appid>wx2421b1c4370ec43b</appid><attach>支付测试</attach><body>JSAPI支付测试</body><mch_id>10000100</mch_id><nonce_str>1add1a30ac87aa2db72f57a2375d8fec</nonce_str><notify_url>http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php</notify_url><out_trade_no>1415659990</out_trade_no><spbill_create_ip>14.23.150.211</spbill_create_ip><total_fee>1</total_fee><trade_type>APP</trade_type><sign>0CB01533B8C1EF103065174F50BCA001</sign></xml>";
//		String str1=HttpKit.post(pay_order_url, str11);
//		System.out.println(str1);
	}
}
