<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp"%>

<!DOCTYPE HTML>
<html>
<head>
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">

//表单提交验证
function checkForm() {
	var img = $("#img").val();
	if (img == "") {
		alert("请选择图片！");
		return false;
	} else {
		/*$ .ajax(
		{
			url:"${path}/setting/saveStart",
			type:"POST",
			dataType : 'text',
			data:{"img":img},
			success : function(msg) {
				if (msg == "0") {
					alert("修改成功！");
					window.location.href = "${path}/setting/preEdit";
				} else {
					alert("修改失败！");
				}
			}
		});*/
		$("#start_ajax").submit();
	}
}
</script>
<style>
.iphone tr td {
	padding: 10px;
}

.redfont {
	color: #F00
}

.hui {
	color: #999;
	display: block
}
</style>
</head>
<%@ include file="../common/top.jsp"%>
<body onload="initRow()">

	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>APP启动页
					</h2>
				</div>
				<div class="box-content">
					<form id="start_ajax" enctype="multipart/form-data" action="${path}/setting/saveStart" method="post">
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">图片：</label>
							<div class="controls">
								<img alt="缩略图" src="<%=imgPath %>${setting.img}">
								<p class="help-block">* 原图片</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="fileInput">修改图片：</label>
							<div class="controls">
								<input class="input-file uniform_on" name="img" id="img" type="file" />
							</div>
						</div>
						<div class="form-actions">
							<input type="button" value="保存" class="btn btn-primary" onclick="checkForm()" />
							<input type="reset" class="btn" value="重置" />
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
</body>
</html>