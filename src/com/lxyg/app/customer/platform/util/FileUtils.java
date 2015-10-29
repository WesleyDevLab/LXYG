package com.lxyg.app.customer.platform.util;

import com.jfinal.upload.UploadFile;
import sun.misc.BASE64Decoder;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * <p/>
 * 郑州云峰计算机科技有限公司版权所有
 * <p/>
 * 创 建 人：王朝伟
 * <p/>
 * 创建日期：2013-07-06
 * <p/>
 * 创建时间：10:15:30
 * <p/>
 * 功能描述：文件管理类
 * <p/>
 * -----------------------------------------------------------
 * <p/>
 * 修改历史
 * <p/>
 * 修改人 修改时间 修改原因
 * <p/>
 * -----------------------------------------------------------
 */
public class FileUtils {
	public static final String ULFP = ConfigUtils.getProperty("file.path"); // 路径
	public static final String IMG = "img"; // 图片存储路径

	// 随机产生文件名，避免文件名冲突
	public static String getFileName(String fileName) {
		String path = ConfigUtils.getProperty("file.path");
		fileName = DateTools.nowTime()
				+ fileName.substring(fileName.lastIndexOf("."));
		path = path + File.separator + fileName.substring(0, 4);
		File targetFile = new File(path, fileName);
		if (!(new File(targetFile.getParent()).exists())) {
			targetFile.mkdirs();
		}
		return fileName;
	}

	// 返回值直接保存到数据库
	public static String saveAppFile(String type, String img) {
		FileOutputStream fos = null;
		String realName = null;
		String year = "";
		try {
			String path = FileUtils.ULFP.concat(type).concat("/");
			byte[] buffer = new BASE64Decoder().decodeBuffer(img);
			// 从新获取图片类型
			realName = WebUtils.uuid().concat(".jpg");
			year = DateTools.createDate().substring(0, 4);//
			path = path.concat(year);
			File targetFile = new File(path, realName);
			if (!(new File(targetFile.getParent()).exists())) {
				targetFile.getParentFile().mkdirs();
			}
			fos = new FileOutputStream(targetFile);
			fos.write(buffer);
			fos.flush();
			fos.close();
		} catch (Exception e) {
		} finally {
			if (fos != null) {
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		realName = type.concat("/").concat(year).concat("/").concat(realName);
		return realName;
	}

	/**
	 * 重组文件名
	 */
	public static String newFileName(String fileName) {
		fileName = DateTools.nowTime()
				+ fileName.substring(fileName.lastIndexOf("."));
		return fileName;
	}

	/**
	 * 重组路径 e:/images/yfapp/2013
	 */
	public static String getSavePath(String fileType, String fileName) {
		String path = FileUtils.ULFP + fileType + fileName.substring(0, 4);
		return path;
	}

	public static File reName(String mHttpUrl, UploadFile file) {
		String fileExt = file.getFileName().substring(
				file.getFileName().lastIndexOf("."));
		File nf = file.getFile();
		String fname2 = WebUtils.uuid().substring(0, 8);
		File file2 = new File(mHttpUrl, DateTools.nowTime().concat(fname2)
				.concat(fileExt));
		nf.renameTo(file2);
		return file2;
	}

}
