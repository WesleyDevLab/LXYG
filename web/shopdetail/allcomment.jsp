<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<style type="text/css">
* {
	padding: 0px;
	margin: 0px;
}

#popupdiv {
	width: 460px;
	margin-bottom: 50px;
	position: fixed;
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

.con {
	width: 420px;
	padding: 20px;
	margin: 0px auto
}
</style>
<script type="text/javascript">
function toUrl(url) {
	location.href=url;
}

function del(orderId) {
	var url = "${path}/shop/delComment";
	if (confirm("确定要删除吗?", "警告")) {
		$.post(url, {
			"orderId" : orderId
		}, function(data) {
			if (data == 1) {
				alert("删除成功！");
				location.href = "${path}/shop/allcomment?type=0";
			} else {
				alert("删除失败！");
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
<%@ include file="../common/top.jsp"%>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>评价管理
					</h2>
				</div>
				<div class="box-content">
					<div style="margin:10px 0;">
					    <div class="bar_blue">
							 被评论商家<span class="font_red">${count.scount}</span>家 
							 评论数量<span class="font_red">${count.count}</span>条
					    </div>
					    <form action="<%=basePath %>shop/allcomment" method="post">
					    	<table>
		                        <tr>
			                      	<td valign="middle" style="padding-left:20px;  padding-right:10px;" >商家名称:</td>
									<td>
										<div class="dataTables_filter" id="shopname">
											<input type="text" name="shopname" value="${shopname}" aria-controls="DataTables_Table_0">
											<input type="hidden" name="type" value="2" />
										</div>
									</td>
									<td valign="top">
										<button type="submit" class="btn btn-primary">搜索</button>
									</td>
		                        </tr>
	                        </table>
                        </form>
					</div>
					<table class="table table-bordered table-striped table-condensed">
	                    <thead>
		                    <tr>
			                    <th>序号</th>
			                    <th>店铺名称</th>
			                    <th>订单号</th>
			                    <th>联系电话</th>
			                    <th>产品名称</th>
			                    <th>评价内容</th>
			                    <th>评价时间</th>
			                    <th>操作</th>
		                    </tr>
	                    </thead>
	                    <tbody>
		                    <c:forEach items="${pageBean.list}" var="order" varStatus="loopStatus">
								<tr>
									<td>${loopStatus.count}</td>
									<td>${order.shopname}</td>
									<td>${order.orderNo}</td>
									<td>${order.phone}</td>
									<td>${order.orderName}</td>
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
									<td class="center">
										<button type="button" onclick="del('${order.orderId}')" class="btn btn-primary">删除</button>
									</td>
								</tr>
							</c:forEach>
							<tr>
								<td colspan="11">
									<div class="pagination pagination-centered">
										<div class="bg">
											<div class="r_page">
												<script type="text/javascript">
													var url = location.href;
													var type = "${type}";
													if (type == 1) {
														var shopname = "${shopname}";
														url = url + "?type=1&shopname=" + shopname;
													}
													var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
												</script>
											</div>
											<div class="clear"></div>
										</div>
									</div>
								</td>
							</tr>
	                    </tbody>
                    </table>
				</div>
			</div>
			<!--/span-->

		</div>
		<!--/row-->


	</div>

	</div>
	<!--/fluid-row-->
	<!--/row-->

	</div>
	<!--/fluid-row-->

	<div class="clearfix"></div>
	<footer>
	<p>
		<span style="text-align: left; float: left">Copyright &copy;
			2014.乐享云购 All rights reserved.</span>
	</p>
	</footer>
	<div id="popupdiv" style="display: none;">
		<h1 class="tittle_yz">
			<span>评论详情</span>
			<a href="javascript:void(0)" onclick="closeDiv('popupdiv')"> 
				<img src="${path}/public/img/close.png" width="50" height="50" /> 
			</a>
		</h1>
		<div id="comment" class="con"></div>
	</div>
</body>
</html>

