<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<!DOCTYPE HTML >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0"> 
<style> 
.news_con{ width:94%; margin:0px auto; line-height:30px;  padding:12px;  font-size:20px;}
.block{ display:block; text-align:center; width:auto;}
.block.prob{ text-align:left; line-height:36px; width:auto;}
.time{ font-size:12px; color:#999; line-height:36px; text-align:center}
img{ width:40px; margin:0px 0px 10px 0px;}
</style>
</head>

<body>
	<div class="news_con">
		<c:if test="${!empty method}">
	  		<a href="http://www.hc85.com/app"><img alt="广告图" src="${path}/public/images/loading-app.jpg" style="width:100%;"></a>
	  	</c:if>
		<h2 class="block">${play.title}</h2>
		<span class="block time">队伍名称：${play.teamname}&nbsp;&nbsp; 创建时间：${play.createtime}</span>
		<span><img width="40px;" src="${imgPath }${play.img }"></span>
		<span>活动时间：${play.playtime }----${play.endtime }</span><span>允许加入时间：${play.autointime }</span>
		<span>活动人数：${play.count}/${play.total }</span><span>费用：${play.cost}</span>
		<div>${play.content}</div>
	</div> 
</body>
</html>
