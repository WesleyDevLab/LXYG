package com.lxyg.app.customer.platform.TestUnit;

import com.alibaba.fastjson.JSON;
import com.google.gson.JsonArray;
import com.jfinal.aop.Before;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.model.*;

import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.util.*;
import net.minidev.json.JSONObject;
import net.sf.json.JSONArray;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.json.JSONException;
import sun.misc.BASE64Decoder;

import javax.imageio.stream.FileImageInputStream;
import java.io.*;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.net.URL;

import static com.lxyg.app.customer.platform.TestUnit.Test.download;

/**

 */
public class Test extends TestBefore {

    public void cityJson() {
        JSONArray array = new JSONArray();
        List<Record> pList = Db.find("select * from kk_area where father_id=0 ");
        for (Record record : pList) {
            JSONObject pObject = new JSONObject();
            pObject.put("province", record.getStr("name"));
            pObject.put("code", record.getStr("code"));
            String code = record.getStr("code");
            JSONArray cityArray = new JSONArray();
            List<Record> cList = Db.find("select * from kk_area where  father_id=?", code);
            for (Record record1 : cList) {
                if (record1 != null) {
                    JSONObject cObject = new JSONObject();
                    cObject.put("name", record1.getStr("name"));
                    cObject.put("code", record1.getStr("code"));
                    String acode = record1.getStr("code");
                    JSONArray aArray = new JSONArray();
                    List<Record> aList = Db.find("select * from kk_area where father_id=?", acode);
                    for (Record record2 : aList) {
                        if (record2 != null) {
                            JSONObject aObject = new JSONObject();
                            aObject.put("name", record2.getStr("name"));
                            aObject.put("code", record2.getStr("code"));
                            aArray.add(aObject);
                        }
                    }
                    if (aList.size() != 0) {
                        cObject.put("area", aArray);
                    }
                    cityArray.add(cObject);
                }
                pObject.put("city", cityArray);
            }
            array.add(pObject);
        }
        toFile(array.toString());
    }

    public void toFile(String str) {
        BufferedWriter writer = null;
        try {
            String path = "d://city.json";
            File file = new File(path);
            if (!file.exists()) {
                file.createNewFile();
            }
            writer = new BufferedWriter(new FileWriter(file));
            writer.write(str);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (writer != null) {
                try {
                    writer.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }


    public void comp() {
        int i = 3;
        int j = 4;
        int b = 4;
        if (i != b && j != b) {
            System.out.println(123);
        }
    }

    public void loadImg() {
        String sql = "select cover_img from kk_product";
        String sql2 = "select img_url from kk_product_img";
        List<Record> records = Db.find(sql);
        List<Record> records1 = Db.find(sql2);
        for (Record record : records) {
            String url = record.getStr("cover_img");
            download(url, "d://cover_imgs");
        }
        for (Record record : records1) {
            String url = record.getStr("img_url");
            download(url, "d://imgs");
        }
    }

    public static void download(String urlString, String path) {
        try {
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setConnectTimeout(5 * 1000);
            InputStream is = connection.getInputStream();
            byte[] bs = new byte[1024];
            int len;
            File file = new File(path);
            if (!file.exists()) {
                file.mkdir();
            }
            OutputStream os = new FileOutputStream(file.getPath() + "\\" + urlString.substring(urlString.lastIndexOf("/") + 1, urlString.length()));
            while ((len = is.read(bs)) != -1) {
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

    public void upload() {
        String URL = "http://lxyg8.b0.upaiyun.com";
        UpYun upYun = new UpYun("lxyg8", "lxyg8888", "0611lxyg123");
        String filePath = "/lxyg/";
//        net.sf.json.JSONObject json= net.sf.json.JSONObject.fromObject(getPara("info"));
//        String str=getPara("ImgData");
//        if(str==null){
//            str=json.getString("ImgData");
//        }
        filePath += loadUUID.getUUID() + ".jpg";
        byte[] buffer = image2byte("d://aa.jpg");
        boolean result = upYun.writeFile(filePath, buffer, true);
    }

    public static byte[] image2byte(String path) {
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
        } catch (FileNotFoundException ex1) {
            ex1.printStackTrace();
        } catch (IOException ex1) {
            ex1.printStackTrace();
        }
        return data;
    }

    public void addForm() {
        Form f = new Form();
        FormImg fi = new FormImg();
        f.set("title", "test");
        f.set("content", "test111");
        f.set("create_time", new Date());
        f.set("u_uid", "asdasdsad");
        f.save();
    }

    public void jsonParse() {
//        String str="[\"/platform/cV5zsOBe1JJlujUR.jpg\",/platform/LLMIWpwmiURyKQKM.jpg\"]";
//        String str1="[\"/platform/pDXXpAr9IFnUGYiM.jpg\",\"/platform/CsNQ99w2F81l0H73.jpg\",\"/platform/CsNQ99w2F81l0H73.jpg\"]";
//
//        com.alibaba.fastjson.JSONArray array = com.alibaba.fastjson.JSONArray.parseArray(str);
    }


    public void addLoginLog() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date d = new Date();
        Record r = Db.findFirst("select count(id) as cc from kk_login_log where u_uid=? and create_time like ? ", "b4f8f2652073400b", "%" + sdf.format(d) + "%");
        if (r.getLong("cc") > 0) {
            return;
        }
        r.clear();
        r.set("u_uid", "b4f8f2652073400b");
        r.set("create_time", d);
        Db.save("kk_login_log", r);
        Record record = Db.findFirst("select * from kk_login_sign where u_uid=?", "b4f8f2652073400b");
        if (record == null) {
            Db.update("insert into kk_login_sign(u_uid,num,create_time) values(?,?,?)", "b4f8f2652073400b", 1, new Date());
            return;
        } else {
            Date d1 = record.getDate("create_time");
            Date d2 = new Date();

            if (d2.getTime() - d1.getTime() > 1000 * 60 * 60 * 24) {
                record.set("num", 1);
            } else {
                record.set("num", record.getInt("num") + 1);
            }
            record.set("create_time", new Date());
            Db.update("kk_login_sign", record);
        }
    }

    /**
     * 随机
     */
    public void choujiang() {
        int days = 3; //连续签到天数
        Date start = new Date();//开始时间

        Date end = new Date();//结束时间
        Record record = Db.findFirst("SELECT * from kk_login_sign where create_time BETWEEN ? and ? and num>=? ORDER BY rand() ", start, end, days);
    }

    /**
     * 随机
     * 去掉已经获得的
     */
    public void choujiang_1() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        date.setTime(date.getTime() - 7 * 1000 * 60 * 60 * 24);
    }

    public void test1() {
        Record activity = Db.findById("kk_shop_activity", 1);
        if (activity.getInt("limit_e") == null) {
        }
        Db.update("update kk_product_activity set surplus_num=surplus_num-? where activity_id=?", activity.getInt("limit_e"), 1);
    }

    public void category() {
        Record rS = Db.findFirst("SELECT ( SELECT  pc.id FROM kk_product_category pc WHERE pc. name LIKE ? LIMIT 0,1 ) AS cid, " +
                "( SELECT pt.id FROM kk_product_type pt WHERE pt.name LIKE ? LIMIT 0,1) AS tid, ( SELECT pb.id FROM kk_product_brand pb WHERE pb. name LIKE ? LIMIT 0,1) AS bid", "%粮油调味%", "%方便速食%", "%双汇%");
    }

    public void readExcel() {
        String path = "D://nh_1.xls";
        File file = new File(path);
        if (!file.exists()) {
            return;
        }
        try {
            POIFSFileSystem poifsFileSystem = new POIFSFileSystem(new FileInputStream(file));
            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(poifsFileSystem);
            HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
            int rowstart = hssfSheet.getFirstRowNum();
            int rowEnd = hssfSheet.getLastRowNum();
            for (int i = 2; i <= rowEnd; i++) {
                HSSFRow row = hssfSheet.getRow(i);
                if (null == row) {
                    continue;
                }
                int cellStart = row.getFirstCellNum();
                int cellEnd = row.getLastCellNum();
                Object[] objects = new Object[cellEnd];
                for (int k = cellStart; k <= cellEnd; k++) {
                    HSSFCell cell = row.getCell(k);
                    if (null == cell) continue;
                    Object value = null;

                    switch (cell.getCellType()) {
                        case HSSFCell.CELL_TYPE_NUMERIC:
                            Double d;
                            if (k == 9) {
                                d = cell.getNumericCellValue() * 100;
                            } else {
                                d = cell.getNumericCellValue();
                            }
                            value = d.intValue();

                            break;
                        case HSSFCell.CELL_TYPE_STRING:
                            value = cell.getStringCellValue();
                            break;
                        case HSSFCell.CELL_TYPE_FORMULA:
                            String v1;
                            try {
                                v1 = String.valueOf(cell.getNumericCellValue());
                            } catch (IllegalStateException e) {
                                v1 = String.valueOf(cell.getCellFormula());
                            }
                            Double d1 = Double.parseDouble(v1);
                            value = d1.intValue();
                            break;
                        case HSSFCell.CELL_TYPE_BLANK:
                            value = 0;
                            break;
                        case HSSFCell.CELL_TYPE_ERROR:
                            break;
                        default:
                            break;
                    }
                    objects[k] = value;
                }
                String str = "";
                for (Object object : objects) {
                    Record record = Db.findFirst("select id from kk_product where name like ?", object.toString());
                    if (record == null) {
                        System.out.println(object.toString());
                        continue;
                    }
                    str += record.getInt("id") + ",";
                }
//                Record record=new Record();
//                record.set("p_category_name",objects[0]);
//                record.set("p_type_name",objects[1]);
//                record.set("p_brand_name",objects[2]);
//
//                Record r=Db.findFirst("SELECT ( SELECT pc.id FROM kk_product_category pc WHERE pc. name LIKE ? LIMIT 0,1) AS cid, " +
//                        "( SELECT pt.id FROM kk_product_type pt WHERE pt.name LIKE ? LIMIT 0,1) AS tid, ( SELECT pb.id FROM kk_product_brand pb WHERE pb. name LIKE ? LIMIT 0,1) AS bid", "%" + objects[0] + "%", "%" + objects[1] + "%", "%" + objects[2] + "%");
//                record.set("p_category_id",r.getInt("cid"));
//                record.set("p_type_id",r.getInt("tid"));
//                record.set("p_brand_id",r.getInt("bid"));
//
//                record.set("name",objects[3]);
//                record.set("txm_code",objects[4]);
//                record.set("p_unit_name",objects[5]);
//                record.set("p_unit_num",objects[6]);
//                record.set("min_stock_all",objects[7]);
//                record.set("min_stock_shop",objects[8]);
//                record.set("supplier_price",objects[9]);
//                record.set("box_specification",objects[10]);
//                record.set("min_quantity",objects[11]);
//                record.set("quantity",objects[12]);
//                record.set("p_desc",objects[13]);
//                Db.save("kk_product_data",record);
////               Db.update("insert into kk_product_data(p_category_name,p_type_name,p_brand_name,name,txm_code,p_unit_name,p_unit_num" +
////                      "min_stock_all,min_stock_shop,supplier_price,box_specification,min_quantity,quantity,p_desc) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", objects);
////                Db.update("insert into kk_product_data(p_type_name) values(?)", objects);
//                System.out.print("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void insert() {
        // Db.findFirst("select group_concat(fb.id) as pids,fb.* from kk_product_fb fb where fb.s_uid=1 and fb.id in (1) and fb.hide=0");
        List<Record> records = Db.find("SELECT group_concat(p.p_type_id) as types,p.p_brand_id from kk_product p GROUP BY p.p_brand_id");
        for (Record record : records) {
            int p_brand_id = record.getInt("p_brand_id");
            String types = record.getStr("types");
            int type = Integer.parseInt(types.split(",")[0]);
            Record record1 = new Record();
            record1.set("id", p_brand_id);
            record1.set("p_type_id", type);
            Db.update("kk_product_brand_copy", record1);
        }
    }

    public void Test() {
        BigDecimal allPrice = new BigDecimal(73);
        Record record = Db.findFirst("select * from kk_shop_activity sa where sa.shop_id=? and activity_type=5", 6);
        String rule = record.getStr("price_rule");
        int reduce = 0;
        net.sf.json.JSONObject o = net.sf.json.JSONObject.fromObject(rule);
        net.sf.json.JSONArray array = o.getJSONArray("rule");
        for (int i = 0; i < array.size(); i++) {
            net.sf.json.JSONObject object = (net.sf.json.JSONObject) array.get(i);
            if (object.getInt("limit_price") > allPrice.intValue()) {
                if (i == 0) {
                    if (object.getInt("limit_price") == allPrice.intValue()) {
                        reduce = object.getInt("reduce");
                    }
                    break;
                }
                object = (net.sf.json.JSONObject) array.get(i - 1);
                reduce = object.getInt("reduce");
                break;
            } else {
                reduce = object.getInt("reduce");
            }
        }
    }

    public void copyActivityPros() {
        List<Record> records = Db.find("select * from kk_product_activity pa where activity_id=?", 10);
        for (Record record : records) {
            record.set("id", null);
            record.set("activity_id", 18);
            Db.save("kk_product_activity", record);
        }
    }


    public void addSignLog() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date d = new Date();
        int mg = 1;
        int num = 1;
        Record r = Db.findFirst("select * from kk_login_sign where u_uid=? order by  id desc limit 0,1", "a28358da76424297");
        String last_sign = sdf.format(r.getDate("create_time"));
        if (last_sign.equals(sdf.format(d))) {
            return;
        }
        Record r1 = new Record();
        r1.set("u_uid", "a28358da76424297");
        r1.set("create_time", d);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        calendar.add(Calendar.DAY_OF_MONTH, -1);

        if (sdf.format(calendar.getTime()).equals(last_sign)) {
            num = r.getInt("num") + 1;
            if (r.getInt("mg") < 5) {
                mg = r.getInt("mg") + 1;
            } else {
                mg = r.getInt("mg");
            }
        }
        r1.set("num", num);
        r1.set("mg", mg);
        Db.save("kk_login_sign", r1);
    }

    @org.junit.Test
    public void searchName() {
        int s_uid=5;
        String p_name="雪碧";
        int pg=1;
        List<Goods> goodses=Goods.dao.find("call searchName(?,?,?)",s_uid,p_name,1);
        System.out.println(goodses);
        int totalpage=0;
        int totalrecord=goodses.size();
        if(totalrecord%IConstant.PAGE_DATA==0){
            totalpage = totalrecord/IConstant.PAGE_DATA;
        }else{
            totalpage = totalrecord/IConstant.PAGE_DATA + 1;
        }
        System.out.println(totalpage);
        System.out.println(totalrecord);
        //Page<Record> Goods=new Page<Record>(goodses,pg,IConstant.PAGE_DATA,totalpage,totalrecord);
    }
}
