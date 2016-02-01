package com.lxyg.app.customer.platform.weiapiUtil;

import com.jfinal.core.Const;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.config.Config;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.M;
import com.lxyg.app.customer.tencent.common.HttpKit;
import com.lxyg.app.customer.tencent.common.RandomStringGenerator;
import com.lxyg.app.customer.tencent.common.Signature;
import com.lxyg.app.customer.tencent.common.XMLParser;
import org.apache.log4j.Logger;
import org.apache.taglibs.standard.extra.spath.Path;
import org.xml.sax.SAXException;

import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import com.lxyg.app.customer.platform.weiapiUtil.HttpRequest;

import static com.lxyg.app.customer.platform.weiapiUtil.HttpRequest.postSend;


public class WXUtil {
	private static final Logger log=Logger.getLogger(WXUtil.class);
	private static final String port="APP";
	public static final String MCH_ID = "1281748701";
	public static final String APPID = "wx2d2b54b6349d8ef7";
	private static final String SECRET="d4624c36b6795d1d99dcf0547af5443d";
	public static final String KEY="d4624c36b6795d1lxygcf0547af5443d";
	private static final String body="fengyu";
	public static final String token_url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+ WXUtil.APPID+"&secret="+ WXUtil.SECRET;
	private static final String pay_order_url="https://api.mch.weixin.qq.com/pay/unifiedorder";
	private static final String refund_url="https://api.mch.weixin.qq.com/secapi/pay/refund";
	private static final String refund_query="https://api.mch.weixin.qq.com/pay/refundquery";
	private static final String order_query="https://api.mch.weixin.qq.com/pay/orderquery";
	private static final String certPath= Path.class.getClassLoader().getResource("").getPath()+"res" + File.separator +"apiclient_cert.p12";

	private static final String notify_url="www.lexiangyungou.cn:8080/LXYG/app/pay/wxpayNotify";


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
		System.out.println(str);
		Map<String, Object> map=new HashMap<String, Object>();
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

	public static Map<String,Object> wxRefund(String transaction_id,String refund_id,Record conf,int total_fee) {
		//String certPath=new File("").getCanonicalPath()+ File.separator + "src" + File.separator + "res" + File.separator + "apiclient_cert.p12";
		Map<String,Object> map=new HashMap<String,Object>();
		Map<String,Object> res=new HashMap<String,Object>();
		File f=new File(certPath);
		if(!f.exists()){
			log.error("文件不存在!!!");
			return map;
		}
		map.put("appid",APPID);
		map.put("mch_id",MCH_ID);
		map.put("nonce_str",RandomStringGenerator.getRandomStringByLength(32));
		map.put("op_user_id",MCH_ID);
		map.put("out_refund_no",refund_id);
		map.put("total_fee",total_fee);
		map.put("refund_fee",total_fee);
		map.put("transaction_id",transaction_id);
		String sign= Signature.getSign(map,conf.getStr("key"));
		map.put("sign",sign);
		String postData= M.mapToXML(map);
		String str="";
		try {
			str= new certValidate().validate(certPath, MCH_ID, postData, refund_url);  //证书验证请求微信服务器
			res=XMLParser.getMapFromXML(new String(str.getBytes(),"UTF-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		return res;
	}



	public static Map<String,Object> orderQuery(String order_id,Record conf){
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("appid",APPID);
		map.put("mch_id",MCH_ID);
		map.put("nonce_str",RandomStringGenerator.getRandomStringByLength(32));
		map.put("out_trade_no",order_id);
		String sign= Signature.getSign(map,conf.getStr("key"));
		map.put("sign",sign);
		String postData= M.mapToXML(map);
		String str = postSend(order_query, postData);
		Map res=new HashMap();
		try {
			res=XMLParser.getMapFromXML(new String(str.getBytes(),"UTF-8"));
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		return res;
	}

	public static  Map<String,Object> refundQuery(String out_trade_no,Record conf){
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("appid",APPID);
		map.put("mch_id",MCH_ID);
		map.put("nonce_str",RandomStringGenerator.getRandomStringByLength(32));
		map.put("out_trade_no",out_trade_no);
		String sign= Signature.getSign(map,conf.getStr("key"));
		map.put("sign",sign);
		String postData= M.mapToXML(map);
		String str=postSend(refund_query,postData);
		Map res=new HashMap();
		try {
			res=XMLParser.getMapFromXML(new String(str.getBytes(),"UTF-8"));
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		return res;
	}

	public static Map<String,Object> orderQuery(String order_id,String key){
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("appid",APPID);
		map.put("mch_id",MCH_ID);
		map.put("nonce_str",RandomStringGenerator.getRandomStringByLength(32));
		map.put("out_trade_no",order_id);
		String sign= Signature.getSign(map,key);
		map.put("sign",sign);
		String postData= M.mapToXML(map);
		String str = postSend(order_query, postData);
		Map res=new HashMap();
		try {
			res=XMLParser.getMapFromXML(new String(str.getBytes(),"UTF-8"));
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}
		return res;
	}








//	public static void createMenu(){
//		delMenu();
//		String url="https://api.weixin.qq.com/cgi-bin/menu/create?access_token="+Token.loadTokenD();
//
//		JSONObject all=new JSONObject();
//		JSONObject obj=new JSONObject();
////		JSONObject obj1=new JSONObject();
//		JSONObject obj2=new JSONObject();
//		JSONArray array=new JSONArray();
//
//		obj.put("type","click");
//		obj.put("name","老板娘日记");
//		obj.put("key","v1");
//
////		obj1.put("type","view");
////		obj1.put("name","腔调");
////		obj1.put("url","http://www.kaka51.com");
//
//		obj2.put("type","view");
//		obj2.put("name","戳了怀孕");
//		obj2.put("url","http://www.kaka51.com/KAKAPlatform/android/kaka.jsp");
//
//		array.add(obj);
////		array.add(obj1);
//		array.add(obj2);
//
//		all.put("button", array);
//		String res="";
//		try {
//			res=HttpKit.post(url,all.toString());
//		} catch (IOException e) {
//			e.printStackTrace();
//		} catch (ExecutionException e) {
//			e.printStackTrace();
//		} catch (InterruptedException e) {
//			e.printStackTrace();
//		}
//
//	}

//	public static void delMenu(){
//		String url="https://api.weixin.qq.com/cgi-bin/menu/delete?access_token="+Token.loadTokenD();
//		String res="";
//		try {
//			res=HttpKit.get(url);
//		} catch (IOException e) {
//			e.printStackTrace();
//		} catch (ExecutionException e) {
//			e.printStackTrace();
//		} catch (InterruptedException e) {
//			e.printStackTrace();
//		} catch (NoSuchAlgorithmException e) {
//			e.printStackTrace();
//		} catch (NoSuchProviderException e) {
//			e.printStackTrace();
//		} catch (KeyManagementException e) {
//			e.printStackTrace();
//		}
//
//	}

	public static void main(String[] args) throws IOException, ExecutionException, InterruptedException {
		Map m=orderQuery("1009280584201601282954205678","d4624c36b6795d1lxygcf0547af5443d");
		System.out.println(m);
		//System.out.println(new File("").getAbsolutePath());
		//createMenu();
		//loadPrepayid("fdfafc67d2a446d9",93000,"121.42.192.108","123");
		//Record record=new Record();
		//wxRefund("1008760584201512292384335393","0f0929d278b248aa",record,2);
	}
}
