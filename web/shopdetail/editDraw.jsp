<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="<%=basePath %>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/public.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">

function toUrl(url) {
	location.href=url;
}

//表单提交验证
function check() {
	var remark = $("#remark").val();
	/*var img = $("#img").val();
	if (img == "") {
		alert("请上传图片！");
		return false;
	} */
	if (remark == "") {
		alert("请认真填写图片描述！");
		return false;
	} 
	$("#add_ajax").ajaxSubmit( {
		dataType : 'text',
		success : function(msg) {
			if (msg == "0") {
				alert("修改成功！");
				window.location.href = "${path}/shop/preEditDraw?id=${draw.id}";
			} else {
				alert("修改失败！");
			}
		}
	});
}
</script>
</head>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>修改展示图片
					</h2>
				</div>
				<div class="box-content">
					<form action="<%=basePath%>shop/editDraw" id="add_ajax" method="post" enctype="multipart/form-data" class="form-horizontal" />
						<fieldset>
							<c:if test="${!empty draw.img}">
								<div class="control-group">
									<label class="control-label" for="typeahead">
										原图：
									</label>
									<div class="controls">
										<img alt="缩略图" src="<%=imgPath %>${draw.img}" style="width: 160px;height: 120px;">
									</div>
								</div>
							</c:if>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									产品图片上传：
								</label>
								<div class="controls">
									<input id="img" name="img" type="file" class="input-file uniform_on" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									产品注释：
								</label>
								<div class="controls">
									<textarea id="remark" name="remark" cols="" rows="" style="width: 400px; height: 100px;">${draw.remark}</textarea>
								</div>
							</div>
							<div class="form-actions">
								<input type="hidden" id="id" name="id" value="${draw.id}" />
								<input type="hidden" id="shopId" name="shopId" value="${shopId}" />
								<button type="button" onclick="check()" class="btn btn-primary">修改</button>
								<button type="reset" class="btn">重置</button>
							</div>
						</fieldset>
					</form>
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
	<!--<footer>
	<p>
		<span style="text-align: left; float: left">Copyright &copy;
			2014.乐享云购 All rights reserved.</span>
	</p>
	</footer>
--></body>
</html>