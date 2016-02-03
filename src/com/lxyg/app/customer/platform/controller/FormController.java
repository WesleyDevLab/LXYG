package com.lxyg.app.customer.platform.controller;

import com.alibaba.fastjson.JSONArray;
import com.jfinal.aop.Before;
import com.jfinal.aop.ClearInterceptor;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.interceptor.loginInterceptor;
import com.lxyg.app.customer.platform.model.Form;
import com.lxyg.app.customer.platform.model.FormReplay;
import com.lxyg.app.customer.platform.model.FormZan;
import com.lxyg.app.customer.platform.model.User;
import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.util.EmojiFilter;
import com.lxyg.app.customer.platform.util.M;
import com.lxyg.app.customer.platform.util.SensitivewordFilter;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.util.List;

/**
 * Created by 秦帅 on 2015/11/10.
 */

@Before(loginInterceptor.class)
public class FormController extends Controller {
    private static final Logger log= Logger.getLogger(FormController.class);
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

    private static String isSuccess(boolean result) {
        return result ? " 成功" : " 失败";
    }


    /**
     * 添加帖子
     * */
    @ActionKey("app/user/v2/addForm")
    @Before(Tx.class)
    public void addForm(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        Form form=new Form();
        if(!json.containsKey("uid")){
            renderFaile("异常");
            return;
        }
        if(json.containsKey("title")){
            String title=  SensitivewordFilter.filterSensitiveWord(json.getString("title"));
            form.setTitle(title);
        }
        if(json.containsKey("content")){
            String content=  SensitivewordFilter.filterSensitiveWord(json.getString("content"));
            form.setContent(EmojiFilter.filterEmoji(content));
        }
        if(json.containsKey("uid")){
            form.setU_uid(json.getString("uid"));
        }
        form.setCreate_time();
        form.save();
        if(json.containsKey("imgs")){
            JSONArray array =JSONArray.parseArray(json.getString("imgs"));
            for(int i=0;i<array.size();i++){
                form.setFormImg(array.get(i).toString(),form.getInt("id"));
            }
           // form.set("form_id",form.getInt("id"));
            form.put("formImgs",form.getFormImgs(form.getInt("id")));
        }

        renderSuccess("添加成功", form);
    }

    /**
     * 删除帖子
     * */

    @ActionKey("app/user/v2/delForm")
    @Before(Tx.class)
    public void delFrom(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("uid")){
            renderFaile("异常");
            return;
        }
        int form_id=json.getInt("form_id");
        boolean b=Form.dao.delForm(form_id);
        if(b){
            renderSuccess(isSuccess( b),null);
        }else{
            renderFaile("异常");
            return;
        }
    }

    @ActionKey("app/user/v2/adminDelForm")
    @ClearInterceptor
    public void delForm(){
        int formId=getParaToInt("formId");
        boolean b=Form.dao.delForm(formId);
        if(b){
            renderSuccess("删除成功",null);
            return;
        }
        renderFaile("异常");
    }

    /**
     * 帖子列表
     * */
    @ActionKey("app/user/v2/listForm")
    @ClearInterceptor
    public void listForm(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        int page=1;
        if(json.containsKey("pg")){
            page=json.getInt("pg");
        }
        String uid="";
        if(json.containsKey("uid")){
            uid=json.getString("uid");
        }
        if(isParaExists("pg")){
            page=getParaToInt("pg");
        }
        Page<Form> formpage=Form.dao.forms(page,uid);
        if(isParaExists("type")&&getPara("type").equals("web")){
            setAttr("forms",formpage);
            setAttr("code", 10010);
            setAttr("message", "load成功");
            render("/forum/forumList.jsp");
            return;
        }
        renderSuccess("获取成功",formpage);
    }

    /**
     * 帖子详情
     * */
    @ActionKey("app/user/v2/form")
    public void form(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("form_id")){
            renderFaile("异常");
            return;
        }
        int form_id=json.getInt("form_id");
        Form form=Form.dao.findFirst("SELECT COUNT(*) as count FROM kk_form f where f.id=?",form_id);
        if(form.getLong("count")==0){
            renderFaile("加载异常");
            return;
        }
        String uid="";
        if(json.containsKey("uid")){
            uid=json.getString("uid");
        }
        Form f=Form.dao.form(form_id,uid);
        renderSuccess("获取成功 ",f);
    }

    /**
     * 帖子回复
     * */
    @ActionKey("app/user/v2/replay")
    public void addReplay(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("form_id")||!json.containsKey("uid")||!json.containsKey("content")){
            renderFaile("提交信息异常");
            return;
        }
        int form_id=json.getInt("form_id");
        String to_u_uid="";
        if(json.containsKey("to_uid")){
             to_u_uid=json.getString("to_uid");
            pushBySDK(json.getString("uid"),form_id,to_u_uid,json.getString("content"));
        }else{
            pushBySDK(json.getString("uid"),form_id,json.getString("content"));
        }
        String u_uid=json.getString("uid");
        String content=json.getString("content");
        Form.dao.setFormReplay(u_uid,to_u_uid,content,form_id);
        renderSuccess("添加成功",null);
    }

    /**
     * 删除回复
     * */
    @ActionKey("app/user/v2/delReplay")
    public void delReplay(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("replayId")||!json.containsKey("uid")){
            renderFaile("提交信息异常");
            return;
        }
        FormReplay formReplay=FormReplay.dao.findById(json.getInt("replayId"));
        if(!formReplay.getStr("u_uid").equals(json.containsKey("uid"))){
            renderFaile("删除异常");
            return;
        }
        int replay_id=json.getInt("replayId");
        boolean b= FormReplay.dao.deleteById(replay_id);
        renderSuccess(isSuccess(b), null);
    }


    /**
     * 帖子赞
     * */
    @ActionKey("app/user/v2/zan")
    public void addZan(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("form_id")||!json.containsKey("uid")){
            renderFaile("提交信息异常");
            return;
        }
        int form_id=json.getInt("form_id");
        String u_uid=json.getString("uid");
        Form f=Form.dao.findFirst("select count(id) as count from kk_form_zan z where z.form_id=? and z.u_uid=? ",form_id,u_uid);
        if(f.getLong("count")>0){
            renderFaile("已赞");
            return;
        }
         Form.dao.setFormZan(u_uid, form_id);
        renderSuccess("添加成功",null);
    }

    /**
     * 帖子删除赞
     * */
    @ActionKey("app/user/v2/delZan")
    public void delZan(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("zId")||!json.containsKey("uid")){
            renderFaile("提交信息异常");
            return;
        }
        int zId=json.getInt("zId");
        String u_uid=json.getString("uid");
        boolean b= FormZan.dao.deleteById(zId);
        renderSuccess(isSuccess(b), null);
    }

    @ActionKey("app/user/v2/myForms")
    public void myForms(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("uid")){
            renderFaile("异常");
            return;
        }
        int page=1;
        if(json.containsKey("pg")){
            page=json.getInt("pg");
        }
        renderSuccess("获取成功",Form.dao.myForms(page,json.getString("uid")));
    }

    public static void pushBySDK(String u_uid,int form_id,String to_uid,String content){
        User user=User.dao.findFirst("select * from kk_user u where u.uuid=?",u_uid);
        User to_user=User.dao.findFirst("select * from kk_user u where u.uuid=?",to_uid);
        if(user!=null && to_user!=null){
            String str=user.getStr("name")+"回复了您："+content;
           new JPush("你有新的回复",str,user.getStr("uuid"),"alias_one", M.pushMap(form_id),"user").start();
        }
    }
    public static void pushBySDK(String u_uid,int form_id,String content){
        User user=User.dao.findFirst("select * from kk_user u where u.uuid=?",u_uid);
        List<User> users=User.dao.find("SELECT u.phone, u.wechat_id,u.uuid FROM kk_form_replay fr LEFT JOIN kk_user u ON fr.u_uid = u.uuid WHERE form_id = ? AND u_uid != ? GROUP BY u_uid",form_id,u_uid);
        if(user!=null&&users.size()!=0){
            String str=user.getStr("name")+"评论："+content;
            for(User to_user:users){
                new JPush("你有新的评论",str,to_user.getStr("uuid"),"alias_one", M.pushMap(form_id),"user").start();
            }
        }
    }

}
