package com.lxyg.app.customer.platform.util;

import net.minidev.json.JSONArray;
import net.minidev.json.JSONValue;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class JsonUtils {
	public static String pojo2json(Object pojo){
		String jsonStr = JSONValue.toJSONString(pojo);
		return jsonStr;
	}
	
	/**
	 * json
	 * @param json
	 * @return
	 */
	public static Object json2pojo(String json){
		Object obj = null;
		try {
			obj = JSONValue.parse(json);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return obj;
	}
	/**
	 * list
	 * @param <T>
	 * @param list
	 * @return
	 */
	public static <T> String list2json(List<T> list){
        String jsonStr = JSONValue.toJSONString(list);
		return jsonStr;
	}
	/**
	 * json
	 * @param json
	 * @return
	 */
	public static List json2list(String json){
		Object obj= JSONValue.parse(json);
        JSONArray array=(JSONArray)obj;
		return array;
	}
	
	public static Map<String, Object> obj2map(Object obj) throws JSONException {
		Map<String,Object> map = new HashMap<String,Object>();
		JSONObject json = new JSONObject(obj.toString());
		Iterator it = json.keys();
		while(it.hasNext()){
			String key = (String) it.next();
			map.put(key,json.getString(key));
		}
		System.out.println(map);
		return map;

	}
	
	public static void main(String[] args) {
		String payment="{startTime:2015-08-10,endDate:2015-08-10,shopName:王沛栋无忧店铺,payType:2}";
		try {
			Map m=obj2map(payment);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
	
}