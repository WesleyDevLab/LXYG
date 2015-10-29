<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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

function del(url, id){
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"id" : id}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="<%=basePath %>shop/drawList";
		    } else {
		    	alert("删除失败！");
		    	location.href="<%=basePath %>shop/drawList";
		    }
		});
	}
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：商家图片展示
	</div>
	<h1 class="tittle">商家图片列表</h1>
	<div class="con">

		<div class="search">
			<input type="button" value="添加图片" onclick="toUrl('<%=basePath %>shop/preAddDraw');" class="add_pro2" />
		</div>
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>商家名称</th>
					<th>图片详细信息</th>
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
				<c:forEach items="${pg.list}" var="draw" varStatus="loopStatus">
					<tr>
						<td>${loopStatus.count}</td>
						<td>${draw.shopname}</td>
						<td>
							<c:if test="${empty draw.img}">
								暂无图片
							</c:if>
							<c:if test="${!empty draw.img}">
								<a href="javascript:void(0)" onclick="alertJsp('查看图片','<%=imgPath %>${draw.img }')">点击查看图片</a>
							</c:if>
						</td>
						<td>
							<input name="input" type="button" onclick="toUrl('<%=basePath %>shop/preEditDraw?id=${draw.id}')" value="修改" class="xiugai_btn" />
							<input type="button" onclick="del('<%=basePath %>shop/delDraw','${draw.id}')"  value="删除" class="dele_btn"/>
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

