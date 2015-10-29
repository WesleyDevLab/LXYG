package com.lxyg.app.customer.platform.util;

import sun.misc.BASE64Encoder;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Encrypt {
	/**
	 * 对字符进行加密
	 * @param str  要加密的str
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws UnsupportedEncodingException
	 */
	public static String EncoderByMd5(String str) throws NoSuchAlgorithmException, UnsupportedEncodingException{
		//确定计算方法
		MessageDigest md5=MessageDigest.getInstance("MD5");
		BASE64Encoder base64en = new BASE64Encoder();
		//加密后的字符串
		String newstr=base64en.encode(md5.digest(str.getBytes("utf-8")));
		return newstr;
	}
	/**
	 * 测试
	 * @param args
	 * @throws NoSuchAlgorithmException
	 * @throws UnsupportedEncodingException
	 */
	public static void main(String[] args) throws NoSuchAlgorithmException, UnsupportedEncodingException{
		String encryptedPwd = EncoderByMd5("666666");
		System.out.println(encryptedPwd);
	}

	/** 
	 * @param newpasswd  用户输入的密码
	 * @param oldpasswd  数据库中存储的密码－－用户密码的摘要
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws UnsupportedEncodingException
	 */
	/*public static boolean checkpassword(String newpasswd,String oldpasswd) throws NoSuchAlgorithmException,  UnsupportedEncodingException{
	         if(EncoderByMd5(newpasswd).equals(oldpasswd))
	             return true;
	         else
	             return false;
	     }*/
}
