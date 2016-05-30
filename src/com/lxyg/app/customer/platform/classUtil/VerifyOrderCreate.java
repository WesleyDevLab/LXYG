package com.lxyg.app.customer.platform.classUtil;

import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Shop;
import net.sf.json.JSONObject;
import net.sf.json.JSONArray;

/**
 * Created by ÇØË§ on 2016/4/20.
 */
public class VerifyOrderCreate {
    static VerifyOrder verifyOrder=null;
    static StrategyContext context;


    public VerifyOrder verifyOrder(JSONArray array,int shopId){
        verifyOrder=new verifyOrder_isProEnough(array,shopId);

        return verifyOrder;
    }

    public VerifyOrder verifyOrder(String uid,JSONArray jsonArray){
        verifyOrder=new verifyOrder_checkActivity(uid,jsonArray);
        return verifyOrder;
    }

    public VerifyOrder verifyOrder(String scope,int addressId){
        verifyOrder=new verifyOrder_inScope(scope,addressId);
        return verifyOrder;
    }

    public VerifyOrder verifyOrder(Shop shop){
        verifyOrder=new verifyOrder_ShopIsOn(shop);
        return verifyOrder;
    }

    public StrategyContext StrategtContext(int cashPay,JSONArray jsonArray,String uid,int shopId){
        if(cashPay>0){
            context=new StrategyContext(new StrategyCashPay(jsonArray,uid,shopId));
        }else{
            context=new StrategyContext(new StrategyNorm(jsonArray));
        }

        return context;
    }

    public JSONObject GoResult(){

        return verifyOrder.GoResult();
    }

    public JSONObject GoResult(JSONArray orderItem,Shop shop,int addressId){

        VerifyOrder verifyOrder=new verifyOrder_ShopIsOn(shop);
        JSONObject obj=verifyOrder.GoResult();
        if(obj.containsKey("code")&&obj.getInt("code")==10001){
            return verifyOrder.GoResult();
        }

        verifyOrder=new verifyOrder_isProEnough(orderItem,shop.getInt("id"));
        obj=verifyOrder.GoResult();
        if(obj.containsKey("code")&&obj.getInt("code")==10001){
            return verifyOrder.GoResult();
        }

        verifyOrder=new verifyOrder_checkActivity(shop.getStr("uuid"),orderItem);
        obj=verifyOrder.GoResult();
        if(obj.containsKey("code")&&obj.getInt("code")==10001){
            return verifyOrder.GoResult();
        }

        verifyOrder=new verifyOrder_inScope(shop.getStr("scope"),addressId);
        obj=verifyOrder.GoResult();
        if(obj.containsKey("code")&&obj.getInt("code")==10001){
            return verifyOrder.GoResult();
        }
        return verifyOrder.GoResult();
    }

}
