package com.lxyg.app.customer.platform.JPush;

import cn.jpush.api.JPushClient;
import cn.jpush.api.common.resp.APIConnectionException;
import cn.jpush.api.common.resp.APIRequestException;
import cn.jpush.api.push.PushResult;
import cn.jpush.api.push.model.Message;
import cn.jpush.api.push.model.Options;
import cn.jpush.api.push.model.Platform;
import cn.jpush.api.push.model.PushPayload;
import cn.jpush.api.push.model.audience.Audience;
import cn.jpush.api.push.model.notification.Notification;
import com.jfinal.log.Logger;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class JPushKit {
	private static final Logger log= Logger.getLogger(JPushKit.class);

	//商家版正式key
	private static String aB = ConfigUtils.getProperty("kaka.jpush.appkey");
	private static String masterSecretB = ConfigUtils.getProperty("kaka.jpush.masterSecret");

	//商家版测试key
	private static String aBT = ConfigUtils.getProperty("kaka.jpush.appkey_inHouse");
	private static String masterSecretBT = ConfigUtils.getProperty("kaka.jpush.masterSecret_inHouse");

	//客户版测试key
	private static String aCT = ConfigUtils.getProperty("kaka.jpush.appkey_inHouse_c");
	private static String masterSecretCT = ConfigUtils.getProperty("kaka.jpush.masterSecret_inHouse_c");

	//客户版测试key
	private static String aC = ConfigUtils.getProperty("kaka.jpush.appkey_c");
	private static String masterSecretC = ConfigUtils.getProperty("kaka.jpush.masterSecret_c");





	public static void push(String alias,String plat,String content,Map<String,Object> objs,String Title){
		Record r = new Record();
		//如果是商户端
		if(plat.equals("shop")){
			r= Db.findFirst("select * from kk_shop s where s.phone like ?", new Object[]{alias});
		}
		//如果是用户端
		if(plat.equals("user")){
			r= Db.findFirst("select * from kk_user s where s.phone like ? or s.wechat_id like ?", new Object[]{alias, alias});
		}


		//如果不为空
		if(r!=null){
			//如果ios是正式版 或者是android版本 则使用正式的可key推送数据

			if(r.getInt("login_android_in_test") ==1 || r.getInt("login_android_pub") ==1){
				if(plat.equals("shop")){
					send_alias(masterSecretB,aB,alias,objs,content,Title);
				}
				if(plat.equals("user")){
					System.out.println("+++++++"+masterSecretC);
					send_alias(masterSecretC,aC,alias,objs,content,Title);
				}
			}

			if(r.getInt("login_ios_inapp")==1 ){
				//如果是商家  则使用商家的key
				if(plat.equals("shop")){
					send_alias(masterSecretB,aB,alias,objs,content,Title);
				}
				if(plat.equals("user")){
					send_alias(masterSecretC,aC,alias,objs,content,Title);
				}

			}
			//如果是内测版 则使用ios内测版给ios设备推送
			if(r.getInt("login_ios_inhouse")==1){
				if(plat.equals("shop")){
					send_alias(masterSecretBT, aBT,alias,objs,content,Title);
				}
				if(plat.equals("user")){
					send_alias(masterSecretCT, aCT,alias,objs,content,Title);
				}

			}
		}
	}





	public static PushPayload buildPushObject_all_all_alert(String content) {

		return PushPayload.alertAll(content);
	}
	
	/*public static void  send_all(String content){
		log.info("send_alias_array");
		JPushClient jpushClient = new JPushClient(masterSecret.trim(), appkey.trim(),3);
        PushPayload payload = buildPushObject_all_all_alert(content);
        try {
            PushResult result = jpushClient.sendPush(payload);
            log.info("Got result - " + result);

        } catch (APIConnectionException e) {
        	log.error("Connection error, should retry later", e);

        } catch (APIRequestException e) {
        	log.error("Should review the error, and fix the request", e);
        	log.info("HTTP Status: " + e.getStatus());
        	log.info("Error Code: " + e.getErrorCode());
        	log.info("Error Message: " + e.getErrorMessage());
        }
	}*/


	public static PushPayload buildPushObject(String alias,Map<String,Object> extr,String content,String Title) {

		return PushPayload.newBuilder()
				.setPlatform(Platform.all())
				.setAudience(Audience.alias(alias))
				.setMessage(buildMessage(extr, content, Title))
				.build();
	}

	public static Message buildMessage(Map<String,Object> extr,String content,String Title){
		Message.Builder array= Message.newBuilder();
		Iterator iter = extr.entrySet().iterator();
		while(iter.hasNext()){
			Map.Entry entry = (Map.Entry) iter.next();
			String key=entry.getKey().toString();
			String val=entry.getValue().toString();
			array.addExtra(key, val);
		}
		return array.setMsgContent(content).setTitle(Title).build();
	}

	public static PushPayload buildPushObject_all_alias_alert(String alias,String Title,String content){
		return PushPayload.newBuilder()
				.setPlatform(Platform.all())
				.setAudience(Audience.alias(alias)).setOptions(Options.newBuilder()
						.setApnsProduction(true)
						.build())
				.setNotification(Notification.alert(content)).build();
	}


	public static PushPayload buildPushObject_all_alias_alert() {
		return PushPayload.newBuilder()
				.setPlatform(Platform.all())
				.setAudience(Audience.alias("15010751363"))
				.setNotification(Notification.ios_incr_badge(3)).setOptions(Options.newBuilder()
						.setApnsProduction(true)
						.build())
				.build();


//		return PushPayload.newBuilder()
//				.setPlatform(Platform.ios())
//				.setAudience(Audience.tag_and("tag1", "tag_all"))
//				.setNotification(Notification.newBuilder()
//						.addPlatformNotification(IosNotification.newBuilder()
//								.setAlert(ALERT)
//								.setBadge(5)
//								.setSound("happy.caf")
//								.addExtra("from", "JPush")
//								.build())
//						.build())
//				.setMessage(Message.content(MSG_CONTENT))
//				.setOptions(Options.newBuilder()
//						.setApnsProduction(true)
//						.build())
//				.build();
	}


	public static void  send_alias(String Secret,String app,String alias,Map<String, Object> extr,String content,String Title){
		log.error("send_alias_one");
		JPushClient jpushClient = new JPushClient(Secret.trim(),app.trim(),3);
		//PushPayload payload = buildPushObject(alias,extr,content,Title);
		//PushPayload payload = buildPushObject_all_alias_alert();
		 PushPayload payload = buildPushObject_all_alias_alert(alias, Title, content);
		try {
			PushResult result = jpushClient.sendPush(payload);
			log.info("Got result - " + result);
		} catch (APIConnectionException e) {
			log.error("Connection error, should retry later", e);
		} catch (APIRequestException e) {
			log.error("Should review the error, and fix the request", e);
			log.info("HTTP Status: " + e.getStatus());
			log.info("Error Code: " + e.getErrorCode());
			log.info("Error Message: " + e.getErrorMessage());
		}
	}
	
	/*public static void  send_alias_array(String alias[],Map<String,Object> extr,String content,String Title){
		JPushClient jpushClient = new JPushClient(masterSecret.trim(), appkey.trim(),3);
		for(String str:alias){
			PushPayload payload = buildPushObject(str,extr,content,Title);
			try {
				PushResult result = jpushClient.sendPush(payload);
				if(!result.isResultOK()){
					continue;
				}
				log.info("Got result - " + result);
			} catch (APIConnectionException e) {
				log.error("Connection error, should retry later", e);
			} catch (APIRequestException e) {
				log.error("Should review the error, and fix the request", e);
				log.info("HTTP Status: " + e.getStatus());
				log.info("Error Code: " + e.getErrorCode());
				log.info("Error Message: " + e.getErrorMessage());
			}
		}
	}*/


	public static void main(String[] args) {

		String alias_android="18837145615";
//		String alias_ios="18625838770";
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("orderId", "2e7f037ec8fe4cd1");
		map.put("type", IConstant.OrderStatus.order_status_kqd);
		send_alias(masterSecretB,aB,alias_android,map,"tetetetetet","test");
	}

}
