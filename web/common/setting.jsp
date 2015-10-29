<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1" http-equiv="Content-Type" content="text/html;charset=gbk" />
<title>动态详情</title>
<style type="text/css"> 
.news_con{ width:94%; margin:0px auto; line-height:30px;  padding:12px;  font-size:14px;}
.block{ display:block; text-align:left; width:auto;}
.block.prob{ text-align:left; line-height:36px; width:auto;}
</style>
</head>

<body>
  <div class="news_con">
  	<h2 class="block">${setting.sname}</h2>
  	<div>${setting.content}</div>
  </div>
</body>
</html>
