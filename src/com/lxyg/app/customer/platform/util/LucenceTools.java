package com.lxyg.app.customer.platform.util;

import java.io.IOException;
import java.io.StringReader;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.tokenattributes.CharTermAttribute;
import org.wltea.analyzer.lucene.IKAnalyzer;

/**
 * Created by 秦帅 on 2016/2/23.
 */
public class LucenceTools {


    public static void analyzerCn(String p_name) {
        try {
            //创建分词对象
            Analyzer anal = new IKAnalyzer(true);
            StringReader reader = new StringReader(p_name);
            //分词
            TokenStream ts = null;
            ts = anal.tokenStream("",reader);
            CharTermAttribute term = ts.getAttribute(CharTermAttribute.class);
            //遍历分词数据
            while (ts.incrementToken()) {
                System.out.print(term.toString() + "|");
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        analyzerCn("牙膏");
    }
}
