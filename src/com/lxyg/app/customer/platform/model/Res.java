package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;

import java.util.List;

public class Res extends Model<Res> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 109L;
	public static final Res dao = new Res();

	public static List<Res> findMyByParentId(int parentId, int userId) {
		String sql="SELECT DISTINCT res.* FROM kk_manager m LEFT JOIN kk_role_res r ON m.role_id = r.roleid LEFT JOIN kk_res res ON res.resid = r.resid WHERE res.flag = 0 AND m.id =? AND res.parentid =? ORDER BY orderno";
		
		return Res.dao
				.find(sql,
						userId, parentId);
	}

	public static List<Res> findAllByType(int restype) {
		return Res.dao.find("SELECT * FROM hc_res where flag=0 and restype=?", restype);
	}

	public static List<Res> findMyNameByType(int uid, int restype) {
		return Res.dao
				.find("SELECT r.resname as cname FROM hc_res r LEFT JOIN  hc_role_res rr ON r.resid=rr.resid  left join hc_user_role ur on ur.roleid=rr.roleid where uid=? and r.restype=? order by orderno",
						uid, restype);
	}

	public static List<Res> findMyNameByParentId(int userId, int resParId) {
		return Res.dao
				.find("SELECT r.resname as cname FROM hc_res r LEFT JOIN  hc_role_res rr ON r.resid=rr.resid  left join hc_user_role ur on ur.roleid=rr.roleid where uid=? and r.parentid=? order by orderno",
						userId, resParId);
	}

	public static Res findByColid(int id) {
		return Res.dao.findFirst("select * from hc_res where columnid=?", id);
	}

	public static boolean delBycolumnId(int cid) {
		Res r = Res.dao.findFirst("select * from hc_res where columnid=?", cid);
		delRole_Res(r.getInt("resid"));
		return r.delete();
	}

	public static void delRole_Res(int resid) {
		String sql = "select * from hc_role_res where resid=?";
		List<Record> rlist = Db.find(sql, resid);
		for (Record r : rlist) {
			Db.delete("hc_role_res", r);
		}
	}
}
