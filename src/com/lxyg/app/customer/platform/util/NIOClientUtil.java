package com.lxyg.app.customer.platform.util;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;

public class NIOClientUtil {
	private static final String hostname = ConfigUtils.getProperty("ios.url");
	private static final int port = Integer.parseInt(ConfigUtils.getProperty("ios.port"));
	private String toname;
	private String sendText;
	/*缓冲区大小*/  
	private static int BLOCK = 4096;  
	/*接受数据缓冲区*/  
	private static ByteBuffer sendBuffer = ByteBuffer.allocate(BLOCK);  
	/*服务器端地址*/  
	private final InetSocketAddress SERVER_ADDRESS = new InetSocketAddress(hostname, port); 
	
	public NIOClientUtil() {
	}
	
	public NIOClientUtil(String toname, String sendText) {
		this.toname = toname;
		this.sendText = sendText;
	}
	
	public boolean sendTextByToken() {
		boolean b = false;
		SocketChannel clientChannel = null;
		try {
			clientChannel = SocketChannel.open();
			// 设置为非阻塞方式  
			clientChannel.configureBlocking(false);  
			// 连接  
			clientChannel.connect(SERVER_ADDRESS);
			if(clientChannel.finishConnect()){
				System.out.println("connected server:" + SERVER_ADDRESS.getAddress());
			}
			String str = toname + ":" + sendText;
			if(str.length() > 200) {
				str = str.substring(0, 200);
			}
			sendBuffer.put(str.getBytes("gbk"));  
			//将缓冲区各标志复位,因为向里面put了数据标志被改变要想从中读取数据发向服务器,就要复位  
			sendBuffer.flip();  
			System.out.println("send server data：" + str);  
			clientChannel.write(sendBuffer);  
			sendBuffer.clear();
			clientChannel.close();
			b = true;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return b;
	}
}
