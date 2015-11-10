package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;

import java.util.List;

/**
 * Created by Administrator on 2015/9/11.
 */
public class FBGoods extends Model<FBGoods> {
    private static final long serialVersionUID = 101L;
    public static final FBGoods dao = new FBGoods();

    private String find_sql="select id as fb_product_id,name,title,price,market_price,cash_pay,cover_img," +
            "p_unit_name,descripation,hide,index_show,payment,create_time,modify_time,order_no,s_uid from kk_product_fb where 1=1 ";

    private String search_hide=" and hide=0 ";
    private String search_product_id=" and id=? ";

    public FBGoods findbyId(int productId){
        FBGoods fbGoods=dao.findFirst(find_sql+search_hide+search_product_id,productId);
        if(fbGoods!=null){
            fbGoods.put("productImgs",getGoodsImgs(productId));
        }
        return fbGoods;
    }
    public FBGoods findById_lazy(int productId){
        FBGoods gs=new FBGoods().findFirst("select p.id as fb_product_id,p.name,p.title,p.price,p.cover_img,p.cash_pay from kk_product_fb p where p.id=? ", new Object[]{productId});
        return gs;
    }

    public List<Record> getGoodsImgs(int fbgoodsId){
        return Db.find("select id as proimgsId,product_id,img_url from kk_product_fb_img where product_id=?", fbgoodsId);
    }

    public Page<FBGoods> findBySID(String s_uid,int page){
        Page<FBGoods> fbGoodses=dao.paginate(page, IConstant.PAGE_DATA,"select id as fb_product_id,name,title,price,market_price,cash_pay,cover_img," +
                "p_unit_name,descripation,hide,index_show,payment,create_time,modify_time,order_no,s_uid","from kk_product_fb where 1=1 and hide=0 and s_uid=? order by order_no asc",s_uid);
        for(FBGoods fbGoods:fbGoodses.getList()){
            fbGoods.put("productImgs", getGoodsImgs(fbGoods.getInt("fb_product_id")));
        }
        return fbGoodses;
    }
    public List<FBGoods> findBySID(String s_uid){
        List<FBGoods> fbGoodses=dao.find("select id as fb_product_id,name,title,price,market_price,cash_pay,cover_img," +
                "p_unit_name,descripation,hide,index_show,payment,create_time,modify_time,order_no,s_uid " +
                "from kk_product_fb where 1=1 and hide=0 and s_uid=? order by order_no asc",s_uid);
        for(FBGoods fbGoods:fbGoodses){
            fbGoods.put("productImgs", getGoodsImgs(fbGoods.getInt("fb_product_id")));
        }
        return fbGoodses;
    }

    public List<Record> getactivitys(int s_uid,int type){
        return Db.find("select id as activity_id,alt,label_cn,shop_id,type,start_time," +
                "end_time,create_time,limit_e from kk_shop_activity sa where sa.shop_id=? and sa.type=?", s_uid, type);
    }
}

