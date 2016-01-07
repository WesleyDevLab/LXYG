package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.aop.ClearInterceptor;
import com.jfinal.aop.ClearLayer;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.platform.model.FBGoods;
import com.lxyg.app.customer.platform.model.Goods;
import com.lxyg.app.customer.platform.model.Manager;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.DateTools;
import com.lxyg.app.customer.platform.util.IConstant;
import com.sun.scenario.effect.impl.sw.sse.SSEBlend_SRC_OUTPeer;
import org.apache.log4j.Logger;
import org.json.JSONException;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * @author Fuen
 * @since 2014-08-07
 */
@ClearInterceptor(ClearLayer.ALL)
public class GoodsController extends Controller {
    private static final Logger log = Logger.getLogger(GoodsController.class);
    private GoodsService goodsService = new GoodsService();
//	
//	private ShopService shopService = new ShopService();
//

    /**
     * 产品管理 -> 产品列表
     */
    public void index() {
        log.info("index");
        int pageSize = IConstant.PAGE_DATA;
        int page = 1;
        String index = getPara("index_search");
        String proName = getPara("proName");
        page = Integer.parseInt(getPara("pg"));
        Manager user = (Manager) getSession().getAttribute("manager");
        if (user == null) {
            render("/login.jsp");
            return;
        }
        Page<Record> goods = null;
        String search = "";
        Object[] obj = new Object[]{};
        if (index.equals("bz")) {
            if (getPara("brandId") != null && getParaToInt("brandId") != 0) {
                search = "and p_brand_id =?";
                obj = new Object[]{getPara("brandId")};
            }
            if (getPara("typeId") != null && getParaToInt("typeId") != 0) {
                search = "and p_type_id =?";
                obj = new Object[]{getPara("typeId")};
            }
            if (getPara("proName") != null && !getPara("proName").equals("")) {
                search = "and name like ?";
                obj = new Object[]{"%" + getPara("proName") + "%"};
            }
            String sql = "FROM kk_product p  where p.hide=1 " + search + " ORDER BY orderno desc";
            goods = Db.paginate(page, pageSize, "select p.* ", sql, obj);
            setAttr("code", 10010);
            setAttr("message", "load成功");
            setAttr("goods", goods);
            renderJson();
            return;
        }

        if (index.equals("fbz")) {
            if (getPara("proName") != null && !getPara("proName").equals("")) {
                search = "and name like ?";
                obj = new Object[]{"%" + getPara("proName") + "%"};
            }
            goods = Db.paginate(page, pageSize, "select pf.* ", "from kk_product_fb pf where 1=1 " + search, obj);
            setAttr("code", 10010);
            setAttr("message", "load成功");
            setAttr("goods", goods);
            renderJson();
            return;
        }

    }


//	
//	/**
//	 * 查看产品详情
//	 */
//	public void view() {
//		int goodsId = 0;
//		if (WebUtils.isNotBlank(getPara("goodsId"))) {
//			goodsId = getParaToInt("goodsId");
//			Goods goods = goodsService.findByID(goodsId);
//			setAttr("goods", goods);
//			render("/shop/goods/view.jsp");
//		} else {
//			render("/shop/index.jsp");
//		}
//	}
//	
//	public void preAdd() {
//		render("/shop/goods/add.jsp");
//	}
//	

    /**
     * 添加产品选择的一些产品属性
     */

    public void loadGoodsAttribute() {
        Object[] o=new Object[]{};
        Object[] o1=new Object[]{};
        String sql = "select pt.id,pt.name,pt.create_time,pt.img,pt.sort_id,pt.is_norm,pt.p_category_id,pc.name as pcName from kk_product_type pt left join kk_product_category pc on pt.p_category_id = pc.id";
        String sql1 = "SELECT pb.id, pb. name, pb.img, pb.p_type_id,pb.p_category_id, pt. NAME AS p_type_name, pc. NAME AS p_category_name FROM kk_product_brand pb LEFT JOIN kk_product_type pt ON pb.p_type_id = pt.id LEFT JOIN kk_product_category pc ON pb.p_category_id = pc.id ";
        String sql2 = "select id,name from kk_product_unit";
        String sql3 = "select id,pay_type_name from kk_pay_type";
        String sql4 = "select id,type,type_name from kk_server";
        String sql5 = "select * from kk_product_category";

        if (isParaExists("typeId")&& getParaToInt("typeId") != 0) {
            sql1 += " where p_type_id=?";
            o=new Object[]{getParaToInt("typeId")};
        }

        if(isParaExists("catId")&&getParaToInt("catId")!=0){
            sql+=" where p_category_id=?";
            o1=new Object[]{getParaToInt("catId")};
        }

        List<Record> type = Db.find(sql,o1);
        List<Record> brand = Db.find(sql1, o);
        List<Record> unit = Db.find(sql2);
        List<Record> payType = Db.find(sql3);
        List<Record> server = Db.find(sql4);
        List<Record> category = Db.find(sql5);
        setAttr("type", type);
        setAttr("brand", brand);
        setAttr("unit", unit);
        setAttr("payType", payType);
        setAttr("server", server);
        setAttr("categorys", category);
        setAttr("code", 10010);
        setAttr("message", "load成功");
        renderJson();
    }

    public void loadBrandByType() {
        int typeId = getParaToInt("typeId");
        String sql1 = "select id,name,img,p_type_id,p_type_name from kk_product_brand where p_type_id=?";
        List<Record> r = Db.find(sql1, new Object[]{typeId});
        setAttr("brands", r);
        setAttr("code", 10002);
        renderJson();
    }

    public void loadTypeByCat() {
        int catId = getParaToInt("catId");
        String sql1 = "select id,name,img from kk_product_type where p_category_id=?";
        List<Record> r = Db.find(sql1, new Object[]{catId});
        setAttr("types", r);
        setAttr("code", 10002);
        renderJson();
    }

    /**
     * 添加产品
     */
    @Before(Tx.class) //事务的支持
    public void add() throws JSONException {
        log.info("add");
        Manager user = (Manager) getSession().getAttribute("manager");
        if (null != user) {
            String cover = getPara("cover");
            if (cover != null && !cover.equals("")) {
                cover = ConfigUtils.getProperty("kaka.qiniu.server") + cover;
            }
            Goods goods = new Goods();
            goods.set("name", getPara("name"));
            goods.set("title", getPara("title"));
            goods.set("price", getPara("price"));
            goods.set("market_price", getPara("marketPrice"));
            goods.set("cash_pay", getPara("cashPay"));
            goods.set("p_category_id",getPara("catId"));
            goods.set("p_category_name",getPara("catName"));
            goods.set("p_type_id", getPara("typeId"));
            goods.set("p_brand_id", getPara("brandId"));
            goods.set("p_type_name", getPara("typeName"));
            goods.set("p_brand_name", getPara("brandName"));
            goods.set("cover_img", cover);
            goods.set("p_unit_id", getPara("unitId"));
            goods.set("p_unit_name", getPara("unitName"));
            goods.set("descripation", getPara("descripation"));
            goods.set("index_show", getPara("isShow"));
            goods.set("server_id", getPara("serverId"));
            goods.set("server_name", getPara("serverName"));
            goods.set("payment", getPara("payment"));
            goods.set("create_time", DateTools.createTime());
            goods.set("code", getPara("code"));
            if (isParaExists("supplier_price")) {
                goods.set("supplier_price", getPara("supplier_price"));
            }
            if (isParaExists("p_number")) {
                goods.set("p_number", getPara("p_number"));
            }
            goods.save();
            Db.update("insert into kk_product_log(p_id,price,market_price,supplier_price,p_number,create_time) values(?,?,?,?,?,?)", goods.getInt("id")
                    , getPara("price"), getPara("marketPrice"), getPara("supplier_price"), getParaToInt("p_number'"), new Date());
            boolean flag = goodsService.save(goods, getPara("imgs"));
            if (flag) {
                setAttr("code", 10010);
                setAttr("message", "添加成功");
                setSessionAttr("index_search", "bz");
                renderJson();
            } else {
                setAttr("code", 10011);
                setAttr("message", "添加失败");
                renderJson();
            }
        } else {
            render("/login.jsp");
        }
    }

    /**
     * 更新产品
     */
    public void updateGoods() {
        Manager user = (Manager) getSession().getAttribute("manager");
        if (user != null) {
            String cover = getPara("cover");
            Goods goods = new Goods().findById(getPara("goodsId"), "id");
            if (cover != null && !cover.equals("")) {
                goods.set("cover_img", cover);
            }
            goods.set("name", getPara("name"));
            goods.set("title", getPara("title"));
            goods.set("price", getParaToInt("price"));
            goods.set("market_price", getParaToInt("marketPrice"));
            goods.set("cash_pay", getParaToInt("cashPay"));
            goods.set("p_category_id", getParaToInt("catId"));
            goods.set("p_type_id", getParaToInt("typeId"));
            goods.set("p_brand_id", getParaToInt("brandId"));
            goods.set("p_category_name", getPara("catName"));
            goods.set("p_type_name", getPara("typeName"));
            goods.set("p_brand_name", getPara("brandName"));
            goods.set("p_unit_id", getParaToInt("unitId"));
            goods.set("p_unit_name", getPara("unitName"));
            goods.set("descripation", getPara("descripation"));
            goods.set("index_show", getParaToInt("isShow"));
            goods.set("server_id", getParaToInt("serverId"));
            goods.set("server_name", getPara("serverName"));
            goods.set("payment", getPara("payment"));
            goods.set("modify_time", DateTools.createTime());
            goods.set("code", getPara("code"));
            boolean flag = goods.update();
            if (flag && getPara("imgs") != null && !getPara("imgs").equals("")) {
                flag = goodsService.save(goods, getPara("imgs"));
            }
            if (flag) {
                setAttr("code", 10010);
                setAttr("message", "修改成功");
//				Db.update("insert into kk_product_log(p_id,price,market_price,supplier_price,p_number,create_time) values(?,?,?,?,?,?)",getPara("goodsId")
//						,getParaToInt("price"),getParaToInt("marketPrice"),getParaToInt("supplier_price"),getParaToInt("p_number'"),new Date());
                renderJson();
                return;
            } else {
                setAttr("code", 10011);
                setAttr("message", "添加失败");
                renderJson();
                return;
            }
        } else {
            render("/login.jsp");
        }
    }

    /**
     * 删除商品
     */
    public void deleteByGoodsId() {
        int goodsId = getParaToInt("goodsId");
        if (Db.deleteById("kk_product", "id", goodsId)) {
            Db.update("delete from kk_product_img where product_id=?", goodsId);
            setAttr("code", 10010);
            setAttr("message", "删除成功");
            renderJson();
        } else {
            setAttr("code", 10011);
            setAttr("message", "删除失败");
            renderJson();
        }
    }

    /**
     * 添加产品类型
     */
    public void addProductType() {
        Manager user = (Manager) getSession().getAttribute("manager");
        String type = getPara("ptype");
        if (user != null) {
            if (type == null || type.equals("")) {
                render("/login.jsp");
            }
            int i = Db.update("insert into kk_product_type(name,create_time,img) values(?,?,?)", new Object[]{type, new Date(), ""});
            if (i > 0) {
                setAttr("code", 10010);
                setAttr("message", "添加成功");
                renderJson();
            } else {
                setAttr("code", 10011);
                setAttr("message", "添加失败");
                renderJson();
            }

        } else {
            render("/login.jsp");
        }

    }


    /**
     * 添加品牌
     */
    public void addProductBrand() {
        Manager user = (Manager) getSession().getAttribute("manager");
        String brand = getPara("brandname");
        int typeId = getParaToInt("typeId");
        String typeName = getPara("typeName");
        if (user != null) {
            if (brand == null || brand.equals("")) {
                render("/login.jsp");
            }
            if (typeId == 0) {
                render("/login.jsp");
            }
            int i = Db.update("insert into kk_product_brand(name,create_time,img,p_type_id,p_type_name) values(?,?,?,?,?)", new Object[]{brand, new Date(), "", typeId, typeName});
            if (i > 0) {
                setAttr("code", 10010);
                setAttr("message", "添加成功");
                renderJson();
            } else {
                setAttr("code", 10011);
                setAttr("message", "添加失败");
                renderJson();
            }
        } else {
            render("/login.jsp");
        }
    }


    /**
     * 删除产品类型
     */
    public void delProductType() {
        Manager user = (Manager) getSession().getAttribute("manager");
        int typeId = getParaToInt("typeId");
        if (user != null) {
            if (typeId != 0) {
                render("/login.jsp");
            }
            int i = Db.update("delete from kk_product_type where id=?", new Object[]{typeId});
            if (i > 0) {
                setAttr("code", 10010);
                setAttr("message", "删除成功");
                renderJson();
            } else {
                setAttr("code", 10011);
                setAttr("message", "删除失败");
                renderJson();
            }
        } else {
            render("/login.jsp");
        }

    }

    /**
     * 删除产品品牌
     */
    public void delProductBrand() {
        Manager user = (Manager) getSession().getAttribute("manager");
        int brandId = getParaToInt("brandId");
        if (user != null) {
            if (brandId != 0) {
                render("/login.jsp");
            }
            int i = Db.update("delete from kk_product_brand where id=?", new Object[]{brandId});
            if (i > 0) {
                setAttr("code", 10010);
                setAttr("message", "删除成功");
                renderJson();
            } else {
                setAttr("code", 10011);
                setAttr("message", "删除失败");
                renderJson();
            }

        } else {
            render("/login.jsp");

        }

    }


    /**
     * 订单管理
     */
    public void orderList() {
        Manager user = (Manager) getSession().getAttribute("manager");

    }

    public void loadProByName() {
        String name = getPara("name");
        int pageSize = IConstant.PAGE_DATA;
        int page = 1;
        String sql = "FROM kk_product p  where p.hide=1 and p.name like ? ORDER BY orderno desc";
        Page<Record> goods = Db.paginate(page, pageSize, "select p.* ", sql, "%" + name + "%");
        setAttr("code", 10010);
        setAttr("message", "load成功");
        setAttr("goods", goods);
        renderJson();
    }


    public void addFBPro() {
        log.info("addNonormPros");
        double price = Double.parseDouble(getPara("price"));
        double market = Double.parseDouble(getPara("marketPrice"));
        double cashPay = Double.parseDouble(getPara("cash_pay"));
        FBGoods r = new FBGoods();
        r.set("name", getPara("name"));
        r.set("title", getPara("title"));
        r.set("price", price);
        r.set("market_price", market);
        r.set("cash_pay", cashPay);
        r.set("cover_img", ConfigUtils.getProperty("kaka.qiniu.server") + getPara("cover_img"));
        r.set("p_unit_name", getPara("unit_name"));
        r.set("descripation", getPara("descripation"));
        r.set("hide", 0);
        r.set("index_show", 1);
        r.set("create_time", new Date());
        r.set("order_no", 1);
        String item = getPara("imgs");
        r.save();
        if (item != null) {
            goodsService.saveFB(r, item);
        }
        setAttr("code", 10010);
        setAttr("msg", "添加成功");
        setSessionAttr("index_search", "fbz");
        renderJson();
    }

    public void updateType() {
        int type_id = getParaToInt("type_id");
        String type_name = getPara("type_name");
        Record record = Db.findFirst("select * from kk_product_type pt where pt.id=?", type_id);
        if(isParaExists("cat_id")){
            record.set("p_category_id", getParaToInt("cat_id"));
        }
        record.set("name", type_name);
        Db.update("kk_product_type", record);
        renderJson("code", 10002);
    }

    public void updateBrand() {
        int brand_id = getParaToInt("brand_id");
        String brand_name = getPara("brand_name");
        Record record = Db.findFirst("select * from kk_product_brand pb where pb.id=?", brand_id);
        record.set("name", brand_name);
        Db.update("kk_product_brand", record);
        renderJson("code", 10002);
    }

//	
//	public void preUpdate() {
//		int goodsId = getParaToInt();
//		Goods goods = goodsService.findByID(goodsId);
//		setAttr("goods", goods);
//		render("/shop/goods/edit.jsp");
//	}
//	
//	/**
//	 * 更新产品信息
//	 */
//	public void update() {
//		Goods goods = goodsService.findByID(getParaToInt("goodsid"));
//		goods.set("goodsname", getPara("goodsname"));
//		goods.set("price", getPara("price"));
//		goods.set("img", getPara("img"));
//		goods.set("note", getPara("note"));
//		goods.set("remark", getPara("remark"));
//		goods.set("pyname", Cn2Spell.converterToSpell(getPara("goodsname")));
//		
//		if(goodsService.updateGoods(goods)) {
//			renderJson("0");
//		} else {
//			renderJson("1");
//		}
//	}
//	
//	/**
//	 * 根据ID批量删除产品
//	 */
//	public void delete() {
//		String goodsId = getPara("goodsId");
//
//		String sql = "select * from hc_user_collect where type=1 and cid=?";//会员收藏产品
//		List<Record> uc = Db.find(sql, goodsId);
//		if(null != uc) {
//			for (Record record : uc) {
//				Db.delete("hc_user_collect", "collectid", record);//删除会员收藏的此产品
//			}
//		}
//		
//		int i = 0;
//		i = goodsService.deleteGoods(goodsId);
//		if(i > 0) {
//			renderJson("0");
//		} else {
//			renderJson("1");
//		}
//	}
//	
//	//////////二期所用
//	/**
//	 * 进入编辑页面
//	 */
//	public void preEdit() {
//		String type = getPara("type");
//		if (type.equals("EDIT")) {
//			int goodsId = getParaToInt("goodsId");
//			Goods goods = goodsService.findByID(goodsId);
//			setAttr("goods", goods);
//		}
//		setAttr("type", type);
//		setAttr("shopId", getPara("shopId"));
//		render("/shopdetail/edit.jsp");
//	}
//	
//	/**
//	 * 编辑商品
//	 */
//	public void edit() {
//		UploadFile file = getFile("img","Img");
//		String type = getPara("type");
//		int isstint = getParaToInt("isstint");
//		Goods goods = null;
//		if (type.equals("EDIT")) {
//			int goodsId = getParaToInt("goodsId");
//			goods = goodsService.findByID(goodsId);
//			if(null != file) {
//				String name = WebUtils.uuid().substring(0, 8);
//				String filename = DateTools.nowTime().concat(name) + file.getFileName().substring(file.getFileName().lastIndexOf("."));
//				file.getFile().renameTo(new File(ConfigUtils.getProperty("file.path") + "Img/" + filename));
//				goods.set("img", "Img/" + filename);
//			}
//			goods.set("goodsname", getPara("goodsname"));
//			goods.set("marketprice", getPara("marketprice"));
//			goods.set("isstint", isstint);
//			if (isstint == 1) {
//				goods.set("quaeach", getPara("quaeach"));
//			}
//			goods.set("instock", getPara("instock"));
//			goods.set("price", getPara("price"));
//			goods.set("memberprice", getPara("memberprice"));
//			goods.set("note", getPara("note"));
//			goods.set("remark", getPara("remark"));
//			if(goodsService.updateGoods(goods)) {
//				renderJson("0");
//			} else {
//				renderJson("1");
//			}
//		} else {
//			goods = new Goods();
//			if(null != file) {
//				String name = WebUtils.uuid().substring(0, 8);
//				String filename = DateTools.nowTime().concat(name) + file.getFileName().substring(file.getFileName().lastIndexOf("."));
//				file.getFile().renameTo(new File(ConfigUtils.getProperty("file.path") + "Img/" + filename));
//				goods.set("img", "Img/" + filename);
//			}
//			goods.set("shopid", getPara("shopId"));
//			goods.set("goodsname", getPara("goodsname"));
//			goods.set("marketprice", getPara("marketprice"));
//			goods.set("price", getPara("price"));
//			goods.set("memberprice", getPara("memberprice"));
//			goods.set("isstint", isstint);
//			if (isstint == 1) {
//				goods.set("quaeach", getPara("quaeach"));
//			}
//			goods.set("instock", getPara("instock"));
//			goods.set("note", getPara("note"));
//			goods.set("remark", getPara("remark"));
//			goods.set("createtime", DateTools.createTime());
//			if(goodsService.addGoods(goods)) {
//				renderJson("0");
//			} else {
//				renderJson("1");
//			}
//		}
//	}
//	


}
