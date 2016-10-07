package com.lxyg.app.customer.platform.TestUnit;

import com.alibaba.druid.wall.WallFilter;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.druid.DruidPlugin;
import org.junit.After;
import org.junit.BeforeClass;

/**
 * Created by 秦帅 on 2015/10/23.
 */
public class TestBefore_sybase {
    protected static DruidPlugin dp;
    protected static ActiveRecordPlugin activeRecord;
    /**
     * @throws Exception
     */
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {

        String URL="jdbc:sybase:Tds:116.255.198.151:5000/hytmaindb?charset=cp936";
        String USERNAME="sa";
        String PASSWORD="";
        String driver="com.sybase.jdbc4.jdbc.SybDriver";

        dp=new DruidPlugin(URL,USERNAME,PASSWORD);
        dp.setDriverClass(driver);
        dp.setInitialSize(3);
        dp.setMinIdle(2);
        dp.setMaxActive(5);
        dp.setMaxWait(60000);
        dp.setTimeBetweenEvictionRunsMillis(120000);
        dp.setMinEvictableIdleTimeMillis(120000);

        dp.getDataSource();
        dp.start();

        activeRecord = new ActiveRecordPlugin(dp);

        activeRecord.start();
    }

    /**
     * @throws Exception
     */
    @After
    public void tearDown() throws Exception {
        activeRecord.stop();
        dp.stop();
    }

}
