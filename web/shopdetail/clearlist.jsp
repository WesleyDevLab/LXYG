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
function toUrl(url) {
	location.href=url;
}

function selectAll(){
	$("INPUT[type='checkbox']").each( function() {
        $(this).attr('checked', true);
        $(this).parents('.checkbox').find('span').addClass('checked');
    });
}

function unselectAll(){
	$("INPUT[type='checkbox']").each( function() {
		if($(this).attr('checked')) {
			$(this).attr('checked', false);
			$(this).parents('.checkbox').find('span').removeClass('checked');
		} else {
			$(this).attr('checked', true);
	        $(this).parents('.checkbox').find('span').addClass('checked');
		}
    });
}

function delRecord() {
	var id = "";
	var ids = document.getElementsByName("ids");
	for ( var i = 0; i < ids.length; i++) {
		if (ids[i].type == "checkbox" && ids[i].checked) {
			id += ids[i].value + ",";
		}
	}
	if(id != null) {
		id = id.substring(0, id.length-1);
	}
	if(id == null || id == "") {
		alert("请选择订单！");
		return;
	}
	if (confirm("请问确定结算这些订单吗?", "警告")) {
		$.post("${path}/shop/stints", {
			"ids" : id
		}, function(data) {
			if (data == 1) {
				alert("结算成功！");
				location.href = "${path}/shop/clearlist?shopId=${shopId}&type=0";
			} else {
				alert("结算失败");
			}
		});
	}
}

//结算
function stint(orderId) {
	var url = "<%=basePath%>shop/stint";
	if(confirm("请问确定结算这个订单吗？","警告")) {
		$.post(url, {
			"orderId" : orderId
		}, function(data) {
			if (data == 1) {
				alert("结算成功！");
				location.href = "${path}/shop/clearlist?shopId=${shopId}&type=0";
			} else {
				alert("结算失败");
			}
		});
	}
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
						评论数量 <span class="font_red">58</span> 条
					</div>
					--><div class="tabbox">
						<div class="tabmenu">
							<dl>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/viewShop?shopId=${shopId}')">店铺信息</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/allGoods?shopId=${shopId}')">产品信息</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/orders?shopId=${shopId}&type=0')">订单详情</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/comments?shopId=${shopId}')">评价管理</a></dd>
								<dd class="cli">结算管理</dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearing?shopId=${shopId}')">结算记录</a></dd>
							</dl>
						</div>
						<div id="tabcontent">
							<div class="box-content">
								<table class="table table-bordered table-striped table-condensed">
									<div class="btn_sx">
										<ul>
											<c:if test="${type==0}">
												<button type="button" onclick="selectAll()" class="btn btn-danger">全选</button>
												<button type="button" onclick="unselectAll()" class="btn btn-primary">反选</button>
												<button type="button" onclick="delRecord()" class="btn">结算</button>
												<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">未结算</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=1')">已结算</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=2')">在线付</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=3')">到店付</a></li>
											</c:if>
											<c:if test="${type==1}">
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">未结算</a></li>
												<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=1')">已结算</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=2')">在线付</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=3')">到店付</a></li>
											</c:if>
											<c:if test="${type==2}">
												<button type="button" onclick="selectAll()" class="btn btn-danger">全选</button>
												<button type="button" onclick="unselectAll()" class="btn btn-primary">反选</button>
												<button type="button" onclick="delRecord()" class="btn">结算</button>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">未结算</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=1')">已结算</a></li>
												<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=2')">在线付</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=3')">到店付</a></li>
											</c:if>
											<c:if test="${type==3}">
												<button type="button" onclick="selectAll()" class="btn btn-danger">全选</button>
												<button type="button" onclick="unselectAll()" class="btn btn-primary">反选</button>
												<button type="button" onclick="delRecord()" class="btn">结算</button>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">未结算</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=1')">已结算</a></li>
												<li><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=2')">在线付</a></li>
												<li class="frist"><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=3')">到店付</a></li>
											</c:if>
										</ul>
									</div>
									<thead>
										<tr>
											<th>选择</th>
											<th>订单号</th>
											<th>联系电话</th>
											<th>产品名称</th>
											<th>金额</th>
											<th>支付方式</th>
											<th>结算状态</th>
											<th>结算时间</th>
											<th>操作</th>
										</tr>
									</thead>
									<tbody>
										<c:forEach items="${pageBean.list}" var="order" varStatus="loopStatus">
											<tr>
												<td>
													<c:if test="${order.state==5 && order.isbalance == 0}">
														<label class="checkbox">
			                                                <input class="states" type="checkbox" name="ids" value="${order.orderId}" />
			                                            </label>
		                                            </c:if>
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
													<c:if test="${order.isbalance == 0}">
														未结算
													</c:if>
													<c:if test="${order.isbalance == 1}">
														已结算
													</c:if>
												</td>
												<td>${order.baltime}</td>
												<td>
													<c:if test="${order.state==5 && order.isbalance == 0}">
														<button type="button" onclick="stint('${order.orderId}')" class="btn btn-danger">点击结算</button>
													</c:if>
													<!--<button type="button" class="btn btn-remove" onclick="del('${order.orderId}')">删除</button>
												--></td>
											</tr>
										</c:forEach>
										<tr>
											<td colspan="9">
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
										<c:if test="${type==1}">
											<tr>
												<td colspan="9">
													<div class="pagination">
														结算起始时间：${record.begintime}<br/>
														结算截止时间：${record.endtime}<br/>
														结算数量：${record.count}条<br/>
														结算金额：<script type="text/javascript">formatNum(${record.total});</script>元
													</div>
												</td>
											</tr>
										</c:if>
									</tbody>
								</table>
							</div>
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

