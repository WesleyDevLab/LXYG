package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Goods;
import com.lxyg.app.customer.platform.model.GoodsImg;
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
//        if(isParaExists("p_type_id")&&getParaToInt("p_type_id")!=0){
//            objs=new Object[]{shopId,getParaToInt("activity_id"),getParaToInt("p_type_id")};
//            b.append(" and pa.p_type_id=? ");
//        }
//        Page<Record> recordPage= Db.paginate(page, IConstant.PAGE_DATA,"SELECT pa.*,sa.start_time,sa.end_time,a.name as act_name","FROM kk_product_activity pa LEFT JOIN kk_shop_activity sa " +
//                "ON pa.activity_id = sa.id LEFT JOIN kk_activity a on sa.activity_type=a.id WHERE sa.shop_id =? "+b,objs);
        Page<Record> recordPage= Db.paginate(page, IConstant.PAGE_DATA,"SELECT s. name AS sname,sa.id, sa.label_cn, a. name AS aname, sa.start_time, sa.end_time, IFNULL(sa.limit_e, 0) AS limit_num,sa.activity_type ",
                "FROM kk_shop_activity sa LEFT JOIN kk_shop s ON sa.shop_id = s.id LEFT JOIN kk_activity a ON sa.activity_type = a.id WHERE sa.shop_id = ?"+b,objs);
        renderSuccess("获取成功",recordPage);
    }

    public void addActivity(){
        String title=getPara("title");
        String start_time=getPara("start_time");
        String end_time=getPara("end_time");
        int act_typeId=getParaToInt("act_id");
        int shop_id=getParaToInt("shop_id");
        int limt=getParaToInt("limit");
        String img_url=getPara("img_url");

        Record record=new Record();
        record.set("label_cn",title);
        record.set("start_time",start_time);
        record.set("end_time",end_time);
        record.set("create_time",new Date());
        record.set("activity_type",act_typeId);
        record.set("shop_id",shop_id);
        record.set("limit_e",limt);
        record.set("img_url",img_url);
        Db.save("kk_shop_activity",record);
        setAttr("activity",record);
        setAttr("code",10002);
        renderJson();
    }

    public void addActivityPros(){

        if(!isParaExists("p_id")){
            renderError(10001);
            return;
        }
        int p_id=getParaToInt("p_id");
        Goods goods=Goods.dao.findById(p_id);
        int act_id=getParaToInt("act_id");
        String title=getPara("title");
        int act_price=getParaToInt("act_price");
        int limit_num=getParaToInt("limit_num");
        Record record=new Record();
        record.set("activity_id",act_id);
        record.set("name",goods.getStr("name"));
        record.set("title",title);
        record.set("price",act_price);
        record.set("cover_img",goods.getStr("cover_img"));
        record.set("p_unit_name",goods.getStr("p_unit_name"));
        record.set("create_time",new Date());
        record.set("limit_num",limit_num);
        record.set("surplus_num",limit_num);
        record.set("p_type_id",goods.getInt("p_type_id"));
        record.set("p_type_name",goods.getStr("p_type_name"));
        record.set("p_brand_id",goods.getInt("p_brand_id"));
        record.set("p_brand_name", goods.getStr("p_brand_name"));
        boolean flag=Db.save("kk_product_activity",record);
//        if(flag){
//           List<GoodsImg> GoodsImgs= goods.getProductImgs();
//            for(GoodsImg gi:GoodsImgs){
//
//            }
//        }
        if(flag){
            renderSuccess("添加成功",record);
        }
    }

    public void loadProInfo(){
        int p_id=getParaToInt("p_id");
        Goods goods=Goods.dao.findById(p_id);
        renderSuccess("product",goods);
    }
    public void aProduct(){
        int p_id=getParaToInt("ap_id");
        Record record=Db.findById("kk_product_activity","id",p_id);
        renderSuccess("product",record);
    }

    public void delActivity(){
        int act_id=getParaToInt("act_id");
        Record record=Db.findFirst("select * from kk_shop_activity sa where sa.id=?",act_id);
        if(record!=null){
            boolean b=Db.delete("kk_shop_activity",record);
            if(b){
                Db.update("delete from kk_product_activity  where activity_id=?",act_id);
            }
        }
        renderSuccess("删除成功",null);
    }
    public void updatePro(){
        int p_id=getParaToInt("ap_id");
        Record record=Db.findById("kk_product_activity","id",p_id);
        record.set("title",getPara("title"));
        record.set("price",getParaToInt("price"));
        record.set("limit_num",getParaToInt("p_num"));
        record.set("cover_img",getPara("ap_cover"));
        record.set("surplus_num",getParaToInt("p_num"));
        Db.update("kk_product_activity",record);
        renderSuccess("修改成功",null);
    }

    public void delAPro(){
        int p_id=getParaToInt("ap_id");
        Record record=Db.findById("kk_product_activity","id",p_id);
        if(record!=null&&record.getInt("id")!=0){
            Db.delete("kk_product_activity",record);
            renderSuccess("删除成共",null);
            return;
        }
    }


}
