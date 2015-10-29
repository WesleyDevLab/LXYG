package com.lxyg.app.customer.platform.util;

import com.lxyg.app.customer.platform.model.Shop;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

public final class WebUtils {
	
	public static boolean isNotBlank(String obj){
		boolean result = false;
		if(null != obj && !"".equals(obj.trim()))
			result = true;
		return result;
	}

	public static String uuid(){
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	public static String replaceStr(String str){
        return str.replaceAll("'","").replaceAll("\\*", "").replaceAll("\\|", "").replaceAll("\\+", "").replaceAll("=", "").replaceAll("-", "");
    }
	
	public static void logParam(HttpServletRequest req, String uri) {
		System.out.println("invoke ".concat(uri).concat(" at ").concat(DateTools.createTime()));
		Logger log = Logger.getLogger(WebUtils.class);
		PropertyConfigurator.configure("log4j.properties");
		Map m = req.getParameterMap();
		Set keySet = m.entrySet();  
		for(Iterator it= keySet.iterator();it.hasNext();){
			Map.Entry entry = (Map.Entry)it.next();
			Object value = entry.getValue();
			String[] values = new String[1]; 
			if(value instanceof String[]){
				values = (String[])value;
			}
			log.warn(entry.getKey() + ":" + values[0]);
//			System.out.println(entry.getKey()+":"+values[0]);
		}
	}

	/**
	 * 获取count个随机数
	 * @param count 随机数个数
	 * @return
	 */
	public static String game(int count){
		StringBuffer sb = new StringBuffer();
		String str = "0123456789";
		Random r = new Random();
		for(int i=0;i<count;i++){
			int num = r.nextInt(str.length());
			sb.append(str.charAt(num));
			str = str.replace((str.charAt(num)+""), "");
		}
		return sb.toString();
	}
	
	public static Long DoubleToLong(String num){
		long price=0;
		if(num.contains(".")){
			String [] z = num.split("\\.");
			long a1 = Long.parseLong(z[0]);
			long a2 = Long.parseLong(z[1]);
			if(z[1].length()==1){				
				price = a1*100+a2*10;
			}else if(z[1].length()==2){
				price = a1*100+a2;
			}else if(z[1].length()==0){
				price = a1*100;
			}

		}else{
			price = Integer.parseInt(num)*100;
		}
		return price;
	}
	
	
	public static  String[] getShopPhones(List<Shop> shops){
		String [] phones=new String[shops.size()];
		for(int i=0;i<shops.size();i++){
			phones[i]=shops.get(i).getStr("phone");
		}
		return phones;
	}
	
	public static void main(String[] args) {
		//1439970652_763677928_6a7897b45a67074e7f03ca14fe072be92bdfd417_7637327254535323485
		String timestamp = "1439970652";
		String nonce = "763677928";
		String signature = "6a7897b45a67074e7f03ca14fe072be92bdfd417";
		String echostr = "7637327254535323485";
		
		String[] str = {"kaka",timestamp,nonce};
		Arrays.sort(str);
		
		String bigStr = str[0] + str[1] + str[2]; 
		String digest = DigestUtils.shaHex(bigStr);
		System.out.println(bigStr);
		System.out.println(digest);
		
	}
	
}
