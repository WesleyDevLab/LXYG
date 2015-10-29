package com.lxyg.app.customer.platform.config;

import com.jfinal.config.*;
import com.jfinal.ext.interceptor.SessionInViewInterceptor;
import com.jfinal.kit.PathKit;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.c3p0.C3p0Plugin;
import com.jfinal.render.ViewType;
import com.lxyg.app.customer.platform.interceptor.visitInterceptor;
import com.lxyg.app.customer.platform.model.*;
import com.lxyg.app.customer.platform.plugin.JPush;
import com.lxyg.app.customer.platform.util.ConfigUtils;

import java.io.File;

/**
 * API引导式配
 */
public class Config extends JFinalConfig {
	/**
	 * 配置常量
	 */
	public void configConstant(Constants me) {
		loadPropertyFile("res/jdbc.properties");
		me.setDevMode(true);
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
		
		// 配置C3p0数据库连接池插件
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
		arp.setShowSql(false);
		me.add(arp);
		
		// 配置极光推送插件
		JPush jpush=new JPush();
 	    me.add(jpush);
		
	}
	
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
}
