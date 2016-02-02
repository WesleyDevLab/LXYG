package com.lxyg.app.customer.platform.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.core.ActionInvocation;
import com.jfinal.plugin.activerecord.Db;
import com.lxyg.app.customer.platform.model.Manager;
import net.sf.json.JSONObject;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;

public class visitInterceptor implements Interceptor {

	public void intercept(ActionInvocation ai) {
		String ip="";
		String device="";
		String user_id = "0";
		String session_id="";
		String macAddress = "";
		HttpServletRequest req=ai.getController().getRequest();
		
		Manager m=ai.getController().getSessionAttr("manager");
		if(m!=null){
			user_id=m.get("uid");
		}
		String info=ai.getController().getPara("info");
		JSONObject JB= JSONObject.fromObject(info);
		if(JB.containsKey("uid")){
			user_id=JB.getString("uid");			
		}
		ip=req.getRemoteAddr();
		String url=req.getRequestURL().toString();
		if(req.getQueryString()!=null){
			url=req.getRequestURL().toString()+"?"+req.getQueryString();
		}
		if(req.getCookies() !=null){
			for(Cookie c:req.getCookies()){
				if(c.getName().equals("JSESSIONID")){
					session_id=c.getValue();
				}
			}
		}
        device=req.getHeader("dev");
        if(device==null||device.equals("")){
        	device="pc";
        }
		new VisitThread(ip,device,user_id,session_id,url).start();
		ai.invoke();
	}
}

class VisitThread extends Thread{
	String ip;
	String device;
	String user_id;
	String session_id;
	String url;
	String mac_address;
	public VisitThread(String ip,String device,String user_id,String session_id,String url){
		this.ip=ip;
		this.device=device;
		this.user_id=user_id;
		this.session_id=session_id;
		this.url=url;
//		if(device.equals("pc")){
//		   this.mac_address=GetMacAddress.getMacAddress(ip);
//		}

	}
	@Override
	public void run() {
		Db.update("insert into kk_visit(ip,device,user_id,session_id,url,visit_time,mac_address) values(?,?,?,?,?,?,?)", ip, device, user_id, session_id, url, new Date(),mac_address);
		super.run();
	}
	
}
