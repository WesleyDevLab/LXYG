<%@ page language="java" import="java.util.* " pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>jquery五幅焦点图片特效</title>
<script src="http://www.codefans.net/ajaxjs/jquery-1.7.2.min.js" type="text/javascript"></script>
<style> 
*{margin:0;padding:0;border:none}
body{background:#CCCCCC;padding:20px}
.com{width:490px;height:170px;overflow:hidden;position:relative;background:black}
.com ul{width:3000px;font-size:0;}
.com ul li{vertical-align:bottom;height:100%;overflow:hidden;float:left;background:white url(/jscss/demoimg/201307/loading.gif) no-repeat center center;vertical-align:bottom;list-style:none;overflow:hidden}
.com ol{position:absolute;right:0;bottom:20px;;z-index:10;list-style:none;height:21px}
.com ol li{width:15px;background:white;border:1px solid #74A8ED;border-radius:10px;color:#74A8ED;cursor:pointer;float:left;font:12px Arial;height:15px;margin:2px 3px;text-align:center;}
.com ol li.on{height:19px;width:19px;background:#74A8ED;border:1px solid #EEEEEE;color:#FFFFFF;font-size:16px;font-weight:bold;line-height:19px;margin:0 3px;}
</style>
</head>
<body> 
<img src="${path }/public/images/1.jpg">
<c:forEach items="${pageBean.list }" var="img">
	<img src="${imgPath }${img.img_url}">
</c:forEach>

<img src="${path }/public/images/1.jpg">
 </body>
</html>