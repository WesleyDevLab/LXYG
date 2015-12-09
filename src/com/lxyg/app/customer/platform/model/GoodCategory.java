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
        List<GoodType> goodTypes=GoodType.dao.find("select * from kk_product_type where p_category_id=?",ca_id);
        for(GoodType goodType:goodTypes){
            List<Record> records= Db.find("select * from kk_product_brand where p_type_id=?",goodType.getInt("id"));
            goodType.put("brands",records);
        }
        return goodTypes;
    }

}
