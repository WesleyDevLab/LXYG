package com.lxyg.app.customer.platform.weiapiUtil;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
	
	public static String dateFormat(){
		return dateFormat(new Date());
	}
	
	public static String dateFormat(Date time){
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.DATA_FORMAT);
		return sdf.format(time);
	}
	
	public static Date dateParse(String time) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.DATA_FORMAT);
		return sdf.parse(time);
	}
	
	public static String timeFormat(){
		return timeFormat(new Date());
	}
	public static String timeFormat(Date time){
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.TIME_FORMAT);
		return sdf.format(time);
	}
	
	public static Date timeParse(String time) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat(Constant.TIME_FORMAT);
		return sdf.parse(time);
	}
	
	//*
	
	public static String format(Long time,String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(time);
	}
	
	public static String format(Date time,String format){
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(time);
	}
	
	public static Date parse(String time,String format) throws ParseException{
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.parse(time);
	}
	
//	public static  long Time2Unix(Date d){
//		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//		String time=sdf.toString();
//		try {
//			return (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(time).getTime()/1000);
//		} catch (ParseException e) {
//			e.printStackTrace();
//			return 0;
//		}
//	}
	public static String getTimeStamp(){
		String str=Long.toString(System.currentTimeMillis()/1000);
		return str;
	}
	
	
	public static void main(String[] args) {
		System.out.println(getTimeStamp());
	}
	
}
