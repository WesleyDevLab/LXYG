package com.lxyg.app.customer.platform.service;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.FBGoods;
import com.lxyg.app.customer.platform.model.Goods;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.RegularUtil;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.List;


public class GoodsService{
	private static final Logger log= Logger.getLogger(GoodsService.class);

	public boolean save(Goods goods, String imgs) {
		boolean flag = false;
		int productId = goods.getInt("id");
		if (null != imgs && !imgs.equals("")) {
			try {
				Db.update("DELETE FROM kk_product_img where product_id=?", new Object[]{productId});
				JSONArray array = new JSONArray(imgs);
				for (int i = 0; i < array.length(); i++) {
					String img = array.getString(i);
					if(img.equals("undefined")){
						continue;
					}
					flag = new Goods().insertImgDetail(productId, img,"");
				}
			} catch (JSONException e) {
				log.info("json 解析错误", e);
			}
		}
		return flag;
	}

	public boolean saveFB(FBGoods r, String imgs) {
		boolean flag = false;
		int productId =r.getInt("id");
		if (null != imgs && !imgs.equals("")) {
			try {
				Db.update("DELETE FROM kk_product_fb_img where product_id=?", new Object[]{productId});
				JSONArray array = new JSONArray(imgs);
				for (int i = 0; i < array.length(); i++) {
					String img = array.getString(i);
					Record record=new Record();
					record.set("product_id",productId);
					record.set("img_url", RegularUtil.retIMGURL(img));
					Db.save("kk_product_fb_img", record);
				}
			} catch (JSONException e) {
				log.info("json 解析错误", e);
			}
		}
		return flag;
	}


	
	public List<Record> categoryNum(int shopId){
		List<Record> res= Db.find("select pt.id as goodsId,pt.name,pt.img,0 as num from kk_product_type pt where id<9");
		List<Record> lists= Db.find("SELECT count(*) as num, pt.id, pt.`name`, pt.img FROM " +
				"kk_product p LEFT JOIN kk_shop_product ps ON p.id = ps.product_id " +
				"LEFT JOIN kk_product_type pt ON p.p_type_id = pt.id WHERE ps.shop_id = ? GROUP BY p.p_type_id ", new Object[]{shopId});
		
		for(Record r:res){
			for(Record r1:lists){
				if(r.getInt("goodsId")==r1.getInt("id")){
					r.set("num", r1.get("num"));
				}
			}
		}
	    return res;
	}
	/**减少库存*/
	public void reduceProNum(int proId,int proNum,int shopId){
		Db.update("update kk_shop_product set product_number=product_number-? where product_id=? and shop_id=?",proNum,proId,shopId);
	}
	/**判断库存是否足够*/
	public boolean isProEnough(int proId,int proNum,int shopId){
		Record record=Db.findFirst("select * from kk_shop_product ps where ps.shop_id=? and product_id=?",shopId,proId);
		if(record.getInt("product_number")<proNum){
			return false;
		}
		return true;
	}
	/**增加库存*/
	public void addProNum(int proId,int proNum,int shopId){
		Db.update("update kk_shop_product set product_number=product_number+? where product_id=? and shop_id=?",proNum,proId,shopId);
	}

}
