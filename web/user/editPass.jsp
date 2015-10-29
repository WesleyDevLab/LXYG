<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE HTML >
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript" src="${path }/public/js/public.js"></script>
<script type="text/javascript">
function edit() {
	var opa = $("#oldPassword").val();
	var npa = $("#newPassword").val();
	var rpa = $("#rPassword").val();
	var check = true;
	if (!isString6_20(opa)) {
		alert("旧密码只能输入6-16个字母、数字、下划线哦！!");
		check = false;
	} else if (!isString6_20(npa)) {
		alert("新密码只能输入6-16个字母、数字、下划线哦！");
		check = false;
	} else if (npa == opa) {
		alert("新密码不能和原密码相同！");
		check = false;
	} else if (npa != rpa) {
		alert("新密码前后两次不一致！");
		check = false;
	}

	if (check) {
		$.post('${path}/user/editPa', {"opa" : opa, "npa" : npa},
		function(data) {
			if(data == "0") {
				alert("修改成功，请重新登录");
				window.location.href="${path}/user/exit";
			} else {
				alert("修改失败！");
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
						<i class="icon-edit"></i>修改密码
					</h2>
				</div>
				<div class="box-content">
					<form id="add" action="${path }/user/add" method="post" class="form-horizontal" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">旧密码：</label>
							<div class="controls">
								<input type="password" id="oldPassword" name="oldPassword" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">新密码：</label>
							<div class="controls">
								<input type="password" id="newPassword" name="newPassword" class="span6 typeahead" />
								<p class="help-block">新密码只能输入6-16个字母、数字、下划线哦！</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">确认密码：</label>
							<div class="controls">
								<input type="password" id="rPassword" name="rPassword" class="span6 typeahead" />
							</div>
						</div>

						<div class="form-actions">
							<input type="button" value="保存" onclick="edit()" class="btn btn-primary" />
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
	<!-- <div id="popupdiv_psw"border:1px #000000 solid" >
		<div class="chaxun1" style="width:600px;">
			<div id="bar_blue" class="bar_blue">修改密码</div>
			<div class="xiugai">
				<span class="xuanxiang">原始密码:</span>
				<input type="password" name="oldPassword" id="oldPassword" /> 
				<span class="red_ts" id="red_opa"></span>
			</div>
			<div class="xiugai">
				<span class="xuanxiang">新&nbsp;密&nbsp;码:</span> 
				<input type="password" name="newPassword" id="newPassword" /> 
				<span class="" id="red_npa">*长度至少为6的数字、字母</span>
			</div>
			<div class="xiugai">
				<span class="xuanxiang">密码确认:</span> 
				<input type="password" name="rPassword" id="rPassword" class="{required:true,isWord:true,minlength:6,messages:{required:'请确认新密码',isWord:'密码必须为数字、字母.',minlength:'长度至少为6'}}" />
				<span class="red_ts" id="red_rpa"></span>
			</div>
			<div class="caozuo_bot01">
				<input name="b2" type="button" value="修改" class="caozuo_input" onclick="edit();" /> 
				<input name="b2" type="button" value="重置" class="caozuo_input" /> 
				<input name="b3" type="button" value="取消" class="caozuo_input" onclick="art.dialog.close()" />
			</div>
		</div>
	</div> -->
</body>
</html>
