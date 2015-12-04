package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.util.IConstant;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.util.Date;
import java.util.List;

/**
 * Created by 秦帅 on 2015/12/2.
 */
public class activityController extends Controller{
    private static final Logger log = Logger.getLogger(activityController.class);
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

    public void searchInfo(){
        List<Shop> shops=Shop.dao.find("select id,name from kk_shop ");
        List<Record> activities=Db.find("select * from kk_activity");
        setAttr("shops",shops);
        setAttr("activities",activities);
        setAttr("code",10002);
        renderJson();
    }

    public void loadActivity(){
        log.info("loadActivity");
        int page=1;
        if(isParaExists("pg")){
            page=getParaToInt("pg");
        }
        if(!isParaExists("shop_id")){
            renderFaile("请选择店铺");
            return;
        }
        int shopId=getParaToInt("shop_id");
        Object[] objs=new Object[]{shopId};
        StringBuffer b=new StringBuffer();
        if(isParaExists("activity_id")&&getParaToInt("activity_id")!=0){
            objs=new Object[]{shopId,getParaToInt("activity_id")};
            b.append(" and sa.activity_type=? ");
        }
        if(isParaExists("p_type_id")&&getParaToInt("p_type_id")!=0){
            objs=new Object[]{shopId,getParaToInt("activity_id"),getParaToInt("p_type_id")};
            b.append(" and pa.p_type_id=? ");
        }
        Page<Record> recordPage= Db.paginate(page, IConstant.PAGE_DATA,"SELECT pa.*,sa.start_time,sa.end_time,a.name as act_name","FROM kk_product_activity pa LEFT JOIN kk_shop_activity sa " +
                "ON pa.activity_id = sa.id LEFT JOIN kk_activity a on sa.activity_type=a.id WHERE sa.shop_id =? "+b,objs);
        renderSuccess("获取成功",recordPage);
    }

    public void addActivity(){
        String title=getPara("title");
        String start_time=getPara("start_time");
        String end_time=getPara("end_time");
        int act_typeId=getParaToInt("act_id");
        int shop_id=getParaToInt("shop_id");
        int limt=getParaToInt("limit");

        Record record=new Record();
        record.set("label_cn",title);
        record.set("start_time",start_time);
        record.set("end_time",end_time);
        record.set("create_time",new Date());
        record.set("activity_type",act_typeId);
        record.set("shop_id",shop_id);
        record.set("limit_e",limt);
        Db.save("kk_shop_activity",record);
        setAttr("activity",record);
        setAttr("code",10002);
        renderJson();
    }

}
