package com.lxyg.app.customer.platform.util;

import com.lxyg.app.customer.platform.model.Shop;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class RegularUtil {
	public static boolean isMobileNO(String mobiles) {
		Pattern p = Pattern
				.compile("1[3|5|8|7]\\d{9}");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}
	public static boolean isEmail(String email) {
		String str = "^([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)*@([a-zA-Z0-9]*[-_]?[a-zA-Z0-9]+)+[\\.][A-Za-z]{2,3}([\\.][A-Za-z]{2})?$";
		Pattern p = Pattern.compile(str);
		Matcher m = p.matcher(email);
		return m.matches();
	}
	public static boolean isPassword(String pwd){
		String str = "^[+-]?d+.?d*$";
		Pattern p = Pattern.compile(str);
		Matcher m = p.matcher(pwd);
		return m.matches();
	}
	public static String gen(){
		Random r = new Random();
		StringBuilder gen = new StringBuilder();
		for(int i=0;i<6;i++){
			gen.append(r.nextInt(10));
		}
		return gen.toString();
	}
	
	public static List<Integer> getIntArray(String[] str){
		List<Integer> list=new ArrayList<Integer>();
		for(String s:str){
			list.add(Integer.parseInt(s));
		}
		return list;
	}
	
	public static String[] minus(String[] arr1, String[] arr2){
		LinkedList<String> list = new LinkedList<String>();   
        LinkedList<String> history = new LinkedList<String>();   
        String[] longerArr = arr1;   
        String[] shorterArr = arr2;   
        //找出较长的数组来减较短的数组   
//        if (arr1.length > arr2.length) {   
//            longerArr = arr2;   
//            shorterArr = arr1;   
//        }   
        for (String str : longerArr) {   
            if (!list.contains(str)) {   
                list.add(str);   
            }   
        }   
        for (String str : shorterArr) {   
            if (list.contains(str)) {   
                history.add(str);   
                list.remove(str);   
            } else {   
                if (!history.contains(str)) {   
                    list.add(str);   
                }   
            }   
        }   
        String[] result = {};   
        return list.toArray(result);   
	}
	
	
	public static List<Integer> minus(List<Integer> arr1, List<Integer> arr2){
		List<Integer> lists=new ArrayList<Integer>();
		if(arr1.size()==0){
			lists= arr2;
		}
		if(arr1.size()!=0){
			 arr2.removeAll(arr1);
			 lists=arr2;
		}
		return lists;
	}
	
	public static void main(String[] args) {
		String phone="18625838770,18837145615";
		if(phone.contains(",")){
			String[] ps=phone.split(",");
			for(String p:ps){
				System.out.println(p);
				//SdkMessage.sendUser(p, IConstant.content_order_new + str);
			}
		}else{
			System.out.println(phone);
			//SdkMessage.sendUser(phone,IConstant.content_order_new+str);
		}
		
//		String [] arr1=new String[]{"1","2","3"};
//		String [] arr2=new String[]{"1","2"};
//		String[] res_1=minus(arr1, arr2);
//		for(String str:res_1){
//			System.out.println(str);
//		}
	}
	public static String[] union(String[] arr1, String[] arr2) {   
        Set<String> set = new HashSet<String>();   
        for (String str : arr1) {   
            set.add(str);   
        }   
        for (String str : arr2) {   
            set.add(str);   
        }   
        String[] result = {};   
        return set.toArray(result);   
    } 
	
	public static String[] unionMore(List<Shop> lists){
		int len=lists.size();
		String [] str0=lists.get(0).getStr("pros").split(",");
		for(int i=1;i<len;i++){
			String [] str1=lists.get(i).getStr("pros").split(",");
			str0=union(str0, str1);
		}
		return str0;
	}
	
	public static boolean isExists(List<Integer> lists,Integer i){
		if(lists.contains(i)){
			return false;
		}else{
			return true;
		}
	}

	public static String retIMGURL(String imgUrl){
		if(!imgUrl.startsWith(ConfigUtils.getProperty("kaka.qiniu.server"))){
			imgUrl=ConfigUtils.getProperty("kaka.qiniu.server")+imgUrl;
		}
		return  imgUrl;
	}




	
}
