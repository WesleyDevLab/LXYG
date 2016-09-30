package com.lxyg.app.customer.platform.TestUnit;


import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import org.junit.*;

import java.util.List;

/**

 */
public class Test_sybase extends TestBefore_sybase {

    @org.junit.Test
    public void test(){
        List<Record> records= Db.find("SELECT * from HYT_BMZX_SPB");
        for(Record record:records){
            System.out.println(record);
        }
    }


}
