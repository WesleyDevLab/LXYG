package com.lxyg.app.customer.platform.TestUnit;


import com.jfinal.plugin.activerecord.Db;
import com.jfinal.plugin.activerecord.Record;
import org.junit.*;
import org.junit.Test;

import java.io.*;
import java.util.List;
import java.util.Scanner;

/**

 */
public class Test_sybase extends TestBefore_sybase {

    @Test
    public void test() {
        // HYT_CGZX_CGDDMX HYT_BMZX_SPB HYT_BMZX_LBB
        //SELECT * from HYT_BMZX_SPB
        List<Record> record = Db.find("SELECT * from HYT_CGZX_CGDDMX");
        System.out.println(record);
    }

    public void TraversalTable() throws IOException {
        File file = new File(new File("").getCanonicalPath() + "\\src\\res\\table.txt");
        if (!file.exists()) {
            throw new RuntimeException("找不到文件");
        }
        String lineTxt = null;
        Scanner scanner = new Scanner(file);
        while (scanner.hasNext()) {
            lineTxt=scanner.nextLine();
            Record record = Db.findFirst("SELECT count(*) as c from "+lineTxt);
            if(record.getInt("c")>0&&record.getInt("c")<2000){
                System.out.println(lineTxt+"_"+record.getInt("c"));
                File f=new File("d:/dataA/"+lineTxt+".txt");
                if(!f.exists()){
                    f.createNewFile();
                    List<Record> records = Db.find("SELECT * from "+lineTxt);
                    FileOutputStream o=new FileOutputStream(f);
                    o.write(records.toString().getBytes());
                    o.close();
                }
            }
        }
    }

    public void writeDataToTxt(){
        List<Record> r = Db.find("SELECT * from HYT_BMZX_SPB");
        File f=new File("d:/dataA/HYT_BMZX_SPB.json");
        FileOutputStream o= null;
        try {
            o = new FileOutputStream(f);
            o.write(r.toString().getBytes());
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }finally {
            try {
                o.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

}
