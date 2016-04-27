package com.lxyg.app.customer.platform.classUtil;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import java.util.Date;

/**
 * Created by 秦帅 on 2016/4/14.
 * 下单活动订单 分析
 */
public class ActivityAnaylze {
    JSONObject obj=new JSONObject();
    public  JSONObject result(){
        obj.put("msg","");
        obj.put("code",10002);
        return obj;
    }
}

class validActivity extends ActivityAnaylze{ //活动是否有效 是否在有效期内
    JSONObject obj=new JSONObject();
    private Record record;
    public validActivity(Record record){
        this.record=record;
    }
    @Override
    public JSONObject result() {
        Date now=new Date();
        Date start=record.getDate("start_time");
        Date end=record.getDate("end_time");
        if(start.before(now)&&end.after(now)){
            obj.put("msg","");
            obj.put("code",10002);
        }else{
            obj.put("msg","活动未开始或已过期");
            obj.put("code",10001);
        }
        return obj;
    }
}

class validNewUser extends ActivityAnaylze{ //是否是新用户 新用户满足 首次下单 购买一件活动产品 产品数量为1
    private String uid;
    private int activityId;
    private JSONArray jsonArray;
    private int proNum;
    private Record record;
    public validNewUser(String uid,int activityId,JSONArray array,int proNum,Record record){
        this.uid=uid;
        this.activityId=activityId;
        this.jsonArray=array;
        this.proNum=proNum;
        this.record=record;
    }

    @Override
    public JSONObject result() {
        JSONObject obj=new JSONObject();
        if(proNum<=0){
            obj.put("msg","购买数量不能为0");
            obj.put("code",10001);
        }

        Record r= Db.findFirst("SELECT count(*) as count FROM kk_order o LEFT JOIN kk_order_item oi ON o.order_id = oi.order_id WHERE oi.product_id IN ( SELECT id FROM kk_product_activity pa WHERE pa.activity_id = ? ) AND o.order_status IN (" + IConstant.OrderStatus.order_status_dfh + "," + IConstant.OrderStatus.order_status_psz + "," + IConstant.OrderStatus.order_status_ywc + "," + IConstant.OrderStatus.order_status_js_success + ") and o.u_uuid=?", activityId, uid);
        if(r.getLong("count")>0){
            obj.put("msg","您不是新用户");
            obj.put("code",10001);
        }

        if(proNum>record.getInt("limit_e")){
            obj.put("msg","本活动限购"+record.getInt("limit_e")+"个");
            obj.put("code",10001);
        }
        return obj;
    }
}