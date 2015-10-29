package com.lxyg.app.customer.platform.plugin;

import com.jfinal.plugin.IPlugin;
import com.lxyg.app.customer.platform.JPush.JPushKit;

import java.util.Map;

public class JPush implements IPlugin {
	public JPush() {}
	public String Content;
	public String Title;
	public String [] alias;
	public boolean flag=false;
	public String pushType="";
	public String phone;
	public Map<String,Object> map;
	public String plat;

	
	public JPush(String content,String pushType) {
		super();
		this.Content = content;
		this.pushType=pushType;
	}
	
	public JPush(String Title,String content,String phone,String pushType,Map<String,Object> map,String plat) {
		super();
		this.Content = content;
		this.pushType=pushType;
		this.phone=phone;
		this.map=map;
		this.Title=Title;
		this.plat=plat;
	}
	
	public boolean stop() {
		return true;
	}

	
	public boolean start() {

		if(pushType.equals("alias_one")){
			JPushKit.push(phone, plat, Content, map, Title);
		}
		return true;
	}

}

