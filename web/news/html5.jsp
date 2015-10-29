<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<title>动态详情</title>
<style type="text/css"> 
.news_con{ width:94%; margin:0px auto; line-height:30px;  padding:12px;  font-size:16px;}
.block{ display:block; text-align:left; width:auto;}
.block.prob{ text-align:left; line-height:36px; width:auto;}
.time{ font-size:12px; color:#999; line-height:36px; text-align:left}
</style>
</head>

<body>
  <div class="news_con">
  	<c:if test="${!empty method}">
  		<a href="http://www.hc85.com/app"><img alt="广告图" src="${path}/public/images/loading-app.jpg" style="width:100%;"></a>
  	</c:if>
  	<h2 class="block">${news.title}</h2>
  	<span class="block time">${news.creator} &nbsp;&nbsp; ${news.createtime}</span>
  	<div>${news.content}</div>
  </div>
</body>
</html>
