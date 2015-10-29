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
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript">
function toUrl(url) {
	location.href=url;
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
				if (msg == "0") {
					alert("保存成功！");
					window.location.href = "<%=basePath%>shop/viewShop?shopId=${shop.shopid}";
				} else
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
	if (!isString6_20(npa)) {
		alert("新密码只能输入6-16个字母、数字、下划线哦！");
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
				window.location.href="<%=basePath%>shop/viewShop?shopId=${shop.shopid}";
			} else {
				alert("重置失败！");
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
					<h2> <i class="icon-edit"></i>编辑商家 </h2>
					<div class="box-icon">
						<a href="javascript:history.back()" class="btn-add"> 
							<i class="icon-edit" style="width: 60px;">返回</i> 
						</a>
					</div>
				</div>
				<div class="box-content">
					<div class="tabbox">
						<div class="tabmenu">
							<dl>
								<dd class="cli">店铺信息</dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/allGoods?shopId=${shopId}')">产品信息</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/orders?shopId=${shopId}&type=0')">订单详情</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/comments?shopId=${shopId}')">评价管理</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearlist?shopId=${shopId}&type=0')">结算管理</a></dd>
								<dd><a href="javascript:void(0)" onclick="toUrl('<%=basePath %>shop/clearing?shopId=${shopId}')">结算记录</a></dd>
							</dl>
						</div>
						<div id="tabcontent">
							
							<dl name="tabul">
								<div class="box-content">
									<form id="shop_ajax" action="<%=basePath%>shop/update" method="post" class="form-horizontal" />
										<fieldset>
											<div class="control-group">
												<div class="controls">
											 		<input type="button" onclick="toUrl('<%=basePath %>shop/drawList?shopId=${shopId}')" value="店铺图片展示" class="btn btn-primary" />
											 	</div>
											</div>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													新密码：
												</label>
												<div class="controls">
													<input type="password" id="newPassword" name="newPassword" class="span6 typeahead" />
													<p class="help-block">密码只能输入6-16个字母、数字、下划线哦！</p>
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
											<c:if test="${!empty shop.img}">
												<div class="control-group">
													<label class="control-label" for="typeahead">
														原店标：
													</label>
													<div class="controls">
														<img alt="缩略图" src="<%=imgPath %>${shop.img}" style="width: 160px;height: 120px;">
													</div>
												</div>
											</c:if>
											<div class="control-group">
												<label class="control-label" for="typeahead">
													店标：
												</label>
												<div class="controls">
													<input id="img" name="img" type="file" class="input-file uniform_on" />
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
													<input type="text" id="address" name="address" value="${shop.address}" class="span6 typeahead" />
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

