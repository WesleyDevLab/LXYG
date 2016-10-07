package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
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
        List<Record> records= Db.use("sybase").find("SELECT * from HYT_BMZX_SPB");

        renderSuccess("获取成功",records);
    }





}
