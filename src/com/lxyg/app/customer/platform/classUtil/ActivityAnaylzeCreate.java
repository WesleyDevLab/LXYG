package com.lxyg.app.customer.platform.classUtil;

import com.jfinal.plugin.activerecord.Db;
import net.sf.json.JSONObject;
import com.jfinal.plugin.activerecord.Record;
import net.sf.json.JSONArray;


public class ActivityAnaylzeCreate {
    static ActivityAnaylze activityAnaylze=null;

    public static ActivityAnaylze activityAnaylze(String uid,int activityId,JSONArray array,int proNum){
        int activityType=0;
        Record record= Db.findFirst("select activity_type,start_time,end_time,limit_e from kk_shop_activity sa where sa.id=?", activityId);
        if(record!=null){
            activityType=record.getInt("activity_type");
        }
        switch (activityType){
            case 2 :
                activityAnaylze=new validActivity(record);
                break;
            case 4 :
                activityAnaylze=new validNewUser(uid,activityId,array,proNum,record);
                break;
            default:
                activityAnaylze=new ActivityAnaylze();
        }
        return activityAnaylze;
    }

    public JSONObject GetResult(){

        return activityAnaylze.result();
    }

}
