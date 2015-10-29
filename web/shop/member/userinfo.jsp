<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
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
<script type="text/javascript">
function init() {
	initRow();
}

function exportExcel(url) {
	location.href = url;
}

function toUrl(url) {
	location.href = url;
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：会员统计
	</div>
	<h1 class="tittle">会员统计</h1>
	<div class="con">
		<div class="search">
			<input name="params.name" type="text" class="search_input" placeholder="会员名称、联系电话等"  title="会员名称、联系电话等" />
			<input type="button" value="搜索" onclick="query(document.form1,'<%=basePath %>user/userList');" class="search_btn" /> 
			<input type="button" value="导出Excel" onclick="exportExcel('<%=basePath %>user/exportExcel');" class="add_pro" />
		</div>
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>会员姓名</th>
					<th>会员卡号</th>
					<th>联系电话</th>
					<th>详细地址</th>
					<th>所持卡种</th>
					<th>领卡时间</th>
					<!-- <th>操 作</th> -->
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty page.list}">
					<tr height="30" style="text-align: center;">
						<td colspan="7"><font style="font-size:16px;" color="red">暂无相关数据!</font>
						</td>
					</tr>
				</c:if>
				<c:if test="${!empty page.list}">
					<c:forEach items="${page.list}" var="user" varStatus="loopStatus">
						<tr>
							<td>${loopStatus.count}</td>
							<td>${user.realname}</td>
							<td>${user.id}</td>
							<td>${user.mobile}</td>
							<td>${user.address}</td>
							<td>${user.cardname}</td>
							<td>${user.createtime}</td>
							<!-- <td>
								<input name="input" type="text" value="" class="xiugai_btn" /> 
							</td> -->
						</tr>
					</c:forEach>
					<tr>
						<td colspan="7">
							<div class="bg">
								<div class="r_page">
								<script type="text/javascript">
									var url = location.href;
									var pageOne = new PageObject(url,'${pg}','${page.totalPage}','${page.totalRow}','pageOne');
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

