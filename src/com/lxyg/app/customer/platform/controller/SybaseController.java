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
    private static final Logger log = Logger.getLogger(SybaseController.class);

    public void renderSuccess(String value, Object o) {
        setAttr("code", 10002);
        setAttr("msg", value);
        if (o == null) {
            setAttr("data", new JSONObject());
        } else {
            setAttr("data", o);
        }
        renderJson();
        return;
    }

    public void renderFaile(String value) {
        setAttr("code", 10001);
        setAttr("msg", value);
        renderJson();
        return;
    }

    @ActionKey("sybase/products")
    public void productsSybase() {
        log.info("productsSybase");
        /***
         *
         `product_tm` varchar(50) NOT NULL COMMENT '条码',
         `product_name` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '产品名称',
         `product_price` BIGINT NOT NULL DEFAULT '0' COMMENT '产品售价',
         `product_spbm` VARCHAR(20) not NULL COMMENT '商品编码',
         `product_unit` VARCHAR(5) NOT NULL COMMENT '商品单位',
         `product_csbm` VARCHAR(20) not NULL COMMENT '厂商编码',
         `product_category` int(11) NOT NULL DEFAULT 0 COMMENT '产品分类编码',
         `create_time` TIMESTAMP not null DEFAULT current_timestamp comment '创建时间',
         *
         * **/
        //TM,SPBM,SPMC,JLDW,CSBM,DJ
        List<Record> records = Db.use("sybase").find("SELECT TM,SPBM,SPMC,JLDW,CSBM,SJ,SPLB from HYT_BMZX_SPB");
        StringBuffer sb = new StringBuffer();
        for (Record r : records) {
            Record record = new Record();
            if (r.getStr("TM") == null || r.getStr("TM").equals("")) {
                record.set("product_tm", "no TM");
            } else {
                record.set("product_tm", r.getStr("TM").trim());
            }
            record.set("product_name", r.getStr("SPMC"));
            record.set("product_price", r.getBigDecimal("SJ").toString());
            record.set("product_spbm", r.getStr("SPBM"));
            record.set("product_unit", r.getStr("JLDW"));
            record.set("product_csbm", r.getStr("CSBM"));
            record.set("product_category", r.getStr("SPLB").trim());
            Db.save("kk_product_sybase", record);
        }
        renderSuccess("获取成功", records);
    }

    @ActionKey("sybase/categorys")
    public void categorysSybase() {
        log.info("categorysSybase");
        /***
         *
         `category_id` int(11) NOT NULL DEFAULT 0 COMMENT '类别编码',
         `category_name` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '类别名称',
         `create_time` TIMESTAMP not null DEFAULT current_timestamp comment '创建时间',
         *
         * **/
        //TM,SPBM,SPMC,JLDW,CSBM,DJ
        List<Record> records = Db.use("sybase").find("SELECT LBBM,LBMC from HYT_BMZX_LBB");
        for (Record r : records) {
            Record record = new Record();
            if (r.getStr("LBBM") == null || r.getStr("LBBM").trim().equals("")) {
                record.set("category_id", 0);
            } else {
                record.set("category_id", r.getStr("LBBM").trim());
            }
            record.set("category_name", r.getStr("LBMC"));
            Db.save("kk_category_sybase", record);
        }
        renderSuccess("获取成功", records);
    }
}
