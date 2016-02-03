package com.lxyg.app.customer.platform.listener;


import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class KAKAListener  implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent arg0) {
		
	}

	public void contextInitialized(ServletContextEvent arg0) {
//		pushTimerTask.begin();
//		letOrderGoListener.begin();
//		pushManagerListener.begin();
		orderAutoFinishListener.begin();
	}


}
