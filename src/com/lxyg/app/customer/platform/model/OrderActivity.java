package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

import java.util.List;

/**
 * Created by ÇØË§ on 2015/12/28.
 */
public class OrderActivity extends Model<OrderActivity>{
    private static final long serialVersionUID = 112L;
    public static final OrderActivity dao = new OrderActivity();

//    select oi.id as orderItemId,oi.product_id,oi.product_number,oi.product_price,oi.cash_pay,oi.product_pay,oi.is_norm,p.name,p.cover_img "
//            + "from kk_order_item oi left join kk_product p on oi.product_id =p.id  where oi.order_id =? ", orderId);

    public List<Record> getActivityOrderItem(String orderId){
        List<Record> records= Db.find("select oai.id as orderItemId,oai.order_id,oai.product_id,oai.product_number," +
                "oai.product_price,oai.cash_pay,oai.product_pay,oai.create_time,pa.name,pa.cover_img from kk_order_activity_item oai left join kk_product_activity pa on oai.product_id =pa.id where oai.order_id=?", orderId);
        return records;
    }

    public void delActivityOrderItem(String orderId){
        System.out.println(orderId);
        List<Record> records=getActivityOrderItem(orderId);
        for(Record record:records){
            record.set("id",record.getInt("orderItemId"));
            Db.delete("kk_order_activity_item",record);
        }
    }
}
