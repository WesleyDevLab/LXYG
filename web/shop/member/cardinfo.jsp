<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.kaka.platform.util.ConfigUtils"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	String imgPath = ConfigUtils.getProperty("nginx.root");
%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>商家后台办公系统</title>
<link href="<%=basePath%>shop/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>shop/js/page.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/artDialog.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/iframeTools.js"></script>
<script type="text/javascript">
function init() {
	initRow();
}

function alertJsp(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
}

function toUrl(url) {
	location.href = url;
}

function formatNum(num){
	document.writeln((num/100).toFixed(2));
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：折扣管理
	</div>
	<h1 class="tittle">会员卡列表</h1>
	<div class="con">

		<div class="search">
			<input type="button" value="添加会员卡" onclick="toUrl('<%=basePath %>card/preAdd');" class="add_pro2" />
		</div>
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>会员卡名称</th>
					<th>会员卡折扣</th>
					<th>需要累计消费方可领取</th>
					<th>会员卡详细信息</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty pg.list}">
				<tr height="30" style="text-align: center;">
					<td colspan="6"><font style="font-size:16px;" color="red">暂无相关数据!</font>
					</td>
				</tr>
			</c:if>
			<c:if test="${!empty pg.list}">
				<c:forEach items="${pg.list}" var="card" varStatus="loopStatus">
					<tr>
						<td>${loopStatus.count}</td>
						<td>${card.cardname}</td>
						<td>${card.discount/10}折</td>
						<td>
							<c:if test="${!empty card.request}">
								<script type="text/javascript">formatNum(${card.request});</script>元
							</c:if>
							<c:if test="${empty card.request}">
								暂未定价
							</c:if>
						</td>
						<td>
							<c:if test="${empty card.img}">
								暂无图片
							</c:if>
							<c:if test="${!empty card.img}">
								<a href="javascript:void(0)" onclick="alertJsp('查看图片','<%=imgPath %>${card.img }')">点击查看图片</a>
							</c:if>
						</td>
						<td>
							<input name="input" type="button" onclick="toUrl('<%=basePath %>card/preUpdate?cardId=${card.cardid}')" value="修改" class="xiugai_btn" />
						</td>
					</tr>
				</c:forEach>
				<tr>
					<td colspan="6">
					<div class="bg">
						<div class="r_page">
						<script type="text/javascript">
							var url = location.href;
							var pageOne = new PageObject(url,'${page}','${pg.totalPage}','${pg.totalRow}','pageOne');
						</script>
						</div>
					</div>
					</td>
				</tr>
			</c:if>	
			</tbody>
		</table>

	</div>
</body>
</html>

