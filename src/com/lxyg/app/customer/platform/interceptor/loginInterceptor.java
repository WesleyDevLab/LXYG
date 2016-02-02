package com.lxyg.app.customer.platform.interceptor;

import com.jfinal.aop.Interceptor;
import com.jfinal.core.ActionInvocation;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.MD5;
import net.sf.json.JSONObject;

import javax.servlet.http.HttpServletRequest;


public class loginInterceptor implements Interceptor {
	public void intercept(ActionInvocation ai) {
		JSONObject obj=new JSONObject();
		String sec= ConfigUtils.getProperty("kaka.server.secret");
		HttpServletRequest req=ai.getController().getRequest();
		if(!req.getMethod().equals("POST")){
			 obj.put("code",10001);
	    	 obj.put("msg", "请用POST请求方式！");
	    	 ai.getController().renderJson(obj);
	    	 return;
		}
	   	 String appid=req.getHeader("appid");
	   	 String chnl=req.getHeader("chnl");
	   	 String dev=req.getHeader("dev");
	   	 String m=req.getHeader("m");
	   	 String os=req.getHeader("os");
	   	 String t=req.getHeader("t");
	   	 String ver=req.getHeader("ver");
	   	 String sign=req.getHeader("sign");
		 String eMd5="appid="+appid+"&chnl="+chnl+"&dev="+dev+"&m="+m+"&os="+os+"&t="+t+"&ver="+ver+"&secret="+sec;
		 String emd5_ios="os="+os+"&dev="+dev+"&ver="+ver+"&chnl="+chnl+"&t="+t+"&appid="+appid+"&m="+m+"&secret="+sec;
	 if(sign==null||sign.equals("")){
		 obj.put("code",10001);
    	 obj.put("msg", " 签名错误！");
		 ai.getController().renderJson(obj);
    	 return;
	 }
	 if( !sign.equals(MD5.getMd5String(eMd5).toLowerCase()) && !sign.equals(MD5.getMd5String(emd5_ios).toLowerCase()) ){
		 obj.put("code",10001);
    	 obj.put("msg", "header 文件错误！");
		 ai.getController().renderJson(obj);
		 return;
	 }
	ai.invoke();
	}
}
