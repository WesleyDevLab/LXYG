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
	<style>
		.white_product {
			border-radius: 5px;
			display: none;
			position: absolute;
			top: 20%;
			left: 30%;
			width: 40%;
			height: 40%;
			padding: 10px 20px 20px 20px;
			border: 0px solid ;
			background-color: rgba(105,105,105,0.8);
			z-index:1002;
			overflow: auto;
			box-shadow:2px 2px 10px #909090;
		}

		.white_shop {
			border-radius: 5px;
			display: none;
			position: absolute;
			top: 20%;
			left: 30%;
			width: 20%;
			height: 40%;
			padding: 10px 20px 20px 20px;
			border: 0px solid ;
			background-color: rgba(105,105,105,0.8);
			z-index:1002;
			overflow: auto;
			box-shadow:2px 2px 10px #909090;
		}
	</style>
<script type="text/javascript">
	var orders='${orders}';
	var obj=jQuery.parseJSON(orders);
	console.info(obj);

	function showProductInfo(orderId){
		var objs=jQuery.parseJSON(orders);
		for(var i=0;i<objs.length;i++){
			var str="";
			$("#pros").html(str);
			if(objs[i].orderId==orderId){
				var items=objs[i].items;
				for(var j=0;j<items.length;j++){
					str+="<tr ><td>"+items[j].columns.name+"</td><td>"+items[j].columns.product_number+"</td><td>￥"+items[j].columns.product_price/100+"</td></tr>";
				}
				$("#pros").append(str);
				$("#product").fadeIn();
				return;
			}
		}
	}

	function closeProductInfo(){
		$("#product").fadeOut();
	}
	function showShopInfo(shopId){
		$.post("${path}/order/loadShopInfo",{"shop_id":shopId},function(result){
			if(result.code==10002){
				$("#shopInfo").html("");
				$("#shopInfo").append("<tr><td>商户名称</td><td>"+result.data.name+"</td></tr>" +
						"<tr><td>联系人</td><td>"+result.data.link_man+"</td></tr>"+
						"<tr><td>联系电话</td><td>"+result.data.phone+"</td></tr>"+
						"<tr><td>店铺地址</td><td>"+result.data.full_address+"</td></tr>");
				$("#shop").fadeIn();
			}
		});
	}

	function closeShopInfo(){
		$("#shop").fadeOut();
	}

</script>
</head>
<%@ include file="../common/top.jsp"%>
<body>
<div id="product" class="white_product">
	<div >
		<img onclick="closeProductInfo();" src="http://7xk59r.com2.z0.glb.qiniucdn.com/exit.png"  style="float: right;padding-bottom: 10px">
	</div>
	<table class="table table-bordered  table-condensed" style="overflow:scroll;color: white">
		<thead>
		<tr>
			<th>产品名字</th>
			<th>购买数量</th>
			<th>购买价格</th>
		</tr>
		</thead>
		<tbody id="pros">
		</tbody>
	</table>
</div>

<div id="shop" class="white_shop">
	<div style="height: 20px">
		<img onclick="closeShopInfo();" src="http://7xk59r.com2.z0.glb.qiniucdn.com/exit.png"  style="float: right;padding-bottom: 10px">
	</div>
	<table class="table table-bordered  table-condensed" style="overflow:scroll;color: white;" >
		<tbody id="shopInfo">

		</tbody>
	</table>

</div>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>编辑商家
					</h2>
					<div class="box-icon">
						<a href="javascript:history.back()" class="btn-add"> 
							<i class="icon-edit" style="width: 60px;">返回</i> 
						</a>
					</div>
				</div>
				<div class="box-content">
					<!--<div class="bar_blue">
						被评论商家
						<span class="font_red">58</span>家 评论数量
						<span class="font_red">58</span> 条
					</div>
					--><div class="tabbox">
						<div class="tabmenu">
							<dl>
								<dd class="cli">送货商家</dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">结算管理</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearing?shopId=${shopId}')">结算记录</a></dd>
							</dl>
						</div>
						<div id="tabcontent">
							<dl name="tabul">
								<div class="box-content">
									<table class="table table-bordered table-striped table-condensed">
										<div class="btn_sx">

										</div>
										<thead>
											<tr>
												<th>订单号</th>
												<th>支付方式</th>
												<th>收货人/电话</th>
												<th>收货地址</th>
												<th>店铺</th>
												<th>店铺电话</th>
												<th>配送方式</th>
												<th>订单状态</th>
												<th>订单金额</th>
												<th>时间</th>
												<th>产品信息</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${orders}" var="order" varStatus="loopStatus">
												<tr>
													<td>${order.orderNo}</td>
													<td>
														${order.payType}
													</td>
													<td>
														${order.userName}/${order.phone}
													</td>
													<td>
														<%--<script type="text/javascript">formatNum(${order.totalCost});</script>元--%>
														${order.sendAddress}
													</td>
													<td>
														<a href="javascript:void(0)" onclick="showShopInfo('${order.shop_id}');" style="color: #30ace9">${order.shopName}</a>

													</td>
													<td>
														${order.shopPhone}
													</td>
													<td>
														${order.sendName}
													</td>
													<td><span style="color:indianred">${order.orderStatusName}</span></td>

													<td>￥ ${order.price/100}</td>
													<td>${order.create_time}</td>
													<td style="display: none">${order.items}</td>
													<td><a href="javascript:void(0)"  onclick="showProductInfo('${order.orderId}')" style="color: #30ace9">查看产品详情</a></td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</dl>
						</div>
					</div>
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
</body>
</html>

