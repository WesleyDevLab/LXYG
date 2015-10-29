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
//弹出窗
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px',
		close : function () {
             art.dialog.open.origin.location.href='${path}/shop/allGoods?shopId=${shopId}';
        }
	});
}

function toUrl(url) {
	location.href=url;
}

function del(shopId) {
	var url = "<%=basePath%>goods/deleteByGoodsId";
	if (confirm("确定要删除吗?", "警告")) {
		$.post(url, {
			"goodsId" : shopId
		}, function(data) {
			if (data == 0) {
				alert("删除成功！");
				location.href = "<%=basePath%>shop/allGoods?shopId=${shopId}&pg=${pg}";
			} else {
				alert("删除失败！");
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
						被评论商家
						<span class="font_red">58</span>家 评论数量
						<span class="font_red">58</span> 条
					</div>
					--><div class="tabbox">
						<div class="tabmenu">
							<dl>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/viewShop?shopId=${shopId}')">店铺信息</a></dd>
								<dd class="cli">产品信息</dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/orders?shopId=${shopId}&type=0')">订单详情</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/comments?shopId=${shopId}')">评价管理</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">结算管理</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearing?shopId=${shopId}')">结算记录</a></dd>
							</dl>
						</div>
						<div id="tabcontent">
							<dl name="tabul">
								<div class="box-content">
									<button type="button" class="btn btn-primary" onclick="alertJsp('产品管理','<%=basePath %>goods/preEdit?type=ADD&shopId=${shopId}')" style="margin: 20px 0px;">
										添加产品
									</button>
									<table class="table table-bordered table-striped table-condensed">
										<thead>
											<tr>
												<th>序号</th>
												<th>产品名称</th>
												<th>原价</th>
												<th>现价</th>
												<th>产品图片</th>
												<th>限购</th>
												<th>库存</th>
												<th>添加时间</th>
												<th>操作</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach items="${pageBean.list}" var="goods" varStatus="loopStatus">
												<tr>
													<td>${loopStatus.count}</td>
													<td>
														<a href="<%=basePath %>goods/view?goodsId=${goods.goodsid}">${goods.goodsname}</a>
													</td>
													<td>
														<script type="text/javascript">formatNum(${goods.marketprice});</script>元
													</td>
													<td>
														<script type="text/javascript">formatNum(${goods.price});</script>元
													</td>
													<td>
														<img src="<%=imgPath %>${goods.img}" width="56" height="56" />
													</td>
													<td>
														<c:if test="${goods.isstint == 1}">
															限购
														</c:if>
														<c:if test="${goods.isstint == 0}">
															不限购
														</c:if>
													</td>
													<td>${goods.instock}</td>
													<td>${goods.createtime}</td>
													<td>
														<button type="button" class="btn btn-danger" onclick="alertJsp('产品管理','<%=basePath %>goods/preEdit?type=EDIT&shopId=${shopId}&goodsId=${goods.goodsid}')">编辑</button>
														<button type="button" class="btn btn-remove" onclick="del('${goods.goodsid}')">删除</button>
													</td>
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
	
	<%-- 弹出层begin --%>
	
	<%-- 弹出层end --%>
	<div class="clearfix"></div>
	<footer>
	<p>
		<span style="text-align: left; float: left">Copyright &copy;
			2014.乐享云购 All rights reserved.</span>
	</p>
	</footer>
</body>
</html>

