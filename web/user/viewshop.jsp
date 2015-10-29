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
<script type="text/javascript" src="<%=basePath%>public/js/yfweb.js"></script>
<style type="text/css">
#popupdiv_logo {
	width: 500px;
	height: 190px;
	position: absolute;
	z-index: 1000;
	border: 2px solid #ffffff;
	background: #ffffff;
}
</style>
<script type="text/javascript">
$(function(){
	$('#productTab li a').click(function(){
		$("#productTab li").removeClass("active");
		$(this).parent("li").addClass("active");
		$("div.tab-pane").eq($(this).parent("li").index()).addClass("active").siblings(".tab-pane").removeClass("active");
	});
});

function del(url,goodsId) {
	var shopId = $("#shopid").val();
	if(confirm("确定要删除吗?","警告")){
		$.post(url, {"goodsId" : goodsId}, function(data){
		    if (data == 0) {
		    	alert("删除成功！");
		    	location.href="<%=basePath%>shop/view?shopId=" + shopId;
		    } else {
		    	alert("删除失败！");
		    	location.href="<%=basePath%>shop/view?shopId=" + shopId;
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
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-align-justify"></i><span class="break"></span>优惠商家详细信息
					</h2>
				</div>
				<div class="box-content">
					<!-- Nav tabs -->
					<ul class="nav nav-tabs" id="productTab">
						<li class="active"><a href="javascript:void(0)">商家详情</a>
						</li>
						<li><a href="javascript:void(0)">商家产品列表</a>
						</li>
					</ul>
					<!-- Tab panes -->
					<div class="tab-content">
						<div class="tab-pane active">
							<form id="shop_ajax" action="<%=basePath%>shop/update" method="post" class="form-horizontal" />
							<fieldset>
								<div class="control-group">
									<label class="control-label" for="typeahead">新密码：</label>
									<div class="controls">
										<input type="password" id="newPassword" name="newPassword" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">密码确认：</label>
									<div class="controls">
										<input type="password" id="rPassword" name="rPassword" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">密码重置：</label>
									<div class="controls">
										<input type="button" onclick="resetPass()" value="重置商家密码" class="btn" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">商家商标：</label>
									<div class="controls">
										<c:if test="${empty shop.img}">
											<div class="span6 typeahead">还没有商标，请上传！</div>
										</c:if>
										<c:if test="${!empty shop.img }">
											<img src="<%=imgPath %>${shop.img}" style="width:100px;height:100px;display:none" align="left" />
										</c:if>
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">店主姓名：</label>
									<div class="controls">
										<input type="text" id="realname" name="realname" value="${shop.realname}" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">手机号码：</label>
									<div class="controls">
										<input type="text" id="mobile" name="mobile" value="${shop.mobile}" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">商家名称：</label>
									<div class="controls">
										<input type="text" id="shopname" name="shopname" value="${shop.shopname}" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">商家电话：</label>
									<div class="controls">
										<input type="text" id="telphone" name="telphone"  value="${shop.telphone}" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="selectError3">经营类型：</label>
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
									<label class="control-label" for="typeahead">商家地址：</label>
									<div class="controls">
										<input type="text" id="address" name="address" value="${shop.address }" class="span6 typeahead" />
									</div>
								</div>
								<div class="control-group">
									<label class="control-label" for="typeahead">描述：</label>
									<div class="controls">
										<input type="text" id="remark" name="remark" value="${shop.remark}" class="span6 typeahead" />
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
						<div class="tab-pane">
							<table class="table table-bordered table-striped table-condensed">
								<thead>
									<tr>
										<th>序号</th>
										<th>产品名称</th>
										<th>产品价格</th>
										<th>产品图片</th>
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
												<c:if test="${!empty goods.price }">
													<script type="text/javascript">formatNum(${goods.price});</script>元
												</c:if> 
												<c:if test="${empty goods.price }">
													暂未定价
												</c:if>
											</td>
											<td>
												<img src="<%=imgPath %>${goods.img}" width="34" height="34" />
											</td>
											<td>${goods.createtime}</td>
											<td>
												<button type="button" class="btn btn-remove" onclick="del('<%=basePath %>goods/delete','${goods.goodsid}')">删除</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
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
						</div>
					</div>
				</div>
			</div>
			<!--/span-->
		</div>
		<!--/row-->


	</div>
	<!-- end: Content -->

	</div>
	<!--/fluid-row-->
	<!--/row-->

	</div>
	<!--/fluid-row-->


	<div class="clearfix"></div>
	<%@include file="/common/bottom.jsp"%>
	<%-- <div class="right_con">
		<div class="chaxun">商家信息</div>
		<div class="tabbox">
			<div class="tabmenu">
				<ul>
					<li onClick="tabChange(this,'tabcontent')" class="cli">商家详情</li>
					<li onClick="tabChange(this,'tabcontent')">商家产品列表</li>
				</ul>
			</div>
			<div id="tabcontent">
				<ul name="tabul">
					<a href="javascript:void(0)" class="bj" onclick="show('popupdiv_psw','bar_blue')">重置商家密码</a>
					<div id="popupdiv_psw" style="display:none; border:1px #000000 solid">
						<div class="chaxun1">
						<div id="bar_blue" class="bar_blue">修改密码</div>
								<div class="xiugai">
									<span class="xuanxiang">新&nbsp;&nbsp;密&nbsp;&nbsp;码:</span>
								    <input type="password" name="newPassword" id="newPassword" class="{required:true,isWord:true,minlength:6,messages:{required:'请输入新密码',isWord:'密码必须为数字、字母.',minlength:'长度至少为6'}}"/> 
								</div>
								<div class="xiugai">
									<span class="xuanxiang">密码确认:</span>
									<input type="password" name="rPassword" id="rPassword" class="{required:true,isWord:true,minlength:6,messages:{required:'请确认新密码',isWord:'密码必须为数字、字母.',minlength:'长度至少为6'}}"/>
								</div>
								<div class="caozuo_bot01">
									<input name="b1" type="button" onclick="edit()" value="确定" class="caozuo_input"/>
									<input name="b2" type="reset" value="重置" class="caozuo_input"/>
									<input name="b3" type="button" value="取消" class="caozuo_input" onclick="closeDiv('popupdiv_psw')"/>
								</div>
						  </div>
				    </div>
					<c:if test="${empty shop.img}">
						<div class="form_style">
							<span class="label_name">商家商标：</span>
							<div class="group">
								你还没有商标，请马上上传！
							</div>
						</div>
					</c:if>
					<c:if test="${!empty shop.img }">
						<div class="form_style">
							<span class="label_name">商家商标：</span>
							<div class="group">
								<img src="<%=imgPath %>${shop.img}" width="146" height="113" align="left"/>
							</div>
						</div>
					</c:if>
					<div class="form_style">
						<span class="label_name">商家名称：</span>
						<div class="group">
							<input name="shopname_text" id="shopname_text" value="${shop.shopname}" class="b_block width_95" />
							<span class="tishi_red f_l"> * 请填写商家名称</span>
						</div>
					</div>
					<div class="form_style">
						<span class="label_name">商家地址：</span>
						<div class="group">
							<input name="address_text" id="address_text" value="${shop.address }" class="b_block width_95" />
							<span class="tishi_red f_l"> * 请填写商家地址</span>
						</div>
					</div>
					<div class="form_style">
						<span class="label_name">联系电话：</span>
						<div class="group">
							<input name="telphone_text" id="telphone_text" value="${shop.telphone }" class="b_block width_95" />
							<span class="tishi_red f_l"> * 请填写联系电话</span>
						</div>
					</div>
					<div class="btn_bg clr">
						<form id="shop_ajax" action="<%=basePath %>shop/update" method="post">
							<input type="hidden" name="shopid" id="shopid" value="${shop.shopid }" />
							<input type="hidden" name="shopname" id="shopname" />
							<input type="hidden" name="img" id="img" value="${shop.img }" />
							<input type="hidden" name="telphone" id="telphone" />
							<input type="hidden" name="address" id="address" />
							<input type="hidden" name="remark" id="remark" value=${shop.remark } />
							<input type="hidden" name="weixin" id="weixin" value="${shop.weixin }" />
							<input type="hidden" name="qrcode" id="qrcode" value="${shop.qrcode }" />
							<input type="button" onclick="checkForm()" value="保存" class="caozuo_input f_l" />
						</form>
					</div>
				</ul>
				<ul class="hidden">
					<div class="tab">
						<table border="0" cellpadding="4" cellspacing="1" width="100%">
							<thead>
								<tr>
								<th width="15%">产品名称</th>
								<th width="15%">产品价格</th>
								<th width="40%">产品图片</th>
								<th width="20%">添加时间</th>
								<th width="10%">操作</th>
								</tr>
							</thead>
					
							<tbody>
								<c:if test="${empty list}">
									<tr height="30" style="text-align: center;">
										<td colspan="5"><font style="font-size:16px;" color="red">暂无相关数据!</font>
										</td>
									</tr>
								</c:if>
								<c:if test="${!empty list}">
									<c:forEach items="${list}" var="goods" varStatus="loopStatus">
										<tr>
											<td><a href="<%=basePath %>goods/view?goodsId=${goods.goodsid}">${goods.goodsname}</a></td>
											<td>
												<c:if test="${!empty goods.price }">
													<script type="text/javascript">formatNum(${goods.price});</script>元
												</c:if>
												<c:if test="${empty goods.price }">
													暂未定价
												</c:if>
											</td>
											<td><img src="<%=imgPath %>${goods.img}" width="34" height="34"/></td>
											<td>${goods.createtime}</td>
											<td>
												<a href="javascript:void(0)" onclick="del('<%=basePath %>goods/delete','${goods.goodsid}')" class="bj">删除</a>
											</td>
										</tr>
									</c:forEach>
								</c:if>				
							</tbody>
						</table>
					</div>
				</ul>
		</div>
	</div>
	</div> --%>

</body>
</html>

