<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
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

function formatNum(num){
	if (num==null||typeof(num)=='undefined') {
		num = 0;
	}
	document.writeln((num/100).toFixed(2));
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：查看订单
	</div>
	<h1 class="tittle">订单列表</h1>
	<div class="con">

		<%-- <div class="search">
			<form name="form1" id="form1" action="<%=basePath %>goods" method="post">
				<input name="str" type="text" class="search_input" placeholder="产品名称、产品价格等" title="产品名称、产品价格等" />
				<input type="submit" value="搜索" class="search_btn" /> 
				<input type="button" value="添加产品" onclick="toUrl('<%=basePath %>goods/preAdd');" class="add_pro" />
			</form>
		</div> --%>
		
		<div class="btn_sx"> 
			<ul>
				<c:if test="${type==0}">
					<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=0')">全部</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=1')">未付款</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=2')">未消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=3')">已消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=4')">在线付</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=5')">到店付</a></li>
				</c:if>
				<c:if test="${type==1}">
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=0')">全部</a></li>
					<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=1')">未付款</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=2')">未消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=3')">已消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=4')">在线付</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=5')">到店付</a></li>
				</c:if>
				<c:if test="${type==2}">
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=0')">全部</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=1')">未付款</a></li>
					<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=2')">未消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=3')">已消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=4')">在线付</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=5')">到店付</a></li>
				</c:if>
				<c:if test="${type==3}">
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=0')">全部</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=1')">未付款</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=2')">未消费</a></li>
					<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=3')">已消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=4')">在线付</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=5')">到店付</a></li>
				</c:if>
				<c:if test="${type==4}">
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=0')">全部</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=1')">未付款</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=2')">未消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=3')">已消费</a></li>
					<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=4')">在线付</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=5')">到店付</a></li>
				</c:if>
				<c:if test="${type==5}">
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=0')">全部</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=1')">未付款</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=2')">未消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=3')">已消费</a></li>
					<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=4')">在线付</a></li>
					<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath%>shop/order4Shop?type=5')">到店付</a></li>
				</c:if>
			</ul>
		</div>
		
		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>订单号</th>
					<th>联系电话</th>
					<th>产品名称</th>
					<th>数量</th>
					<th>金额</th>
					<th>支付方式</th>
					<th>订单类型</th>
					<th>消费时间</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty pg.list}">
					<tr height="30" style="text-align: center;">
						<td colspan="9"><font style="font-size:16px;" color="red">暂无相关数据!</font>
						</td>
					</tr>
				</c:if>
				<c:if test="${!empty pg.list}">
					<c:forEach items="${pg.list}" var="order" varStatus="loopStatus">
						<tr>
							<td>
								${loopStatus.count}
							</td>
							<td>${order.orderNo}</td>
							<td>${order.phone}</td>
							<td>${order.orderName}</td>
							<td>${order.totalCount}</td>
							<td>
								<script type="text/javascript">formatNum(${order.totalCost});</script>元
							</td>
							<td>
								<c:if test="${order.payMode == 1}">
									在线支付
								</c:if>
								<c:if test="${order.payMode == 2}">
									到店支付
								</c:if>
							</td>
							<td>
								<c:if test="${order.payMode == 1}">
									<c:if test="${order.state == 1}">
										未支付
									</c:if>
									<c:if test="${order.state == 4}">
										未消费
									</c:if>
									<c:if test="${order.state == 5}">
										已消费
									</c:if>
								</c:if>
								<c:if test="${order.payMode == 2}">
									<c:if test="${order.state == 1}">
										未消费
									</c:if>
									<c:if test="${order.state == 5}">
										已消费
									</c:if>
								</c:if>
								
							</td>
							<td>${order.contime}</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="9">
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

