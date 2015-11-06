package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Shop extends Model<Shop> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final Shop dao = new Shop();
	
	public List<Record> getActivity(){
		return Db.find("select id as activityId,img_url,alt,label_cn,shop_id,type,end_time,start_time,limit_e from kk_shop_activity where shop_id=1");
	}
	
	public Shop findBysuid(String suid){
		return dao.findFirst("select * from kk_shop where uuid=?", suid);
	}
	public Shop findByShopIdenti(String suid){
		return dao.findFirst("select * from kk_shop s left join kk_shop_identi si on s.id=si.shop_id where s.uuid=?", suid);
	}
	
	public List<Shop> findByProduct(List<Integer> lists,double lng,double lat){
		String sql="";
		for(Integer i:lists){
			sql+=i+",";
		}
		sql=sql.substring(0, sql.length()-1);
		List<Shop> shops=dao.find("SELECT DISTINCT distance(?,?,s.lng,s.lat) as dis ,s.uuid as s_uuid,s.phone FROM kk_shop_product ps RIGHT JOIN kk_shop s ON s.id = ps.shop_id " +
				                   "WHERE ps.product_id IN ("+sql+") and distance(?,?,s.lng,s.lat) <=3000 GROUP BY ps.product_id order by dis",new Object[]{lng,lat,lng,lat});
		return shops;
	}
	
	/**查找哪些店包含某些产品*/
	public List<Shop> findBylessProduct(List<Record> goods,double lng,double lat){
		List<Shop> res=new ArrayList<Shop>();
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i).getInt("product_id")+",";
		}
		str=str.substring(0, str.length()-1);
		
		String sql="SELECT distance(?,?,s.lng,s.lat) as dis, s.id AS shopId, s. NAME, s.uuid, s.cover_img, s.phone, ps.product_id, " +
				"COUNT(ps.product_id) as num FROM kk_shop s LEFT JOIN kk_shop_product ps ON s.id = ps.shop_id WHERE ps.product_id IN ("+str+") and distance(?,?,s.lng,s.lat) <=3000 " +
				"GROUP BY shop_id  ORDER BY dis asc LIMIT 0, 10";
		
		List<Shop> shops=dao.find(sql,new Object[] { lng, lat ,lng, lat});
		for(Shop s:shops){
			int num=s.getLong("num").intValue();
			if(num==goods.size()){
				res.add(s);
			}
		}
		return res;
	}
	
	public List<Shop> findBylessProductArray(List<Integer> goods,double lng,double lat){
		List<Shop> res=new ArrayList<Shop>();
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i)+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance(?,?,s.lng,s.lat) as dis, s.id AS shopId, s. NAME, s.uuid, s.cover_img, s.phone, ps.product_id, " +
				"COUNT(ps.product_id) as num FROM kk_shop s LEFT JOIN kk_shop_product ps ON s.id = ps.shop_id WHERE ps.product_id IN ("+str+") and distance(?,?,s.lng,s.lat) <=3000 GROUP BY shop_id  " +
						"ORDER BY dis asc LIMIT 0, 10";
		List<Shop> shops=dao.find(sql,new Object[] { lng, lat,lng, lat });
		for(Shop s:shops){
			int num=s.getLong("num").intValue();
			if(num==goods.size()){
				res.add(s);
			}
		}
		return res;
	}
	/**查找哪些店包含某些产品多少个*/
	public List<Shop> findShopByProductId(List<Integer> goods,double lng,double lat){
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i)+",";
		}
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") AND " +
				"distance ( ?, ?, s.lng, s.lat ) < 3000 GROUP BY ps.shop_id ORDER BY num, dis ";
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,lng, lat});
		return res;
	}
	/**立即送  查找哪些店包含某些产品多少个*/
	public List<Shop> findShopByProductRecordDis (List<Record> goods,double lng,double lat){
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i).getInt("product_id")+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id,s.uuid as s_uid,s.phone, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") AND " +
				"distance ( ?, ?, s.lng, s.lat ) < 3000 GROUP BY ps.shop_id ORDER BY num desc, dis asc";
		
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,lng, lat});
		return res;
	}
	
	/**立即送  查找哪些店包含某些产品多少个*/
	public List<Shop> findShopByProductRecord (String[] pros,double lng,double lat){
		String str="";
		for(int i=0;i<pros.length;i++){
			str+=""+pros[i]+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id,s.uuid as s_uid,s.phone, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") AND " +
				"distance ( ?, ?, s.lng, s.lat ) < 3000 GROUP BY ps.shop_id ORDER BY num  desc, dis asc";
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,lng, lat});
		
		return res;
	}
	
	/**定时送  查找哪些店包含某些产品多少个*/
	public List<Shop> findShopByProductRecord(List<Record> goods,double lng,double lat){
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i).getInt("product_id")+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id,s.uuid as s_uid,s.phone, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") and " +
				" distance ( ?, ?, s.lng, s.lat )<10000 GROUP BY ps.shop_id ORDER BY num desc, dis asc";
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,lng, lat});
		return res;
	}
	
	/**定时送  查找哪些店包含某些产品多少个*/
	public List<Shop> findShopByProductShop(List<Record> goods,double lng,double lat,String u_uuid){
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i).getInt("product_id")+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id,s.uuid as s_uid,s.phone, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") " +
				" and s.uuid=? ORDER BY num desc, dis asc";
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,u_uuid});
		return res;
	}
	
	/**让单*/
	public List<Shop> findShopByProductRecordDis (List<Record> goods,double lng,double lat,String s_uid){
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i).getInt("product_id")+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id,s.uuid as s_uid,s.phone, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") AND " +
				"distance ( ?, ?, s.lng, s.lat ) < 3000 and s.uuid!=? GROUP BY ps.shop_id ORDER BY num desc, dis asc";
		
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,lng, lat,s_uid});
		return res;
	}
	/**让单*/
	public List<Shop> findShopByProductRecord (List<Record> goods,double lng,double lat,String s_uid){
		String str="";
		for(int i=0;i<goods.size();i++){
			str+=""+goods.get(i).getInt("product_id")+",";
		}
		str=str.substring(0, str.length()-1);
		String sql="SELECT distance ( ?, ?, s.lng, s.lat ) dis, ps.shop_id,s.uuid as s_uid,s.phone, " +
				"COUNT(ps.product_id) AS num, group_concat(ps.product_id) AS pros FROM kk_shop_product ps " +
				"LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE ps.product_id IN ("+str+") AND " +
				"distance ( ?, ?, s.lng, s.lat ) < 10000 and s.uuid!=? GROUP BY ps.shop_id ORDER BY num desc, dis asc";
		
		List<Shop> res= Shop.dao.find(sql, new Object[]{lng, lat,lng, lat,s_uid});
		return res;
	}
	
	
	
	public void createAccount(String u_uuid,String wechart,String order_id,int order_price,
			int cash_pay,int is_rob,int commission_rate,int type,int main_account,
			int main_account_type,String shop_id,int shop_account,
			int shop_commission,int shop_commission_type,String commission_shop,String alipay_no){
		
		Record r=new Record();
		r.set("u_uuid", u_uuid);
		if(wechart!=null){
			r.set("wechart", wechart);			
		}
		r.set("order_id", order_id);
		r.set("order_price", order_price);
		r.set("order_cash", cash_pay);
		r.set("is_rob", is_rob);
		r.set("commission_rate", commission_rate);
		r.set("type", type);
		r.set("type_name", IConstant.accountRecord.get(type));
		r.set("main_account", main_account);
		r.set("main_account_type", main_account_type);
		r.set("shop_id", shop_id);
		r.set("shop_account", shop_account);
		r.set("shop_commission", shop_commission);
		r.set("shop_commission_type", shop_commission_type);
		r.set("commission_shop", commission_shop);
		r.set("create_time", new Date());
		r.set("alipay_no", alipay_no);
		Db.save("kk_acount_record", r);
	}
	
	public Record createBalance(String suid,String bank,String bankNum){
		Record r=new Record();
		r.set("s_uid", suid);
		r.set("balance", 0);
		r.set("shop_bank", bank);
		r.set("shop_bank_card_num", bankNum);
		r.set("create_time", new Date());
		Db.save("kk_shop_balance", r);
		return r;
	}
	public void updateBalance(String suid,String bank,String bankNum){
		Record r= Db.findFirst("select * from kk_shop_balance where s_uid=?", new Object[]{suid});
		r.set("shop_bank", bank);
		r.set("shop_bank_card_num", bankNum);
		r.set("modify_time", new Date());
		Db.update("kk_shop_balance", r);
	}
	public void createBalanceLog(String suid,int in_come,int expend,int balance_type,String order_id){
		Record r=new Record();
		r.set("s_uid", suid);
		r.set("in_come", in_come);
		r.set("expend", expend);
		r.set("balance_type", balance_type);
		r.set("create_time", new Date());
		r.set("order_id",order_id);
		Db.save("kk_shop_balance_log", r);
	}
	
	public void updateBalance(String suid,int balance,int type){
		Record r= Db.findFirst("select * from kk_shop_balance where s_uid=?", new Object[]{suid});
		int b=0;
		if(r==null){
			r=dao.createBalance(suid, "", "");
			b=0;
		}
		b=r.getInt("balance");
		if(type==1){
			r.set("balance",b+balance);
		}
		if(type==2){
			r.set("balance", b-balance);
		}
		Db.update("kk_shop_balance", r);
	}
	
}
