package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.IConstant;

import java.util.*;

/**
 * 店铺商品实体类，数据库操作类
 * 
 * @author Fuen
 * @since 2014-08-07
 */
public class Goods extends Model<Goods> {
	private static final long serialVersionUID = 103L;
	public static final Goods dao = new Goods();


	/**
	 * 根据ID查询商品详情
	 * 
	 * @param
	 *
	 */


	public Goods findById(int productId){
		Goods gs=new Goods().findFirst("select id as productId,name,title,price," +
				"p_type_id,p_brand_id,p_type_name,p_brand_name,cover_img,p_unit_id,p_unit_name,descripation," +
				"hide,index_show,server_id,server_name,payment,create_time,cash_pay,market_price,code from kk_product p where p.id=? ",new Object[]{productId});
		gs.put("productImgs", gs.getProductImgs());
	    return gs;
	}

	public Goods findById_lazy(int productId){
		Goods gs=new Goods().findFirst("select p.id as productId,p.name,p.title,p.price,p.cover_img,p.cash_pay from kk_product p where p.id=? ",new Object[]{productId});
	    return gs;
	}

	public Page<Goods> findByName(String p_name,int pg){
		Page<Goods> goods=dao.paginate(pg,IConstant.PAGE_DATA,"SELECT p.id AS productId, p. name, p.title, price, p_type_id, p_brand_id, p_type_name, p_brand_name, p.cover_img, p_unit_id, p_unit_name, p.descripation, p.hide, p.index_show, p.server_id, p.server_name, p.payment, p.cash_pay, p.market_price",
				"FROM  kk_product p where  p. name LIKE ?",new Object[]{"%"+p_name+"%"});
		for(Goods g:goods.getList()){
			g.put("productImgs",g.getProductImgs());
		}
		return goods;
	}

	public Page<Goods> findByName(String s_uid,String p_name,int pg){
		Page<Goods> goods=dao.paginate(pg,IConstant.PAGE_DATA,"SELECT p.id AS productId, p. name, p.title, price, p_type_id, p_brand_id, p_type_name, p_brand_name, p.cover_img, p_unit_id, p_unit_name, p.descripation, p.hide, p.index_show, p.server_id, p.server_name, p.payment, p.cash_pay, p.market_price",
				"FROM kk_shop_product ps LEFT JOIN kk_product p ON ps.product_id = p.id LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE s.uuid = ? AND p. name LIKE ?",new Object[]{s_uid,"%"+p_name+"%"});
		for(Goods g:goods.getList()){
			g.put("productImgs",g.getProductImgs());
		}
		return goods;
	}
	public Page<Goods> findByTxm(String s_uid,String code,int pg){
		Page<Goods> goods=dao.paginate(pg,IConstant.PAGE_DATA,"SELECT p.id AS productId, p. name, p.title, price, p_type_id, p_brand_id, p_type_name, p_brand_name, p.cover_img, p_unit_id, p_unit_name, p.descripation, p.hide, p.index_show, p.server_id, p.server_name, p.payment, p.cash_pay, p.market_price",
				"FROM kk_shop_product ps LEFT JOIN kk_product p ON ps.product_id = p.id LEFT JOIN kk_shop s ON ps.shop_id = s.id WHERE s.uuid = ? AND p.code = ?",new Object[]{s_uid,code});
		for(Goods g:goods.getList()){
			g.put("productImgs",g.getProductImgs());
		}
		return goods;
	}
	/**
	 * 获取多张图片
	 */
	public List<GoodsImg> getProductImgs(){
		List<GoodsImg> goodsImgs=GoodsImg.dao.find("select id as imgId,product_id,img_url,alt from kk_product_img where product_id=?",get("productId"));
		if(goodsImgs.size()!=0){
			return goodsImgs;
		}
		return goodsImgs;
	}
	
	/**
	 * pc端添加图片
	 */
	
	public boolean insertImgDetail(int productId,String imgUrl,String alt){
		String sql="insert into kk_product_img(product_id,img_url,create_time,alt) values(?,?,?,?)";
		int i= Db.update(sql, new Object[]{productId, ConfigUtils.upYunServer+ imgUrl, new Date(), alt});
		if(i!=0){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 *B端 产品列表展示
	 */
	
	
	public Page<Goods> goods(int type,int page,int typeId,int shopId,String searchItems){
		Page<Goods> goods = null;
		if(type== IConstant.quanbu){
			String select="SELECT p.id as productId,p.name,p.title,p.price,p.cover_img";
			String sql="from kk_product p where p.p_type_id=?";
			goods=new Goods().paginate(page, IConstant.PAGE_DATA, select, sql, new Object[]{typeId});
			int size=goods.getList().size();
			for(int i=0;i<size;i++){
				Goods g=goods.getList().get(i);
				int goodsId=g.getInt("productId");
				Record r= Db.findFirst("select * from kk_shop_product  where shop_id=? and product_id=? ", new Object[]{shopId, goodsId});
				if(r!=null){
					goods.getList().get(i).put("status", 1);
				}else{
					goods.getList().get(i).put("status", 2);
				}
			}
			
		}
		if(type==IConstant.youhuo){
			String select="select p.id as productId,p.name,p.title,p.price,p.cover_img,ps.status";
			String sql="from kk_product p left join kk_shop_product ps on p.id=ps.product_id where ps.shop_id=?  and p.p_type_id=? and ps.status=1";
			goods=new Goods().paginate(page, IConstant.PAGE_DATA, select, sql,new Object[]{shopId,typeId});
		}
		return goods;
	}
	
	public Page<Goods> goodsList(int type,int page,int typeId,int shopId,String searchItems,int brandId){
		Page<Goods> goods = null;
		String str="";
		if(typeId==0){
			str="and p.p_brand_id=?";
			typeId=brandId;
		}
		if(brandId==0){
			str="and p.p_type_id=?";
		}

		if(type==IConstant.quanbu){
			String select="SELECT p.id as productId,p.name,p.title,p.price,p.cover_img";
			String  sql="FROM kk_product p  WHERE p.id NOT IN ( SELECT ps.product_id FROM kk_shop_product ps WHERE ps.shop_id = ? ) "+str;
			goods=new Goods().paginate(page, IConstant.PAGE_DATA, select, sql, new Object[]{shopId,typeId});
		}
		if(type==IConstant.youhuo){
			String select="select p.id as productId,p.name,p.title,p.price,p.cover_img,ps.status,ps.product_number";
			String sql="from kk_product p left join kk_shop_product ps on p.id=ps.product_id where ps.shop_id=?  and ps.status=1 "+str;
			goods=new Goods().paginate(page, IConstant.PAGE_DATA, select, sql,new Object[]{shopId,typeId});
		}
		return goods;
	}
	
	
	public Map<String,List<Integer>> getGoods(List<Record> goods,int shop_id){
		Map<String,List<Integer>> map=new HashMap<String, List<Integer>>();
		List<Integer> haveGoods=new ArrayList<Integer>();
		List<Integer> noGoods=new ArrayList<Integer>();
		
		for(int i=0;i<goods.size();i++){
			int productId=goods.get(i).getInt("product_id");
			String sql="SELECT * from kk_shop_product where product_id in ("+productId+") and shop_id=? and `status`=1";
			
			Record r= Db.findFirst(sql, new Object[]{shop_id});
			if(r!=null){
				haveGoods.add(productId);
			}
			if(r==null){
				noGoods.add(productId);
			}
		}
		
		map.put("haveGoods", haveGoods);
		map.put("noGoods", noGoods);
		return map;
	}
}
	

