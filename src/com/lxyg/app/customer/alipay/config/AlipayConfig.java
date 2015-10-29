package com.lxyg.app.customer.alipay.config;

/* *
 *类名：AlipayConfig
 *功能：基础配置类
 *详细：设置帐户有关信息及返回路径
 *版本：3.3
 *日期：2012-08-10
 *说明：
 *以下代码只是为了方便商户测试而提供的样例代码，商户可以根据自己网站的需要，按照技术文档编写,并非一定要使用该代码。
 *该代码仅供学习和研究支付宝接口使用，只是提供一个参考。
	
 *提示：如何获取安全校验码和合作身份者ID
 *1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
 *2.点击“商家服务”(https://b.alipay.com/order/myOrder.htm)
 *3.点击“查询合作者身份(PID)”、“查询安全校验码(Key)”

 *安全校验码查看时，输入支付密码后，页面呈灰色的现象，怎么办？
 *解决方法：
 *1、检查浏览器配置，不让浏览器做弹框屏蔽设置
 *2、更换浏览器或电脑，重新登录查询。
 */

public class AlipayConfig {
	
	//↓↓↓↓↓↓↓↓↓↓请在这里配置您的基本信息↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
	// 合作身份者ID，以2088开头由16位纯数字组成的字符串
	public static String partner = "2088111581933941";
	// 商户的私钥
	public static final String SELLER = "service@caca9.com";
	// 商户的MD5
	public static String key = "hmf9aqc5hv6x39mh964f3cztix3gzh5q";
	// 商户的RSA
	//public static String private_key = "MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAML+AudcpWVO3gGYN28lNqtgrFlF716AgYQeHjk9O+vRkbAQhWNT5tcn+sFyMpqY9TY1OXgTfqaC0KyQ0aGs4z8SounK2E+TxwMZRCQaPmappOwEyv9MxJUokgj9fhSxr7PwCvJvZ3t0+7bx3W0V4JIz+bsilFzOu2v/yKbr2/klAgMBAAECgYAfsJ6SMVlkBJRKGA3yT076PUTlYVtMtX/XE/n/fXculSmjPpwfD3S1xPaY19FnlLJNdAr5+9kagKofUY3wQ6POxKfi1VP8unDqz/9R5vIrEUHzlZQ3ukrKlNRvHmlKPx8xnwA3c2hiXg25cRVcdKlMW+T3KUukD/nPNZqKF6PwBQJBAOqtPKCl8hEinGf7xdtE0DadWa6LppGI+g1NTYmSL0Cw/Bo7ZSXDdwthcnz4wMwDqgcMqIHR4jlh3bwxnAqCK/8CQQDUta7FIfKjmmV4AN2UIV2kyD4Ob0onWu1K1X+DMrZk931aRfBexY1IdKoO9trSATlKPcgvMphM3Mi1PCX2t6rbAkEAm/3ZXgPQmzlBdBE0nKLqMFN5qH9lkjnV1P+8eaS1SjAa86jlfCuotuTogE+tgC8zVwo//EMyN+hoxs7HJWkPqwJAEWWKlbThE2BdTCNF/Ad+kSuPZ77SYcWeArDTbPeI01kqd2eg8R9XHsXr4q1t2B8hgGDtLm8E5cRo5em1cSg0YQJAOnkjJ3Tl/1iChmO59PHDlRp/vbKRrlaqaiF5uUPnJBERGmZVgNbfTuQx+Awki7jmgagkxHMDRos+C0IoDAyMSg==";
	public static final String RSA_PRIVATE ="MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALSYQHDxFGNu9H1KFQqvJJvWRkwFATALATo+qDTl2uOS6FoeLm/aI1di16gjMd+2Ue87Nksq6Tj6LIcoDthE/+7/5Tl5pgeIKdsmEomaEezmT/TwHnb4A1qKqtxYE6ou3ctKRh+krBzlWSQ4hy7vgVcebSEduCipKAQr/h6t8YMNAgMBAAECgYAuAJJ5so9U/NB+kb5maFLU93IUrzmsOUFoyskiIGLvkV5qhkGh8FkMS3tPsxdjOxgH7ndYEmgyQVfSXdvaL0lZ9HshtjvK0hafLAXalI50WHS9nwRImCm3O66kZ0pYI2e4rOBREBa79OHSejdgu8JjevtxV1Mtk6yLHuifsyoaQQJBANpI48lVe9CGxz6nwfjPFSXHCF5YaXYOUQw4Tpx8poTZ/49c5jjydpHiBGohhPnB+ou45QjNfbA+/5PdpSFtP3UCQQDTzES89UmIsLTZQzzAUEr+r4k75mJ0s/7z6hJ45wpSwv1QWWo9oboFmS1sSXbBOUkLzfYsdond25KKwj+Gapo5AkAmpW8Gz0arhaEy+5qBBZDV7mYR5g9N4n0A79sjI4KL1NjFNgpgnLTXYS+s5qBXY7uLD0Ili9Qr5wtyz3QT9fadAkEAr0ksTnJ21EDiu7jw63zIRHZEjqWCMHHTfEzp0tPr8EjeWwRVcAKMMRvvwuId/ZaKhNGFfpDwUwPpCRvwdS9+yQJAKAc/+skkYvjfMZB0AbRMgqnLU5Pfrj4Du/VEabEbaIt7A4ihxm/kL0n1u3cn4bpO1XfRi/V6xES+UVv4ZxmfIA==";

	// 支付宝的公钥，无需修改该值
	public static String ali_public_key  = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
	//↑↑↑↑↑↑↑↑↑↑请在这里配置您的基本信息↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
	

	// 调试用，创建TXT日志文件夹路径
	public static String log_path = "D:\\";

	// 字符编码格式 目前支持 gbk 或 utf-8
	public static String input_charset = "utf-8";
	
	// 签名方式 不需修改
	public static String sign_type = "RSA";

}
