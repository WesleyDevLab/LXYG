package com.lxyg.app.customer.platform.classUtil;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.User;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.service.OrderService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * Created by 秦帅 on 2016/4/21.
 */

abstract class Strategy {
    public abstract int algorithmicInterface();
}



class StrategyNorm extends Strategy{
    private JSONArray array;
    public StrategyNorm(){}
    public StrategyNorm(JSONArray array){
       this.array=array;
    }

    @Override
    public int algorithmicInterface() { //正常支付
        GoodsService goodsService=new GoodsService();
        int allPrice=0;
        for (int i = 0; i < array.size(); i++){
            JSONObject o = array.getJSONObject(i);
            int productId=o.getInt("productId");
            int productNum = o.getInt("productNum");
            int isNorm = o.getInt("is_norm");
            allPrice+=goodsService.getPrice(productId, productNum, isNorm);
        }
        return allPrice;
    }
}


class StrategyCashPay extends Strategy{ //代金券
    OrderService orderService=new OrderService();
    private JSONArray array;
    private String uid;
    private int shopId;
    public StrategyCashPay(JSONArray array,String uid,int shopId){
        this.array=array;
        this.uid=uid;
        this.shopId=shopId;
    }
    @Override
    public int algorithmicInterface() {
        int allPrice=new StrategyNorm(array).algorithmicInterface();
        Record r = Db.findFirst("select IFNULL(sum(cash),0) as cash,u_uuid from kk_user_cash uc left join kk_cash c on uc.cash_id=c.id  " +
                "where uc.u_uuid=? and c.cash_status=1", uid);

        if (r.getBigDecimal("cash").intValue() != 0) {
            Record record = Db.findFirst("select count(*) as count from kk_shop_activity sa where sa.shop_id=? and activity_type=7", shopId);
            if (record.getLong("count") > 0) {
                int reduce = orderService.getReduceCash(shopId, allPrice);
                allPrice = allPrice - reduce;
                /***
                 * 总价减去活动区间红包可优惠代金券
                 * */
                User.dao.reduceCash(uid, reduce);
            }
        }
        return allPrice;
    }
}


