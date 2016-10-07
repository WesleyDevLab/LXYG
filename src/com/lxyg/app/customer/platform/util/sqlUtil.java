package com.lxyg.app.customer.platform.util;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import java.beans.PropertyVetoException;
import java.sql.*;

/**
 * Created by 秦帅 on 2016/6/28.
 */
public class sqlUtil {
    private static String className = ConfigUtils.getProperty("res/jdbc.properties", "driverClassNameForSybase");
    private static String url = ConfigUtils.getProperty("res/jdbc.properties", "urlForSybase");
    private static String username = ConfigUtils.getProperty("res/jdbc.properties", "usernameForSybase");
    private String password = ConfigUtils.getProperty("res/jdbc.properties", "passwordForSybase");
    private static ComboPooledDataSource ds=new ComboPooledDataSource();
    static {
        ds = new ComboPooledDataSource();
        ds.setUser(username);
        ds.setJdbcUrl(url);
        try {
            ds.setUser(username);
            ds.setJdbcUrl(url);
            ds.setDriverClass(className);
            ds.setInitialPoolSize(2);
            ds.setMinPoolSize(1);
            ds.setMaxPoolSize(10);
            ds.setMaxStatements(50);
            ds.setMaxIdleTime(60);
        } catch (PropertyVetoException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

}
