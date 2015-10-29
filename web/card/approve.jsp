<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>禹州后台管理系统</title>
<link href="<%=basePath%>public/css/index.css" rel="stylesheet" type="text/css" />
<link href="<%=basePath%>public/css/right.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/page.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/artDialog.js?skin=blue"></script>
<script type="text/javascript" src="<%=basePath%>public/js/iframeTools.js"></script>
<script type="text/javascript">
function init() {
	initRow();
}
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px',
		 close: function () {
        	location.reload();
    }
	});
}
$(function() {
	var user = "${session['user'].uid}";
	if (user == 12) {
		$("#val").attr("disabled", true);
		$("#but").css("display", "black");
	} else {
		$("#val").attr("disabled", true);
		$("#but").attr("display", "none");
	}
});

function upval() {
	var butval = $("#but").val();
	if (butval == "修改") {
		$("#val").attr("disabled", false);
		$("#but").val("确认");
	} else {
		var valval = $("#val").val();
		alert(valval);
		$.ajax({
			type : "POST",
			url : "<%=basePath%>card/editReback",
			data : {
				"val" : valval,"type" : 2
			},
			dataType : "json",
			success : function(data) {
				if (data == "0") {
					location.href = "<%=basePath%>card/getReback?type=2";
				}
			}
		});
	}
}
</script>

<style type="">
li a {
	color: black;
}

a:link {
	color: black;
}
</style>
</head>

<body onload="init();">
	<div class="right_con">
		<div class="chaxun">保证金管理</div>
		
		<div class="caozuo">
		<div>
			<input type="text" value="${reback.hcval }" class="caozuo_input f_l" id="val"> 
			<input type="button" value="修改" class="caozuo_input f_l" id="but" onclick="upval();">
			<span style="color:red;">*点击修改开始操作，书写格式：如返利5%，这输入数组‘5’，点击确定完成修改</span>
		<form id="form1" action="<%=basePath%>user/list?type=1" method="post">
		<input name="username" id="username_search" placeholder="会员名称" class="caozuo_input_shuru" /> 
				<input name="" type="submit" value="查询" class="caozuo_input f_l" />
				
		</form>
		</div>
		</div>
		<div class="tab">
			<table border="0" cellpadding="4" cellspacing="1" width="100%">
				<thead>
				<tr>
						<th colspan="7">保证金不足的商家</th>
						 
					</tr>
					<tr>
						<th>选择</th>
						<th>会员名称</th>
						<th>店铺名称</th>
						<th>剩余保证金</th>
						<th>联系电话</th>
						<th>详细地址</th>
						<th>操作</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${empty pageBean.list}">
						<tr>
							<td colspan="10" style="text-align:center;">
								<font style="font-size:16px;" color="red">暂无相关数据!</font>
							</td>
						</tr>
					</c:if>
					<c:if test="${!empty pageBean.list}">
					<c:forEach items="${pageBean.list}" var="user" varStatus="status">
						<tr>
							<td><input type="checkbox" name="ids" id="10" class="nobor" />
							</td>
							<td align="left">${user.username }</td>
							<td>
								<a href="<%=basePath%>shop/view?shopId=${user.shopid}">${user.shopname}</a>
							</td>
							<td><span style="color:red;">${user.account }</span></td>
							<td>${user.mobile }</td>
							<td>${user.address }</td>
							<td>
							<c:choose>
							<c:when test="${user.flag==1 }">
								<input name="" type="button" value="上架" class="caozuo_input f_l" onclick="upFlag('${user.shopid}','flag',0)"/>
							</c:when>
							<c:otherwise>
								<input name="" type="button" value="下架" class="caozuo_input f_l" onclick="upFlag('${user.shopid}','flag',1)" />
							</c:otherwise>
							</c:choose> 
							<c:choose>
							<c:when test="${user.approve==0 }">
								<input name="" type="button" value="认证" class="caozuo_input f_l" onclick="upFlag('${user.shopid}','approve',1)"/>
							</c:when>
							<c:otherwise>
								<input name="" type="button" value="取消认证" class="caozuo_input f_l" onclick="upFlag('${user.shopid}','approve',0)"/>
							</c:otherwise>
							</c:choose> 
							<input name="" type="button" value="充值" class="caozuo_input f_l" onclick="alertJsp('充值保证金','${path}/shop/preEditAccount?shopId=${user.shopid }')"/>
								 
								 
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="7">
							<div class="bg">
								<div class="r_page">
									<script type="text/javascript">
										var url = location.href;
										var pageOne = new PageObject(url,'${pg}','${pageBean.totalPage}','${pageBean.totalRow}','pageOne');
									</script>
									<div class="clear"></div>
								</div>
							</div>
						</td>
					</tr>
					</c:if>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
