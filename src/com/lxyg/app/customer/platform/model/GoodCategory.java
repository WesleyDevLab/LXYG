package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

import java.util.List;

/**
 * Created by ÇØË§ on 2015/12/9.
 */
public class GoodCategory extends Model<GoodCategory> {
    private static final long serialVersionUID = 112L;
    public static final GoodCategory dao = new GoodCategory();

    private List<GoodType> goodTypes;

    public void setGoodTypes(List<GoodType> goodTypes) {
        this.goodTypes = goodTypes;
    }

    public List<GoodType> getGoodTypes(int ca_id) {
        List<GoodType> goodTypes=GoodType.dao.find("select * from kk_product_type pt where pt.p_category_id=? ",ca_id);
        for(GoodType goodType:goodTypes){
            List<Record> records= Db.find("select * from kk_product_brand where p_type_id=? or id=1 order by id asc",goodType.getInt("id"));
            goodType.put("brands",records);
        }
        return goodTypes;
    }
    public List<GoodType> getGoodTypes_1(int ca_id) {
        List<GoodType> goodTypes=GoodType.dao.find("select * from kk_product_type pt where pt.p_category_id=? or id=0 ",ca_id);
        for(GoodType goodType:goodTypes){
            List<Record> records= Db.find("select * from kk_product_brand where p_type_id=? or id=1 order by id asc",goodType.getInt("id"));
            goodType.put("brands",records);
        }
        return goodTypes;
    }


    public List<GoodType> getGoodTypes(int ca_id,int shop_id) {
        List<GoodType> goodTypes=GoodType.dao.find("SELECT p.p_type_id, p.p_type_name FROM kk_shop_product sp LEFT JOIN kk_product p ON p.id = sp.product_id LEFT JOIN kk_product_type pt ON p.p_type_id = pt.id WHERE sp.shop_id = ? AND pt.p_category_id = ? GROUP BY p.p_type_id;",shop_id,ca_id);
        for(GoodType goodType:goodTypes){
            List<Record> records= Db.find("SELECT p.p_brand_id, p.p_brand_name FROM kk_shop_product sp LEFT JOIN kk_product p ON p.id = sp.product_id WHERE sp.shop_id = ? AND p_type_id = ? GROUP BY p_brand_id;",shop_id,goodType.getInt("id"));
            goodType.put("brands",records);
        }
        return goodTypes;
    }


}
