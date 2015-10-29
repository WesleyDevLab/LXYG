<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
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
function init(){
	initRow();			
}
function add(){ 
	location.href="<%=basePath%>draw/preAdd?parentId=${parentId}";
}	 
function upOrderBy(){
	var drawId = "";
	var ids = document.getElementsByName("ids");
	for(var i=0;i<ids.length;i++){
		if(ids[i].type== "checkbox" && ids[i].checked){ 
			drawId += ids[i].value+",";
		}
	}
	var did = drawId.split(',');
	if(did.length-1>1){
		alert("只能选择一个");
		return;
	}else{
		var id=did[0];
		var orderby = $("#orderby").val();
		alert(orderby);
		$.post("<%=basePath%>draw/edit",{"drawId":id,"orderby":orderby},function(data){
	 	if(data=='0'){
			alert("修改成功！");
			location.href="<%=basePath%>draw/list?parentId=${parentId}";
		}else{
			alert("修改失败！");
		}
	});
		
	}
}
function delRecord() {
	var drawId = "";
	var ids = document.getElementsByName("ids");
	for ( var i = 0; i < ids.length; i++) {
		if (ids[i].type == "checkbox" && ids[i].checked) {
			alert(ids[i].value);
			drawId += ids[i].value + ",";
			alert(drawId);
		}
	}
	$.post("<%=basePath%>draw/del", 
		{"drawId" : drawId}, 
		function(data) {
			if (data == '0') {
				alert("删除成功！");
				location.href = "<%=basePath%>draw/list?parentId=${parentId}";
			} else {
				alert("删除失败！");
			}
		});

}
function update(drawId) {
	location.href = "<%=basePath%>draw/preEdit?drawId=" + drawId
			+ "&parentId=${parentId}";
}
function drawByCol(val) {
	if (val != 0) {
		location.href = "<%=basePath%>draw/list?parentId=${parentId}&columnId=" + val;
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
		<div class="chaxun">商家管理</div>
		<div class="tabbox">
			<div class="tabmenu">
				<ul>
					<li class="cli">顶部广告管理</li>
				</ul>
			</div>
		</div>
		<div class="caozuo">
			<form id="form1" action="<%=basePath%>user/searchByName" method="post">
				<input name="" type="button" value="全选" onclick="selectAll(document.form2);" class="caozuo_input f_l" /> 
				<input name="" type="button" value="反选" onclick="unselectAll(document.form2);" class="caozuo_input f_l" />
				<input name="" type="button" value="删除" onclick="delRecord();" class="caozuo_input f_l" /> 
				<input name="username" id="orderby" value="" class="caozuo_input_shuru" style="width=20px;" /> 
				<input name="" type="button" value="修改排序" onclick="upOrderBy();" class="caozuo_input f_l" /> 
				<input name="" type="button" value="添加" onclick="add();" class="caozuo_input f_l" />
			</form>

		</div>

		<div class="tab">
			<table border="0" cellpadding="4" cellspacing="1" width="100%">
				<thead>
					<tr>
						<th width="6%">选择</th>
						<th width="20%">名称</th>
						<th width="20%">描述</th>
						<th width="10%">URL</th>
						<th width="10%">排序</th>
						<th width="20%">操作</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${empty drawList}">
						<tr>
							<td colspan="10" style="text-align:center;">
								<font style="font-size:16px;" color="red">暂无相关数据!</font>
							</td>
						</tr>
					</c:if>
					<c:forEach items="${drawList}" var="draw" varStatus="status">
						<tr>
							<td>
								<input type="checkbox" name="ids" id="10" class="nobor" value="${draw.drawid }" />
							</td>
							<td align="left">${draw.title }</td>
							<td>${draw.desc }</td>
							<td>${draw.url }</td>
							<td>${draw.orderby}</td>
							<td>
								<a class="bj" href="JavaScript:update('${draw.drawid}');">修改</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
