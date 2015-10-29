package com.lxyg.app.customer.platform.util;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

public class OnLineUser implements HttpSessionListener {
	private static int activeSessions = 0;
 

	public void sessionDestroyed(HttpSessionEvent se) {
		if (activeSessions > 0)
			activeSessions--;
	}

	public static int getActiveSessions() {
		return activeSessions;
	}

	public void sessionCreated(HttpSessionEvent se) { 		 
			activeSessions++;
	}
}