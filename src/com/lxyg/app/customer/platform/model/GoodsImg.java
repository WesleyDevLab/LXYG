package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Model;

public class GoodsImg extends Model<GoodsImg> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final GoodsImg dao=new GoodsImg();
	
	public Goods getGoods(){
		return Goods.dao.findById(get("product_id"));
	}

}
