
package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.ActionKey;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Page;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.alipay.util.UtilDate;
import com.lxyg.app.customer.platform.JPush.JPushKit;
import com.lxyg.app.customer.platform.Queue.orderQueue;
import com.lxyg.app.customer.platform.interceptor.loginInterceptor;
import com.lxyg.app.customer.platform.model.*;
import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.service.GoodsService;
import com.lxyg.app.customer.platform.service.OrderService;
import com.lxyg.app.customer.platform.weiapiUtil.WXUtil;
import com.lxyg.app.customer.platform.util.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.*;
import java.util.concurrent.ExecutionException;

@Before(loginInterceptor.class)
public class AppController extends Controller {
	private static final Logger log = Logger.getLogger(AppController.class);
	private GoodsService goodService = new GoodsService();
	private OrderService orderService = new OrderService();

	public void renderSuccess(String value, Object o) {
		setAttr("code", 10002);
		setAttr("msg", value);
		if (o == null) {
			setAttr("data", new JSONObject());
		} else {
			setAttr("data", o);
		}
		renderJson();
		return;
	}

	public void renderFaile(String value) {
		setAttr("code", 10001);
		setAttr("msg", value);
		renderJson();
		return;
	}

	public int checkUUID() {
		log.info("checkUUID");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);
		String uid = json.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		if (s != null) {
			return s.getInt("id");
		} else {
			return 0;
		}
	}

	/**
	 * @Author qin
	 * app B端更新
	 **/
	public void appUpdate() {
		log.info("appUpdate");
		JSONObject json = JSONObject.fromObject(getPara("info"));
		String app = json.getString("app");
		Record r = Db.findFirst("select * from kk_app where app like ?  ", new Object[]{app});
		renderSuccess("需要更新", r);
	}


	/**
	 * 商户登录
	 **/
	public void login() {
		log.info("login");
		String info = getPara("info");
		JSONObject JB = JSONObject.fromObject(info);
		String phone = JB.getString("phone");
		String password = JB.getString("password");

		if (RegularUtil.isMobileNO(phone) && WebUtils.isNotBlank(password)) {
			Shop shop = new Shop().findFirst("select id as shopId,name,link_man,phone,full_address,cover_img,uuid,q_verifi,shop_type,is_norm,server_id from kk_shop s where s.phone=? and s.password=?", new Object[]{phone, password});
			if (shop != null) {
				/**
				 * 登录检查app版本
				 * **/
				if (JB.containsKey("version")) {
					String version = JB.getString("version");
					shop.set("id", shop.getInt("shopId"));
					shop.set("login_" + version, 1);
					shop.update();
				}
				renderSuccess("登陆成功", shop);
				return;
			} else {
				renderJson(M.FAILE("10001", "登录失败"));
				return;
			}
		} else {
			renderJson(M.FAILE("10001", "登录失败"));
			return;
		}
	}


	/**
	 * 发送验证码
	 **/

	public void messageCode() {
		log.info("messageCode");
		String info = getPara("info");
		JSONObject JB = JSONObject.fromObject(info);
		String phone = JB.getString("phone");
		if (!RegularUtil.isMobileNO(phone)) {
			setAttr("code", 10001);
			setAttr("msg", "手机号码有误！");
			renderJson();
		}

		List<Record> lists = Db.find("select * from kk_reg where phone = ?", new Object[]{phone});
		String sql = "";
		Object[] obj = new Object[]{};
		String code = RegularUtil.gen();
		if (lists.size() == 0) {
			sql = "insert into kk_reg(phone,password,code,create_time) values(?,?,?,?)";
			obj = new Object[]{phone, "", code, new Date()};
		} else {
			sql = "update kk_reg set code=?,password=?,create_time=? where phone=?";
			obj = new Object[]{code, "", new Date(), phone};
		}
		boolean b = SdkMessage.send(phone, code);
		if (b) {
			int i = Db.update(sql, obj);
			if (i > 0) {
				JSONObject o = new JSONObject();
				o.put("code", code);
				renderSuccess("获取验证码成功", o);
				return;
			} else {
				renderJson(M.FAILE("10001", "添加失败"));
				return;
			}
		} else {
			renderJson(M.FAILE("10001", "验证码错误"));
			return;
		}
	}

	/**
	 * @author M
	 * 忘记密码
	 */
	public void resetPassword() {
		log.info("resetPassword");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);

		String phone = json.getString("phone");
		String password = json.getString("password");
		String code = json.getString("code");
		if (!RegularUtil.isMobileNO(phone)) {
			setAttr("code", 10001);
			setAttr("msg", "手机号码有误！");
			renderJson();
		}
		List<Shop> shops = Shop.dao.find("select * from kk_shop s where phone=?", phone);
		if (shops.size() == 0) {
			renderFaile("该账号未注册");
			return;
		}
		List<Record> lists = Db.find("select * from kk_reg where phone = ? and code=?", new Object[]{phone, code});
		if (lists.size() == 0) {
			renderFaile("验证码错误");
			return;
		}
		if (RegularUtil.isMobileNO(phone) && WebUtils.isNotBlank(password)) {
			Shop s = new Shop().findFirst("select * from kk_shop s where s.phone=?", new Object[]{phone});
			s.set("password", password);
			s.update();
			renderSuccess("修改成功", s);
			return;
		} else {
			renderFaile("手机号或者密码为空");
		}
	}


	/**
	 * 商户注册
	 **/
	public void register() {
		log.info("register");
		String info = getPara("info");
		JSONObject JB = JSONObject.fromObject(info);
		String phone = JB.getString("phone");
		String code = JB.getString("code");
		String password = JB.getString("password");
		Record r = Db.findFirst("select * from kk_reg r where r.phone=?", new Object[]{phone});
		String scode = r.get("code");
		Date d = r.getDate("create_time");
		Date now = new Date();
		long T = now.getTime() - d.getTime();
		if (T > 1800000) {
			setAttr("code", 10001);
			setAttr("msg", "验证码超时");
			renderJson();
			return;
		}
		if (!code.equals(scode)) {
			renderJson(M.FAILE("10001", "注册码错误"));
			return;
		}
		if (r.get("password").equals("")) {
			int id = r.getInt("id");
			int i = Db.update("update kk_reg r set password =? where id=?", new Object[]{password, id});
			if (i > 0) {
				renderSuccess("获取验证码成功", null);
				return;
			} else {
				renderJson(M.FAILE("10001", "注册失败"));
				return;
			}
		} else {
			renderJson(M.FAILE("10001", "已经注册过！"));
			return;
		}
	}


	/**
	 * B端 判断是否注册过
	 **/
	public void isExists() {
		log.info("isExists");
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String phone = obj.getString("phone");
		Shop s = new Shop().findFirst("select count(s.id) as num from kk_shop s where s.phone=? ", new Object[]{phone});
		if (s.getLong("num") != 0) {
			renderFaile("该手机号已经注册过");
			return;
		}
		messageCode();
	}


	/**
	 * 商户密码修改
	 **/
	public void updatePassword() {
		log.info("updatePassword");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String suid = obj.getString("uid");
		String password = obj.getString("password");
		Shop s = Shop.dao.findBysuid(suid);
		if (s != null) {
			s.set("password", password);
			s.update();
			renderSuccess("修改成功", s);
			return;
		} else {
			renderFaile("异常！");
		}
	}

	/**
	 * @author M
	 * 商户信息添加 商户注册
	 */
	@Before(Tx.class)
	public void addShopInfo() {
		log.info("addShopInfo");
		String info = getPara("info");
		JSONObject obj = JSONObject.fromObject(info);
		Map<String, Object> m = new HashMap<String, Object>();
		String name = "";
		String password = "";
		String concact = "";
		String phone = "";
		String fullAddress = "";
		double lat = 0.0;
		double lng = 0.0;
		String street = "";
		String provinceName = "";
		String cityName = "";
		String areaName = "";
		int templeId = 0;
		String coverImg = "";
		int mId = 0;
		if (obj.containsKey("name")) {
			name = obj.getString("name");
			m.put("name", name);
		}
		if (obj.containsKey("title")) {
			m.put("title", obj.getString("title"));
		}

		if(obj.containsKey("service_phone")){
			m.put("service_phone", obj.getInt("service_phone"));
		}

		if (obj.containsKey("shop_type")) {
			m.put("shop_type", obj.getInt("shop_type"));
			Record record = Db.findById("kk_shop_type", obj.getInt("shop_type"));
			if (record != null) {
				m.put("is_norm", record.getInt("is_norm"));
			}
		}

		if (obj.containsKey("password")) {
			password = obj.getString("password");
			m.put("password", password);
		}
		if (obj.containsKey("concact")) {
			concact = obj.getString("concact");
			m.put("link_man", concact);
		}
		if (obj.containsKey("phone")) {
			phone = obj.getString("phone");
			Shop s = new Shop().findFirst("select count(s.id) as num from kk_shop s where s.phone=? ", new Object[]{phone});
			if (s.getLong("num") != 0) {
				renderFaile("该手机号已经注册过");
				return;
			}
			m.put("phone", phone);
		}
		if (obj.containsKey("fulladdress")) {
			fullAddress = obj.getString("fulladdress");
			m.put("full_address", fullAddress);
		}
		if (obj.containsKey("lat")) {
			lat = obj.getDouble("lat");
			m.put("lat", lat);
		}
		if (obj.containsKey("lng")) {
			lng = obj.getDouble("lng");
			m.put("lng", lng);
		}

		if (obj.containsKey("street")) {
			street = obj.getString("street");
			m.put("street", street);
		}
		if (obj.containsKey("provinceName")) {
			provinceName = obj.getString("provinceName");
			Record r = Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + provinceName + "%"});
			m.put("province_id", r.get("code"));
			m.put("province_name", provinceName);
		}
		if (obj.containsKey("cityName")) {
			cityName = obj.getString("cityName");
			Record r = Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + cityName + "%"});
			m.put("city_id", r.get("code"));
			m.put("city_name", cityName);
		}
		if (obj.containsKey("areaName")) {
			areaName = obj.getString("areaName");
			Record r = Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + areaName + "%"});
			m.put("area_id", r.get("code"));
			m.put("area_name", areaName);
		}
		if (obj.containsKey("templeId")) {
			templeId = obj.getInt("templeId");
			m.put("temple_id", templeId);
		}
		if (obj.containsKey("cover_img")) {
			if (!obj.getString("cover_img").startsWith(ConfigUtils.getProperty("kaka.qiniu.server"))) {
				coverImg = ConfigUtils.getProperty("kaka.qiniu.server") + obj.getString("cover_img");
			} else {
				coverImg = obj.getString("cover_img");
			}
			m.put("cover_img", coverImg);
		}
		if (obj.containsKey("mId")) {
			mId = obj.getInt("mId");
			m.put("m_id", mId);
		}
		if (obj.containsKey("districtId")) {
			m.put("district_id", obj.getInt("districtId"));
		}
		if (obj.containsKey("scope")) {
			String str = "{scope:" + obj.getString("scope") + "}";
			m.put("scope", str);
		}

//		Shop shop=new Shop().findFirst("select * from kk_shop where phone like ?", new Object[]{phone});
//		if(shop!=null){
//			setAttr("code", 10001);
//			setAttr("msg", "该手机号已存在");
//			renderJson();
//			return;
//		}

		m.put("create_time", new Date());
		m.put("q_verifi", -1);
		UUID UID = UUID.randomUUID();
		String uuid = UID.toString().replace("-", "").substring(0, 16);
		m.put("uuid", uuid);

		m.put("ewm_code", M.getCoe(uuid));
		Shop s = new Shop();
		s.remove("id");
		s.setAttrs(m);
		s.save();
		new Shop().createBalance(s.getStr("uuid"), null, null);
		setAttr("data", s);
		setAttr("code", 10002);
		setAttr("msg", "上传成功");
		renderJson();
	}


	/**
	 * 店铺资质认证
	 **/
	public void addShopIdenti() {
		log.info("addShopIdenti");
		String info = getPara("info");
		JSONObject obj = JSONObject.fromObject(info);
		String uid = obj.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		String userName = "";
		String idNum = "";
		String handlerImg = "";
		String idImg = "";
		String bankName = "";
		String branchName = "";
		String bandCardNum = "";
		String bankImg = "";
		String bussinessImg = "";
		String bussinessNum = "";
		String coverImg = "";
		int shopId = 0;
		String bankProvince = "";
		String bankCity = "";

		shopId = s.getInt("id");
		if (obj.containsKey("userName")) {
			userName = obj.getString("userName");
		}
		if (obj.containsKey("idNum")) {
			idNum = obj.getString("idNum");
		}
		if (obj.containsKey("bankName")) {
			bankName = obj.getString("bankName");
		}
		if (obj.containsKey("branchName")) {
			branchName = obj.getString("branchName");
		}
		if (obj.containsKey("bankCardNum")) {
			bandCardNum = obj.getString("bankCardNum");
		}
		if (obj.containsKey("handlerImg")) {
			handlerImg = RegularUtil.retIMGURL(obj.getString("handlerImg"));
		}
		if (obj.containsKey("idImg")) {
			idImg = RegularUtil.retIMGURL(obj.getString("idImg"));
		}
		if (obj.containsKey("bankImg")) {
			bankImg = RegularUtil.retIMGURL(obj.getString("bankImg"));
		}
		if (obj.containsKey("bussinessImg")) {
			bussinessImg = RegularUtil.retIMGURL(obj.getString("bussinessImg"));
		}
		if (obj.containsKey("coverImg")) {
			coverImg = RegularUtil.retIMGURL(obj.getString("coverImg"));
		}
		if (obj.containsKey("bussinessNum")) {
			bussinessNum = obj.getString("bussinessNum");
		}
		if (obj.containsKey("bankProvince")) {
			bankProvince = obj.getString("bankProvince");
		}
		if (obj.containsKey("bankCity")) {
			bankCity = obj.getString("bankCity");
		}
		int i = Db.update("insert into kk_shop_identi(shop_id,user_name,phone,id_number,bank_name,bank_branch_name,bank_card_num,handle_id_img," +
				"id_num_img,bank_card_img,bussiness_num_img,cover_img,create_time,bussiness_number,bank_branch_province,bank_branch_city) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", new Object[]{shopId, userName, "18025698814",
				idNum, bankName, branchName, bandCardNum, handlerImg, idImg, bankImg, bussinessImg, coverImg, new Date(), bussinessNum, bankProvince, bankCity});

		if (i > 0) {
			s.set("q_verifi", 1);
			s.update();
			s.updateBalance(uid, bankName, bandCardNum);
			setAttr("code", 10002);
			setAttr("msg", "添加成功");
			setAttr("data", new JSONObject());
		} else {
			setAttr("code", 10001);
			setAttr("msg", "添加失败");
		}
		renderJson();
	}

	/**
	 * @author M
	 * 获取商户信息
	 **/
	public void loadShopInfo() {
		log.info("loadShopInfo");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);
		if(!json.containsKey("uid")){
			renderFaile("uid参数异常");
			return;
		}
		String uid = json.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		if (s != null) {
			s = s.findFirst("select s.id as shopId,s.name,s.link_man,s.phone,s.full_address,s.city_name,s.province_name,s.area_name,s.street,s.cover_img,s.is_norm,s.create_time,s.uuid,s.q_verifi,s.ewm_code,s.service_phone,si.user_name," +
					"si.id_number,si.bank_name,si.bank_branch_name,si.handle_id_img,si.id_num_img,si.bank_card_img,si.bussiness_num_img," +
					"si.bussiness_number,si.bank_branch_province,si.bank_branch_city,si.bank_card_num from kk_shop s left join kk_shop_identi si on s.id=si.shop_id where s.uuid=?", new Object[]{uid});
			setAttr("code", 10002);
			setAttr("msg", "load成功");
			setAttr("data", s);
			renderJson();
		} else {
			renderJson(M.FAILE("10001", "uuid错误"));
		}
	}


	/**
	 * @author M
	 * 获取分类下已上架的产品个数
	 **/
	public void showCatagoryList() {
		log.info("showCatagoryList");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);
		String uid = json.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		if (s != null) {
			List<Record> res = goodService.categoryNum(s.getInt("id"));
			setAttr("data", res);
			setAttr("code", 10002);
			setAttr("msg", "成功");
			renderJson();
			return;
		} else {
			renderJson(M.FAILE("10001", "uid 错误"));
			return;
		}
	}

	/**
	 * @author M
	 * 货品列表信息展示
	 */
	public void showProductList() {
		log.info("showProductList");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);
		String uid = json.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		if (s != null) {
			int cid = json.getInt("typeId");
			int type = json.getInt("type");
			int page = json.getInt("pg");
			Page<Goods> goods = new Goods().goods(type, page, cid, s.getInt("id"), "");
			renderSuccess("成功", goods);
		} else {
			renderFaile("uuid 错误");
			return;
		}
	}

	/**
	 * @author M
	 * 货品列表信息展示
	 */
	public void showGoodsList() {
		log.info("showGoodsList");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);
		if(!json.containsKey("uid")){
			renderFaile("uid参数异常");
			return;
		}
		String uid = json.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		if (s != null) {
			int cid = json.getInt("typeId");
			int type = json.getInt("type");
			int page = json.getInt("pg");
			int brandId = 0;
			if (json.containsKey("brandId")) {
				brandId = json.getInt("brandId");
			}
			Page<Goods> goods = new Goods().goodsList(type, page, cid, s.getInt("id"), "", brandId);
			renderSuccess("添加成功", goods);
		} else {
			renderFaile("uuid 错误");
			return;
		}
	}

	/**
	 * @author M
	 * 商品详细信息
	 */
	public void showProductInfo() {
		log.info("showProductInfo");
		String info = getPara("info");
		JSONObject json = JSONObject.fromObject(info);
		String uid = json.getString("uid");
		Shop s = new Shop().findFirst("select * from kk_shop where uuid=?", new Object[]{uid});
		if (s != null) {
			int productId = json.getInt("productId");
			Goods g = new Goods().findById(productId);
			renderSuccess("添加成功", g);
		} else {
			renderFaile("uuid 错误");
			return;
		}
	}

	/**
	 * @author M
	 * 商品详细信息
	 */
	@Before(Tx.class)
	public void addProducts() {
		log.info("addProduct");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String pids = obj.getString("pids");
		String[] str = pids.split(",");
		for (int i = 0; i < str.length; i++) {
			int pid = Integer.valueOf(str[i]);
			Record r = Db.findFirst("select count(id) as num from kk_shop_product ps where product_id=? and shop_id=?", new Object[]{pid, sid});
			if (r.getLong("num") == 0) {
				Db.update(
						"insert into kk_shop_product(product_id,shop_id,status,create_time,product_number) "
								+ "values(?,?,?,?,?)", new Object[]{pid, sid, 1,
								new Date(), 0});
			} else {
				Db.update("delete from  kk_shop_product where shop_id =? and product_id =?", new Object[]{sid, pid});
			}
		}
		renderSuccess("添加成功", null);
	}


	/**
	 * @author M
	 * 商品详细信息
	 * 上货  下货
	 */
	@Before(Tx.class)
	public void repertory() {
		log.info("addProduct");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		int product_number = 0;
		if (obj.containsKey("product_number")) {
			product_number = obj.getInt("product_number");
		}
		String pids = obj.getString("pids");
		int type = obj.getInt("type");
		String[] str = pids.split(",");
		for (int i = 0; i < str.length; i++) {
			int pid = Integer.valueOf(str[i]);
			Record r = Db.findFirst("select count(id) as num ,ps.id from kk_shop_product ps where product_id=? and shop_id=?", new Object[]{pid, sid});
			switch (type) {
				case 1:
					if (r.getLong("num") == 0) {
						Db.update("insert into kk_shop_product(product_id,shop_id,status,create_time,product_number) values(?,?,?,?,?)", new Object[]{pid, sid, 1, new Date(), product_number});
						Goods goods = Goods.dao.findById(pid);
						int type_id = goods.getInt("p_type_id");
						Record record = Db.findFirst("SELECT * from kk_shop_type st where st.s_id=?", sid);
						if (record == null) {
							Db.update("insert into kk_shop_type(name,title,imgs,sort,is_norm,s_id) values(?,?,?,?,?,?)", "", "", "", type_id, 1, sid);
						} else {
							String tyStr = record.getStr("sort");
							if (!tyStr.contains("" + type_id)) {
								record.set("sort", tyStr + "," + type_id);
								Db.update("kk_shop_type", record);
							}
						}
					}
					break;
				case 2:
					if (r.getLong("num") != 0) {
						r.set("id", r.getInt("id"));
						Db.delete("kk_shop_product", r);
					}
					break;
			}
		}
		renderSuccess("修改成功", null);
	}

	/**
	 * @author M
	 * 修改库存接口
	 */
	public void modifyProductNum() {
		log.info("modifyProductNum");
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		if (!obj.containsKey("s_uid") || !obj.containsKey("p_id")) {
			renderFaile("提交数据异常");
			return;
		}
		Shop s = Shop.dao.findBysuid(obj.getString("s_uid"));
		if (s == null) {
			renderFaile("提交数据异常");
			return;
		}
		int product_id = obj.getInt("p_id");
		int num = obj.getInt("p_num");
		int b = Db.update("update kk_shop_product set product_number=? where product_id=? and shop_id=?", num, product_id, s.getInt("id"));
		if (b <= 0) {
			renderFaile("修改失败");
			return;
		}
		renderSuccess("修改成功", null);
	}

	/**
	 * @author M
	 * 查看库存接口
	 */
	public void checkProductNum() {
		log.info("checkProductNum");
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		if (!obj.containsKey("s_uid")) {
			renderFaile("提交数据异常");
			return;
		}
		int page = 1;
		if (obj.containsKey("pg")) {
			page = obj.getInt("page");
		}
		Page<Goods> goodsPage = null;
		String select = "SELECT p.id AS productId, p. name, p.title, p.price, p.p_type_id, p.p_brand_id, p.p_type_name, p.p_brand_name, p.cover_img, p.p_unit_id, p.p_unit_name, p.descripation, p.hide, p.index_show, p.server_id, p.server_name, p.payment, p.cash_pay, p.market_price, ps.product_number";
		String left = "FROM kk_product p LEFT JOIN kk_shop_product ps ON p.id = ps.product_id LEFT JOIN kk_shop s on ps.shop_id=s.id ";
		if (obj.containsKey("p_id") && obj.getInt("p_id") != 0) {
			goodsPage = Goods.dao.paginate(page, IConstant.PAGE_DATA, select,
					left + " WHERE p.id = ? AND s.uuid = ?", obj.getInt("p_id"), obj.getString("s_uid"));
		}
		if (obj.containsKey("brand_id") && obj.getInt("brand_id") != 0) {
			goodsPage = Goods.dao.paginate(page, IConstant.PAGE_DATA, select,
					left +
							"WHERE p.p_brand_id = ? AND s.uuid =?", obj.getInt("brand_id"), obj.getString("s_uid"));
		}
		if (obj.containsKey("is_low") && obj.getInt("is_low") != 0) {
			goodsPage = Goods.dao.paginate(page, IConstant.PAGE_DATA, select, left + "WHERE ps.product_number <=? AND s.uuid =?", IConstant.low, obj.getString("s_uid"));
		}
		renderSuccess("获取成功", goodsPage);
	}


	/**
	 * @author M
	 * 商户订单
	 */
	public void orderByStatus() {
		log.info("orderByStatus");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		int status = obj.getInt("orderStatus");
		String uid = obj.getString("uid");

		int page = 1;
		if(obj.containsKey("pg")&&obj.getInt("pg")>0){
			page=obj.getInt("pg");
		}
		Page<Order> o = null;//普通订单
//		Page<OrderActivity> recordPage = null;//活动订单
		if (status == 1) {
			o = orderService.loadOrderByStatus(IConstant.OrderStatus.order_status_chushi, uid, page);
//			recordPage = orderService.getActivityOrders(IConstant.OrderStatus.order_status_chushi, uid, page);
		} else if (status == 5) {
			o = orderService.loadOrderByStatus(5, uid, page);
//			recordPage = orderService.getActivityOrders(IConstant.OrderStatus.order_status_js, uid, page);
		} else {
			o = orderService.loadOrderByStatus(status, uid, page);
//			recordPage = orderService.getActivityOrders(status, uid, page);
		}
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("order", o);
//		map.put("orderActivity", recordPage);
		renderSuccess("获取成功", map);
	}

	/**
	 * @author M
	 * 商家 发货
	 */
	public void updateOrderStatus() {
		log.info("updateOrderStatus");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject json = JSONObject.fromObject(getPara("info"));
		String orderId = json.getString("orderId");
		int status = json.getInt("orderStatus");
		//int bussinessCode=json.getInt("code");
		if (orderId == null || orderId.equals("")) {
			renderFaile("订单错误");
			return;
		}
		Order o = new Order().findByStatus(orderId, status);
		if (o == null) {
			renderFaile("订单错误");
			return;
		}
		if (o.getInt("order_status") >= 4) {
			renderFaile("异常");
			return;
		}
		o.set("id", o.getInt("orderId"));
		orderService.updateOrderStatus(o, json);
		renderSuccess("成功", null);
	}

//	/**
//	 * @author M
//	 * 商户让单
//	 */
//	@Before(Tx.class)
//	public void letOrderGo() {
//		log.info("letOrderGo");
//		int sid = checkUUID();
//		if (sid == 0) {
//			renderFaile("uuid 错误");
//			return;
//		}
//		JSONObject obj = JSONObject.fromObject(getPara("info"));
//		String uid = obj.getString("uid");
//		String orderId = obj.getString("orderId");
//
//		List<Record> re = Db.find("select * from kk_order_cache where order_id=? and u_uuid=?", new Object[]{orderId, uid});
//		if (re.size() != 0) {
//			renderFaile("已经让单");
//			return;
//		}
//		Order o = new Order().findById(false, orderId);
//		if (o.getInt("order_status") != IConstant.OrderStatus.order_status_dfh) {
//			renderFaile("订单异常");
//			return;
//		}
//		if (o != null) {
//			List<Record> rs = o.get("orderItems");
//			Double lat = o.getDouble("lat");
//			Double lng = o.getDouble("lng");
//			if (rs == null || rs.size() == 0) {
//				renderFaile("订单异常");
//				return;
//			}
//			String str = "";
//			for (int i = 0; i < rs.size(); i++) {
//				str += "" + rs.get(i).getInt("product_id") + ",";
//			}
//			str = str.substring(0, str.length() - 1);
//			List<Shop> allShops = new ArrayList<Shop>();
//			if (o.getInt("send_type") == 1) {
//				allShops = new Shop().findShopByProductRecordDis(rs, lng, lat, o.getStr("shop_id"));
//			} else {
//				allShops = new Shop().findShopByProductRecord(rs, lng, lat, o.getStr("shop_id"));
//			}
//			if (allShops.size() == 0) {
//				new Order().createOrder(RegularUtil.getIntArray(str.split(",")), o.getStr("order_id"),
//						"",
//						IConstant.OrderStatus.order_status_ld);
//				o.set("id", o.getInt("orderId"));
//				o.set("order_status", IConstant.OrderStatus.order_status_ld);
//				o.update();
//				renderSuccess("流单", null);
//				return;
//			} else {
//				String[] strA = str.split(",");
//				String[] strB = RegularUtil.unionMore(allShops);
//				String[] res_pro = RegularUtil.minus(strA, strB);//缺失的产品
//				if (res_pro.length != 0) {
//					//缺失的产品流单
//					new Order().createOrder(RegularUtil.getIntArray(res_pro), o.getStr("order_id"),
//							"",
//							IConstant.OrderStatus.order_status_ld);
//				}
//
//				List<Integer> pros = new ArrayList<Integer>();
//				for (Shop s : allShops) {
//
//					List<Integer> pIds = RegularUtil.getIntArray(s.getStr("pros").split(","));
//					pIds = RegularUtil.minus(pros, pIds);
//					if (pIds.size() == 0) {
//						continue;
//					}
//
//					Order nOrder = new Order().createOrder(pIds, orderId, "",
//							IConstant.OrderStatus.order_status_kqd);
//					List<Record> ors = nOrder.get("orderItems");
//
//					new OrderCache().save(s.getStr("s_uid"), nOrder.getStr("order_id"),
//							ors, lat, lng, o.getStr("send_name"));
//					new JPush(IConstant.Title, IConstant.content_order,
//							s.getStr("phone"), IConstant.PUSH_ONE, M.pushMap(
//							nOrder.getStr("order_id"),
//							IConstant.OrderStatus.order_status_kqd), "shop").start();
//					pros.addAll(pIds);
//
//				}
//				o.set("id", o.getInt("orderId"));
//				o.set("order_status", IConstant.OrderStatus.order_status_rd);
//				o.set("let_order_time", new Date());
//				o.update();
//				renderSuccess("让单成功", null);
//				return;
//			}
//		}
//	}

	/**
	 * @author M
	 * 订单管理 各个不同订单状态的个数说
	 */
	public void manageOrder() {
		log.info("manageOrder");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String uid = obj.getString("uid");
		Record r = new Order().loadOrderNum(uid);
		renderSuccess("获取成功", r);
	}

	/**
	 * @author M
	 * 商家抢单
	 */
	@Before(Tx.class)
	public void robOrder() {
		log.info("robOrder");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String uid = obj.getString("uid");
		String orderId = obj.getString("orderId");

		Record re = Db.findFirst("select * from kk_order_cache where u_uuid=? and order_id=? ", new Object[]{uid, orderId});
		if (re.getInt("status") != 1) {
			renderFaile("已经被抢");
			return;
		}
		Order o = new Order().findById(false, orderId);
		if (o.getStr("shop_id") != null && !o.getStr("shop_id").equals("")) {
			renderFaile("抢单异常");
			return;
		}

		String orginOrderId = o.getStr("original_order_id");
		if (orginOrderId == null || orginOrderId.equals("")) {
			renderFaile("--异常");
			return;
		}

		List<Record> rs = o.get("orderItems");
		String str = "";
		for (int i = 0; i < rs.size(); i++) {
			str += "" + rs.get(i).getInt("product_id") + ",";
		}
		str = str.substring(0, str.length() - 1);
		o.set("id", o.getInt("orderId"));
		o.set("s_uuid", uid);
		o.set("is_rob", 2);
		o.set("order_status", IConstant.OrderStatus.order_status_dfh);
		o.update();
		Db.update("update kk_order_cache set status=? where order_id=?", new Object[]{2, orderId});
		new Order().createLog(orderId, IConstant.orderAction.order_action_newOrder, o.getStr("send_name"), str, null, o.getStr("order_id"), IConstant.OrderStatus.order_status_dfh, uid);
		renderSuccess("成功", null);
	}

	/**
	 * @author M
	 * 订单详细信息
	 */
	public void orderInfo() {
		log.info("orderInfo");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String orderId = obj.getString("orderId");
		Order o = new Order().findById(false, orderId);
		renderSuccess("或许订单信息成功", o);
	}

	/**
	 * @author M
	 * 账户管理
	 */
	public void accountManager() {
		log.info("accountManager");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shopId = obj.getString("uid");

		Calendar cl = Calendar.getInstance();
		cl = M.getBeforeDay(cl.getTime());
		String time = M.printCalendar(cl);
		Map<String, Object> m = new HashMap<String, Object>();
		String sql = "SELECT ( SELECT IFNULL(sum(in_come), 0) FROM kk_shop_balance_log  WHERE balance_type = 1 AND create_time like ? and s_uid = ?) AS YS, ( SELECT IFNULL(sum(in_come), 0) FROM kk_shop_balance_log WHERE balance_type = 2 AND create_time like ? and s_uid = ?) AS ROB, ( SELECT IFNULL(sum(expend), 0) FROM kk_shop_balance_log WHERE balance_type = 3 AND create_time like ? and s_uid = ?) AS LET, ( SELECT IFNULL(sum(expend), 0) FROM kk_shop_balance_log WHERE balance_type = 4 AND create_time like ? and s_uid = ?) AS TX ";
		Record r = Db.findFirst(sql, new Object[]{"%" + time + "%", shopId, "%" + time + "%", shopId, "%" + time + "%", shopId, "%" + time + "%", shopId});

		String sql1 = "SELECT ( SELECT IFNULL(sum(in_come), 0) FROM kk_shop_balance_log WHERE balance_type = 1  and s_uid = ? ) AS YS, ( SELECT IFNULL(sum(in_come), 0) FROM kk_shop_balance_log WHERE balance_type = 2 and s_uid = ?) AS LET, ( SELECT IFNULL(sum(expend), 0) FROM kk_shop_balance_log WHERE balance_type = 3 and s_uid = ?) AS ROB, ( SELECT IFNULL(sum(expend), 0) FROM kk_shop_balance_log WHERE balance_type = 4 and s_uid = ?) AS TX ";
		Record r1 = Db.findFirst(sql1, new Object[]{shopId, shopId, shopId, shopId});

		String sql2 = "select balance from  kk_shop_balance where s_uid = ?";
		Record r2 = Db.findFirst(sql2, new Object[]{shopId});
		m.put("yesterday", r);
		m.put("all", r1);
		if (r2 == null) {
			m.put("balance", 0);
		} else {
			m.put("balance", r2.getInt("balance"));
		}
		renderSuccess("获取成功", m);
	}

	/**
	 * @author M
	 * homePage
	 */
	public void Home() {
		log.info("Home");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shopId = obj.getString("uid");

		Map<String, Object> m = new HashMap<String, Object>();

		Calendar cl = Calendar.getInstance();
		cl = M.getBeforeDay(cl.getTime());
		String time = M.printCalendar(cl);

		String accountSql = "SELECT IFNULL(( SELECT sum(in_come) FROM kk_shop_balance_log bl WHERE bl.s_uid =? AND bl.create_time =? and bl.balance_type!=5 ),0) AS YS, " +
				"IFNULL(( SELECT sum(in_come) FROM kk_shop_balance_log bl WHERE bl.s_uid =? and bl.balance_type!=5 ),0) AS LJYS, " +
				"IFNULL(( SELECT b.balance FROM kk_shop_balance b WHERE s_uid =? ), 0 ) AS balance";
		Record accountR = Db.findFirst(accountSql, shopId, "%" + time + "%", shopId, shopId);
		String ordersql = "SELECT ( SELECT count(o.id) FROM kk_order o WHERE o.order_status =? AND o.s_uuid =? ) AS newOrder, " +
				" ( SELECT count(o.id) FROM kk_order o WHERE o.order_status =? AND o.s_uuid =? ) AS shouHuo, " +
				"(SELECT COUNT(oc.id) FROM kk_order_cache oc WHERE oc.`status` =? and oc.u_uuid=? ) AS robOrder";

		Record orderR = Db.findFirst(ordersql, IConstant.OrderStatus.order_status_dfh, shopId, IConstant.OrderStatus.order_status_psz, shopId, 1, shopId);
		String cusSql = "select ( SELECT count(u.id) AS new_add FROM kk_shop s, kk_user u WHERE u.create_time LIKE '%" + time + "%' AND s.uuid = u.shop_id AND u.shop_id = '" + shopId + "' ) AS new_add," +
				"(10) as hyl,( SELECT count(u.id) AS allU FROM kk_shop s, kk_user u WHERE s.uuid = u.shop_id AND u.shop_id = '" + shopId + "' ) AS allU ";
		Record cusR = Db.findFirst(cusSql);

		m.put("account", accountR);
		m.put("order", orderR);
		m.put("custormer", cusR);
		renderSuccess("获取成功", m);
	}

	/**
	 * @author M
	 * 商户端 用户管理
	 */

	public void manageUser() {
		log.info("manageUser");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shopId = obj.getString("uid");
		List<Record> rs = new ArrayList<Record>();
		Calendar cl = Calendar.getInstance();
		for (int i = 0; i < IConstant.PAGE_DATA; i++) {
			cl = M.getBeforeDay(cl.getTime());
			String time = M.printCalendar(cl);
			String str = "SELECT ('" + time + "') as time," +
					"( SELECT count(u.id) AS new_add FROM kk_user u WHERE u.create_time LIKE '%" + time + "%'  AND u.shop_id = '" + shopId + "' ) AS new_add, " +
					"( SELECT ('" + 2 + "') ) AS huoyue ," +
					"( SELECT count(u.id) AS allU from  kk_user u WHERE  u.shop_id = '" + shopId + "' ) AS allU ";
			Record r = Db.findFirst(str);
			rs.add(r);
		}
		renderSuccess("获取成功", rs);
	}

	/**
	 * @author M
	 * 商户端 提现
	 */
	@Before(Tx.class)
	public void withDraw() {
		log.info("withDraw");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shopId = obj.getString("uid");
		int draw = obj.getInt("amount");
		String pawd = obj.getString("pawd");
		Shop s = new Shop().findBysuid(shopId);
		if (s != null) {
			Record r = Db.findFirst("select * from kk_shop_identi si where si.shop_id=? and withdraw_pass=?", s.getInt("id"), pawd);
			if (r == null) {
				renderFaile("密码有误");
				return;
			}
			Record r1 = Db.findFirst("select * from kk_shop_balance si where si.s_uid=?", shopId);
			if (r1.getInt("balance") < draw) {
				renderFaile("账户余额不足");
				return;
			}
			r = new Record();
			r.set("s_uid", shopId);
			r.set("amount", draw);
			r.set("create_time", new Date());
			r.set("bank_name", r1.getStr("shop_bank"));
			r.set("bank_card", r1.getStr("shop_bank_card_num"));
			Db.save("kk_shop_withdraw", r);
			renderSuccess("申请成功！", r);
		} else {
			renderFaile("异常");
		}
	}

	/**
	 * @author M
	 * 意见反馈接口
	 */
	public void showIdenti() {
		log.info("showIdenti");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shopId = obj.getString("uid");
		Shop s = new Shop().findBysuid(shopId);
		if (s == null) {
			renderFaile("异常");
			return;
		}
		int id = s.getInt("id");
		Record r = Db.findFirst("select si.id as identiId,si.user_name,si.bank_name,si.bank_branch_name,si.bank_card_num,si.withdraw_pass,sb.balance from kk_shop_identi si , kk_shop_balance sb where shop_id =? and sb.s_uid=?", new Object[]{id, shopId});
		if (r == null) {
			renderFaile("资质认证尚未完成");
			return;
		}
		renderSuccess("获取成功", r);
	}

	/**
	 * 添加（修改）提现密码
	 **/
	public void addWithPwd() {
		log.info("addWithPwd");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String pawd = obj.getString("password");
		String shopId = obj.getString("uid");
		Shop s = new Shop().findBysuid(shopId);
		if (s == null) {
			renderFaile("异常");
			return;
		}
		Record r = Db.findFirst("select * from kk_shop_identi where shop_id =?", new Object[]{s.getInt("id")});
		r.set("withdraw_pass", pawd);
		Db.update("kk_shop_identi", r);
		renderSuccess("修改成功", null);
	}

	/**
	 * @author M
	 * 意见反馈接口
	 */
	public void feedBack() {
		log.info("feedBack");
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String uid = "";
		if (obj.containsKey("uid")) {
			uid = obj.getString("uid");
		}
		String content = obj.getString("content");
		Record r = new Record();
		r.set("u_uid", uid);
		r.set("content", content);
		r.set("create_time", new Date());
		Db.save("kk_feed_back", r);
		renderSuccess("成功", null);
	}

	/**
	 * @author M
	 * 订单跟踪
	 */
	public void orderTail() {
		log.info("orderTail");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shop_id = obj.getString("uid");
//		double lat=obj.getDouble("lat");
//		double lng=obj.getDouble("lng");
		String lat = obj.getString("lat");
		String lng = obj.getString("lng");
		List<Order> os = Order.dao.find("select * from kk_order o where o.order_status=? and s_uuid=?", new Object[]{IConstant.OrderStatus.order_status_psz, shop_id});
		if (os.size() == 0) {
			renderFaile("异常");
			return;
		}
		for (Order o : os) {
			Record r = new Record();
			r.set("s_uid", shop_id);
			r.set("order_id", o.getStr("order_id"));
			r.set("lng", Double.parseDouble(lng));
			r.set("lat", Double.parseDouble(lat));
			r.set("create_time", new Date());
			Db.save("kk_order_tail", r);
			renderSuccess("添加成功", null);
		}
	}

	/**
	 * 商户 账户明细
	 **/
	public void accontDetail() {
		log.info("accontDetail");
		int sid = checkUUID();
		if (sid == 0) {
			renderFaile("uuid 错误");
			return;
		}
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String shop_id = obj.getString("uid");
		List<Record> rs = Db.find("select * from kk_shop_balance_log where s_uid=? ", shop_id);
		if (rs.size() == 0) {
			renderFaile("异常");
			return;
		}
		renderSuccess("获取成功", rs);
	}

	public void addProByCode() {
		log.info("addProByCode");
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		String proCode = obj.getString("code");
		String s_uid = obj.getString("s_uid");
		Goods goods = Goods.dao.findFirst("select p.id as product_id,p.name,p.title,p.price,p.cover_img,ps.product_number,p.p_brand_name,p.p_type_name,count(*) as count from kk_shop_product ps left join kk_product p on ps.product_id=p.id left join kk_shop s on ps.shop_id=s.id where p.code=? and s.uuid=?", proCode, s_uid);
		if(goods.getLong("count")==0){
			renderFaile("暂无");
		}
		renderSuccess("获取成功", goods);
	}


	/***
	 * 订单退款
	 * ***/
	@ActionKey("/app/refundOrder")
	@Before(Tx.class)
	public void refundOrder(){
		log.info("refundOrder");
		JSONObject obj= JSONObject.fromObject(getPara("info"));
		if(!obj.containsKey("u_id")||!obj.containsKey("order_id")){
			renderFaile("退款异常，参数错误");
			return;
		}
		String cause="";
		if(obj.containsKey("cause")){
			cause=obj.getString("cause");
		}
		String order_id=obj.getString("order_id");
		String u_id=obj.getString("u_id");
		Record r=loadWXconfig(u_id);
		/**查询微信/支付宝订单 是否可以删除**/
		JSONObject res= Order.dao.isRefund(order_id, r);
		if(!res.containsKey("flag")||!res.getBoolean("flag")){
			renderFaile("退款异常,微信/支付宝 查询不到退款订单");
			return;
		}
		Order o=new Order().dao.findFirst("select count(*) as count,alipay_no,pay_type,id,s_uuid,price,order_status from kk_order o where o.order_id=? and o.u_uuid=? and order_status=?", obj.getString("order_id"), obj.getString("u_id"),IConstant.OrderStatus.order_status_js);
		if(o.getLong("count")!=0){
			if(o.getInt("pay_type")==1){
				//微信退款
				Map<String,Object> resMap=WXUtil.wxRefund(res.getString("transaction_id"),order_id,r,res.getInt("cash_fee"));
				if(!resMap.containsKey("return_code")||!resMap.get("return_code").toString().toUpperCase().equals("SUCCESS")){
					renderFaile("退款失败");
					return;
				}
			}
			else if(o.getInt("pay_type")==2){
				//支付宝退款
			}
			/**修改订单状态**/
			o.set("order_status",IConstant.OrderStatus.order_status_js_success);
			o.set("refuse_time",new Date());
			o.set("refuse_cause",cause);
			o.update();
			/**退款后恢复库存数量**/
			List<Record> records=o.getOrderItems(order_id);
			Shop shop =Shop.dao.findBysuid(o.getStr("s_uuid"));
			for(Record record:records){
				goodService.addProNum(record.getInt("product_id"),record.getInt("product_number"),shop.getInt("id"));
			}
			renderSuccess("退款成功", null);
			return;
		}

		OrderActivity orderActivity=OrderActivity.dao.findFirst("select count(*) as count,alipay_no,pay_type,id,price,order_status from kk_order_activity oa where oa.order_id=? and u_uuid=? and order_status=? ", order_id, u_id,IConstant.OrderStatus.order_status_js);
		if(orderActivity.getInt("order_status")!=IConstant.OrderStatus.order_status_js){
			renderFaile("退款异常,查询不到退款订单");
			return;
		}
		if(orderActivity.getLong("count")!=0){
			if(orderActivity.getInt("pay_type")==1){
				//微信退款
				Map<String,Object> resMap=WXUtil.wxRefund(res.getString("transaction_id"), order_id, r, res.getInt("cash_fee"));
				if(!resMap.containsKey("return_code")||!resMap.get("return_code").toString().toUpperCase().equals("SUCCESS")){
					renderFaile("退款失败");
					return;
				}
			}
			else if(orderActivity.getInt("pay_type")==2){
				//支付宝退款
			}

			/**修改订单状态**/
			orderActivity.set("order_status", IConstant.OrderStatus.order_status_js_in);
			orderActivity.set("refuse_time",new Date());
			orderActivity.set("refuse_cause",cause);
			orderActivity.update();
			/**退款后恢复库存数量**/
			List<Record> records=OrderActivity.dao.getActivityOrderItem(order_id);
			for(Record record:records){
				Db.update("update kk_product_activity set surplus_num=surplus_num+? where id=?",record.getInt("product_number"),record.getInt("product_id"));
			}
			renderSuccess("退款成功",null);
			return;
		}
	}






	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    




















































































	 
/**----------------------------------------------------------------------------------------------------------------------------------------------------------*/
	
	/**
	 * @author M
	 * 用户注册
	 * 
	 * */
	@ActionKey("app/user/userLogin")
	@Before(Tx.class)
	public void userLogin(){
		log.info("userLogin");
		String info=getPara("info");
		JSONObject json= JSONObject.fromObject(info);
		String phone=json.getString("phone");
		String code=json.getString("code");
		String lat=json.getString("lat");
		String lng=json.getString("lng");
		User u=new User();
		List<Record> lists= Db.find("select * from kk_reg where phone = ? and code=?", new Object[]{phone, code});
		if(lists.size()==0){
			renderFaile("登录异常");
			return;
		}
		List<User> us= User.dao.find("select id,uuid,name,password,shop_id,cash_pay,create_time,cash_pay,score,phone from kk_user u where u.phone=?", new Object[]{phone});
		if(us.size()!=0){
			u=us.get(0);
		}else{
			Shop s=new Shop().findFirst("SELECT distance(?,?,s.lng,s.lat) as dis,s.id as shopId,s.name,s.uuid,s.cover_img from kk_shop s ORDER BY dis asc", new Object[]{lng,lat});
			Map<String,Object> m=new HashMap<String,Object>();
			m.put("shop_id", s.getStr("uuid"));
			m.put("name", phone);
			m.put("phone", phone);
			m.put("uuid", M.getUUID());
			m.put("create_time", new Date());
			u.setAttrs(m);
			u.save();
		}
		Record r= Db.findFirst("select * from kk_user_cash where u_uuid=? and cash_id=?", new Object[]{u.getStr("uuid"), 2});
		if(r==null){
			User.dao.getCash(u.getStr("uuid"),2);
		}
		if(json.containsKey("version")){
			String version=json.getString("version");
			if(version!=null || version.equals("")){
				Db.update("update kk_user u set login_ios_inhouse=0,login_ios_inapp=0,login_android_in_test=0,login_android_pub=0 where u.uuid=?",u.getStr("uuid"));
				u.set("login_"+version,1);
				u.update();
			}
		}
		/**
		 * 登陆自动签到
		 **/
		//new User().dao.addLoginLog(u.getStr("uuid"));
		renderSuccess("登陆成功", u);
	}
	/**
	 * 
	 * 用户端发送验证码
	 * **/
	@ActionKey("app/user/messageCode")
	public void userMessageCode(){
		log.info("messageCode");
		String info=getPara("info");
		JSONObject JB= JSONObject.fromObject(info);
		String phone=JB.getString("phone");
		if(!RegularUtil.isMobileNO(phone)){
			setAttr("code", 10001);
			setAttr("msg", "手机号码有误！");
			renderJson();
		}
		List<Record> lists= Db.find("select * from kk_reg where phone = ?", new Object[]{phone});
		String sql="";
		Object[] obj=new Object[]{};
		String code= RegularUtil.gen();
		if(lists.size()==0){
			sql="insert into kk_reg(phone,password,code,create_time) values(?,?,?,?)";
			obj=new Object[]{phone,"",code,new Date()};
		}else{
			sql="update kk_reg set code=?,password=?,create_time=? where phone=?";
			obj=new Object[]{code,"",new Date(),phone};
		}
		boolean b = SdkMessage.send(phone, code);
		if(b){
			int i= Db.update(sql, obj);
			if(i>0){
				JSONObject o=new JSONObject();
				o.put("code", code);
				renderSuccess("获取验证码成功", o);
				return;
			}else{
				renderJson(M.FAILE("10001", "添加失败"));
				return;
			}
		}else{
			renderJson(M.FAILE("10001", "验证码错误"));
			return;
		}
	}

	/**
	 *
	 * 用户登出
	 * **/
	@ActionKey("app/user/exit")
	public void exit(){
		log.info("exit");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		User u= User.dao.findFirst("select * from kk_user u where u.uuid=?", new Object[]{uid});
		u.set("login_ios_inhouse",0);
		u.set("login_ios_inapp",0);
		u.set("login_android_in_test",0);
		u.set("login_android_pub",0);
		u.update();
		renderSuccess("退出成功",null);
	}
	/*
	 * @author M
	 * c端 首页展示 1.0
	 * 
	 * */
	@ActionKey("app/user/homePage")
	public void homePage(){
		log.info("homePage");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String lat=json.getString("lat");
		String lng=json.getString("lng");
		String uid="";
		Shop s=new Shop();
		User u=new User();
		if(!json.containsKey("uid")){
			if(!lat.equals("")&&!lng.equals("")){
				s=new Shop().findFirst("SELECT distance(?,?,s.lng,s.lat) as dis,s.id as shopId,s.name,s.uuid,s.cover_img from kk_shop s ORDER BY dis asc", new Object[]{lng,lat});
			}else{
				renderFaile("定位错误");
				return;
			}
		}else{
			uid=json.getString("uid");
			u=new User().getUser(uid);
			if(u==null || u.equals("")){
				renderFaile("登录错误！");
				return;
			}
			s=new Shop().findFirst("SELECT distance(?,?,s.lng,s.lat) as dis,s.id as shopId,s.name,s.uuid,s.cover_img from kk_shop s where s.uuid=?", new Object[]{lng,lat,u.getStr("shop_id")});
		}
		List<Map<String,Object>> maps=new ArrayList<Map<String,Object>>();
		List<Record> rs= Db.find("select id as typeId,name,img from kk_product_type  where sort_id<=8 order by sort_id asc");
		for(int i=0;i<rs.size();i++){
			Map<String,Object> m=new HashMap<String, Object>();
			Record r =rs.get(i);
			m.put("type", r);
			int id=r.get("typeId");
			List<Goods> g=new Goods().find("select id as productId,name,title,price," +
					"p_type_id,p_brand_id,p_type_name,p_brand_name,cover_img,p_unit_id,p_unit_name,cash_pay," +
					"hide,index_show,server_id,server_name,payment,create_time from kk_product where p_type_id=? and index_show=2  LIMIT 0,3", new Object[]{id});
			if(g.size()!=0){
				m.put("products", g);				
				maps.add(m);
			}
		}
		if(s.getActivity()!=null){
			s.put("shopActivits", s.getActivity());			
		}else{
			s.put("shopActivits", null);	
		}
		s.put("types", maps);
		s.put("category", rs);
		renderSuccess("load成功", s);
	}


	/**
	 * @author M
	 * c端 首页展示 1.1
	 *
	 * **/
	@ActionKey("app/user/homePage1")
	public void homePage_1(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String lat=json.getString("lat");
		String lng=json.getString("lng");
		String uid="";
		Shop s=new Shop();
		User u=new User();
		if(!json.containsKey("uid")){
			if(!lat.equals("")&&!lng.equals("")){
				s=new Shop().findFirst("SELECT distance(?,?,s.lng,s.lat) as dis,s.id as shopId,s.name,s.uuid,s.cover_img from kk_shop s ORDER BY dis asc", new Object[]{lng,lat});
			}else{
				renderFaile("定位错误");
				return;
			}
		}else{
			uid=json.getString("uid");
			u=new User().getUser(uid);
			if(u==null || u.equals("")){
				renderFaile("登录错误！");
				return;
			}
			s=new Shop().findFirst("SELECT distance(?,?,s.lng,s.lat) as dis,s.id as shopId,s.name,s.uuid,s.cover_img from kk_shop s where s.uuid=?", new Object[]{lng,lat,u.getStr("shop_id")});
		}

		List<Record> rs= Db.find("select id as typeId,name,img from kk_product_type  where sort_id<=8 order by sort_id asc");
		List<Map<String,Object>> maps=new ArrayList<Map<String,Object>>();
		for(int i=0;i<rs.size();i++){
			Map<String,Object> m=new HashMap<String, Object>();
			Record r =rs.get(i);
			m.put("type", r);
			int id=r.get("typeId");
			List<Goods> g=new Goods().find("select id as productId,name,title,price," +
					"p_type_id,p_brand_id,p_type_name,p_brand_name,cover_img,p_unit_id,p_unit_name,cash_pay," +
					"hide,index_show,server_id,server_name,payment,create_time from kk_shop_product ps left join kk_product p on ps.product_id=p.id where p_type_id=? and ps.shop_id=? and index_show=2  LIMIT 0,6", new Object[]{id,s.getInt("shopId")});
			if(g.size()!=0){
				m.put("products", g);
				maps.add(m);
			}
		}
		if(s.getActivity()!=null){
			s.put("shopActivits", s.getActivity());
		}else{
			s.put("shopActivits", null);
		}
		List<Goods> recommGoods= Goods.dao.find("select p.id as productId,name,title,price," +
				"p_type_id,p_brand_id,p_type_name,p_brand_name,cover_img,p_unit_id,p_unit_name,cash_pay,hide,index_show,server_id,server_name,payment,p.create_time " +
				"from kk_product p left join kk_shop_product ps on p.id=ps.product_id where shop_id =? order by RAND() limit 6 ",s.getInt("shopId"));
		s.put("recommGoods",recommGoods);
		s.put("types", maps);
		s.put("category", rs);
		Record record= Db.findFirst("select count(s.id) as count from kk_shop s WHERE distance(?,?,s.lng,s.lat )<5000;", lng, lat);
		s.put("shopCount",record.getLong("count"));
		renderSuccess("load成功", s);
	}

	/**
	 * @author M
	 * c端 首页展示 点击分类进入产品列表
	 *
	 * */
	@ActionKey("app/user/products")
	public void producListtByType(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		Page<Goods> gs=null;
		int page=json.getInt("pg");
		String s_uid=json.getString("shopId");
		Shop s=Shop.dao.findBysuid(s_uid);
		if(s==null){
			return;
		}
		if(json.containsKey("catId")&&json.getInt("catId")>0){
			int catId=json.getInt("catId");
			if(json.getInt("typeId")==0){
				gs=new Goods().paginate(page,IConstant.PAGE_DATA,"select p.id as productId,p.name,p.title,p.price,p.cover_img,p.cash_pay","from kk_product p right join kk_shop_product ps on ps.product_id=p.id " +
						"where p.p_category_id=? and ps.shop_id=?  order by ps.sort_id desc",new Object[]{catId,s.getInt("id")});
			}
		}

		if(json.containsKey("typeId")&&json.getInt("typeId")>0){
			int typeId=json.getInt("typeId");
			gs=new Goods().paginate(page, IConstant.PAGE_DATA, "select p.id as productId,p.name,p.title,p.price,p.cover_img,p.cash_pay", "from kk_product p right join kk_shop_product ps on ps.product_id=p.id " +
					"where p.p_type_id=? and ps.shop_id=?  order by ps.sort_id desc",new Object[]{typeId,s.getInt("id")});
		}

		if(json.containsKey("brandId")&&json.getInt("brandId")>1){
			int brandId=json.getInt("brandId");
			gs=new Goods().paginate(page, IConstant.PAGE_DATA, "select p.id as productId,p.name,p.title,p.price,p.cover_img,p.cash_pay", "from kk_product p right join kk_shop_product ps on ps.product_id=p.id " +
					"where p.p_brand_id=? and ps.shop_id=? order by ps.sort_id desc",new Object[]{brandId,s.getInt("id")});
		}



		renderSuccess("load成功", gs);
	}


	/**
	 * @author M
	 * c端 首页展示 产品详情页
	 * */
	@ActionKey("app/user/showProductInfo")
	public void product(){
		log.info("product");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		int productId=json.getInt("productId");
		Goods gs=new Goods().findById(productId);
		renderSuccess("load成功", gs);
	}

	@ActionKey("/app/user/categorys_1")
	public void homeCategory() {
		log.info("categorys");
		JSONObject obj = JSONObject.fromObject(getPara("info"));
		List<GoodCategory> goodCategories = GoodCategory.dao.find("select * from kk_product_category order by sort_id asc");
		for (GoodCategory goodCategory : goodCategories) {
			goodCategory.put("types", goodCategory.getGoodTypes_1(goodCategory.getInt("id")));
		}
		renderSuccess("获取成功", goodCategories);
	}
	
	/**
	 * @author M
	 * c端 用户购物车产品id 查询匹配  客户端价格与服务器价格是否一致
	 * */
	@ActionKey("app/user/SCProduct")
	public void SCProduct(){
		log.info("SCProduct");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String pids=json.getString("pids");
		if(pids==null||pids.equals("")){
			renderFaile("有异常！");
			return;
		}
		String [] str=pids.split(",");
		List<Goods> goods=new ArrayList<Goods>();
		for(int i=0;i<str.length;i++){
			Goods g=new Goods();
			int id=Integer.valueOf(str[i]);
			g=g.findById_lazy(id);
			goods.add(g);
		}
		renderSuccess("获取信息成功", goods);
	}
	
	/**
	 * @author M
	 * c端 首页展示 用户添加地址
	 * 
	 * */
	
	@ActionKey("app/user/addAddress")
	public void addUserAddress(){
		log.info("addUserAddress");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		
		String userId=json.getString("uid");
		double lat=0.0;
		double lng=0.0;
		if(json.containsKey("lng")){
			lng=json.getDouble("lng");
		}
        if(json.containsKey("lat")){
        	lat=json.getDouble("lat");
		}
        
		Record re=new Record();
		String pcode="0";
		String ccode="0";
		String acode="0";
		String fulladdress=json.getString("fulladdress");
		re.set("full_address", fulladdress);
		String street=json.getString("street");
		re.set("street", street);
		String phone=json.getString("phone");
		re.set("phone", phone);
		String name=json.getString("name");
		re.set("name", name);
		int defult=2;
		
		
		if(json.containsKey("provinceName")){
			String provinceName=json.getString("provinceName");
			Record r= Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + provinceName + "%"});
			pcode=r.getStr("code");
			re.set("province_name", provinceName);
			re.set("province_id", pcode);
		}
		if(json.containsKey("cityName")){
			String cityName=json.getString("cityName");
			Record r= Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + cityName + "%"});
			ccode=r.getStr("code");
			re.set("city_name", cityName);
			re.set("city_id", ccode);
		}
		if(json.containsKey("areaName")){
			String areaName=json.getString("areaName");
			Record r= Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + areaName + "%"});
			acode=r.getStr("code");
			re.set("area_name", areaName);
			re.set("area_id", acode);
		}
		Record r= Db.findFirst("select count(*) as num from kk_user_address where u_uuid=? ", new Object[]{userId});
		if(r.getLong("num")==0){
			defult=1;
		}
		re.set("is_default", defult);
		re.set("lat", lat);
		re.set("lng", lng);
		re.set("u_uuid", userId);
		Db.save("kk_user_address", re);
		re.set("addressId", re.get("id"));
		renderSuccess("添加成功", re);
	}
	
	/**
	 * @author M
	 * c端 首页展示 用户收货地址信息列表
	 * 
	 * */
	
	@ActionKey("app/user/addressList")
	public void userAddressList(){
		log.info("userAdressList");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String uid=json.getString("uid");
		List<Record> rs= Db.find("select id as addressId,full_address,province_name,city_name,area_name,street,is_default,name,phone,lat,lng from kk_user_address ua where u_uuid =? order by is_default asc ", uid);
		renderSuccess("获取用户地址信息成功", rs);
	}
	
	/**
	 * @author M
	 * c端 首页展示 用户设置默认收货地址
	 * 
	 * */
	
	@ActionKey("app/user/setAddressDef")
	@Before(Tx.class)
	public void setUserAddressAsDef(){
		log.info("setUserAdressAsDef");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		int addressId=json.getInt("addressId");
		String uuid=json.getString("uid");
		Db.update("update kk_user_address set is_default=2 where is_default=1  and u_uuid=?", uuid);
		Db.update("update kk_user_address set is_default=1 where is_default!=1 and id=? and u_uuid=?", addressId, uuid);
		renderSuccess("设为默认地址信息成功", null);
	}
	
	/**
	 * @author M
	 * c端 首页展示 用户删除收货信息
	 * 
	 * */
	
	@ActionKey("app/user/delAddress")
	public void delAddress(){
		log.info("delAddress");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		int addressId=json.getInt("addressId");
		Db.deleteById("kk_user_address", "id", addressId);
		renderSuccess("删除成功", null);
	}
	
	/**
	 * @author M
	 * c端 首页获得默认收货信息
	 * 
	 * */
	
	@ActionKey("app/user/addressDef")
	public void addressDef(){
		log.info("addressDef");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String uid=json.getString("uid");
		Record r= Db.findFirst("select id as addressId,full_address,province_id,city_id,area_id,street,province_name,city_name,area_name,is_default from kk_user_address ua where ua.is_default=1 and ua.u_uuid=?", new Object[]{uid});
		renderSuccess("获取成功", r);
	}
	/**
	 * @author M
	 * 修改收货地址
	 * */
	@ActionKey("app/user/updateAddress")
	public void updateAddress(){
		log.info("updateAddress");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String userId=json.getString("uid");
		String addressId=json.getString("addressId");
		double lat=0.0;
		double lng=0.0;
		if(json.containsKey("lng")){
			lng=json.getDouble("lng");
		}
        if(json.containsKey("lat")){
        	lat=json.getDouble("lat");
		}
        
		Record re= Db.findById("kk_user_address", addressId);
		String pcode="0";
		String ccode="0";
		String acode="0";
		String fulladdress=json.getString("fulladdress");
		re.set("full_address", fulladdress);
		String street=json.getString("street");
		re.set("street", street);
		String phone=json.getString("phone");
		re.set("phone", phone);
		String name=json.getString("name");
		re.set("name", name);
		
		
		if(json.containsKey("provinceName")){
			String provinceName=json.getString("provinceName");
			Record r= Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + provinceName + "%"});
			pcode=r.getStr("code");
			re.set("province_name", provinceName);
			re.set("province_id", pcode);
		}
		if(json.containsKey("cityName")){
			String cityName=json.getString("cityName");
			Record r= Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + cityName + "%"});
			ccode=r.getStr("code");
			re.set("city_name", cityName);
			re.set("city_id", ccode);
		}
		if(json.containsKey("areaName")){
			String areaName=json.getString("areaName");
			Record r= Db.findFirst("select code from kk_area a where name like ?", new Object[]{"%" + areaName + "%"});
			acode=r.getStr("code");
			re.set("area_name", areaName);
			re.set("area_id", acode);
		}
		re.set("lat", lat);
		re.set("lng", lng);
		re.set("u_uuid", userId);
		Db.update("kk_user_address", re);
		re.set("addressId", re.get("id"));
		renderSuccess("修改成功", re);
	}
	/**
	 * @author M
	 * 模拟添加订单
	 * */
	@ActionKey("app/user/addOrderInfo")
	@Before(Tx.class)
	public void addOrderInfo(){
		log.info("addOrderInfo");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		Map<String,Object> map=new HashMap<String, Object>();
		String orderNo= M.getOrderNo();
		String orderId= M.getOrderId();
		String sendTime="";
		int sendId=0;
		int orderStatus= IConstant.OrderStatus.order_status_chushi;
		int price=json.getInt("price");
		String uid=json.getString("uid");
		User u=new User().getUser(uid);
		String shopId=u.getStr("shop_id");
		if(shopId==null || shopId.equals("0")){
			renderFaile("下单异常！");
			return;
		}
		int payType=json.getInt("payType");

		int sendType=json.getInt("sendType");
		int addressId=json.getInt("addressId");
		
		if(sendType== IConstant.send_type_dingshi){
			sendTime=json.getString("sendTime");
			map.put("send_time", DateTools.unixTimeToDate(sendTime));
		}
		map.put("pay_type", payType);
		if(payType!=0){
			Record r= Db.findById("kk_pay_type", payType);
			map.put("pay_name", r.get("pay_type_name"));
			if(payType==3){
				orderStatus=IConstant.OrderStatus.order_status_dfh;
			}
		}
		map.put("order_no", orderNo);
		map.put("order_id", orderId);
		map.put("order_status", orderStatus);
		map.put("create_time", new Date());
		map.put("price", price);
		map.put("order_no", orderNo);
		map.put("order_type", 1);
		map.put("u_uuid", uid);
		map.put("s_uuid", shopId);
		map.put("address_id", addressId);
		if(addressId!=0){
			Record r= Db.findById("kk_user_address", addressId);
			map.put("address", r.get("full_address"));
		}
		if(!shopId.equals("")){
			Shop s=new Shop().findFirst("select * from kk_shop s where s.uuid=?", new Object[]{shopId});
			map.put("shop_name", s.get("name"));
		}
		
		map.put("send_type", sendType);
		map.put("send_name", IConstant.sendType.get(sendType));
		map.put("send_id", sendId);
		map.put("is_rob", 1);
		if(!json.containsKey("cashPay")){
			renderFaile("代金券有异常");
			return;
		}
		String receive_code= RegularUtil.gen();
		map.put("receive_code", receive_code);
		String items=json.getString("orderItems");

		if(json.getInt("cashPay")!=0){
			Record r= Db.findFirst("select sum(cash) as cash,u_uuid from kk_user_cash uc left join kk_cash c on uc.cash_id=c.id  " +
					"where uc.u_uuid=? and c.cash_status=1", new Object[]{uid});
			if(r!=null){
				int cash=r.getBigDecimal("cash").intValue();
				if(cash<json.getInt("cashPay")){
					renderFaile("cashPay异常");
					return;
				}
			}
		}

		int allPrice=0;
		JSONArray array = JSONArray.fromObject(items);
		if (array.size() > 0) {
			for (int i = 0; i < array.size(); i++) {
				JSONObject o = array.getJSONObject(i);
				int productId = o.getInt("productId");
				int productNum = o.getInt("productNum");
				Goods g = new Goods().findById(productId);
				int pric=g.getBigDecimal("price").intValue();
				allPrice+=pric*productNum;
			}
		}


		allPrice=allPrice-json.getInt("cashPay");
		if(allPrice!=price){
			renderFaile("总金额异常");
			return;
		}

//		if(json.getInt("cashPay")!=0){
//			Record cashRe= Db.findFirst("select * from kk_user_cash where u_uuid=?", uid);
//			if(cashRe.getBigDecimal("cash").intValue()<json.getInt("cashPay")){
//				renderFaile("代金券金额不足");
//				return;
//			}
//		}
		map.put("cash_pay", json.getInt("cashPay"));
		boolean f=orderService.splice2Create_1(orderId, items,json.getInt("cashPay"));
		if(f){
			Order o=new Order();
			o.setAttrs(map);
			boolean s=o.save();
			/**cashPay**/
//			if(json.getInt("cashPay")!=0){
//				Order.dao.updateCash(uid,json.getInt("cashPay"),orderId);
//			}
			o.createLog(orderId, IConstant.orderAction.order_action_chushi, IConstant.sendType.get(sendType), null, null, null, IConstant.OrderStatus.order_status_chushi);
			if(s){
				/**分单**/
//				if(payType==3){
//					Map<String,Object> res=orderService.splice2Create_2(o.getStr("order_id"));
//					log.error(res);
//				}
				renderSuccess("添加成功", o.findById(false, orderId));
				return;
			}else{
				renderFaile("下单失败! 添加有误！");
				return;
			}
		}else{
			renderFaile("下单失败! 产品有误！");
			return;
		}
	}
	/**
	 * @author M
	 * 获取当前系统时间
	 * */
	@ActionKey("app/user/currentTime")
	public void currentTime(){
		Map<String,Object> map=new HashMap<String, Object>();
		String now= DateTools.createTime();
		map.put("currentTime", now);
		map.put("startTime", IConstant.startTime);
		map.put("endTime", IConstant.endtTime);
		renderSuccess("获取成功", map);
	}
	/**
	 * @author M
	 * 获取当前系统时间
	 * */
	@ActionKey("app/user/currentTime_unix")
	public void currentTime_unix(){
		Map<String,Object> map=new HashMap<String, Object>();
		map.put("currentTime", Long.toString(new Date().getTime()));
		map.put("startTime", Long.toString(IConstant.startTime_d.getTime()));
		map.put("endTime", Long.toString(IConstant.endtTime_d.getTime()));
		renderSuccess("获取成功", map);
	}
	/**
	 * @author M
	 * 获取用户订单列表
	 * */
	
	@ActionKey("app/user/userOrderList")
	public void userOrderList(){
		log.info("userOrderList");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		boolean b=new User().isLogin(json.getString("uid"));
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String uid=json.getString("uid");
		int page=json.getInt("pg");
		int status=json.getInt("status");
		Page<Order> o = null;
		Page<OrderActivity> recordPage=orderService.getActivityOrders(100,uid,page);
		if(status==1){
			o=orderService.userLoadOrderByStatus(IConstant.OrderStatus.order_status_chushi,uid,page);
//			recordPage=orderService.getActivityOrders(IConstant.OrderStatus.order_status_chushi,uid,page);
		}else if(status== IConstant.OrderStatus.order_status_js){
			o=orderService.userLoadOrderByStatus(IConstant.OrderStatus.order_status_js,uid,page);
//			recordPage=orderService.getActivityOrders(IConstant.OrderStatus.order_status_js,uid,page);
		}else{
			 o=orderService.userLoadOrderByStatus(status,uid,page);
//			recordPage=orderService.getActivityOrders(status,uid,page);
		}
		Map<String,Object> map=new HashMap<String,Object>();
		map.put("order",o);
		map.put("orderActivity",recordPage);
		renderSuccess("获取成功", map);
	}
	/**
	 * @author M
	 * 代金券
	 * */
	@ActionKey("app/user/cashList")
	public void cashList(){
		List<Record> rs= Db.find("select uc.id as cashId,uc.create_time,uc.cash_title,uc.cash_content,uc.cash_img,uc.cash_unit " +
				"from kk_user_cash uc ");
		renderSuccess("获取成功", rs);
	}
	
//	/**
//	 * @author M
//	 * 用户领取代金券
//	 * */
//	@Before(Tx.class)
//	@ActionKey("app/user/getCash")
//	public void getCash(){
//		log.info("getCash");
//		JSONObject json=JSONObject.fromObject(getPara("info"));
//		String uid=json.getString("uid");
//		boolean b=new User().isLogin(uid);
//		if(!b){
//			renderFaile("请登录！");
//			return;
//		}
//		int cashId=json.getInt("cashId");
//		Record r=Db.findFirst("select * from kk_user_cash where u_uuid=? and cash_id=?", new Object[]{uid,cashId});
//		if(r!=null){
//			renderFaile("你已经领取过");
//			return;
//		}
//		List<Record> rs=Db.find("select * from kk_cash_item where cash_id =? and cash_item_status=?", new Object[]{cashId,IConstant.cashItem.cash_item_status_h});
//		if(rs.size()==0){
//			renderFaile("代金券已经被领完~");
//			return;
//		}
//		int cash=rs.get(0).getInt("cash_price");
//		new User().addCash(cashId, uid,cash);
//		renderSuccess("获取成功", null);
//	}
	/**
	 * @author M
	 * 收货码
	 * */
	@ActionKey("app/user/receiveGoods")
	@Before(Tx.class)
	public void receiveGoods(){
		log.info("receiveGoods");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String orderId=json.getString("orderId");
		Order o= Order.dao.findByStatus(orderId, IConstant.OrderStatus.order_status_psz);
		o.set("id", o.getInt("orderId"));
		o.set("order_status", o.getInt("order_status")+1);
		o.set("finish_time", new Date());
		boolean flag=orderService.recordfinshOrder(o);
		if(!flag){
			renderFaile("异常");
			return;
		}
		new JPush(IConstant.Title, IConstant.content_order_Touser_finish, o.getStr("u_uuid"), IConstant.PUSH_ONE, M.pushMap(o.getStr("order_id"), IConstant.OrderStatus.order_status_ywc),"user").start();
		o.update();
		renderSuccess("成功", o);
	}
	/**
	 *
	 * @author M
	 * 扫描接口
	 * 
	 * */
	@ActionKey("app/user/scanCode")
	public void scanCode(){
		log.info("scanCode");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String code=json.getString("ewm_code");
		String shopId= M.parseCode(code);
		Shop s = new Shop().findBysuid(shopId);
		User u=new User().getUser(uid);
		if(s!=null){
			u.set("id", u.getInt("userId"));
			u.set("shop_id",shopId );
			u.update();
			renderSuccess("验证成功", null);
			return;
		}
		renderFaile("异常");
	}
	/**
	 * @author M
	 * 扫描接口
	 * 
	 * */
	@ActionKey("app/user/weLogin")
	public void weLogin(){
		log.info("weLogin");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String weName= EmojiFilter.filterEmoji(json.getString("weName"));
		String wechat_id=json.getString("openId");
		double lng=json.getDouble("lng");
		double lat=json.getDouble("lat");
		String head=json.getString("headimgurl");
		if(wechat_id==null || wechat_id.equals("")){
			renderFaile("openId 异常");
			return;
		}
		User u= User.dao.findFirst("select * from kk_user where wechat_id=?", new Object[]{wechat_id});
		if(u!=null){
			Record r= Db.findFirst("select * from kk_user_cash where u_uuid=? and cash_id=?", new Object[]{u.getStr("uuid"), 2});
			if(r==null){
				User.dao.getCash(u.getStr("uuid"),2);
			}
		}else{
			Shop s=new Shop().findFirst("SELECT distance(?,?,s.lng,s.lat) as dis,s.id as shopId,s.name,s.uuid,s.cover_img from kk_shop s ORDER BY dis asc", new Object[]{lng,lat});
			u=new User();
			u.set("name", weName);
			u.set("wechat_id", wechat_id);
			u.set("create_time", new Date());
			u.set("score", 0);
			u.set("cash_pay", 0);
			u.set("shop_id", s.getStr("uuid"));
			u.set("uuid", M.getUUID());
			u.set("head_img", head);
			u.set("phone", "");
			u.save();
		}
		if(json.containsKey("version")){
			String version=json.getString("version");
			Db.update("update kk_user u set login_ios_inhouse=0,login_ios_inapp=0,login_android_in_test=0,login_android_pub=0 where u.uuid=?",u.getStr("uuid"));
			u.set("login_" + version, 1);
			u.update();
		}
		//new User().dao.addLoginLog(u.getStr("uuid"));
		renderSuccess("登陆成功", u);
	}

	/**
	 * @author M
	 * 微信获取payNo
	 * */
	@ActionKey("app/user/wxPayNo")
	public void wxPayNo(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String order_id=json.getString("orderId");
		String ip=json.getString("ip");
		Order o= Order.dao.findById(false, order_id);
		List<Record> rs=o.get("orderItems");
		String attach="[buy] ";
		for(Record r:rs){
			attach+=r.getInt("product_id")+"*"+r.getInt("product_number")+"|";
		}
		Map<String,Object> map=new HashMap<String, Object>();
		try {
			map= WXUtil.loadPrepayid(order_id, o.getBigDecimal("price").intValue(), ip, attach);
		} catch (IOException e) {
			log.error("",e);
		} catch (ExecutionException e) {
			log.error("",e);
		} catch (InterruptedException e) {
			log.error("",e);
		}
		renderSuccess("获取成功", map);
	}

	/**
	 * @author M
	 * 微信获取payNo
	 * */
	@ActionKey("app/user/wxPay")
	public void wxPay() throws InterruptedException, ExecutionException, IOException {
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String order_id=json.getString("orderId");
//		if(json.containsKey("type")){
//			 type=json.getInt("type");
//		}
		String ip=json.getString("ip");
		Record conf=loadWXconfig(uid);
		Map<String,Object> map=new HashMap<String, Object>();

		Order o= Order.dao.findById(false, order_id);
		List<Record> rs=o.get("orderItems");
		String attach="";
		for(Record r:rs){
			attach+=r.getInt("id");
		}
		map= WXUtil.loadPrepayid(conf, order_id, o.getBigDecimal("price").intValue(), ip, attach);

//		if(type!=2){
//			Order o= Order.dao.findById(false, order_id);
//			List<Record> rs=o.get("orderItems");
//			String attach="";
//			for(Record r:rs){
//				attach+=r.getInt("id");
//			}
//			map= WXUtil.loadPrepayid(conf, order_id, o.getBigDecimal("price").intValue(), ip, attach);
//		}
//		if(type==2){
//			Record record= Db.findFirst("select * from kk_order_activity oa where oa.order_id=?", order_id);
//			List<Record> records= Db.find("select *,p.name from kk_order_activity_item oai left join kk_product p on oai.product_id=p.id where oai.order_id=?", order_id);
//			String attach="";
//			for(Record r:records){
//				attach+=r.getInt("id");
//			}
//			map= WXUtil.loadPrepayid(conf, order_id, record.getBigDecimal("price").intValue(), ip, attach);
//		}
		renderSuccess("获取成功", map);
	}


	public Record loadWXconfig(String uid){
		User u= User.dao.getUser(uid);
		Record r=new Record();
		if(u.getInt("login_ios_inhouse")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "ios", "inhouse");
		}
		if(u.getInt("login_ios_inapp")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "ios", "inapp");
		}
		if(u.getInt("login_android_in_test")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "android", "in_test");
		}
		if(u.getInt("login_android_pub")==1){
			r= Db.findFirst("select * from kk_config where app=? and version=?", "android", "in_pub");
		}
		return r;
	}
	/**
	 * @author M
	 * 订单跟踪
	 * */
	@ActionKey("app/user/orderTail")
	public void orderListTail(){
		log.info("orderListTail");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		List<Order> orders= Order.dao.find("select * from kk_order o where o.u_uuid=? and order_status=?", new Object[]{uid, IConstant.OrderStatus.order_status_psz});
		if(orders.size()==0){
			renderFaile("异常");
			return;
		}
		List<JSONObject> objs=new ArrayList<JSONObject>();
		for(Order o:orders){
			JSONObject obj=new JSONObject();
			obj.put("shop_id", o.getStr("s_uid"));
			obj.put("order_id", o.getStr("order_id"));
			List<Map<String,Object>> ms=new ArrayList<Map<String,Object>>();
			List<Record> res= Db.find("select lng,lat from kk_order_tail ot where ot.order_id=?", new Object[]{o.getStr("order_id")});
			for(Record r:res){
				Map<String,Object> m=new HashMap<String, Object>();
				m.put("lng", r.getDouble("lng"));
				m.put("lat", r.getDouble("lat"));
				ms.add(m);
			}
			obj.put("pos",ms);
			objs.add(obj);
		}
		renderSuccess("获取成功", objs);
	}
	/**
	 * @author M
	 * 删除订单
	 * */
	@ActionKey("app/user/delOrder")
	public void delOrder(){
		log.info("orderListTail");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String orderId=json.getString("orderId");
		Order order= Order.dao.findById(true,orderId);
		if(order!=null){
			boolean flag=orderService.delOrder(order);
			if(flag){
				renderSuccess("删除成功",null);
			}
			return;
		}
		OrderActivity orderActivity=OrderActivity.dao.findFirst("select * from kk_order_activity oa where oa.order_id=?",orderId);
		if(orderActivity!=null){
			orderActivity.delActivityOrderItem(orderId);
			boolean flag=orderActivity.delete();
			if(flag){
				renderSuccess("删除成功",null);
			}
			return;
		}
	}
	/**
	 * @author M
	 * 获取电子现金券
	 * */
	@ActionKey("app/user/loadCash")
	public void loadCash(){
		log.info("loadCash");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		if(!json.containsKey("uid")){
			renderFaile("请登录！");
			return;
		}
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		Record r= Db.findFirst("select IFNULL(sum(cash),0) as cash,u_uuid,c.create_time,c.end_time,c.cash_title,c.cash_content from kk_user_cash uc left join kk_cash c on uc.cash_id=c.id  where uc.u_uuid=? and c.cash_status=1", new Object[]{uid});
		renderSuccess("获取成功", r);
	}
	@ActionKey("app/user/loadCashs")
	public void loadCashs(){
		log.info("loadCashs");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		List<Record> rs= Db.find("select uc.cash,uc.u_uuid,c.cash_title,c.create_time,c.end_time,c.cash_status from kk_user_cash uc left join kk_cash c on uc.cash_id=c.id  where uc.u_uuid=? and c.cash_status=1", new Object[]{uid});
		renderSuccess("获取成功", rs);
	}
	/**
	 * @author M
	 * 订单拒收*
	 * **/
	@ActionKey("app/user/refuse")
	public void refuseOrder(){
		log.info("refuseOrder");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		String cause=json.getString("cause");
		String orderId=json.getString("orderId");
		Order o= Order.dao.findById(true, orderId);
		if(o!=null){
			o.set("id",o.getInt("orderId"));
			o.set("order_status", IConstant.OrderStatus.order_status_js);
			o.set("refuse_time",new Date());
			o.set("refuse_cause",cause);
			o.update();
			/**退款后恢复库存数量**/
			renderSuccess("拒收成功",null);
			return;
		}

		OrderActivity orderActivity=OrderActivity.dao.findFirst("select count(*) as count,alipay_no,pay_type,id from kk_order_activity oa where oa.order_id=? and u_uuid=?", orderId, uid);
		if(orderActivity.getLong("count")>0){
			orderActivity.set("order_status",IConstant.OrderStatus.order_status_js);
			orderActivity.set("refuse_time",new Date());
			orderActivity.set("refuse_cause",cause);
			orderActivity.update();
			/**退款后恢复库存数量**/
			renderSuccess("拒收成功",null);
			return;
		}
	}



	@ActionKey("app/user/orderStatusNum")
	public void orderStatusNum(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		boolean b=new User().isLogin(uid);
		if(!b){
			renderFaile("请登录！");
			return;
		}
		Record r= Order.dao.loadOrderNumU(uid);
		renderSuccess("获取成功", r);
	}


	@ActionKey("app/user/activityProducts")
	public void activityProducts(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		int aid=json.getInt("activity_id");
		List<Record> records= Db.find("select id as paId,activity_id,name,title,price," +
				"cash_pay,cover_img,p_unit_name,payment,create_time,order_no from kk_product_activity pa where pa.activity_id=?", aid);
		renderSuccess("获取成功",records);
	}
	@ActionKey("app/user/activityProduct")
	public void activityProduct(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		int s_uid=json.getInt("s_uid");
		List<Record> records= Db.find("SELECT pa.id AS paId, pa.activity_id, pa. name, pa.title, pa.price, pa.cash_pay, pa.cover_img, pa.p_unit_name, pa.payment, pa.create_time, pa.order_no " +
				"FROM kk_product_activity pa LEFT JOIN kk_shop_activity sa ON pa.activity_id = sa.id WHERE sa.shop_id = ?", s_uid);
		renderSuccess("获取成功",records);
	}



	@ActionKey("app/user/addActivityOrder")
	@Before(Tx.class)
	public void addActivityOrder(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String uid=json.getString("uid");
		String s_uid=json.getString("s_uid");

       /*检测是否非法店铺**/
		Shop s=Shop.dao.findBysuid(s_uid);
		if(s==null){
			renderFaile("异常");
			return;
		}
		String items=json.getString("orderItems"); //订单产品列表
		if(items==null || items.equals("")){
			renderFaile("购买产品异常");
			return;
		}
			/*检测活动是否有效**/
		int activityId=json.getInt("activity_id");
		JSONObject obj=orderService.checkActivity(activityId, uid, items);
		if(obj.containsKey("code")&&obj.getInt("code")==10001){
			renderFaile(obj.getString("msg"));
			return;
		}

		Order o=new Order();
		o.set("order_no",M.getOrderNo());
		o.set("order_id",M.getOrderId());
		int sendType =1;
		if(json.containsKey("sendType")){
			sendType=json.getInt("sendType");
		}
		int addressId=json.getInt("address_id");
		int order_status= IConstant.OrderStatus.order_status_chushi;
		if(json.getInt("pay_type")==3){
			order_status= IConstant.OrderStatus.order_status_dfh;
		}
        if(json.containsKey("remark")){
            o.set("remark",json.getString("remark"));
        }
		if (sendType == IConstant.send_type_dingshi) {
			String sendTime = json.getString("sendTime");
			o.put("send_time", DateTools.unixTimeToDate(sendTime));
		}
		o.set("send_type",sendType);
		o.set("send_name", IConstant.sendType.get(sendType));
		o.set("order_status",order_status);
		o.set("create_time",new Date());
		o.set("price",json.getInt("price"));
		o.set("u_uuid",uid);
		o.set("s_uuid",json.getString("s_uid"));
		o.set("address_id",json.getInt("address_id"));
		o.set("pay_type",json.getInt("pay_type"));
		o.set("is_rob",1);
		Record rp= Db.findById("kk_pay_type", json.getInt("pay_type"));
		o.set("pay_name", rp.getStr("pay_type_name"));

		String receive_code = RegularUtil.gen();
		o.set("receive_code", receive_code);

		Shop shop = new Shop().findFirst("select * from kk_shop s where s.uuid=?", new Object[]{s_uid});
		/**配送**/
		if (json.getInt("address_id") != 0 && !s_uid.equals("")) {
			Record r = Db.findById("kk_user_address", addressId);
			o.set("address", r.get("full_address"));
			o.set("shop_name", shop.get("name"));
			/**
			 * 配送距离超过1000米 不让下单
			 * */
//            Record dis=Db.findFirst("select distance(?,?,?,?) as dis",r.getDouble("lng"),r.getDouble("lat"),shop.getDouble("lng"),shop.getDouble("lat"));
//            if(dis.getDouble("dis")>1000){
//                renderFaile("太远了！！送不到啊 亲~");
//                return;
//            }
			/**
			 * 是否在配送区域内
			 * */
			if (shop.getStr("scope") != null) {
				JSONObject jsonObject = JSONObject.fromObject(shop.getStr("scope"));
				List objs = JsonUtils.json2list(jsonObject.getString("scope"));
				Point[] points = Point.list2point(objs);
				Point p = new Point(r.getDouble("lat"), r.getDouble("lng"));
				boolean flag = Point.inPolygon(p, points);
				if (!flag) {
					renderFaile("超过指定区域,暂时无法下单");
					return;
				}
			}
		}
		/**
		 * 队列
		 * */
		IConstant.orderQueue.insert(o);//放入队列中
		while(!IConstant.orderQueue.isEmpty()){
			Order order=IConstant.orderQueue.peekFront();//取队列第一个元素
			JSONArray array = JSONArray.fromObject(items);
			for(int i=0;i<array.size();i++) {
				JSONObject oritem = array.getJSONObject(i);
				int productId = oritem.getInt("productId");
				int productNum = oritem.getInt("productNum");
				Record pr = Db.findFirst("select * from kk_product_activity pa where pa.id=? and activity_id=?", productId, activityId);
				if (pr.getInt("surplus_num") <=0 ||pr.getInt("surplus_num") < productNum) {
					renderFaile("剩余数量不够");
					return;
				}
			}

			/**下单*/
			boolean save=order.save();
			if(save){
				orderService.splice2Create_a(order.getStr("order_id"), items,activityId);
				/**下单后 程序推送**/
				Map<String,Object> pu=new HashMap<String,Object>();
				pu.put("orderId",order.getStr("order_id"));
				JPushKit.push(shop.getStr("phone"), "shop", IConstant.content_order_new, pu, "");
				/**下单后 短信推送**/
				if (order.getInt("pay_type") == 3) {
					String str = ",收货人:" + o.getStr("name");
					str += ",联系电话：" + o.getStr("phone");
					str += ",收获地址:" + o.getStr("address");
					str += ",支付方式：" + o.getStr("pay_name");
					str += ",购买产品：【";
					for (Record r : o.getOrderItems(o.getStr("uuid"))) {
						str += r.getStr("name") + "*" + r.getInt("product_number") + ",";
					}
					str += "】";
					str += "总价:" + o.getInt("price") / 100 + "元";
					SdkMessage.sendUser(shop.getStr("phone"), str);
				}
				IConstant.orderQueue.remove();//从队列移除第一个项目
			}
		}
		renderSuccess("购买成功", o);
	}


//	@ActionKey("app/user/addActivityOrder")
//	@Before(Tx.class)
//	public void addActivityOrder(){
//		JSONObject json= JSONObject.fromObject(getPara("info"));
//		String uid=json.getString("uid");
//		String s_uid=json.getString("s_uid");
//		int activityId=json.getInt("activity_id");
//		JSONObject obj=checkActivity(activityId, uid);
//		if(obj.containsKey("code")&&obj.getInt("code")==10001){
//			renderFaile(obj.getString("msg"));
//			return;
//		}
//		Shop s=Shop.dao.findBysuid(s_uid);
//		if(s==null){
//			renderFaile("异常");
//			return;
//		}
//		boolean b=new User().isLogin(uid);
//		if(!b){
//			renderFaile("请登录！");
//			return;
//		}
//		String orderNo= M.getOrderNo();
//		String orderId= M.getOrderId();
//		String items=json.getString("orderItems");
//		if(items==null || items.equals("")){
//			renderFaile("购买产品异常");
//			return;
//		}
//		Record r=new Record();
//		r.set("order_no",orderNo);
//		r.set("order_id",orderId);
//
//		int order_status= IConstant.OrderStatus.order_status_chushi;
//		if(json.getInt("pay_type")==3){
//			order_status= IConstant.OrderStatus.order_status_dfh;
//		}
//		if(json.containsKey("remark")){
//			r.set("remark",json.getString("remark"));
//		}
//		r.set("order_status",order_status);
//		r.set("create_time",new Date());
//		r.set("price",json.getInt("price"));
//		r.set("u_uuid",uid);
//		r.set("s_uid",json.getString("s_uid"));
//		r.set("address_id",json.getInt("address_id"));
//		r.set("pay_type",json.getInt("pay_type"));
//		Record ra= Db.findById("kk_user_address", json.getInt("address_id"));
//		r.set("address", ra.get("full_address"));
//		Record rp= Db.findById("kk_pay_type", json.getInt("pay_type"));
//		r.set("pay_name", rp.getStr("pay_type_name"));
//		/**
//		 * 队列
//		 * */
//		IConstant.orderQueue.insert(r);//放入队列中
//		while(!IConstant.orderQueue.isEmpty()){
//			Record record=IConstant.orderQueue.peekFront();//取队列第一个元素
//			JSONArray array = JSONArray.fromObject(items);
//			for(int i=0;i<array.size();i++) {
//				JSONObject o = array.getJSONObject(i);
//				int productId = o.getInt("productId");
//				int productNum = o.getInt("productNum");
//				Record pr = Db.findFirst("select * from kk_product_activity pa where pa.id=? and activity_id=?", productId, activityId);
//				if (pr.getInt("surplus_num") < productNum) {
//					renderFaile("剩余数量不够");
//					return;
//				}
//			}
//			/**下单*/
//			boolean save=Db.save("kk_order_activity", record);
//			if(save){
//				for(int i=0;i<array.size();i++){
//					JSONObject o = array.getJSONObject(i);
//					int productId = o.getInt("productId");
//					int productNum = o.getInt("productNum");
//					Record pr= Db.findFirst("select * from kk_product_activity pa where pa.id=? and activity_id=?",productId, activityId);
//					Db.update("insert kk_order_activity_item(order_id,product_id,product_number," +
//									"product_price,cash_pay,product_pay,create_time) values(?,?,?,?,?,?,?)", orderId, productId, productNum, pr.getBigDecimal("price"),
//							pr.getBigDecimal("cash_pay"), pr.getBigDecimal("price").intValue() - pr.getBigDecimal("cash_pay").intValue(), new Date());
//					/**减少库存数量*/
//					Db.update("update kk_product_activity set surplus_num=surplus_num-? where id=?",productNum,productId);
//				}
////				if(r.getInt("pay_type")==3){
////					orderService.pushBySdk(ConfigUtils.getProperty("kaka.order.activity.manager.phone"), r.getStr("order_id"),2);
////				}
//				IConstant.orderQueue.remove();//从队列移除第一个项目
//			}
//		}
//		renderSuccess("购买成功", r);
//	}




	@ActionKey("app/user/activityOrderPay")
	public void activityOrderPay(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String orderId=json.getString("order_id");
		if(orderId==null || orderId.equals("")){
			renderFaile("订单异常");
			return;
		}
		Record record= Db.findFirst("select * from kk_order_activity oa where oa.order_id=?", orderId);
		if(record==null){
			renderFaile("订单异常");
			return;
		}
		if(record.getInt("order_status")!= IConstant.OrderStatus.order_status_chushi){
			renderFaile("订单状态异常");
			return;
		}
		record.set("order_status", IConstant.OrderStatus.order_status_dfh);
		Db.update("kk_order_activity", record);
		orderService.pushBySdk(ConfigUtils.getProperty("kaka.order.activity.manager.phone"), orderId, 2);
		renderSuccess("成功",null);
	}


	@ActionKey("app/user/activityPros")
	public void activityPros(){
		JSONObject json= JSONObject.fromObject(getPara("info"));
		int page=1;
		if(json.containsKey("pg")){
			page=json.getInt("pg");
		}
		int actType_id = json.getInt("activityId");
		Page<Record> recordPage=Db.paginate(page,IConstant.PAGE_DATA,"select id as productId,name,title,price,cash_pay,cover_img,p_unit_name,create_time,limit_num,surplus_num,p_type_id,p_type_name,p_brand_id,p_brand_name","from kk_product_activity pa where pa.activity_id=?",actType_id);
		renderSuccess("获取成功",recordPage);
	}


//	@ActionKey("/app/user/refundInfo")
//	public void refundInfo(){
//		log.info("refundOrder");
//		JSONObject obj= JSONObject.fromObject(getPara("info"));
//		if(!obj.containsKey("u_id")||!obj.containsKey("order_id")){
//			renderFaile("退款异常，参数错误");
//			return;
//		}
//		Record r=loadWXconfig(obj.getString("u_id"));
//		Map<String,Object> map=WXUtil.refundQuery(obj.getString("order_id"),r);
//		renderSuccess("获取成功",map);
//		return;
//	}

}
