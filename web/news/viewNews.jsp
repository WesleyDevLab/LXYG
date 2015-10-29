<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<style> 
.news_con{ width:94%; margin:0px auto; line-height:30px;  padding:12px;  font-size:20px;}
.block{ display:block; text-align:center; width:auto;}
.block.prob{ text-align:left; line-height:36px; width:auto;}
.time{ font-size:12px; color:#999; line-height:36px; text-align:center}
img{ width:100%; margin:0px 0px 10px 0px;}
</style>
</head>

<body>
	<div class="news_con">
		<h2 class="block">${news.title}</h2>
		<span class="block time">作者：${news.author}&nbsp;&nbsp; 创建时间：${news.createTime}</span>
		<span>缩略图${imgPath }${news.img }<img src="${imgPath }${news.img }"></span>
		<div>${news.content}</div>
	</div> 
</body>
</html>
