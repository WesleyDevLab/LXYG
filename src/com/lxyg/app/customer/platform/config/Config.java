package com.lxyg.app.customer.platform.config;

import com.jfinal.config.*;
import com.jfinal.ext.interceptor.SessionInViewInterceptor;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.plugin.druid.DruidPlugin;
import com.jfinal.render.ViewType;
import com.lxyg.app.customer.platform.interceptor.visitInterceptor;
import com.lxyg.app.customer.platform.model.*;
import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.util.ConfigUtils;

/**
 * API引导式配
 */
public class Config extends JFinalConfig {
	/**
	 * 配置常量
	 */
	public void configConstant(Constants me) {
		loadPropertyFile("res/jdbc.properties");
		me.setDevMode(Boolean.valueOf(ConfigUtils.devModel));
		me.setViewType(ViewType.JSP); 		// 设置视图类型为Jsp，否则默认为FreeMarker
		//me.setUploadedFileSaveDirectory(uploadedFileSaveDirectory);//修改默认保存文件路径
	}
	/**
	 * 配置路由
	 */
	public void configRoute(Routes me) {

		me.add(new Router());
	}
	
	/**
	 * 配置插件
	 */
	public void configPlugin(Plugins me) {
//		if(M.loadInfo()==1){
			C3p0Plugin c3 = new C3p0Plugin(getProperty("url"), getProperty("username"), getProperty("password").trim());
			c3.setDriverClass(getProperty("driverClassName"));
			me.add(c3);


			// 配置ActiveRecord插件
			ActiveRecordPlugin arp = new ActiveRecordPlugin(c3);
			arp.addMapping("kk_product", Goods.class);
			arp.addMapping("kk_manager", Manager.class);
			arp.addMapping("kk_res", Res.class);
			arp.addMapping("kk_user", User.class);
			arp.addMapping("kk_shop", Shop.class);
			arp.addMapping("kk_product_img", GoodsImg.class);
			arp.addMapping("kk_order", Order.class);
			arp.addMapping("kk_order_cache", OrderCache.class);
			arp.addMapping("kk_product_fb", FBGoods.class);
			arp.addMapping("kk_district",District.class);
			arp.addMapping("kk_product_type",GoodType.class);
			arp.addMapping("kk_form",Form.class);
			arp.addMapping("kk_form_img",FormImg.class);
			arp.addMapping("kk_form_replay",FormReplay.class);
			arp.addMapping("kk_form_zan",FormZan.class);
			arp.addMapping("kk_product_category",GoodCategory.class);
		    arp.addMapping("kk_order_activity",OrderActivity.class);
			arp.setShowSql(false);
			me.add(arp);
			// 配置极光推送插件
			JPush jpush=new JPush();
			me.add(jpush);


		String URL="jdbc:sybase:Tds:116.255.198.151:5000/hytmaindb?charset=cp936";
		String USERNAME="sa";
		String PASSWORD="";
		String driver="com.sybase.jdbc4.jdbc.SybDriver";

		DruidPlugin dp=new DruidPlugin(URL,USERNAME,PASSWORD);
		dp.setDriverClass(driver);
		dp.setInitialSize(3);
		dp.setMinIdle(2);
		dp.setMaxActive(5);
		dp.setMaxWait(60000);
		dp.setTimeBetweenEvictionRunsMillis(120000);
		dp.setMinEvictableIdleTimeMillis(120000);

//		C3p0Plugin c31 = new C3p0Plugin(URL, USERNAME, PASSWORD.trim());
//		c3.setDriverClass(driver);
//		me.add(c3);
		me.add(dp);
		ActiveRecordPlugin arp1 = new ActiveRecordPlugin("sybase",dp);
		me.add(arp1);
	}
		// 配置C3p0数据库连接池插件

//	}
	
	/**
	 * 配置全局拦截?
	 */
	public void configInterceptor(Interceptors me) {
		me.add(new SessionInViewInterceptor());
		me.add(new visitInterceptor());
	}
	
	/**
	 * 配置处理?
	 */
	public void configHandler(Handlers me) {
	}

	public void afterJFinalStart(){
//		pushTimerTask p=new pushTimerTask();
//		p.begin();
//		super.afterJFinalStart();
	};
}
