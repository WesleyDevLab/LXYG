package com.lxyg.app.customer.platform.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class SendSms {

	public static void main(String[] args) {
		String s = new SendSms().sendSms("huichengyuzhou@qq.com",
				"huichengyuzhou", "18538557277", "上午好！(乐享云购】");
		System.out.println(s);
	}

	public String sendSms(String accName, String accPwd, String mobies,
			String content) {
		StringBuffer sb = new StringBuffer("http://www.lx198.com/sdk/send?");
		try {
			sb.append("&accName=" + accName);
			sb.append("&accPwd=" + MD5.getMd5String(accPwd));
			sb.append("&aimcodes=" + mobies);
			sb.append("&content=" + URLEncoder.encode(content, "UTF-8"));
			sb.append("&bizId=" + BizNumberUtil.createBizId());
			sb.append("&dataType=string");
			URL url = new URL(sb.toString());
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("POST");
			BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
			return in.readLine();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}