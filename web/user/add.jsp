<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE HTML >
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript" src="${path}/public/js/public.js"></script>
<script type="text/javascript">
function init() {
	initRow();
}

function formsubmit() {
	var username = $("#username").val();
	var password = $("#password").val();
	var rpass = $("#rpass").val();
	var realname = $("#realname").val();
	var mobile = $("mobile").val();
	var shopname = $("#shopname").val();
	var telphone = $("#telphone").val();
	var columnId = $("#columnId").val();
	var address = $("#address").val();
	var type = $("#type").val();
	if(username == "") {
		alert("用户名不能为空！");
		return;
	}
	if(!isString6_20(password)) {
		alert("密码只能输入6-16个字母、数字、下划线哦！");
		return;
	}
	if(!isString6_20(rpass)) {
		alert("确认密码只能输入6-16个字母、数字、下划线哦！");
		return;
	}
	if(password != rpass) {
		alert("两次输入密码不相等！");
		return;
	}
	if(realname == "") {
		alert("店主姓名不能为空！");
		return;
	}
	if(mobile == "") {
		alert("手机号码不能为空！");
		return;
	}
	if(shopname == "") {
		alert("商家名称不能为空！");
		return;
	}
	if(telphone == "") {
		alert("商家电话不能为空！");
		return;
	}
	if(columnId == 0) {
		alert("请选择经营类型！");
		return;
	}
	if(address == "") {
		alert("商家地址不能为空！");
		return;
	} else {
		$("#add").ajaxSubmit({
			dataType : 'text',
			success : function(msg) {
				if (msg == 0) {
					alert("添加成功！");
					location.href = "${path}/user/list?type=" + type;
				} else if (msg == 2) {
					alert("用户名已存在！");
					location.href = "${path}/user/preAdd?type=" + type;
				} else  {
					alert("添加失败！");
				}
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
						<i class="icon-edit"></i>添加商家
					</h2>
				</div>
				<div class="box-content">
					<form id="add" action="${path }/user/add" method="post" class="form-horizontal" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">用户名：</label>
							<div class="controls">
								<input type="text" id="username" name="user.username" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">密码：</label>
							<div class="controls">
								<input type="password" id="password" name="password" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">确认密码：</label>
							<div class="controls">
								<input type="password" id="rpass" name="rpass" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">店主姓名：</label>
							<div class="controls">
								<input type="text" id="realname" name="realname" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">手机号码：</label>
							<div class="controls">
								<input type="text" id="mobile" name="mobile" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">商家名称：</label>
							<div class="controls">
								<input type="text" id="shopname" name="shopname" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">商家电话：</label>
							<div class="controls">
								<input type="text" id="telphone" name="telphone" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">经营类型：</label>
							<div class="controls">
								<select id="columnId" name="columnId">
				         			<option value="0">选择经营类型</option>
									<c:forEach items="${colList }" var="col">
									<option value="${col.id }">${col.cname } </option>
									</c:forEach>
				         		</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">商家地址：</label>
							<div class="controls">
								<input type="text" id="address" name="address" class="span6 typeahead" />
							</div>
						</div>

						<div class="form-actions">
							<input type="hidden" id="type" name="type" value="${type}" />
							<input type="button" value="保存" onclick="formsubmit('${type}')" class="btn btn-primary" />
							<input type="reset" value="重置" class="btn" />
						</div>
					</fieldset>
					</form>
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
	<%-- <div class="caozuo">
		<span class="title caozuo_span ">
		<c:if test="${type==1 }">
		  商家管理>>添加商家
		</c:if></span>
    </div>
    <div class="caozuo">
		<c:if test="${type==1 }">
		<input type="button" value="添加商家" onclick="formsubmit('${type }');" class="caozuo_input f_l" /> 
		</c:if>
    </div>
 	<div class="bor_con">
 	<form id="add" action="${path }/user/add?type=${type}" method="post">
		<ul>
			<li><span > </span> </li>
			<li><span >用户名：</span><input type="text" name="user.username" class="width_35" /></li>
            <li><span >密码：</span><input type="password" name="password" class="width_35" /></li>
            <li><span >确认密码：</span><input type="password" name="rpass" class="width_35" /></li>
            <li><span >店主姓名：</span><input type="text" name="realname" class="width_35" /></li>
            <li><span >手机号：</span><input type="text" name="mobile" class="width_35" /></li>
            <li><span >店铺名称：</span><input type="text" name="shopname" class="width_35" /></li>
            <li><span >店铺电话：</span><input type="text" name="telphone" class="width_35" /></li>
            <li><span >经营类型：</span>
            	<select name="columnId">
         			<option>选择经营类型</option>
					<c:forEach items="${colList }" var="col">
					<option value="${col.id }">${col.cname } </option>
					</c:forEach>
         		</select>
         		</li>
            <li><span >地址：</span><input type="text" name="address" class="width_45" /></li>
		</ul>
		</form>
</div> --%>

</body>
</html>
