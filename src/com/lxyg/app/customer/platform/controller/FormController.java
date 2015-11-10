package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.jfinal.plugin.activerecord.tx.TxConfig;
import com.lxyg.app.customer.platform.interceptor.loginInterceptor;
import com.lxyg.app.customer.platform.model.Form;
import com.lxyg.app.customer.platform.model.FormImg;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.text.Normalizer;

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


    @ActionKey("app/user/v2/addForm")
    @Before(Tx.class)
    public void addForm(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        Form form=new Form();
        if(json.containsKey("title")){
            form.setTitle(json.getString("title"));
        }
        if(json.containsKey("content")){
            form.setContent(json.getString("content"));
        }
        if(json.containsKey("uid")){
            form.setU_uid(json.getString("uid"));
        }
        form.setCreate_time();
        form.save();
        if(json.containsKey("imgs")){
            net.sf.json.JSONArray array=json.getJSONArray("imgs");
            for(int i=0;i<array.size();i++){
                form.setFormImg(array.get(i).toString(),form.getInt("id"));
            }
            form.set("form_id",form.getInt("id"));
            form.put("formImgs",form.getFormImgs(form.getInt("id")));
        }
        renderSuccess("添加成功", form);
    }
    @ActionKey("app/user/v2/delForm")
    @Before(Tx.class)
    public void delFrom(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        int form_id=json.getInt("form_id");
        boolean b=Form.dao.delForm(form_id);
        if(b){
            renderSuccess("删除成功",null);
        }else{
            renderFaile("异常");
            return;
        }
    }
    @ActionKey("app/user/v2/listForm")
    public void listForm(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        int page=1;
        if(json.containsKey("pg")){
            page=json.getInt("pg");
        }
        renderSuccess("获取成功",Form.dao.forms(page));
    }
    @ActionKey("app/user/v2/form")
    public void form(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("form_id")){
            renderFaile("异常");
            return;
        }
        int form_id=json.getInt("form_id");
        Form f=Form.dao.form(form_id);
        renderSuccess("获取成功 ",f);
    }


    @ActionKey("app/user/v2/replay")
    public void addReplay(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("form_id")||!json.containsKey("uid")||!json.containsKey("to_u_uid")||!json.containsKey("content")){
            renderFaile("提交信息异常");
            return;
        }
        int form_id=json.getInt("form_id");
        String u_uid=json.getString("uid");
        String to_u_uid=json.getString("to_uid");
        String content=json.getString("content");
        Form.dao.setFormReplay(u_uid,to_u_uid,content,form_id);
        renderSuccess("添加成功",null);
    }

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
        if(f.getBigDecimal("count").intValue()>0){
            renderFaile("已赞");
            return;
        }
        Form.dao.setFromZan(u_uid,form_id);
        renderSuccess("添加成功",null);
    }

    @ActionKey("app/user/v2/delZan")
    public void delZan(){
        JSONObject json= JSONObject.fromObject(getPara("info"));
        if(!json.containsKey("form_id")||!json.containsKey("uid")){
            renderFaile("提交信息异常");
            return;
        }
        int form_id=json.getInt("form_id");
        String u_uid=json.getString("uid");
        Form.dao.setFromZan(u_uid,form_id);
        renderSuccess("添加成功",null);
    }



}
