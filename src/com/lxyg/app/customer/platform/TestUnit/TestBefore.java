package com.lxyg.app.customer.platform.TestUnit;

import com.alibaba.druid.wall.WallFilter;
import com.jfinal.plugin.activerecord.ActiveRecordPlugin;
import com.jfinal.plugin.activerecord.dialect.MysqlDialect;
import com.jfinal.plugin.druid.DruidPlugin;
import com.lxyg.app.customer.platform.model.Goods;
import com.lxyg.app.customer.platform.model.Order;
import org.junit.After;
import org.junit.BeforeClass;

/**
 * Created by ��˧ on 2015/10/23.
 */
public class TestBefore {
    protected static DruidPlugin dp;
    protected static ActiveRecordPlugin activeRecord;

    /**
     * �������ӵ�ַ
     */
    private static final String URL ="jdbc:mysql://localhost:3306/lxyg?&autoReconnect=true&useUnicode=true&characterEncoding=UTF-8";

    /**
     * ���ݿ��˺�
     */
    private static final String USERNAME ="root";

    /**
     * ���ݿ�����
     */
    private static final String PASSWORD ="root";

    /**
     * ���ݿ�����
     */
    private static final String DRIVER ="com.mysql.jdbc.Driver";

    /**
     * ���ݿ����ͣ���mysql��oracle��
     */
    private static final String DATABASE_TYPE ="mysql";

    /**
     * @throws java.lang.Exception
     */
    @BeforeClass
    public static void setUpBeforeClass() throws Exception {
        dp=new DruidPlugin(URL,USERNAME,PASSWORD);

       // dp.addFilter(new StatFilter());

        dp.setInitialSize(3);
        dp.setMinIdle(2);
        dp.setMaxActive(5);
        dp.setMaxWait(60000);
        dp.setTimeBetweenEvictionRunsMillis(120000);
        dp.setMinEvictableIdleTimeMillis(120000);

        WallFilter wall = new WallFilter();
        wall.setDbType(DATABASE_TYPE);
        dp.addFilter(wall);

        dp.getDataSource();
        dp.start();

        activeRecord = new ActiveRecordPlugin(dp);
        activeRecord.setDialect(new MysqlDialect());
//.setDevMode(true)
//.setShowSql(true) //�Ƿ��ӡsql���
        ;

        activeRecord.addMapping("kk_product",Goods.class);
        activeRecord.addMapping("kk_order",Order.class);

//ӳ�����ݿ�ı�ͼ̳���model��ʵ��
//ֻ�������ӳ��󣬲��ܽ���junit����
//        activeRecord.addMapping("f_user", FUser.class)
//                .addMapping("f_content", FContent.class)
//                .addMapping("f_content_type", FContentType.class)
//                .addMapping("f_column", FColumn.class)
//                .addMapping("f_comment", FComment.class)
        ;

        activeRecord.start();
    }

    /**
     * @throws java.lang.Exception
     */
    @After
    public void tearDown() throws Exception {
        activeRecord.stop();
        dp.stop();
    }

}
