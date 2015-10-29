package com.lxyg.app.customer.platform.controller;

import com.jfinal.aop.Before;
import com.jfinal.core.Controller;
import com.jfinal.ext.interceptor.POST;
import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Manager;
import com.lxyg.app.customer.platform.model.Res;
import com.lxyg.app.customer.platform.util.ConfigUtils;
import com.lxyg.app.customer.platform.util.QiniuImgUtil;
import com.qiniu.util.Auth;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import sun.misc.BASE64Decoder;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class ResController extends Controller {
	private static final Logger log= Logger.getLogger(ResController.class);
	
////	private LogService logService = new LogService();
//
//	public void list() {
//		List<Res> resList = Res.dao
//				.find("select * from hc_res where restype=0");
//		List<Res> resList2 = Res.dao
//				.find("select * from hc_res where restype=1");
//		setAttr("res", resList);
//		setAttr("res2", resList2);
////		User user = (User) getSession().getAttribute("user");
////		logService.add(user.getInt("uid"), IConstant.SHOW, "查看菜单列表",
////				IPUtil.getIpAddr(getRequest()));
//		render("/sys/resList.jsp");
//	}
//
//	public void faList() {
//		List<Res> resList = Res.dao
//				.find("select * from hc_res where restype=0");
//		setAttr("res", resList);
//		String msg = getPara("msg");
//		System.out.println(msg);
//		setAttr("msg", msg);
//		render("/sys/addRes.jsp");
//	}
//
//	public void role_res() {
//		List<Res> resList = Res.findAllByType(0);
//		List<Res> resList2 = Res.findAllByType(1);
//		setAttr("res", resList);
//		setAttr("res2", resList2);
//		List<Res> resList3 = new ArrayList<Res>();
//		resList3 = Res.findAllByType(4);
//		setAttr("res3", resList3);
//		int roleid = getParaToInt("roleId");
//		setAttr("roleId", roleid);
//		List<Record> roleResList = Db.find("select r.resid,e.resname from hc_role_res r LEFT JOIN hc_res e ON r.resid=e.resid where roleid=?", roleid);
//		setAttr("roleRes", roleResList);
//		render("/sys/role_res.jsp");
//	}
//
	
	public void load(){
		HttpServletRequest req=getRequest();
		BufferedReader reader;
		try {
			reader = req.getReader();
			StringBuffer buf=new StringBuffer();
			String string;
			while ((string = reader.readLine()) != null) {
				buf.append(string);
			}
		} catch (IOException e) {
			
		}
		getPara("page");
		setAttr("page",getPara("page"));
		renderJson();
	}
	
	
	
	public void loadImgToken(){
		String ak= ConfigUtils.getProperty("kaka.qiniu.ak");
		String sk= ConfigUtils.getProperty("kaka.qiniu.sk");
		Auth auth = Auth.create(ak, sk);
		String token=auth.uploadToken("lxyg");
		System.out.println(token);
		setAttr("token", token);
		setAttr("code", 10010);
		renderJson();
	}
	
	@Before(POST.class)
	public void addImg(){
		log.info("addImg");
		JSONObject json= JSONObject.fromObject(getPara("info"));
		String str=getPara("ImgData");
		if(str==null){
			str=json.getString("ImgData");
		}
		String key="";
		if(str!=null){
			try {
				byte[] buffer = new BASE64Decoder().decodeBuffer(str);
				key= QiniuImgUtil.upload(buffer);
			} catch (IOException e1) {
				log.error("error", e1);
			}			
		}
		setAttr("code", 10002);
		setAttr("msg", "上传成功");
		setAttr("data", ConfigUtils.getProperty("kaka.qiniu.server")+key);
		renderJson();
	}
	
	
	
	
	public void home() {
		Manager user = (Manager) getSession().getAttribute("manager");
		if (null != user) {
			int userId = user.get("userId");
			List<Record> res = Db
					.find("SELECT r.resid FROM kk_role_res r LEFT JOIN kk_manager m ON r.roleid=m.role_id WHERE m.id = ?; ", userId);
			setAttr("myRes", res);
			String sql="SELECT DISTINCT rs.* FROM kk_manager m LEFT JOIN kk_role_res res ON m.role_id = res.roleid LEFT JOIN kk_res rs on res.resid=rs.resid WHERE m.id = ? and rs.flag=0 order by orderno";
			List<Res> resList = Res.dao.find(sql,userId);
			List<Res> resList2 = new ArrayList<Res>();
			int parentId;
			if (null != resList && resList.size() > 0) {
				if (null == getPara("parentId")) {
					parentId = resList.get(0).getInt("resid");
				} else {
					parentId = getParaToInt("parentId");
				}
				resList2 = Res.findMyByParentId(parentId, userId);
				if (null != resList2 && resList2.size() > 0) {
					String url = resList2.get(0).getStr("url");
					setAttr("defaultUrl", url);
				} else {
					String url = "common/noRes.jsp";
					setAttr("defaultUrl", url);
				}
				setAttr("res", resList);
				setSessionAttr("rl", resList);
				setAttr("res2", resList2);
				render("/index.jsp");
			} else {
				render("/common/noRes.jsp");
			}
		} else {
			render("/login.jsp");
		}
	}
//
//	public void add() {
//		Res res = getModel(Res.class);
//		System.out.println(res.get("resname"));
//		res.save();
//		redirect("/res/faList?msg=Suc", true);
//	}
}
