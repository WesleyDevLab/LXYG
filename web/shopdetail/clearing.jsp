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
<script type="text/javascript">
function init() {
	initRow();
}

function toUrl(url) {
	location.href=url;
}

</script>
</head>
<%@ include file="../common/top.jsp"%>
<body onload="init()">
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
						被评论商家 <span class="font_red">58</span>家 
						评论数量 <span class="font_red">58</span>条
					</div>
					--><div class="tabbox">
						<div class="tabmenu">
							<dl>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/viewShop?shopId=${shopId}')">店铺信息</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/allGoods?shopId=${shopId}')">产品信息</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/orders?shopId=${shopId}&type=0')">订单详情</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/comments?shopId=${shopId}')">评价管理</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">结算管理</a></dd>
								<dd class="cli">结算记录</dd>
							</dl>
						</div>
						<div id="tabcontent">
							<dl name="tabul">
								<div class="box-content">
									<table class="table table-bordered table-striped table-condensed">
										<thead>
										<tr>
											<th>序号</th>
											<th>结算时间</th>
											<th>结算金额</th>
											<th>支付方式</th>
										</tr>
										</thead>
										<tbody>
											<c:forEach items="${pageBean.list}" var="order" varStatus="loopStatus">
												<tr>
													<td>${loopStatus.count}</td>
													<td>
														${order.baltime}
													</td>
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
												</tr>
											</c:forEach>
											<tr>
												<td colspan="4">
													<div class="pagination pagination-centered">
														<div class="bg">
															<div class="r_page">
																<script type="text/javascript">
																	var url = location.href;
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

