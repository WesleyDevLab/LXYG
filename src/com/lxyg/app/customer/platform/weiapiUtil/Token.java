package com.lxyg.app.customer.platform.weiapiUtil;

import com.gson.util.HttpKit;
import net.sf.json.JSONObject;
import org.apache.commons.collections4.map.HashedMap;
import org.apache.log4j.Logger;

import java.util.Map;

/**
 * 微信的access_token容器，兼容多个公众账号。
 * @author wz
 *
 */
public class Token{
	private static Logger log= Logger.getLogger(com.lxyg.app.customer.platform.weiapiUtil.Token.class);
	private static Map<String,Object> Token=new HashedMap<String, Object>();
		/**
	 * 从微信服务器获取token
	 * @param
	 * @return
	 */
	public static String loadToken(){
		String rs = "";
		JSONObject obj=new JSONObject();
		try {
			rs = HttpKit.get(WXUtil.token_url);
			obj = JSONObject.fromObject(rs);
		} catch (Exception e) {
			log.error("异常",e);
		}
		return obj.getString("access_token");
		
	}

//	public static String loadTokenD(){
//		String appid="wxe3112550c99b97e6";
//		String secret="e4fc2d5793e4ae94b1d687d8abc90877";
//
//		String token_url="https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid="+appid+"&secret="+secret;
//		String rs = "";
//		JSONObject obj=new JSONObject();
//		try {
//			rs = HttpKit.get(token_url);
//			obj = JSONObject.fromObject(rs);
//		} catch (Exception e) {
//			log.error("异常",e);
//		}
//		return obj.getString("access_token");
//
//	}


	public static void main(String[] args) {

	}


}
