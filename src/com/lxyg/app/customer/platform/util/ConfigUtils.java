package com.lxyg.app.customer.platform.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;


public class ConfigUtils {
	/**
	 * 加载当前classloader下的默认配置文件并获取属性
	 * @param key
	 * @return
	 */
	public static String getProperty(String key){
		String val = getProperty("res/config.properties",key);
		return val;
	}
	/**
	 * 加载当前classloader下的配置文件并获取属性
	 * @param fileName
	 * @param key
	 * @return
	 */
	public static String getProperty(String fileName,String key){
		Properties properties = new Properties();
        InputStream is = ConfigUtils.class.getClassLoader().getResourceAsStream(fileName);//加载文件内容
        try {
			properties.load(is);
			is.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
        String val = properties.getProperty(key);
        return val;
	}
	public static int rate=Integer.parseInt(getProperty("kaka.commission_rate"));
	public static int clear=Integer.parseInt(getProperty("kaka.Distribution_coefficient"));
	public static String upYunServer=getProperty("kaka.qiniu.server");
	public static String devModel=getProperty("lxyg.dev");
	/**
	 * @param args
	 */

	public static void main(String[] args) {
		System.out.println(upYunServer);

		System.out.println(getProperty("kaka.server.secret"));
	}

}
