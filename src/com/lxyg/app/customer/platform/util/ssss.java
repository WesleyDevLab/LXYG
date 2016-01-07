package com.lxyg.app.customer.platform.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by 秦帅 on 2016/1/7.
 */
public class ssss {
    public static void main(String[] args) {
        String str = "你TMD，也太缺德了，太变态了吧TM  ";
        String regex = ".*[TMD,TM,缺德,变态了].*";
        Pattern pat = Pattern.compile(regex);
        Matcher mat = pat.matcher(str);
        String s = "";
        if (mat.matches()) {
            s = mat.group().replace("TMD", "*").replace("TM", "*");
            s = mat.group().replace("缺德", "*").replace("缺德", "*");
        }
        System.out.println(s);
    }
}
