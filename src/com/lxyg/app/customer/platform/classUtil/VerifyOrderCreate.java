package com.lxyg.app.customer.platform.classUtil;

import com.jfinal.plugin.activerecord.Record;
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

    public VerifyOrder verifyOrder(String scope,double lat,double lng){
        verifyOrder=new verifyOrder_inScope(scope,lat,lng);
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




}
