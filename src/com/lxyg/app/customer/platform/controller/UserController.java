package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.Controller;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.jfinal.plugin.activerecord.tx.Tx;
import com.lxyg.app.customer.platform.model.Manager;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.M;
import com.lxyg.app.customer.platform.util.MD5ForDiscuz;
import org.apache.log4j.Logger;

import java.util.Date;

public class UserController extends Controller {
	private static final Logger log= Logger.getLogger(UserController.class);
	//
	// private UserService userService = new UserService();
	// private Column columnService = new Column();
	// private ShopService shopService = new ShopService();
	// private ExportService exportService = new ExportService();
	// private LogService logService = new LogService();

	// public void index() {
	// if (getSession().getAttribute("user") != null) {
	// System.out.println(getSession().getAttribute("user"));
	// User user = (User) getSession().getAttribute("user");
	// int isSeller = user.getInt("isseller");
	// if (isSeller == 0) {
	// redirect("/res/home");
	// } else {
	// int uid = user.getInt("uid");
	// int shopId = userService.getShopID(uid);
	// String shopname = shopService.getShopName(shopId);
	// setAttr("shopName", shopname);
	// setAttr("shopId", shopId);
	// render("/shop/index.jsp");
	// }
	// } else {
	// render("/login.jsp");
	// }
	// }
	//

	/**
	 * 管理员登录
	 */
	public void login() {
		log.info("后台登录");
		int isSeller = -1;
		String userpwd = MD5ForDiscuz.npwd(getPara("password"));
		Manager user = Manager.dao
				.findFirst(
						"select i.id as userId,i.usercode,i.username,i.phone,i.full_address,i.role_id,i.role_name from kk_manager i where i.phone=?  and i.userpass=?",
						getPara("username"), userpwd);
		if (null != user) {
			if (null != user.get("role_id")) {
				setSessionAttr("manager", user);
				
				isSeller = user.getInt("role_id");
				if (isSeller == 0) {// 管理员
					log.info("管理员登录");

					redirect("/res/home");
				} else if (isSeller == 1) {// 商家
					log.info("商家登录");
					/**
					 * 预留商家登录
					 * 
					 * **/
				} else {
					setAttr("msg", "对不起，您没有权限登录！");
					render("/login.jsp");
				}
			}else{
				setAttr("msg", "对不起，您没有权限登录！");
				render("/login.jsp");
			}
		} else {
			setAttr("msg", "用户名不存在");
			render("/login.jsp");
		}
	}
	
	/**
	 * 分发电子代金券
	 */
	@Before(Tx.class)
	public void createCash(){
		Record r=new Record();
		int total=getParaToInt("total");
		int count=getParaToInt("count");
		int unit=getParaToInt("unit");
		int status= IConstant.cash.cash_status_h;
		String title="";
		String content="";
		String img="";
		if(getPara("title")!=null){
			title=getPara("title");		
			r.set("cash_title", title);
		}
		if(getPara("content")!=null){
			content=getPara("content");	
			r.set("cash_content", content);
		}
		if(getPara("img")!=null){
			img=getPara("img");	
			r.set("cash_img", img);
		}
		r.set("cash_total", total);
		r.set("cash_count", count);
		r.set("cash_status", status);
		r.set("create_time", new Date());
		r.set("cash_unit", unit);
		Db.save("kk_cash", r);
		String sql=M.getCashItemSql(r.getLong("id").intValue(), count, unit);
		int b= Db.update("insert into kk_cash_item(cash_id,cash_price,cash_item_status) values " + sql);
		if(b>0){
			setAttr("code", 10002);
			setAttr("msg", "成功");
			renderJson();
		}
	}

	//
	// /**
	// * 会员列表
	// */
	// public void list() {
	// int pg = 1;
	// if (null != getPara("pg")) {
	// pg = getParaToInt("pg");
	// }
	// setAttr("pg", pg);
	// int isseller = getParaToInt("type");
	// String username = getPara("realname");
	// System.out.println(username);
	// // if (pg > 1) {
	// // username = getPara("realname");
	// // if (StrKit.notBlank(username)) {
	// // try {
	// // username = new String(getRequest().getParameter("realname")
	// // .getBytes("ISO-8859-1"), "utf-8");
	// // username = WebUtils.replaceStr(username);
	// // } catch (UnsupportedEncodingException e) {
	// // e.printStackTrace();
	// // }
	// // }
	// // }
	// Page<User> userList = UserService.search(username, pg, 40, isseller);
	// setAttr("pageBean", userList);
	// setAttr("type", isseller);
	// setAttr("realname", username);
	// if (isseller == 1) {
	// List<Column> columnList = columnService.columnList(4);// 优惠栏目
	// setAttr("colList", columnList);
	// render("/user/shop.jsp");
	// } else {
	// render("/user/userlist.jsp");
	// }
	// }
	//
	// /**
	// * 会员列表
	// */
	// public void searchByAddress() {
	// int pg = 1;
	// if (null != getPara("pg")) {
	// pg = getParaToInt("pg");
	// }
	// setAttr("pg", pg);
	// int isseller = getParaToInt("type");
	// String address = getPara("address");
	// System.out.println(address);
	// // if (pg > 1) {
	// // if (StrKit.notBlank(address)) {
	// // try {
	// // address = new String(getRequest().getParameter("address")
	// // .getBytes("ISO-8859-1"), "utf-8");
	// // address = WebUtils.replaceStr(address);
	// // } catch (UnsupportedEncodingException e) {
	// // e.printStackTrace();
	// // }
	// // }
	// // }
	// Page<User> userList = UserService.searchByAddress(address, pg, 40,
	// isseller);
	// setAttr("pageBean", userList);
	// setAttr("type", isseller);
	// if (isseller == 1)
	// render("/user/shop.jsp");
	// else {
	// setAttr("address", address);
	// render("/user/userlist.jsp");
	// }
	// }
	//
	// /**
	// * 会员列表通过会员手机号查询
	// */
	// public void searchByMobile() {
	// int pg = 1;
	// int pageSize = 40;
	// if (null != getPara("pg")) {
	// pg = getParaToInt("pg");
	// }
	// setAttr("pg", pg);
	// int isseller = getParaToInt("type");
	// String mobile = getPara("mobile");
	// String select = "select i.*";
	// String sql =
	// "from hc_members_info i where i.isseller=? and i.mobile like '%"
	// + mobile + "%'";
	// Page<Record> userList = Db
	// .paginate(pg, pageSize, select, sql, isseller);
	// setAttr("pageBean", userList);
	// setAttr("type", isseller);
	// if (isseller == 1)
	// render("/user/shop.jsp");
	// else {
	// setAttr("mobile", mobile);
	// render("/user/userlist.jsp");
	// }
	// }
	//
	// /**
	// * 根据是否认证筛选商家列表
	// */
	// public void toSift() {
	// int pg = 1;
	// if (null != getPara("pg")) {
	// pg = getParaToInt("pg");
	// }
	// setAttr("pg", pg);
	// int isseller = getParaToInt("type");
	//
	// int approve = getParaToInt("approve");
	// // if (approve == 0 || approve == 1) {
	// Page<User> userList = UserService.toSift(approve, pg, 40, isseller);
	// setAttr("pageBean", userList);
	// setAttr("type", isseller);
	// setAttr("approve", approve);
	// List<Column> columnList = columnService.columnList(4);// 优惠栏目
	// setAttr("colList", columnList);
	// render("/user/shop.jsp");
	// // } else {
	// // String username = getPara("username");
	// // Page<User> userList = UserService
	// // .search(username, pg, 10, isseller);
	// // setAttr("pageBean", userList);
	// // setAttr("type", isseller);
	// // if (isseller == 1) {
	// // List<Column> columnList = columnService.columnList(4);// 优惠栏目
	// // setAttr("colList", columnList);
	// // render("/user/shop.jsp");
	// // } else
	// // render("/user/userlist.jsp");
	// // }
	//
	// }
	//
	// /**
	// * 根据分类筛选商家列表
	// */
	// public void toColumn() {
	// int pg = 1;
	// int pageSize = 40;
	// if (null != getPara("pg")) {
	// pg = getParaToInt("pg");
	// }
	// setAttr("pg", pg);
	// int isseller = getParaToInt("type");
	// int cid = getParaToInt("cid");
	//
	// String select =
	// "select i.*,sp.shopname,sp.shopid,sp.flag,sp.approve,sp.approvetime";
	// String sql =
	// "from hc_members_info i LEFT JOIN hc_shop sp ON i.uid=sp.uid WHERE i.isseller=? "
	// + "and (sp.flag=1 or sp.flag=0) AND sp.columnid=?";
	//
	// Page<Record> userList = Db.paginate(pg, pageSize, select, sql,
	// isseller, cid);
	// setAttr("pageBean", userList);
	// setAttr("type", isseller);
	// if (isseller == 1) {
	// List<Column> columnList = columnService.columnList(4);// 优惠栏目
	// setAttr("colList", columnList);
	// setAttr("cid", cid);
	// render("/user/shop.jsp");
	// } else {
	// render("/user/userlist.jsp");
	// }
	// }
	//
	// /**
	// * 角色管理
	// */
	// public void addRole() {
	// String rid = getPara("roleId");
	// int userid = getParaToInt("userId");
	// String sql = "select * from hc_user_role where uid=?";
	// List<Record> list = Db.find(sql, userid);
	// if (null != list) {
	// for (Record record : list) {
	// Db.delete("hc_user_role", record);
	// }
	// }
	// String roleId[] = rid.split(",");
	// for (String s : roleId) {
	// int roleid = Integer.parseInt(s);
	// Record role = Db.findById("hc_role", "roleid", roleid);
	// Record r = new Record();
	// r.set("uid", userid);
	// r.set("roleid", roleid);
	// r.set("rolename", role.get("name"));
	// Db.save("hc_user_role", r);
	// logService.add(userid, IConstant.ADD, "增加管理员权限", IPUtil
	// .getIpAddr(getRequest()));
	// }
	// renderJson();
	// }
	//
	// public void exit() {
	// User user = (User) getSession().getAttribute("user");
	// if (null != user) {
	// int uid = user.getInt("uid");
	// logService.add(uid, IConstant.EXIT, "退出平台", IPUtil
	// .getIpAddr(getRequest()));
	// getSession().removeAttribute("user");
	// getSession().invalidate();
	// render("/login.jsp");
	// } else {
	// render("/login.jsp");
	// }
	// }
	//
	// /**
	// * 修改密码
	// */
	// public void editPa() {
	// String opa = "";
	// String npa = "";
	// String salt = "";
	// User us = (User) getSession().getAttribute("user");
	// int uid = us.getInt("uid");
	// Record r = Db.findById("hc_members_info", "uid", uid);
	// salt = r.getStr("salt");
	// opa = MD5ForDiscuz.npwd(getPara("opa"), salt);
	// String nsalt = MD5ForDiscuz.getCharAndNumr(6);
	// npa = MD5ForDiscuz.npwd(getPara("npa"), nsalt);
	// if (r.get("password").equals(opa)) {
	// r.set("salt", nsalt);
	// r.set("password", npa);
	// if (Db.update("hc_members_info", "uid", r)) {
	// logService.add(uid, IConstant.EDIT, "修改密码", IPUtil
	// .getIpAddr(getRequest()));
	// renderJson("0");
	// } else {
	// renderJson("1");
	// }
	// } else {
	// renderJson("2");
	// }
	// }
	//
	// /**
	// * 重置商家密码
	// */
	// public void resetPass() {
	// String npa = getPara("npa");
	// int shopId = getParaToInt("shopId");
	// int uid = shopService.getUID(shopId);
	// Record r = Db.findById("hc_members_info", "uid", uid);
	// String nsalt = MD5ForDiscuz.getCharAndNumr(6);
	// String npass = MD5ForDiscuz.npwd(npa, nsalt);
	// r.set("salt", nsalt);
	// r.set("password", npass);
	// if (Db.update("hc_members_info", "uid", r)) {
	// renderJson("0");
	// } else {
	// renderJson("1");
	// }
	// }
	//
	// /**
	// * 删除商家信息
	// */
	// public void delShop() {
	// int shopId = getParaToInt("shopId");
	// Record r = Db.findById("hc_shop", "shopid", shopId);
	//
	// int uid = r.getInt("uid");
	// Db.deleteById("hc_shop", "shopid", shopId);// 删除商家信息
	// Db.deleteById("hc_members_info", "uid", uid);// 删除商家详细信息
	//
	// String sql = "select * from hc_shop_card where shopid=?";
	// String s = "select * from hc_shop_goods where shopid=?";
	// String s1 = "select * from hc_shop_type where shopid=?";
	// String s2 = "select * from hc_user_collect where type=0 and cid=?";//
	// 会员收藏商家
	// String s3 = "select * from hc_user_collect where type=1 and cid=?";//
	// 会员收藏产品
	// String s5 = "select * from hc_shop_draw where shopid=?";
	// String sl = "select * from hc_user_card where cardid=?";
	//
	// List<Record> type = Db.find(s1, shopId);
	// if (null != type) {
	// for (Record record : type) {
	// Db.delete("hc_shop_type", record);// 删除推荐等中含有删除商家信息
	// }
	// }
	//
	// List<Record> list = Db.find(s2, shopId);
	// if (null != list) {
	// for (Record record : list) {
	// Db.delete("hc_user_collect", "collectid", record);// 删除会员收藏删除商家
	// }
	// }
	//
	// DeleteShop ds = new DeleteShop(shopId); // 异步删除商家消费信息
	// Thread t = new Thread(ds);
	// t.start();
	//
	// List<Record> draw = Db.find(s5, shopId);
	// if (null != draw) {
	// for (Record record : draw) {
	// Db.delete("hc_shop_draw", "id", record);// 删除商家的展示图片
	// }
	// }
	//
	// List<Record> goods = Db.find(s, shopId);
	// if (null != goods) {
	// for (Record g : goods) {
	// int goodsId = g.getInt("goodsid");
	// List<Record> collect = Db.find(s3, goodsId);
	// if (null != collect) {
	// for (Record record : collect) {
	// Db.delete("hc_user_collect", "collectid", record);// 删除会员收藏删除商家的产品
	// }
	// }
	// Db.delete("hc_shop_goods", "goodsid", g); // 删除商家产品
	// }
	// }
	//
	// List<Record> card = Db.find(sql, shopId);
	// if (null != card) {
	// for (Record r1 : card) {
	// int cardId = r1.getInt("cardid");
	// List<Record> uc = Db.find(sl, cardId);
	// if (null != uc) {
	// for (Record r2 : uc) {
	// Db.delete("hc_user_card", r2);// 删除会员领取商家的卡
	// }
	// }
	// Db.deleteById("hc_shop_card", "cardid", cardId);// 删除商家会员卡
	// }
	// }
	//
	// renderJson("0");
	// }
	//
	// class DeleteShop implements Runnable {
	// private int shopId;
	//
	// public DeleteShop() {
	//
	// }
	//
	// public DeleteShop(int shopId) {
	// this.shopId = shopId;
	// }
	//
	// public void run() {
	// String sql = "select * from hc_order where sellerId=?";// 商家消费记录
	//
	// List<Record> consume = Db.find(sql, shopId);
	// if (null != consume) {
	// for (Record record : consume) {
	// Db.delete("hc_order", "orderId", record);// 删除商家消费记录
	// }
	// }
	// }
	// }
	//
	// /**
	// * 用户详细信息
	// */
	// public void detail() {
	// int uid = getParaToInt("uid");
	// User u = UserService.findFrist(uid);
	// Record r = userService.detailRecord(uid);
	// setAttr("userinfo", u);
	// setAttr("r", r);
	// render("/user/userDetail.jsp");
	// }
	//
	// public void preAdd() {
	// int isseller = getParaToInt("type");
	// if (isseller == 1) {
	// List<Column> columnList = columnService.columnList(4);// 优惠栏目
	// setAttr("colList", columnList);
	// setAttr("type", isseller);
	// render("/user/add.jsp");
	// }
	// }
	//
	// /**
	// * 添加商家、管理员
	// */
	// public void add() {
	// int isseller = getParaToInt("type");
	// User user = getModel(User.class);
	// String password = getPara("password");
	// String pwd = "";
	// User u = userService.findByName(user.getStr("username"));
	// if (null != u) {
	// renderJson("2");
	// return;
	// } else {
	// String salt = MD5ForDiscuz.getCharAndNumr(6);
	// pwd = MD5ForDiscuz.npwd(password, salt);
	// user.set("password", pwd);
	// user.set("salt", salt);
	// }
	// if (user.save()) {
	// int uid = user.getInt("uid");
	// String mobile = getPara("mobile");
	// String address = getPara("address");
	// String realname = getPara("realname");
	//
	// if (isseller == 1) {
	// if (userService.updateUser(mobile, address, realname, uid,
	// isseller)) {
	// int columnId = getParaToInt("columnId");
	// String telphone = getPara("telphone");
	// String shopname = getPara("shopname");
	// shopService.saveShop(shopname, address, telphone, uid,
	// columnId);
	// logService.add(uid, IConstant.ADD, "添加商家管理员", IPUtil
	// .getIpAddr(getRequest()));
	// }
	// renderJson("0");
	// return;
	// } else if (isseller == 0) {
	// if (userService.updateUser(mobile, address, realname, uid,
	// isseller)) {
	// logService.add(uid, IConstant.ADD, "添加系统管理员", IPUtil
	// .getIpAddr(getRequest()));
	// }
	// renderJson("0");
	// return;
	// }
	// } else {
	// renderJson("1");
	// return;
	// }
	// }
	//
	// public void update() {
	// int uid = getParaToInt("uid");
	// Record i = Db.findById("hc_members_info", "uid", uid);
	// if (null != getPara("realname"))
	// i.set("realname", getPara("realname"));
	// if (null != getPara("mobile"))
	// i.set("mobile", getPara("mobile"));
	// if (null != getPara("address"))
	// i.set("address", getPara("address"));
	// if (null != getPara("isSeller"))
	// i.set("isseller", getPara("isSeller"));
	// if (null != getPara("idCard"))
	// i.set("idCard", getPara("idCard"));
	// if (Db.update("hc_members_info", "uid", i)) {
	// renderJson("0");
	// } else {
	// renderJson("1");
	// }
	// }
	//
	// public void toadd() {
	// setAttr("type", 0);
	// render("/user/addManage.jsp");
	// }
	//
	// /**
	// * 删除会员信息
	// */
	// public void delete() {
	// int uid = getParaToInt("uid");
	// int type = getParaToInt("type");
	// int pg = 1;
	// if (null != getPara("pg")) {
	// pg = getParaToInt("pg");
	// }
	// DeleteUid du = new DeleteUid(uid);// 删除会员的消费信息
	// Thread t = new Thread(du);
	// t.start();
	//
	// String s = "select * from hc_play_user where uid=?";
	// List<Record> pu = Db.find(s, uid);
	// if (null != pu) {
	// for (Record record : pu) {
	// Db.delete("hc_play_user", record);// 删除玩乐中，会员参与信息
	// }
	// }
	//
	// String s1 = "select * from hc_user_card where uid=?";
	// List<Record> uc = Db.find(s1, uid);
	// if (null != uc) {
	// for (Record record : uc) {
	// Db.delete("hc_user_card", record);// 删除会员的会员卡
	// }
	// }
	//
	// String s2 = "select * from hc_user_collect where uid=?";
	// List<Record> collect = Db.find(s2, uid);
	// if (null != collect) {
	// for (Record record : collect) {
	// Db.delete("hc_user_collect", "collectid", record);// 删除会员的收藏
	// }
	// }
	//
	// String s3 = "select * from hc_news_message where uid=?";
	// List<Record> nm = Db.find(s3, uid);
	// if (null != nm) {
	// for (Record record : nm) {
	// Db.delete("hc_news_message", "mid", record);// 删除会员的动态评论
	// }
	// }
	//
	// Db.deleteById("hc_members_info", "uid", uid);
	//
	// redirect("/user/list?type=" + type + "&pg=" + pg);
	// }
	//
	// class DeleteUid implements Runnable {
	// private int uid;
	//
	// public DeleteUid() {
	//
	// }
	//
	// public DeleteUid(int uid) {
	// this.uid = uid;
	// }
	//
	// public void run() {
	// String sql = "select * from hc_user_consume where uid=?";// 会员的消费信息
	// String s = "select * from hc_message where toid=?";// 会员的消息
	//
	// List<Record> consume = Db.find(sql, uid);
	// if (null != consume) {
	// for (Record record : consume) {
	// Db.delete("hc_user_consume", "consumeid", record);// 删除会员消费记录
	// }
	// }
	//
	// List<Record> message = Db.find(s, uid);
	// if (null != message) {
	// for (Record record : message) {
	// Db.delete("hc_message", "mid", record);// 删除会员的消息
	// }
	// }
	// }
	// }
	//
	// //
	// --------------------------------商家管理----------------------------------------
	// public void userList() {
	// int pageSize = IConstant.PAGE_DATA;
	// int pg = 1;
	// int shopId = 0;
	// String str = getPara("params.name");
	// if (WebUtils.isNotBlank(getPara("pg"))) {
	// pg = Integer.parseInt(getPara("pg"));
	// setAttr("pg", pg);
	// } else {
	// setAttr("pg", new Integer(1));
	// }
	// User user = (User) getSession().getAttribute("user");
	// if (null != user) {
	// int uid = user.getInt("uid");
	// shopId = shopService.getShopId(uid);
	// Page<User> page = userService.searchMem(pg, pageSize, shopId, str);
	// setAttr("page", page);
	// render("/shop/member/userinfo.jsp");
	// } else {
	// render("/login.jsp");
	// }
	// }
	//
	// /**
	// * 全字段导出
	// */
	// public void exportExcel() {
	// int shopId = 0;
	// User user = (User) getSession().getAttribute("user");
	// if (null != user) {
	// int uid = user.getInt("uid");
	// shopId = shopService.getShopId(uid);
	// List<User> list = userService.getAllMem(shopId); // 查询数据
	// // 导出
	// exportService.export(getResponse(), getRequest(), list);
	//
	// renderNull();
	// } else {
	// render("/login.jsp");
	// }
	// }
}
