package com.lxyg.app.customer.platform.classUtil;

import com.alibaba.fastjson.*;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Shop;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.util.JsonUtils;
import com.lxyg.app.customer.platform.util.Point;
import net.sf.json.JSONObject;
import net.sf.json.JSONArray;

import java.util.List;
import java.util.Map;

/**
 * Created by 秦帅 on 2016/4/20.
 */
public class VerifyOrder {
    JSONObject obj=new JSONObject();
    public JSONObject GoResult(){
        return obj;
    }


}

/**产品是否充足*/
class verifyOrder_isProEnough extends VerifyOrder{
    private GoodsService goodsService=new GoodsService();
    private JSONArray jsonArray;
    private int shopId;
    public verifyOrder_isProEnough(){}

    public verifyOrder_isProEnough(JSONArray jsonArray,int shopId){
        this.jsonArray=jsonArray;
        this.shopId=shopId;
    }

    @Override
    public JSONObject GoResult(){
        JSONObject object=new JSONObject();
        StringBuffer stringBuffer=new StringBuffer("抱歉，您的订单");
        for(int i=0;i<jsonArray.size();i++){
            JSONObject o = jsonArray.getJSONObject(i);
            int productId = o.getInt("productId");
            int productNum = o.getInt("productNum");
            int isNorm = o.getInt("is_norm");
            if(isNorm==1){
                Record record= Db.findFirst("select p.name,ps.product_number from kk_shop_product ps left join kk_product p on ps.product_id=p.id where ps.shop_id=? and product_id=?", shopId, productId);
                if(record.getInt("product_number")<=0||record.getInt("product_number")<productNum){
                    object.put("code",10001);
                    object.put("msg",stringBuffer.append(record.getStr("name")).append("、"));
                }
            }
            if(isNorm==2){
                Record record=Db.findFirst("select name,surplus_num from kk_product_activity pa where pa.id=?",productId);
                if(record.getInt("surplus_num")<=0||record.getInt("surplus_num")<productNum){
                    object.put("code",10001);
                    object.put("msg",stringBuffer.append(record.getStr("name")).append("、"));
                }
            }
        }
        return object;
    }

}
/**产品是否参与活动*/
class verifyOrder_checkActivity extends VerifyOrder{
    private String uid;
    private JSONArray jsonArray;
    public verifyOrder_checkActivity(String uid,JSONArray jsonArray){
        this.uid=uid;
        this.jsonArray=jsonArray;
    }

    public JSONObject GoResult(){
        JSONObject object=new JSONObject();
        for(int i=0;i<jsonArray.size();i++){
            JSONObject o = jsonArray.getJSONObject(i);
            int productId = o.getInt("productId");
            int productNum = o.getInt("productNum");
            int isNorm = o.getInt("is_norm");
            int activityId=o.getInt("activity_id");
            ActivityAnaylze anaylze=ActivityAnaylzeCreate.activityAnaylze(uid,activityId,jsonArray,productNum);
            object= anaylze.result();
            if(object.containsKey("code")&&object.getInt("code")==10001){
                return object;
            }
        }
        return null;

    }

}
/**产品是否在配送区域内*/
class verifyOrder_inScope extends VerifyOrder{
    private String scope;
    private int addressId;

    public verifyOrder_inScope(String scope,int addressId){
        this.scope=scope;
        this.addressId=addressId;
    }
    JSONObject object=new JSONObject();
    public JSONObject GoResult(){
        Record r = Db.findById("kk_user_address", addressId);
        JSONObject jsonObject = JSONObject.fromObject(scope);
        List objs = JsonUtils.json2list(jsonObject.getString("scope"));
        Point[] points = Point.list2point(objs);
        Point p = new Point(r.getDouble("lat"), r.getDouble("lng"));
        boolean flag = Point.inPolygon(p, points);
        if (!flag) {
            object.put("code",10001);
            object.put("msg","不在配送范围内");
        }
        return object;
    }
}
/**店铺是否关闭*/
class verifyOrder_ShopIsOn extends VerifyOrder{
    private int status;
    public verifyOrder_ShopIsOn(Shop shop){
        this.status=shop.getInt("off");
    }
    JSONObject object=new JSONObject();
    public JSONObject GoResult(){
        if(status>0){
            object.put("code",10001);
            object.put("msg","店铺维护中，暂停下单，请到实体店购买。");
        }
        return object;
    }
}
