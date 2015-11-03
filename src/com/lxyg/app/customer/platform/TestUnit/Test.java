package com.lxyg.app.customer.platform.TestUnit;

import com.alibaba.fastjson.JSONObject;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import net.sf.json.JSONArray;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.util.List;
import java.net.URL;

import static com.lxyg.app.customer.platform.TestUnit.Test.download;

/**
 * Created by ÇØË§ on 2015/10/23.
 */
public class Test extends TestBefore {
    public void cityJson(){
        JSONArray array=new JSONArray();
        List<Record> pList=Db.find("select * from kk_area where father_id=0");
        for(Record record:pList){
            JSONObject pObject=new JSONObject();
            pObject.put("province",record.getStr("name"));
            String code=record.getStr("code");
            JSONArray cityArray=new JSONArray();
            List<Record> cList=Db.find("select * from kk_area where  father_id=?",code);
            for(Record record1:cList){
                if(record1!=null){
                    JSONObject cObject=new JSONObject();
                    cObject.put("name",record1.getStr("name"));
                    String acode=record1.getStr("code");
                    JSONArray aArray=new JSONArray();
                    List<Record> aList=Db.find("select * from kk_area where father_id=?",acode);
                    for(Record record2:aList){
                        if(record2!=null){
                            JSONObject aObject=new JSONObject();
                            aObject.put("name",record2.getStr("name"));
                            aArray.add(aObject);
                        }
                    }
                    if(aList.size()!=0){
                        cObject.put("area",aArray);
                    }
                    cityArray.add(cObject);
                }
                pObject.put("city",cityArray);
            }
            array.add(pObject);
        }
         toFile(array.toString());
    }




    public void toFile(String str){
        BufferedWriter writer = null;
        try{
            String path="d://city.json";
            File file=new File(path);
            if(!file.exists()){
                file.createNewFile();
            }
             writer=new BufferedWriter(new FileWriter(file));
            writer.write(str);
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(writer!=null){
                try {
                    writer.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }
    public void comp(){
        int i=3;
        int j=4;
        int b=4;
        if( i!=b && j!=b ){
            System.out.println(123);
        }
    }

    public void loadImg(){
        String sql="select cover_img from kk_product";
        String sql2="select img_url from kk_product_img";
        List<Record> records=Db.find(sql);
        List<Record> records1=Db.find(sql2);
        for(Record record:records){
            String url=record.getStr("cover_img");
            download(url,"d://cover_imgs");
        }
        for(Record record:records1){
            String url=record.getStr("img_url");
            download(url,"d://imgs");
        }
    }


    public static void download(String urlString,String path){
        try {
            URL url = new URL(urlString);
            HttpURLConnection connection= (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(5*1000);
            InputStream is=connection.getInputStream();
            byte[] bs=new byte[1024];
            int len;
            File file=new File(path);
            if(!file.exists()){
                file.mkdir();
            }
            OutputStream os = new FileOutputStream(file.getPath()+"\\"+urlString.substring(urlString.lastIndexOf("/")+1,urlString.length()));
            while ((len = is.read(bs)) != -1){
                os.write(bs, 0, len);
            }
            os.close();
            is.close();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}
