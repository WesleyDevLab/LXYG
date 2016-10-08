package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.interceptor.loginInterceptor;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.util.List;

/**
 * Created by audie on 2016/10/2.
 */
@Before(loginInterceptor.class)
public class SybaseController extends Controller {
    private static final Logger log= Logger.getLogger(SybaseController.class);
    public void renderSuccess(String value,Object o){
        setAttr("code", 10002);
        setAttr("msg", value);
        if(o==null){
            setAttr("data", new JSONObject());
        }else{
            setAttr("data", o);
        }
        renderJson();
        return;
    }
    public void renderFaile(String value){
        setAttr("code", 10001);
        setAttr("msg", value);
        renderJson();
        return;
    }

    @ActionKey("sybase/products")
    public void productsSybase(){
        log.info("productsSybase");
        /***
         *
         `product_tm` int(11) NOT NULL COMMENT '条码',
         `product_name` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '产品名称',
         `product_price` VARCHAR(20) NOT NULL DEFAULT '0' COMMENT '产品售价',
         `product_spbm` VARCHAR(20) not NULL COMMENT '商品编码',
         `product_unit` VARCHAR(5) NOT NULL COMMENT '商品单位',
         `product_csbm` VARCHAR(20) not NULL COMMENT '厂商编码',
         `create_time` TIMESTAMP not null DEFAULT current_timestamp comment '创建时间',
         *
         * **/
        //TM,SPBM,SPMC,JLDW,CSBM,DJ
        List<Record> records= Db.use("sybase").find("SELECT TM,SPBM,SPMC,JLDW,CSBM,SJ from HYT_BMZX_SPB");
        StringBuffer sb=new StringBuffer();
//        sb.append("insert into kk_product_sybase(product_tm,product_name,product_price," +
//                "product_spbm,product_unit,product_csbm) values");
        for (Record r:records){
            Record record=new Record();
            if(r.getStr("TM")==null||r.getStr("TM").equals("")){
                record.set("product_tm","no TM");
            }else{
                record.set("product_tm",r.getStr("TM"));
            }
            record.set("product_name",r.getStr("SPMC"));
            record.set("product_price",r.getBigDecimal("SJ").toString());
            record.set("product_spbm",r.getStr("SPBM"));
            record.set("product_unit",r.getStr("JLDW"));
            record.set("product_csbm",r.getStr("CSBM"));
            Db.save("kk_product_sybase",record);
        }
        renderSuccess("获取成功",records);
    }
}
