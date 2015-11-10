package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;

import java.util.Date;
import java.util.List;

/**
 * Created by 秦帅 on 2015/11/10.
 */
public class Form extends Model<Form>{
    private static final long serialVersionUID = 102L;
    public static final Form dao=new Form();

    private String title;
    private String content;
    private String create_time;
    private String u_uid;
    private FormImg formImg;
    private FormReplay formReplay;
    private FromZan fromZan;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        set("title",title);
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        set("content",content);
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time() {
        set("create_time",new Date());
    }

    public String getU_uid() {
        return u_uid;
    }

    public void setU_uid(String u_uid) {
        set("u_uid",u_uid);
    }


    public void setFormImg(String imgUrl,int formId) {
        FormImg formImg=new FormImg();
        formImg.set("img_url", imgUrl);
        formImg.set("form_id",formId);
        formImg.save();
    }

    public void setFormReplay(String u_uid,String to_u_uid,String content,int formId) {
        FormReplay formReplay=new FormReplay();
        formReplay.set("form_id",formId);
        formReplay.set("u_uid",u_uid);
        formReplay.set("to_u_uid",to_u_uid);
        formReplay.set("content",content);
        formReplay.save();
    }

    public void setFromZan(String u_uid,int formId) {
        FromZan fromZan=new FromZan();
        fromZan.set("form_id", formId);
        fromZan.set("u_uid",u_uid);
        fromZan.save();
    }

    public List<FromZan> getFromZan(int formId) {
        return fromZan.find("select z.u_uid,z.form_id,u.name,u.head_img from kk_from_zan z left join kk_user u on z.u_uid=u.uuid  where z.form_id=?",formId);
    }
    public List<FromZan> getFromZanAll(int formId) {
        return fromZan.find("select *,count(id) as count from kk_from_zan z  where z.form_id=?",formId);
    }

    public List<FormReplay> getFormReplays(int formId){
        return FormReplay.dao.find("SELECT r.id AS replayId, r.form_id, r.u_uid, r.to_u_uid, r.content, u. name, u.head_img, tu. name, tu.head_img " +
                "FROM kk_form_replay r LEFT JOIN kk_user u ON u.uuid = r.u_uid LEFT JOIN kk_user tu ON tu.uuid = r.to_u_uid where r.form_id=?",formId);
    }
    public List<FormReplay> getFormReplaysAll(int formId){
        return FormReplay.dao.find("SELECT *,count(id) as count from kk_form_replay  where r.form_id=?",formId);
    }

    public List<FormImg> getFormImgs(int formId){
        return FormImg.dao.find("select id as formImgId,img_url,form_id from kk_form_img where form_id=?",formId);
    }
    public List<FormImg> getFormImgsAll(int formId){
        return FormImg.dao.find("select *,count(id) as count from kk_form_img where form_id=?",formId);
    }




    public boolean delForm(int formId){
        Form form=Form.dao.findById(formId);
        boolean flag= form.delete();
        List<FormImg> formImgs=getFormImgsAll(formId);
        for(FormImg formImg:formImgs){
            formImg.delete();
        }
        for(FormReplay formReplay:getFormReplaysAll(formId)){
            formReplay.delete();
        }
        for(FromZan zan:getFromZanAll(formId)){
            zan.delete();
        }
        return flag;
    }

    public Page<Form> forms(int page){
       Page<Form> forms= Form.dao.paginate(page, IConstant.PAGE_DATA, "select f.id as form_id,f.title,f.content,f.create_time,f.u_uid,u.name,u.head_img ",
               "from kk_form f left join kk_user u on f.u_uid=u.uuid");
        for(Form f:forms.getList()){
            Record r= Db.findFirst("select count(r.id) as countR,count(z.id) as countZ from kk_form_replay r,kk_form_zan z where r.form_id=? and z.form_id=?",f.getInt("form_id"));
            f.put("formImgs",getFormImgs(f.getInt("form_id")));
            f.put("replayNum",r.getBigDecimal("countR"));
            f.put("zanNum",r.getBigDecimal("countZ"));
        }
        return forms;
    }

    public Form form(int formId){
        Form form=Form.dao.findFirst("select f.id as form_id,f.title,f.content,f.create_time,f.u_uid,u.name,u.head_img from kk_form f left join kk_user u on f.u_uid=u.uuid where f.id=?",formId);
        form.put("formImgs",getFormImgs(formId));
        form.put("replays",getFormReplays(formId));
        form.put("zans",getFromZan(formId));
        return  form;
    }


}
