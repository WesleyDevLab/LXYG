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

function tabChange(obj, id) {
	var arrayli = obj.parentNode.getElementsByTagName("dd"); //获取li数组
	var arrayul = document.getElementById(id).getElementsByTagName("dl"); //获取ul数组
	for (i = 0; i < arrayul.length; i++) {
		if (obj == arrayli[i]) {
			arrayli[i].className = "cli";
			arrayul[i].className = "";
		} else {
			arrayli[i].className = "";
			arrayul[i].className = "hidden";
		}
	}
}

function toSift(val) {
	var url = "<%=basePath%>user/toSift?type=${type}&approve=";
	location.href = url + val;
}

function upFlag(shopId, type, val) {
	$.post("${path }/shop/edit", {
		"type" : type,
		"val" : val,
		"shopId" : shopId
	}, function(data) {
		if (data == '0') {
			alert("操作成功！");
			location.href = "${path }/user/list?type=1";
		} else {
			alert("删除失败！");
		}
	});
}

function del(shopId) {
	var url = "<%=basePath%>user/delShop";
	if (confirm("确定要删除吗?", "警告")) {
		$.post(url, {
			"shopId" : shopId
		}, function(data) {
			if (data == 0) {
				alert("删除成功！");
				location.href = "${path }/user/list?type=1";
			} else {
				alert("删除失败！");
			}
		});
	}
}

//表单提交验证
function checkForm() {
	var realname = $("#realname").val();
	var mobile = $("#mobile").val();
	var shopname = $("#shopname").val();
	var address = $("#address").val();
	var telphone = $("#telphone").val();
	var columnId = $("#columnId").val();
	if (realname == "") {
		alert("请认真填写店主姓名！");
		return false;
	} else if (mobile == "") {
		alert("请认真填写手机号码！");
		return false;
	} else if (shopname == "") {
		alert("请认真填写商家名称！");
		return false;
	} else if (telphone == "") {
		alert("请认真填写商家电话！");
		return false;
	} else if (columnId == "") {
		alert("请选择商家类型！");
		return false;
	} else if (address == "") {
		alert("请认真填写商家地址！");
		return false;
	} else {
		$("#shop_ajax").ajaxSubmit( {
			dataType : 'text',
			success : function(msg) {
				alert("保存成功！");
				if (msg == "0")
					window.location.href = "<%=basePath%>shop/view?shopId=${shop.shopid}";
				else
					window.location.href = "<%=basePath%>login/login.jsp";
			}
		});
	}
}

//重置密码
function resetPass() {
	var shopId = $("#shopid").val();
	var npa = $("#newPassword").val();
	var rpa = $("#rPassword").val();
	var check = true;
	if (npa.length < 6) {
		alert("新密码不能低于6位!");
		check = false;
	} else if (npa != rpa) {
		alert("新密码前后两次不一致！");
		check = false;
	}

	if (check) {
		$.post('<%=basePath%>user/resetPass', {"shopId" : shopId, "npa" : npa},
		function(data) {
			if(data == "0") {
				alert("重置成功！");
				window.location.href="<%=basePath%>shop/view?shopId=${shop.shopid }";
			} else {
				alert("重置失败！");
			}
		});
	}
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
						<a href="添加商家.html" class="btn-add"> 
							<i class="icon-edit" style="width: 60px;">返回</i> 
						</a>
					</div>
				</div>
				<div class="box-content">
					<div class="bar_blue">
						被评论商家
						<span class="font_red">58</span>家 评论数量
						<span class="font_red">58</span> 条
					</div>
					<div class="tabbox">
						<div class="tabmenu">
							<dl>
								<dd class="cli">店铺信息</dd>
								<dd>产品信息</dd>
								<dd>订单详情</dd>
								<dd>评价管理</dd>
								<dd>结算管理</dd>
								<dd>结算记录</dd>
							</dl>
						</div>
						<div id="tabcontent">
							<dl name="tabul">
								<div class="box-content">
									<form class="form-horizontal" />
										<fieldset>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													新密码：
												</label>
												<div class="controls">
													<input type="password" id="newPassword" name="newPassword" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													密码确认：
												</label>
												<div class="controls">
													<input type="password" id="rPassword" name="rPassword" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													密码重置：
												</label>
												<div class="controls">
													<button type="button" class="btn btn-primary" onclick="resetPass()">
														确认修改
													</button>
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													店主姓名：
												</label>
												<div class="controls">
													<input type="text" id="realname" name="realname" value="${shop.realname}" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													手机号码：
												</label>
												<div class="controls">
													<input type="text" id="mobile" name="mobile" value="${shop.mobile}" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													店铺名称：
												</label>
												<div class="controls">
													<input type="text" id="shopname" name="shopname" value="${shop.shopname}" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													店铺电话：
												</label>
												<div class="controls">
													<input type="text" id="telphone" name="telphone"  value="${shop.telphone}" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="selectError3">
													经营类型：
												</label>
												<div class="controls">
													<select id="columnId" name="columnId">
														<c:forEach items="${colList }" var="col">
															<c:choose>
																<c:when test="${col.id==shop.columnid}">
																	<option value="${col.id }" selected="selected">${col.cname }</option>
																</c:when>
																<c:otherwise>
																	<option value="${col.id }">${col.cname }</option>
																</c:otherwise>
															</c:choose>
														</c:forEach>
													</select>
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													地址：
												</label>
												<div class="controls">
													<input type="text" id="address" name="address" value="${shop.address }" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													描述：
												</label>
												<div class="controls">
													<input type="text" id="remark" name="remark" value="${shop.remark}" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" style="color: #FF0000" for="typeahead">
													付款方式：
												</label>
												<div class="controls">
													<select id="payMode" name="payMode">
														<c:choose>
															<c:when test="${shop.payMode==0}">
																<option value="0" selected="selected">在线支付和到店支付</option>
																<option value="1">在线支付</option>
																<option value="2">到店支付</option>
															</c:when>
															<c:when test="${shop.payMode==1}">
																<option value="0">在线支付和到店支付</option>
																<option value="1" selected="selected">在线支付</option>
																<option value="2">到店支付</option>
															</c:when>
															<c:otherwise>
																<option value="0">在线支付和到店支付</option>
																<option value="1">在线支付</option>
																<option value="2" selected="selected">到店支付</option>
															</c:otherwise>
														</c:choose>
													</select>
												</div>
											</div>
											<div class="form-actions">
												<input type="hidden" id="shopid" name="shopid" value="${shop.shopid}" />
												<input type="button" value="保存" onclick="checkForm()" class="btn btn-primary" /> 
												<input type="reset" value="重置" class="btn" />
											</div>
										</fieldset>
									</form>
								</div>
							</dl>
							<dl class="hidden">
								<button type="button" class="btn btn-primary" style="margin: 20px 0px;">
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
										<c:forEach items="${list}" var="goods" varStatus="loopStatus">
											<tr>
												<td>${loopStatus.count}</td>
												<td>
													<a href="<%=basePath %>goods/view?goodsId=${goods.goodsid}">${goods.goodsname}</a>
												</td>
												<td>
													<script type="text/javascript">formatNum(${goods.price});</script>元
												</td>
												<td>
													<script type="text/javascript">formatNum(${goods.marketprice});</script>元
												</td>
												<td>
													<img src="<%=imgPath %>${goods.img}" width="34" height="34" />
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
													<button type="button" class="btn btn-remove" onclick="del('<%=basePath %>goods/delete','${goods.goodsid}')">删除</button>
												</td>
											</tr>
										</c:forEach>
									</tbody>
									<!-- <div class="pagination pagination-centered">
										<div class="bg">
											<div class="r_page">
												<script type="text/javascript">
													var url = location.href;
													var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
												</script>
											</div>
											<div class="clear"></div>
										</div>
									</div> -->
								</table>
								
								<div class="box-content">
									<form class="form-horizontal" />
										<fieldset>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													产品名称：
												</label>
												<div class="controls">
													<input type="text" class="span6 typeahead" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													产品原价：
												</label>
												<div class="controls">
													<input type="password" class="span6 typeahead"
														style="width: 100px;" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													现价：
												</label>
												<div class="controls">
													<input type="password" class="span6 typeahead"
														style="width: 100px;" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													限购：
												</label>
												<div class="controls">
													<select name="" style="width: 60px;">
														<option>
															是
														</option>
														<option>
															否
														</option>
													</select>
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													每人限购数量：
												</label>
												<div class="controls">
													<input type="password" class="span6 typeahead"
														style="width: 70px;" />
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													库存：
												</label>
												<div class="controls">
													<input type="password" class="span6 typeahead"
														style="width: 70px;" />
												</div>
											</div>

											<div class="control-group">
												<label class="control-label" for="typeahead">
													产品图片上传：
												</label>
												<div class="controls">
													<input name="" type="file">
												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													产品注释：
												</label>
												<div class="controls">
													<textarea name="" cols="" rows=""
														style="width: 700px; height: 200px;"></textarea>

												</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													产品简介：
												</label>
												<div class="controls">
													<textarea name="" cols="" rows=""
														style="width: 700px; height: 200px;"></textarea>

												</div>
											</div>

											<div class="form-actions">
												<button type="submit" class="btn btn-primary">
													保存
												</button>
												<button type="reset" class="btn">
													重置
												</button>
											</div>
										</fieldset>
									</form>
								</div>

							</dl>
							<dl class="hidden">


								<table
									class="table table-bordered table-striped table-condensed">
									<div class="btn_sx">
										<ul>
											<li class="frist">
												全部
											</li>
											<li>
												未付款
											</li>
											<li>
												已付款
											</li>
											<li>
												已付款
											</li>
										</ul>
									</div>
									<thead>
										<tr>
											<th>
												序号
											</th>
											<th>
												订单号
											</th>
											<th>
												联系电话
											</th>
											<th>
												订单金额
											</th>
											<th>
												数量
											</th>
											<th>
												产品名称
											</th>
											<th>
												订单类型
											</th>
											<th>
												消费状态
											</th>
											<th>
												订购时间
											</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												1
											</td>
											<td class="center">
												008300003
											</td>
											<td class="center">
												18137497807
											</td>
											<td class="center">
												140.00 元
											</td>
											<td class="font_red">
												200.00元
											</td>
											<td>
												7.00
											</td>
											<td class="center">
												在线支付
											</td>
											<td class="center">
												已消费
											</td>
											<td class="center">
												2015-01-02 14：11：25
											</td>
										</tr>
										<tr>
											<td>
												1
											</td>
											<td class="center">
												008300003
											</td>
											<td class="center">
												18137497807
											</td>
											<td class="center">
												140.00 元
											</td>
											<td class="font_red">
												200.00元
											</td>
											<td>
												7.00
											</td>
											<td class="center redco">
												进店支付
											</td>
											<td class="center wxf">
												未消费
											</td>
											<td class="center">
												2015-01-02 14：11：25
											</td>
										</tr>
										<tr>
											<td>
												1
											</td>
											<td class="center">
												008300003
											</td>
											<td class="center">
												18137497807
											</td>
											<td class="center">
												140.00 元
											</td>
											<td class="font_red">
												200.00元
											</td>
											<td>
												7.00
											</td>
											<td class="center redco">
												进店支付
											</td>
											<td class="center redco">
												未付款
											</td>
											<td class="center">
												2015-01-02 14：11：25
											</td>
										</tr>
										<tr>
											<td colspan="9">
												<div class="pagination pagination-centered">
													<ul>
														<li>
															<a href="#">上一页</a>
														</li>
														<li class="active">
															<a href="#">1</a>
														</li>
														<li>
															<a href="#">2</a>
														</li>
														<li>
															<a href="#">3</a>
														</li>
														<li>
															<a href="#">4</a>
														</li>
														<li>
															<a href="#">下一页</a>
														</li>
													</ul>
												</div>
											</td>
										</tr>

									</tbody>
								</table>

							</dl>
							<dl class="hidden">
								<table
									class="table table-bordered table-striped table-condensed">

									<tr>
										<th>
											序号
										</th>
										<th>
											订单号
										</th>
										<th>
											联系电话
										</th>
										<th>
											产品名称
										</th>
										<th>
											评价内容
										</th>
										<th>
											评价时间
										</th>
										<th>
											操作
										</th>
									</tr>

									<tr>
										<td>
											1
										</td>
										<td class="center">
											008300003
										</td>
										<td class="center">
											18137497807
										</td>
										<td class="center">
											又
										</td>
										<td class="center">
											<a href="#">评价内容<span class="font_red">[详细]</span> </a>
										</td>
										<td class="center">
											2015-01-02 12：10：02
										</td>
										<td class="center">
											<button type="button" class="btn btn-primary">
												删除
											</button>
										</td>
									</tr>
									<tr>
										<td colspan="7">
											<div class="pagination pagination-centered">
												<ul>
													<li>
														<a href="#">上一页</a>
													</li>
													<li class="active">
														<a href="#">1</a>
													</li>
													<li>
														<a href="#">2</a>
													</li>
													<li>
														<a href="#">3</a>
													</li>
													<li>
														<a href="#">4</a>
													</li>
													<li>
														<a href="#">下一页</a>
													</li>
												</ul>
											</div>
										</td>
									</tr>

								</table>
							</dl>
							<dl class="hidden">
								<table
									class="table table-bordered table-striped table-condensed">
									</tr>

									<tr>
										<td colspan="7">
											<div class="btn_sx">
												<ul>
													<li class="frist">
														未结算
													</li>
													<li>
														已结算
													</li>

												</ul>
											</div>
										</td>
									</tr>

									<tr>
										<th>
											序号
										</th>
										<th>
											订单号
										</th>
										<th>
											联系电话
										</th>
										<th>
											产品名称
										</th>
										<th>
											评价内容
										</th>
										<th>
											评价时间
										</th>
										<th>
											操作
										</th>
									</tr>

									<tr>
										<td>
											1
										</td>
										<td class="center">
											008300003
										</td>
										<td class="center">
											18137497807
										</td>
										<td class="center">
											又
										</td>
										<td class="center">
											<a href="#">评价内容<span class="font_red">[详细]</span> </a>
										</td>
										<td class="center">
											2015-01-02 12：10：02
										</td>
										<td class="center">
											<button type="button" class="btn btn-primary">
												删除
											</button>
										</td>
									</tr>

									<tr>
										<td colspan="7">
											<div class="pagination pagination-centered">
												<ul>
													<li>
														<a href="#">上一页</a>
													</li>
													<li class="active">
														<a href="#">1</a>
													</li>
													<li>
														<a href="#">2</a>
													</li>
													<li>
														<a href="#">3</a>
													</li>
													<li>
														<a href="#">4</a>
													</li>
													<li>
														<a href="#">下一页</a>
													</li>
												</ul>
											</div>
										</td>
									</tr>
								</table>


							</dl>
							<dl class="hidden">
								<table>
									<tr>


										<td style="padding-left: 20px; padding-right: 10px;">
											支付方式
										</td>
										<td>
											<select name="" class="inpt_sec">
												<option>
													在线支付
												</option>
												<option>
													到店支付
												</option>
											</select>
										</td>

									</tr>
								</table>
								<table
									class="table table-bordered table-striped table-condensed">
									<thead>
										<tr>
											<th>
												序号
											</th>
											<th>
												结算时间
											</th>
											<th>
												结算金额
											</th>
											<th>
												支付方式
											</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td>
												1
											</td>
											<td>
												许培育
											</td>
											<td class="center">
												008300003
											</td>
											<td class="center">
												18137497807
											</td>

										</tr>
										<tr>
											<td colspan="4">
												<div class="pagination pagination-centered">
													<ul>
														<li>
															<a href="#">上一页</a>
														</li>
														<li class="active">
															<a href="#">1</a>
														</li>
														<li>
															<a href="#">2</a>
														</li>
														<li>
															<a href="#">3</a>
														</li>
														<li>
															<a href="#">4</a>
														</li>
														<li>
															<a href="#">下一页</a>
														</li>
													</ul>
												</div>
											</td>
										</tr>
									</tbody>
								</table>
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

