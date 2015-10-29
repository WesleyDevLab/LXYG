<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath%>shop/js/page.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/artDialog.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/iframeTools.js"></script>
<style type="text/css">
* {
	padding: 0px;
	margin: 0px;
}

#popupdiv {
	width: 460px;
	margin-bottom: 50px;
	position: absolute;
	z-index: 1000;
	border-radius: 10px;
	background: #FFF;
}

.group {
	float: none;
	overflow: hidden;
	width: 320px;
	margin: 0px auto;
}

.group span {
	float: left;
	display: inline-block;
	line-height: 34px;
}

.group input {
	width: 250px;
	height: 34px;
	border: 1px solid #ececec;
	border-radius: 2px;
}

.tittle_yz {
	float: none;
	overflow: hidden;
	width: 460px;
	margin: 0px auto 0px auto;
	border-bottom: 1px solid #CCC;
	background: #efefef;
	border-radius: 5px 5px 0px 0px;
	height: 50px;
}

.tittle_yz span {
	float: left;
	display: inline-block;
	line-height: 50px;
	height: 50px;
	font-size: 18px;
	font-family: "微软雅黑";
	font-weight: normal;
	text-indent: 1em;
}

.tittle_yz a {
	float: right;
	display: inline;
}

.wrong {
	font-size: 12px;
	color: #F00;
	line-height: 30px;
	width: 320px;
	height: 30px;
	margin: 0px auto;
	text-indent: 5.5em;
}

.none {
	display: none;
}

.qxbtn {
	width: 45%;
	float: left;
	display: inline;
	height: 34px;
	background: #999;
	color: #FFF;
	border-radius: 2px;
	border: 0px;
	padding: 0px
}

.reg_btn {
	width: 45%;
	float: right;
	display: inline;
	height: 34px;
	background: #86c657;
	color: #FFF;
	border-radius: 2px;
	border: 0px;
	padding: 0px
}

.group2 {
	float: none;
	overflow: hidden;
	width: 250px;
	color: #86c657;
	margin-left: 135px;
}

.comment {
	width: 420px;
	padding: 20px;
	margin: 0px auto
}
</style>
<script type="text/javascript">
function alertJsp(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
}

function init(){
	initRow();			
}

function toUrl(url) {
	location.href = url;
}

function update(goodsId) {
	location.href = "<%=basePath%>goods/preUpdate/" + goodsId;
}

function del(url, goodsId){
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"goodsId" : goodsId}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="<%=basePath %>goods";
		    } else {
		    	alert("删除失败！");
		    	location.href="<%=basePath %>goods";
		    }
		});
	}
}

function show(popupdiv, comment) {
	$("#comment").html(comment);
	var Idiv = document.getElementById(popupdiv);
	Idiv.style.display = "block";
	//以下部分要将弹出层居中显示
	Idiv.style.left = (document.documentElement.clientWidth - Idiv.clientWidth)
			/ 2 + document.documentElement.scrollLeft + "px";
	Idiv.style.top = (document.documentElement.clientHeight - Idiv.clientHeight)
			/ 2 + document.documentElement.scrollTop - 50 + "px";
	//以下部分使整个页面至灰不可点击
	var procbg = document.createElement("div"); //首先创建一个div
	procbg.setAttribute("id", "mybg"); //定义该div的id
	procbg.style.background = "#000000";
	procbg.style.width = "100%";
	procbg.style.height = "100%";
	procbg.style.position = "fixed";
	procbg.style.top = "0";
	procbg.style.left = "0";
	procbg.style.zIndex = "500";
	procbg.style.opacity = "0.6";
	procbg.style.filter = "Alpha(opacity=70)";
	//以上部分也可以用csstext代替
	// procbg.style.cssText="background:#000000;width:100%;height:100%;position:fixed;top:0;left:0;zIndex:500;opacity:0.6;filter:Alpha(opacity=70);";
	//背景层加入页面
	document.body.appendChild(procbg);
	document.body.style.overflow = "hidden"; //取消滚动条
	//以下部分实现弹出层的拖拽效果
	var posX;
	var posY;
	Idiv.onmousedown = function(e) {
		if (!e)
			e = window.event; //IE
		posX = e.clientX - parseInt(Idiv.style.left);
		posY = e.clientY - parseInt(Idiv.style.top);
		document.onmousemove = mousemove;
	}
	document.onmouseup = function() {
		document.onmousemove = null;
	}
	function mousemove(ev) {
		if (ev == null)
			ev = window.event;//IE
		Idiv.style.left = (ev.clientX - posX) + "px";
		Idiv.style.top = (ev.clientY - posY) + "px";
	}
}
//关闭弹出层
function closeDiv(popupdiv) {
	var Idiv = document.getElementById(popupdiv);
	Idiv.style.display = "none";
	document.body.style.overflow = "auto"; //恢复页面滚动条
	var body = document.getElementsByTagName("body");
	var mybg = document.getElementById("mybg");
	body[0].removeChild(mybg);
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：查看评论
	</div>
	<h1 class="tittle">评论列表</h1>
	<div class="con">

		<%-- <div class="search">
			<form name="form1" id="form1" action="<%=basePath %>goods" method="post">
				<input name="str" type="text" class="search_input" placeholder="产品名称、产品价格等" title="产品名称、产品价格等" />
				<input type="submit" value="搜索" class="search_btn" /> 
				<input type="button" value="添加产品" onclick="toUrl('<%=basePath %>goods/preAdd');" class="add_pro" />
			</form>
		</div> --%>
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>订单号</th>
					<th>联系电话</th>
					<th>产品名称</th>
					<th>评价内容</th>
					<th>评价时间</th>
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
					<c:forEach items="${pg.list}" var="order" varStatus="loopStatus">
						<tr>
							<td>
								${loopStatus.count}
							</td>
							<td>
								${order.orderNo}
							</td>
							<td>
								${order.phone}
							</td>
							<td>
								${order.orderName}
							</td>
							<td>
								<c:if test="${fn:length(order.comment)>5}">
									${fn:substring(order.comment, 0, 5)}...
									<a href="javascript:void(0)" id="show" onclick="show('popupdiv','${order.comment}')"><b class="red">[详情]</b></a>
								</c:if> 
								<c:if test="${fn:length(order.comment)<=5}">
									${order.comment}
								</c:if>
							</td>
							<td>${order.etime}</td>
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
	<div id="popupdiv" style="display: none;">
		<h1 class="tittle_yz">
			<span>评论详情</span>
			<a href="javascript:void(0)" onclick="closeDiv('popupdiv')"> 
				<img src="<%=basePath %>public/img/close.png" width="50" height="50" /> 
			</a>
		</h1>
		<div id="comment" class="comment"></div>
	</div>
</body>
</html>

