package com.lxyg.app.customer.platform.util;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * Created by ��˧ on 2015/12/10.
 */
public class readEcecl {
    public static void main(String[] args) {
        String path = "D://kk_product_new.xls";
        File file = new File(path);
        if (!file.exists()) {
            System.out.println("�ļ�������");
            return;
        }
        try {
            POIFSFileSystem poifsFileSystem = new POIFSFileSystem(new FileInputStream(file));
            HSSFWorkbook hssfWorkbook =  new HSSFWorkbook(poifsFileSystem);
            HSSFSheet hssfSheet = hssfWorkbook.getSheetAt(0);
            int rowstart = hssfSheet.getFirstRowNum();
            int rowEnd = hssfSheet.getLastRowNum();
            for(int i=rowstart;i<=rowEnd;i++){
                HSSFRow row = hssfSheet.getRow(i);
                if(null == row){
                    continue;
                }
                int cellStart = row.getFirstCellNum();
                int cellEnd = row.getLastCellNum();
                for(int k=cellStart;k<=cellEnd;k++)
                {
                    HSSFCell cell = row.getCell(k);
                    if(null==cell) continue;
                    String value = null;
                    switch (cell.getCellType())
                    {
                        case HSSFCell.CELL_TYPE_NUMERIC: // ����
                            System.out.print(cell.getNumericCellValue() + "   ");
                            break;
                        case HSSFCell.CELL_TYPE_STRING: // �ַ���
                            System.out.print(cell.getStringCellValue() + "   ");
                            break;
                        case HSSFCell.CELL_TYPE_BOOLEAN: // Boolean
                            System.out.print(cell.getBooleanCellValue() + "   ");
                            break;
                        case HSSFCell.CELL_TYPE_FORMULA: // ��ʽ
                            value= String.valueOf(cell.getNumericCellValue()+"   ");
                            System.out.print(value);
                            break;
                        case HSSFCell.CELL_TYPE_BLANK: // ��ֵ
                            System.out.print(" null ");
                            break;
                        case HSSFCell.CELL_TYPE_ERROR: // ����
                            System.out.print(" error ");
                            break;
                        default:
                            System.out.print("δ֪����   ");
                            break;
                    }
                }
                System.out.print("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
