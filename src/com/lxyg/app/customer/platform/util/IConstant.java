package com.lxyg.app.customer.platform.util;

import com.lxyg.app.customer.platform.Queue.orderQueue;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 常量类
 */
public interface IConstant {

	static orderQueue orderQueue=new orderQueue();

	/**
	 * 空格
	 */
	String WHITE_SPACE = "";

	/**
	 * 每页显示的数据量
	 */
	int PAGE_DATA = 12;

	/**
	 * 当前页面属性名
	 */
	String CUR_PAGE_NAME = "curPage";

	/**
	 * 当前
	 */
	String PAGE_DATA_NAME = "pageData";

	/**
	 * 要排序的属性名
	 */
	String ORDER_NAME = "orderName";

	/**
	 * 要排序的方式
	 */
	String ORDER_FLAG = "orderFlag";

	/**
	 * 看是否为数字
	 */
	String NUMBER_REGEX = "^[1-9]\\d*$";

	/**
	 * 默认为第一页
	 */
	int FIRST_PAGE = 1;

	String LOGIN = "LOGIN";
	String EXIT = "EXIT";
	String ADD = "ADD";
	String EDIT = "EDIT";
	String DELETE = "DELETE";
	String SHOW = "SHOW";

	public static int ZERO = 0;// 结束
	public static int START = 1;// 发起
	public static int TRANSFER = 2;// 流转
	public static int CANCEL = 3;// 撤销
	public static int SUSPEND = 4;// 挂起

	public static String startTime = DateTools.str2Str(DateTools.createDate()
			+ " 08:00:00");
	public static String endtTime = DateTools.str2Str(DateTools.createDate()
			+ " 23:00:00");

	public static Date startTime_d = DateTools.str2Date(DateTools.createDate()
			+ " 08:00:00");
	public static Date endtTime_d = DateTools.str2Date(DateTools.createDate()
			+ " 23:00:00");

	public static int send_type_jishi = 1;
	public static int send_type_dingshi = 2;

	// -1 未验证 0 验证中 1验证通过 2 未验证通过 3 问题商户 4 黑名单商户 q_verifi;
	public static int verifi_q_wyz = -1;
	public static int verifi_q_yzz = 0;
	public static int verifi_q_yztg = 1;
	public static int verifi_q_wyztg = 2;
	public static int verifi_q_wtsh = 3;
	public static int verifi_q_gmdsh = 4;

	int quanbu=1;
	int youhuo=2;

	 class sendType{
		public static int send_type_jishi = 1;
		public static int send_type_dingshi = 2;
		public static String send_type_jishi_String = "立即送";
		public static String send_type_dingshi_String = "定时送";
		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			map.put(send_type_jishi, send_type_jishi_String);
			map.put(send_type_dingshi, send_type_dingshi_String);
		}
		public static String get(int key) {
			return map.get(key);
		}
	}

	class sendGoodsType{
		public static int send_type_1 =1;
		public static int send_type_2=2;
		public static String send_type_1_String = "送货上门";
		public static String send_type_2_String = "到店自取";
		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			map.put(send_type_1, send_type_1_String);
			map.put(send_type_2, send_type_2_String);
		}
		public static String get(int key) {
			return map.get(key);
		}
	}

	
	//-1 初始订单 0 支付完成   1 可抢单 2 待发货 3 待收货 4 已完成 5 拒收 6 让单 7 流单;
	 class OrderStatus {

		public static int order_status_chushi = -1;
		public static final String order_status_chushi_String = "待付款";
		public static int order_status_pay = 0;
		public static final String order_status_fendan_String = "支付完成";
		public static final int order_status_kqd = 1;
		public static final String order_status_kqd_String = "可抢单";
		public static final int order_status_dfh = 2;
		public static String order_status_dfh_String = "待发货";
		public static final int order_status_psz = 3;
		public static final String order_status_psz_String = "待收货";
		public static final int order_status_ywc = 4;
		public static final String order_status_ywc_String = "已完成";
		public static final int order_status_js = 5;
		public static final String order_status_js_String = "申请 拒收/退款";
		public static final int order_status_js_in = 6;
		public static final String order_status_rd_String = "退款中";
		public static final int order_status_js_success = 7;
		public static final String order_status_ld_String = "退款成功";

		private static Map<Integer, String> map = new HashMap<Integer, String>();

		static {
			map.put(order_status_kqd, order_status_kqd_String);
			map.put(order_status_dfh, order_status_dfh_String);
			map.put(order_status_psz, order_status_psz_String);
			map.put(order_status_ywc, order_status_ywc_String);
			map.put(order_status_js, order_status_js_String);
			map.put(order_status_js_in, order_status_rd_String);
			map.put(order_status_js_success, order_status_ld_String);
		}

		//public static String unusual=order_status_dfh+","+order_status_ld+","+order_status_js;

		public static String get(int key) {
			return map.get(key);
		}
	}
	
	 class orderAction{
		public static final String order_type_dingshisong="定时送";
		public static final String order_type_lijisong="立即送";
		public static final String order_action_chushi="初始订单生成";
		public static final String order_action_pay="订单付款成功";
		public static final String order_action_rangdan="生成让单";
		public static final String order_action_lliudan="生成流单";
		public static final String order_action_robdan="生成抢单";
		public static final String order_action_xiadan="下单给商户";
		public static final String order_action_newOrder="新生成订单";
		
		
	}
	
	
	/**
	 * 代金券基本信息 状态 录入
	 * **/
	 class cash{
		public static final int cash_status_h=1;
		public static final String cash_status_ystr="有效";
		public static final int cash_status_n=2;
		public static final String cash_status_nstr="无效";
		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			map.put(cash_status_h, cash_status_ystr);
			map.put(cash_status_n, cash_status_nstr);
			
		}
		public static String get(int key) {
			return map.get(key);
		}
	}
	
	 class cashItem{
		public static final int cash_item_status_h=1;
		public static final int cash_item_status_n=2;
		public static final String cash_item_status_hstr="初始代金券";
		public static final String cash_item_status_nstr="已被抢购的代金券";
		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			
			map.put(cash_item_status_h, cash_item_status_hstr);
			map.put(cash_item_status_n, cash_item_status_nstr);
			
		}
		public static String get(int key) {
			return map.get(key);
		}
	}
	
	 class cashLog{
		public static final int cash_log_type_chushi=1;
		public static final int cash_log_type_add=2;
		public static final int cash_log_type_del=3;
		public static final String cash_log_type_chushi_str="日志初始 用户初始";
		public static final String cash_log_type_add_str="代金券获取 增加代金券额度";
		public static final String cash_log_type_del_str="使用代金券 减少代金券额度";
		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			map.put(cash_log_type_chushi, cash_log_type_chushi_str);
			map.put(cash_log_type_add, cash_log_type_add_str);
			map.put(cash_log_type_del, cash_log_type_del_str);
		}
		public static String get(int key) {
			return map.get(key);
		}
		
	}
	
	
	class accountRecord{
		public static final int accountRecord_type_userPay=1;
		public static final int accountRecord_type_orderfinish=2;
		public static final int accountRecord_type_robOrder=3;
		public static final int accountRecord_type_letOrder=4;
		public static final int accountRecord_type_withDraw=5;
		public static final String accountRecord_type__str="用户支付付款  款项流入kaka平台";
		public static final String accountRecord_type_orderfinishstr="订单交易完成商户账户余额增加";
		public static final String accountRecord_type_robOrder_str="抢单商户交易完成 商户账号增加";
		public static final String accountRecord_type_letOrder_str="让dan商户交易完成 商户账号增加";
		public static final String accountRecord_type_withDraw_str="商户提现";
		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			map.put(accountRecord_type_userPay, accountRecord_type__str);
			map.put(accountRecord_type_orderfinish, accountRecord_type_orderfinishstr);
			map.put(accountRecord_type_robOrder, accountRecord_type_robOrder_str);
			map.put(accountRecord_type_letOrder, accountRecord_type_letOrder_str);
			map.put(accountRecord_type_withDraw, accountRecord_type_withDraw_str);
		} 
		public static String get(int key) {
			return map.get(key);
		}
	}

	class balanceType{
		public static final int balance_type_in_dd=1;
		public static final int balance_type_in_yj=2;
		public static final int balance_type_out_yj=3;
		public static final int balance_type_out_tx=4;
		public static final int balance_type_in_xf=5;

		public static final String balance_type_in_dd__str="微信/支付宝 订单收入";
		public static final String balance_type_in_yj_str="订单佣金收入";
		public static final String balance_type_out_yj_str="让单佣金支出";
		public static final String balance_type_out_tx_str="账号体现";
		public static final String balance_type_in_xf_str="货到付款/自提收入";

		private static Map<Integer, String> map = new HashMap<Integer, String>();
		static {
			map.put(balance_type_in_dd, balance_type_in_dd__str);
			map.put(balance_type_in_yj, balance_type_in_yj_str);
			map.put(balance_type_out_yj, balance_type_out_yj_str);
			map.put(balance_type_out_tx, balance_type_out_tx_str);
			map.put(balance_type_in_xf, balance_type_in_xf_str);
		}
		public static String get(int key) {
			return map.get(key);
		}

		public static int getType(int pay_type){
			if(pay_type!=3){
				return balance_type_in_dd;
			}
			return balance_type_in_xf;
		}
	}


	String code="蜂域提醒你，你的验证码: ";
	 String Title="蜂域提醒您，";
	 String content_order="您有新的订单可以抢";
	 String content_order_new="您有一笔新的订单";
	 String content_order_Touser_send="提醒您，您的收货码:";
	 String content_order_Touser_finish="交易完成";
	 String content_order_ToreturnCommission="您有一笔新的返佣金额：";
	 String PUSH_ONE="alias_one";


	int low=10;
	int login_integral=10;



}
