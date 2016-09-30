package com.lxyg.app.customer.platform.classUtil;

import com.lxyg.app.customer.platform.util.sqlUtil;

import java.sql.*;
import java.util.Properties;

/**
 * Created by 秦帅 on 2016/6/28.
 */
public class Sync {
    private static sqlUtil pool = new sqlUtil();

    public static void showTables() {
        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;
        try {
            conn = pool.getConnection();
            st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet rs1 = metaData.getTables("hytmaindb", null, null, null);
            while (rs1.next()) {

                System.out.println("表名: " + rs1.getString(3));

            }
            rs1.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public static void showData() {
        Connection conn = null;
        Statement st = null;
        ResultSet rs = null;
        try {
            conn = pool.getConnection();
            st = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            String sql = "SELECT * from HYT_BMZX_SPB";
            st.execute(sql);
            rs = st.executeQuery(sql);
            int cout=0;
            while (rs.next()) {
                cout++;
                System.out.println(rs.getString(1)+"_"+rs.getString(2)+"_"+rs.getString(3)+"_"+rs.getString(4)+"_"+
                        rs.getString(5)+rs.getString(6)+"_"+rs.getString(7)+"_"+rs.getString(8)+"_"+rs.getString(9)+"_"+rs.getString(10)+"_"+rs.getString(11));
            }
            System.out.println(cout);
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }


    public static void main(String[] args) throws SQLException {
        showData();
    }
//        Connection conn = null;
//        Statement st = null;
//        ResultSet rs = null;
//        conn= pool.getConnection();
//        st=conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
//        String sql="select * from HYT_BMZX_DSPB";
//        rs = st.executeQuery(sql);
//        while (rs.next()){
//            System.out.println("CWBM:"+rs.getString(1)+",SWBM:"+rs.getString(2)+",SPZT:"+rs.getString("SPZT"));
//        }
//    }
}

