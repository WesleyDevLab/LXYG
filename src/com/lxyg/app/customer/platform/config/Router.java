package com.lxyg.app.customer.platform.config;

import com.jfinal.config.Routes;
import com.lxyg.app.customer.platform.controller.*;

public class Router extends Routes {

	@Override
	public void config() {
//		me.add("/",UserController.class); 
		add("/user",UserController.class);
//		me.add("/role",RoleController.class); 
//		me.add("/res",ResController.class); 
		add("/pageTo",PageController.class);
//		me.add("/news",NewsController.class); 
//		me.add("/draw",DrawController.class); 
//		me.add("/upload",UploadController.class); 
//		me.add("/play",PlayController.class); 
		add("/order",OrderController.class);
		add("/goods",GoodsController.class);
		add("/res",ResController.class);
//		me.add("/card",CardController.class); 	
//		me.add("/forum",ForumController.class); 	
		add("/app",AppController.class);
		add("/app/v2",AppControllerV2.class);
		add("/app/pay",alipayController.class);
//		me.add("/log", LogController.class);
//		me.add("/finance", FinanceController.class);
//		me.add("/home", HomeController.class);
//		me.add("/message", MessageController.class);
//		me.add("/setting", SettingController.class);
		add("/wx",wxContronller.class);
		add("/",indexController.class);
		add("/finance", FinanceController.class);
		add("/form",FormController.class);
		add("/activity",activityController.class);
		add("/synch",synchDataController.class);
	}

}
