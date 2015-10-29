package com.lxyg.app.customer.platform.util;

import java.awt.*;
import java.util.Random;

public class ChartUtils {

	private float value; 
	private String color; 
	private String highlight; 
	private String label; 

	public float getValue() {
		return value;
	}

	public void setValue(float value) {
		this.value = value;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getHighlight() {
		return highlight;
	}

	public void setHighlight(String highlight) {
		this.highlight = highlight;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	//未使用
	public static Color createColor(){
		Color color = new Color(
		          (new Double(Math.random() * 128)).intValue() + 128,   
		          (new Double(Math.random() * 128)).intValue() + 128,   
		          (new Double(Math.random() * 128)).intValue() + 128);
		return color;
	}
	
	//方法一
	/** 
     * 生成随机颜色代码 
     *  
     * @return 
     */  
    public static synchronized String getRandomColorCode() {  
        // 颜色代码位数  
        int colorLength = 6;  
  
        // 颜色代码数组  
        char[] codeSequence = { 'A', 'B', 'C', 'D', 'E', 'F', '0', '1', '2',  
                '3', '4', '5', '6', '7', '8', '9' };  
  
//      StringBuffer sb = new StringBuffer("#");  
        StringBuffer sb = new StringBuffer();  
        Random random = new Random();  
        for (int i = 0; i < colorLength; i++) {  
            sb.append(codeSequence[random.nextInt(16)]);  
        }  
        return sb.toString();  
    }  
      
     //方法二
    /** 
     * 获取十六进制的颜色代码.例如 "#6E36B4" , For HTML , 
     *  
     * @return String 
     */  
    public static String getRandColorCode() {  
        String r, g, b;  
        Random random = new Random();  
        r = Integer.toHexString(random.nextInt(256)).toUpperCase();  
        g = Integer.toHexString(random.nextInt(256)).toUpperCase();  
        b = Integer.toHexString(random.nextInt(256)).toUpperCase();  
       
        r = r.length() == 1 ? "0" + r : r;  
        g = g.length() == 1 ? "0" + g : g;  
        b = b.length() == 1 ? "0" + b : b;  
       
        return "#"+r + g + b;  
    } 
    public static ChartUtils chart(float value,String label){
			ChartUtils cu = new ChartUtils();
			cu.setColor(ChartUtils.getRandColorCode());
			cu.setHighlight(ChartUtils.getRandColorCode());
			cu.setLabel(label);
			cu.setValue(value);
			return cu;
    }
  
    public static void main(String[] args) {  
    	Color color = createColor();
		System.out.println(color);
        System.out.println(getRandomColorCode());  
          
        System.out.println(getRandColorCode());  
    }  
}  
