package com.lxyg.app.customer.platform.util;

import com.qiniu.common.QiniuException;
import com.qiniu.http.Response;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;

import javax.imageio.stream.FileImageInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

public class QiniuImgUtil {
	private static final Logger log= Logger.getLogger(QiniuImgUtil.class);
	private static UploadManager uploadManager = new UploadManager();
	/**获取七牛token*/
	public static String loadUpToken(){
		String ak= ConfigUtils.getProperty("kaka.qiniu.ak");
		String sk= ConfigUtils.getProperty("kaka.qiniu.sk");
		Auth auth = Auth.create(ak, sk);
		String token=auth.uploadToken("lxyg");
		return token;
	}
	
	/**本地图片转换成byte流*/
	public static byte[] image2byte(String path){
	    byte[] data = null;
	    FileImageInputStream input = null;
	    try {
	      input = new FileImageInputStream(new File(path));
	      ByteArrayOutputStream output = new ByteArrayOutputStream();
	      byte[] buf = new byte[1024];
	      int numBytesRead = 0;
	      while ((numBytesRead = input.read(buf)) != -1) {
	      output.write(buf, 0, numBytesRead);
	      }
	      data = output.toByteArray();
	      output.close();
	      input.close();
	    }
	    catch (FileNotFoundException ex1) {
	      ex1.printStackTrace();
	    }
	    catch (IOException ex1) {
	      ex1.printStackTrace();
	    }
	    return data;
	  }
	/**获取七牛 服务器端上传*/
	
	public static String upload(byte[] data){
		String key="";
		  try {
		        Response res = uploadManager.put(data, loadUUID.getUUID(), loadUpToken());
		         JSONObject obj= JSONObject.fromObject(res.bodyString());
		         key=obj.getString("key");
		        if(res.isOK()){
		        	log.info("success");
		        }else {
		        	log.info("error");
		        }
		    } catch (QiniuException e) {
		        Response r = e.response;
		        log.error(r.toString());
		        try {
		            log.error(r.bodyString());
		        } catch (QiniuException e1) {
		        }
		    }
		return key;
		}

	public static void main(String[] args) {
		upload(image2byte("d://aa.jpg"));
	}
}
