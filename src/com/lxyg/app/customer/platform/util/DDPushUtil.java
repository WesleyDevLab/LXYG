package com.lxyg.app.customer.platform.util;

import org.ddpush.im.util.StringUtil;
import org.ddpush.im.v1.client.appserver.Pusher;

public class DDPushUtil implements Runnable {
	private String serverIp;
	private int port;
	private byte[] uuid;
	private byte[] msg;

	public DDPushUtil(String serverIp, int port, byte[] uuid, byte[] msg) {
		this.serverIp = serverIp;
		this.port = port;
		this.uuid = uuid;
		this.msg = msg;
	}

	public void run() {
		Pusher pusher = null;
		try {
			boolean result;
			pusher = new Pusher(serverIp, port, 1000 * 10);
			result = pusher.push0x20Message(uuid, msg);
			System.out.println(result);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (pusher != null) {
				try {
					pusher.close();
				} catch (Exception e) {
				}
			}
		}
	}

	public static void main(String[] args) {
		try {
			byte[] uuid = StringUtil.md5Byte("209819");
			DDPushUtil ddPushUtil = new DDPushUtil("android.push.xtox.net",
					9999, uuid, "测试测试！".getBytes("UTF-8"));
			Thread t = new Thread(ddPushUtil);
			t.start();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
