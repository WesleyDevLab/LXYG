package com.lxyg.app.customer.platform.model;

import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Model;
import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.util.IConstant;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class User extends Model<User> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 111L;
	public static final User dao = new User();

	public Map<String, Object> getAttrs() {
		return super.getAttrs();
	}

	private String login_version=" login_ios_inhouse,login_ios_inapp,login_android_in_test,login_android_pub ";
	public User getUser(String uuid){
		return new User().findFirst("select id as userId,name,password,phone," +
				"head_img,shop_id,cash_pay,score,wechat_id,uuid,"+login_version+" from kk_user u where u.uuid=?",new Object[]{uuid});
	}
	
	
	public boolean isLogin(String uuid){
		if(uuid==null||uuid.equals("")){
			return false;
		}
		User u=dao.findFirst("select count(id) as num from kk_user u where u.uuid=?",new Object[]{uuid});
		Long num=u.getLong("num");
		if(num==0){
			return false;
		}
		return true;
	}
	
	
	public Record getAreaCode(String provinceName,String cityName,String areaName){
		String sql="SELECT a.`code` AS pcode, b.`code` AS ccode, c.`code` AS acode " +
				"FROM kk_area a, kk_area b, kk_area c WHERE a.`name` LIKE ? AND b.`name` LIKE ? AND c.`name` LIKE ?";
		return Db.findFirst(sql, new Object[]{"%" + provinceName + "%", "%" + cityName + "%", "%" + areaName + "%"});
	}
	
	
	
	public void createCashLog(String userUUID,int cash_id,int type,int cash){
			Record r=new Record();
			r.set("type", type);
			r.set("type_name", IConstant.cashLog.get(type));
			r.set("create_time", new Date());
			r.set("u_uuid", userUUID);
			r.set("user_cash_id", cash_id);
			r.set("cash", cash);
			Db.save("kk_user_cash_log", r);
	}
	
	
	
	public void addCash(int cash_id,int cashitemId,String userUUID,int cash){
		Record r=new Record();
		r.set("cash_id", cash_id);
		r.set("cash_item_id", cashitemId);
		r.set("cash", cash);
		r.set("u_uuid", userUUID);
		r.set("create_time", new Date());
		Db.save("kk_user_cash", r);
		dao.createCashLog(userUUID, r.getLong("id").intValue(), IConstant.cashLog.cash_log_type_add, cash);
	}

	public void reduceCash(String userUUID,int reduce){
		Record r= Db.findFirst("select * from kk_user_cash where u_uuid=? ", new Object[]{userUUID});
		int b=r.getBigDecimal("cash").intValue();
		b=b-reduce;
		r.set("cash", b);
		r.set("u_uuid", userUUID);
		r.set("create_time", new Date());
		Db.update("kk_user_cash", r);
		dao.createCashLog(userUUID, r.getInt("id"), IConstant.cashLog.cash_log_type_del,b);
	}
	
	public void delCash(int cashId,String userUUID,int cash){
		Record r= Db.findById("select * from kk_user_cash where u_uuid=? and id=? ", new Object[]{userUUID, cashId});
		int b=r.getBigDecimal("cash").intValue();
		b=b-cash;
		r.set("cash", b);
		r.set("u_uuid", r.getStr("uuid"));
		r.set("create_time", new Date());
		Db.save("kk_user_cash", r);
		dao.createCashLog(userUUID, r.getLong("id").intValue(), IConstant.cashLog.cash_log_type_del,b);
	}
	
	
	/**
	 *领取电子现金券
	 * **/
	public void getCash(String uid,int cash_id){
		Record re= Db.findFirst("select * from kk_cash_item where cash_item_status=1 and cash_id=?", new Object[]{cash_id});
		if(re!=null){
			addCash(cash_id,re.getInt("id"), uid, re.getBigDecimal("cash_price").intValue());
			re.set("cash_item_status", 2);
			re.set("get_time", new Date());
			Db.update("kk_cash_item", re);
		}
	}

	public void addExceptionMessage(String order_id,String phone){
		Record record=new Record();
		record.set("order_id",order_id);
		record.set("phone",phone);
		record.set("is_send",1);
		Db.save("kk_exception_message", record);
	}

	public boolean isExistsException(String order_id,String phone){
		List<Record> res= Db.find("select * from kk_exception_message em where em.order_id=? and em.phone=?", order_id, phone);
		if(res.size()==0){
			return true;
		}
		return false;
	}
	/**
	 * 登陆记录
	 * **/
	public void addSignLog(String u_uid){
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		Date d=new Date();
		int mg=1;
		int num=1;
		Record r=Db.findFirst("select * from kk_login_sign where u_uid=? order by  id desc limit 0,1",u_uid);
		if(r==null){
			Record record=new Record();
			record.set("u_uid",u_uid);
			record.set("create_time",new Date());
			record.set("num", num);
			record.set("mg", mg);
			Db.save("kk_login_sign",record);
			addIntegral(mg,u_uid,2);
			return;
		}
		String last_sign=sdf.format(r.getDate("create_time"));
		if(last_sign.equals(sdf.format(d))){
			return;
		}
		Record r1=new Record();
		r1.set("u_uid", u_uid);
		r1.set("create_time", d);

		Calendar calendar=Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.DAY_OF_MONTH, -1);

		if(sdf.format(calendar.getTime()).equals(last_sign)){
			num=r.getInt("num")+1;
			if(r.getInt("mg")<5){
				mg=r.getInt("mg")+1;
			}else{
				mg=r.getInt("mg");
			}
		}
		r1.set("num", num);
		r1.set("mg", mg);
		Db.save("kk_login_sign", r1);
		addIntegral(mg,u_uid,2);
	}

//添加积分
	public  void addIntegral(int integral,String u_uid,int type){
		Record record=Db.findFirst("select * from kk_integral where u_uid=? and type=?",u_uid,type);
		if(record!=null){
			record.set("integral",record.getInt("integral")+integral);
			Db.update("kk_integral",record);
			return;
		}
		record=new Record();
		record.set("u_uid",u_uid);
		record.set("integral",integral);
		record.set("create_time",new Date());
		record.set("type",type);
		Db.save("kk_integral",record);
	}
}
