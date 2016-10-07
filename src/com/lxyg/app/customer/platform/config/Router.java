package com.lxyg.app.customer.platform.config;

import com.jfinal.config.Routes;
import com.lxyg.app.customer.platform.controller.*;

public class Router extends Routes {

	@Override
	public void config() {
		add("/user",UserController.class);
		add("/sybase",SybaseController.class);
		add("/pageTo",PageController.class);
		add("/order",OrderController.class);
		add("/goods",GoodsController.class);
		add("/res",ResController.class);
		add("/app",AppController.class);
		add("/app/v2",AppControllerV2.class);
		add("/app/pay",alipayController.class);
		add("/wx",wxContronller.class);
		add("/",indexController.class);
		add("/finance", FinanceController.class);
		add("/form",FormController.class);
		add("/activity",activityController.class);
		add("/synch",synchDataController.class);

	}

}
