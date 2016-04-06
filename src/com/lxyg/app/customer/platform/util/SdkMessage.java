package com.lxyg.app.customer.platform.util;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.log4j.Logger;

import java.io.IOException;

public class SdkMessage {
	private static final Logger log= Logger.getLogger(SdkMessage.class);
//	// 网址、端口、协议
//		private String httpAddressUrl;
//
//		// 信息发送地址
//		private String msgSendUrl;
//
//		// 余额查询地址
//		private String msgQueryUrl;
//
//		// 用户验证
//		private String msgCheckUrl;
//
//		// 短信定时发送
//		private String msgScheSendUrl;
//
//		// 短信接收地址
//		private String msgRegUrl;
//		// 更改密码地址
//		private String msgModifyUrl;
//
//		public String getMsgModifyUrl() {
//			return msgModifyUrl;
//		}
//
//		public void setMsgModifyUrl(String msgModifyUrl) {
//			this.msgModifyUrl = msgModifyUrl;
//		}
//
//		public String getMsgCheckUrl() {
//			return msgCheckUrl;
//		}
//
//		public void setMsgCheckUrl(String msgCheckUrl) {
//			this.msgCheckUrl = msgCheckUrl;
//		}
//
//		public String getMsgScheSendUrl() {
//			return msgScheSendUrl;
//		}
//
//		public void setMsgScheSendUrl(String msgScheUrl) {
//			this.msgScheSendUrl = msgScheUrl;
//		}
//
//		public String getHttpAddressUrl() {
//			return httpAddressUrl;
//		}
//
//		public void setHttpAddressUrl(String httpAddressUrl) {
//			this.httpAddressUrl = httpAddressUrl;
//		}
//
//		public String getMsgQueryUrl() {
//			return msgQueryUrl;
//		}
//
//		public void setMsgQueryUrl(String msgQueryUrl) {
//			this.msgQueryUrl = msgQueryUrl;
//		}
//
//		public String getMsgSendUrl() {
//			return msgSendUrl;
//		}
//
//		public void setMsgSendUrl(String msgSendUrl) {
//			this.msgSendUrl = msgSendUrl;
//		}
//
//		// 发送信息
//		public PostMethod getSend(String userName, String password, String mobile,
//				String content) {
//			// System.out.println("sms send method");
//			StringBuilder url = new StringBuilder();
//			url.append("accountname=");
//			url.append(userName);
//			url.append("&accountpwd=");
//			url.append(password);
//			url.append("&mobilecodes=");
//			url.append(mobile);
//			url.append("&msgcontent=");
//			url.append(content);
//			// System.out.println(url);
//			PostMethod post = new PostMethod(msgSendUrl);
//			post.setRequestHeader("Content-type", "text/xml; charset=gbk");
//			post.setRequestBody(url.toString());
//			return post;
//		}
//
//		// 定时发送信息
//		public PostMethod getScheSend(String userName, String password,
//				String mobile, String content, String scheTime) {
//			StringBuilder url = new StringBuilder();
//			url.append("accountname=");
//			url.append(userName);
//			url.append("&accountpwd=");
//			url.append(password);
//			url.append("&mobilecodes=");
//			url.append(mobile);
//			url.append("&attime=");
//			url.append(scheTime);
//			url.append("&msgcontent=");
//			url.append(content);
//			// System.out.println(url);
//			PostMethod post = new PostMethod(msgScheSendUrl);
//			post.setRequestHeader("Content-type", "text/xml; charset=gbk");
//			post.setRequestBody(url.toString());
//			return post;
//		}
//
//		// 余额查询
//		public PostMethod getQuery(String userName, String password) {
//			StringBuilder url = new StringBuilder();
//			url.append("accountname=");
//			url.append(userName);
//			url.append("&accountpwd=");
//			url.append(password);
//			// System.out.println(url.toString());
//			PostMethod post = new PostMethod(msgQueryUrl);
//			post.setRequestHeader("Content-type", "text/xml; charset=gbk");
//			post.setRequestBody(url.toString());
//			return post;
//		}
//
//		// 更改密码
//		public PostMethod modifyPwd(String userName, String password,
//				String newpassword) {
//			StringBuilder url = new StringBuilder();
//			url.append("accountname=");
//			url.append(userName);
//			url.append("&accountpwd=");
//			url.append(password);
//			url.append("&accountnewpwd=");
//			url.append(newpassword);
//			// System.out.println(url.toString());
//			PostMethod post = new PostMethod(msgModifyUrl);
//			post.setRequestHeader("Content-type", "text/xml; charset=gbk");
//			post.setRequestBody(url.toString());
//			return post;
//		}
//
//		public String getMsgRegUrl() {
//			return msgRegUrl;
//		}
//
//		public void setMsgRegUrl(String msgRegUrl) {
//			this.msgRegUrl = msgRegUrl;
//		}
//
//		public String smsOperation(HttpMethod method) throws IOException {
//			HttpClient client = new HttpClient();
//			client.getHostConfiguration().setHost("csdk.zzwhxx.com", 8002, "http");
//			client.executeMethod(method);
//			System.out.println("服务器返回的状态：" + method.getStatusLine());
//
//			String value = method.getResponseBodyAsString();
//			method.releaseConnection();
//			return value;
//		}
//
//	public static boolean send(String phone,String label){
//		SdkMessage msgHttp = new SdkMessage();
//		msgHttp.setMsgSendUrl("submitsms.aspx");
//		msgHttp.setMsgQueryUrl("getbalance.aspx");
//		msgHttp.setMsgScheSendUrl("submitschsms.aspx");
//		msgHttp.setMsgModifyUrl("changepwd.aspx");
//		String value="";
//		try {
//			value = msgHttp.smsOperation(msgHttp.getSend("sdkwhzzkkjy", "474680",
//					phone, "(乐享云购】 乐享云购提醒你，你的验证码:"+label));
//		} catch (IOException e) {
//			log.error("error:", e);
//		}
//
//		if(value.equals("0")){
//			return true;
//		}
//		return false;
//
//	}
//
//	public static boolean sendUser(String phone,String label){
//		SdkMessage msgHttp = new SdkMessage();
//		msgHttp.setMsgSendUrl("submitsms.aspx");
//		msgHttp.setMsgQueryUrl("getbalance.aspx");
//		msgHttp.setMsgScheSendUrl("submitschsms.aspx");
//		msgHttp.setMsgModifyUrl("changepwd.aspx");
//		String value="";
//		try {
//			value = msgHttp.smsOperation(msgHttp.getSend("sdkwhzzkkjy", "474680",
//					phone,"(乐享云购】"+label));
//		} catch (IOException e) {
//			log.error("error:", e);
//		}
//
//		if(value.equals("0")){
//			return true;
//		}
//		return false;
//	}
//
//		public static boolean send1(String phone){
//			SdkMessage msgHttp = new SdkMessage();
//			msgHttp.setMsgSendUrl("submitsms.aspx");
//			msgHttp.setMsgQueryUrl("getbalance.aspx");
//			msgHttp.setMsgScheSendUrl("submitschsms.aspx");
//			msgHttp.setMsgModifyUrl("changepwd.aspx");
//			String value="";
//			System.out.println(phone+"_");
//			try {
//				 value = msgHttp.smsOperation(msgHttp.getSend("sdkwhzzkkjy", "474680",
//						phone, "(乐享云购】 尊敬的商家、乐享云购商家版手机店铺请点击  http://dwz.cn/1hsBJG 下载试用。 苹果版稍后发布。本月18号下午2点在德亿大酒店召开：如何用软件赚互联网的钱发布会。请准时出席。(乐享云购】"));
//			} catch (IOException e) {
//				log.error("error:", e);
//			}
//			if(value.equals("0")){
//				return true;
//			}
//			return false;
//
//		}

	private  static  String url="http://222.73.117.158/msg/";
	private  static  String account = "lxyungou";// 账号
	private  static  String pswd = "Lxyungou88";// 密码
	private  static boolean needstatus = true;// 是否需要状态报告，需要true，不需要false
	private  static String product = null;// 产品ID
	private  static String extno = null;// 扩展码

	public static boolean send(String phone,String content){
		try {
			String res=HttpSender.batchSend(url,account,pswd,phone,content,needstatus,product,extno);
			System.out.println(res);
		} catch (Exception e) {
			log.error("短信异常",e);
			e.printStackTrace();
		}
		return true;
	}

	public static void main(String[] args) {
		//send("13917416360","收货人:xxx");
		send("18625838770","收货人:秦帅,联系电话：18625838770,收获地址:河南省郑州市金水区金水东路北侧,中兴路西侧,心怡路东侧,配送方式：送货上门,购买产品：(美年达葡萄味550ml*1)总价:2.5元");
	}
}


