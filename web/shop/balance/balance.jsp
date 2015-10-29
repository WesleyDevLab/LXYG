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
<link rel="stylesheet" type="text/css" href="<%=basePath%>shop/balance/style.css" />
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/jquery.form.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript">
function init() {
	initRow();
	/* document.getElementById("b2").disabled=true; */
	/* var int; */
}

//校验是否全由数字组成
function isDigit3(digit) {
	var patrn = /^[0-9]{9}|[0-9]{13}$/;
	return patrn.test(digit);
}

function check() {
	var orderNo = $("#orderNo").val();
	if(null == orderNo || orderNo == "") {
		alert("请输入订单号！");
		return false;
	}
	if(!isDigit3(orderNo)) {
		alert("请输入9或13位的订单号！");
		return false;
	}
	
	$("#form").submit();
}

function formatNum(num){
	if (num==null||typeof(num)=='undefined') {
		num = 0;
	}
	document.writeln((num/100).toFixed(2));
}
</script>
</head>

<body onload="init()">
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：结算
	</div>
	<h1 class="tittle">消费结算</h1>
	<div class="con">
		<div class="wid_600">
			<div class="order_font">
				<img src="<%=basePath%>shop/images/tit123.jpg" width="319" height="45" />
			</div>
			<div>
				<form id="form" action="<%=basePath%>shop/toBalance" method="post">
					<input id="orderNo" name="orderNo" type="text" class="input_st" />
					<input type="button" onclick="check()" class="btn_red" value="验证订单号" />
				</form>
			</div>
			<div style="line-height: 40px;">
				提示：<span style="color: #01a5a6">进店付</span>的会员订单验证后，先付款，后消费！
				<span style="color: #FF0000">在线付</span>的会员订单验证后可直接消费，无需付款！
			</div>
			<div class="bg_bleu">
				验证状态： <span class="red_1">${order.code}</span>&nbsp;
				付款方式： <span class="red_1"><c:if test="${order.payMode==1}">在线支付</c:if><c:if test="${order.payMode==2}">到店支付</c:if></span>
			</div>

			<table width="620" border="1">
				<tr>
					<td valign="top">
						<table width="275" border="1" class="tab_lin">
							<tr>
								<th colspan="2">
									<img src="<%=basePath%>shop/images/f3.jpg" width="276" height="31" />
								</th>

							</tr>
							<tr>
								<td width="98">产品名称：</td>
								<td width="170" class="red_1">${order.orderName}</td>
							</tr>
							<tr>
								<td>数&nbsp;&nbsp;量：</td>
								<td class="red_1">${order.totalCount}</td>
							</tr>
							<tr>
								<td>金&nbsp;&nbsp;额：</td>
								<td class="red_1"><script type="text/javascript">formatNum(${order.totalCost});</script>元</td>
							</tr>
							<tr>
								<td>会员电话：</td>
								<td class="red_1">${order.phone}</td>
							</tr>
						</table>

					</td>
					<td valign="top">
						<table width="275" border="1" class="tab_lin">
							<tr>
								<th>
									<img src="<%=basePath%>shop/images/rd33.jpg" width="276" height="31" />
								</th>
							</tr>
							<tr>
								<td width="98" rowspan="4">${goods.remark}</td>
							</tr>
							<!--<tr>
								<td>数量</td>
							</tr>
							<tr>
								<td>金额</td>
							</tr>
							<tr>
								<td>会员电话</td>
							</tr>
						--></table>
					</td>
				</tr>
			</table>
		</div>
	</div>
</body>
</html>
