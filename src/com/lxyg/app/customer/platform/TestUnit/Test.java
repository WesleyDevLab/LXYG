package com.lxyg.app.customer.platform.TestUnit;

import com.alibaba.fastjson.JSON;
import com.google.gson.JsonArray;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Form;
import com.lxyg.app.customer.platform.model.FormImg;

import com.lxyg.app.customer.platform.util.JsonUtils;
import com.lxyg.app.customer.platform.util.UpYun;
import com.lxyg.app.customer.platform.util.loadUUID;
import net.minidev.json.JSONObject;
import net.sf.json.JSONArray;
import org.json.JSONException;
import sun.misc.BASE64Decoder;

import javax.imageio.stream.FileImageInputStream;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.util.Date;
import java.util.List;
import java.net.URL;
import static com.lxyg.app.customer.platform.TestUnit.Test.download;

/**

 */
public class Test extends TestBefore {

    public void cityJson(){
        JSONArray array=new JSONArray();
        List<Record> pList=Db.find("select * from kk_area where father_id=0 and code=70");
        for(Record record:pList){
            JSONObject pObject=new JSONObject();
            pObject.put("province",record.getStr("name"));
            pObject.put("code",record.getStr("code"));
            String code=record.getStr("code");
            JSONArray cityArray=new JSONArray();
            List<Record> cList=Db.find("select * from kk_area where  father_id=?",code);
            for(Record record1:cList){
                if(record1!=null){
                    JSONObject cObject=new JSONObject();
                    cObject.put("name",record1.getStr("name"));
                    cObject.put("code",record1.getStr("code"));
                    String acode=record1.getStr("code");
                    JSONArray aArray=new JSONArray();
                    List<Record> aList=Db.find("select * from kk_area where father_id=?",acode);
                    for(Record record2:aList){
                        if(record2!=null){
                            JSONObject aObject=new JSONObject();
                            aObject.put("name",record2.getStr("name"));
                            aObject.put("code",record2.getStr("code"));
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

    public void upload(){
        String URL="http://lxyg8.b0.upaiyun.com";
        UpYun upYun=new UpYun("lxyg8","lxyg8888","0611lxyg123");
        String filePath="/lxyg/";
//        net.sf.json.JSONObject json= net.sf.json.JSONObject.fromObject(getPara("info"));
//        String str=getPara("ImgData");
//        if(str==null){
//            str=json.getString("ImgData");
//        }
        filePath+= loadUUID.getUUID()+".jpg";
        byte[] buffer = image2byte("d://aa.jpg");
        boolean result = upYun.writeFile(filePath, buffer, true);
        System.out.println(result);
    }

    public static byte[] image2byte(String path){
        byte[] data = null;
        FileImageInputStream input = null;
        try {
            input = new FileImageInputStream(new File(path));
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            byte[] buf = new byte[1024];
            int numBytesRead = 0;
            while ((numBytesRead = input.read(buf)) != -1) {
                output.write(buf, 0, numBytesRead);
            }
            data = output.toByteArray();
            output.close();
            input.close();
        }
        catch (FileNotFoundException ex1) {
            ex1.printStackTrace();
        }
        catch (IOException ex1) {
            ex1.printStackTrace();
        }
        return data;
    }

    public void addForm(){
        Form f=new Form();
        FormImg fi=new FormImg();
        f.set("title","test");
        f.set("content","test111");
        f.set("create_time",new Date());
        f.set("u_uid","asdasdsad");
        f.save();
    }

    @org.junit.Test
    public void jsonParse(){
        String str="[\"/platform/cV5zsOBe1JJlujUR.jpg\",/platform/LLMIWpwmiURyKQKM.jpg\"]";
        String str1="[\"/platform/pDXXpAr9IFnUGYiM.jpg\",\"/platform/CsNQ99w2F81l0H73.jpg\",\"/platform/CsNQ99w2F81l0H73.jpg\"]";

        com.alibaba.fastjson.JSONArray array = com.alibaba.fastjson.JSONArray.parseArray(str);
        System.out.println(array.size());
    }
}
