package com.lxyg.app.customer.platform.plugin;

import com.jfinal.plugin.IPlugin;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.model.User;

import java.util.Map;

public class JPush implements IPlugin {
	public JPush() {

	}
	public String Content;
	public String Title;
	public boolean flag=false;
	public String pushType="";
	public String uid;
	public Map<String,Object> map;
	public String plat;

	public JPush(String Title,String content,String uid,String pushType,Map<String,Object> map,String plat) {
		this.Content = content;
		this.pushType=pushType;
		this.uid=uid;
		this.map=map;
		this.Title=Title;
		this.plat=plat;
	}

	public boolean stop() {
		return true;
	}

	
	public boolean start() {
		if(pushType.equals("alias_one")){
			JPushKit.push(alias(plat,uid), plat, Content, map, Title);
		}
		return true;
	}

	public String alias(String plat,String uid){
		String alias="";
		if (plat.equals("user")){
			User u=User.dao.getUser(uid);
			alias=u.getStr("phone")!=null?u.getStr("phone"):u.getStr("wechat_id");
		}
		if (plat.equals("shop")){
			Shop shop=Shop.dao.findBysuid(uid);
			alias=shop.getStr("phone");
		}
		return alias;
	}

}

