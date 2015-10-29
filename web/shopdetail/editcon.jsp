<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="${path}/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path}/public/js/public.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">

function toUrl(url) {
	location.href=url;
}

//表单提交验证
function check() {
	var title = $("#title").val();
	var mobile = $("#mobile").val();
	if(title == ""||title == null) {
		alert("标题不能为空哦！");
		return false;
	}
	if(title.length > 10) {
		alert("标题不要超过10个字符哦！");
		return false;
	}
	if(mobile == ""||mobile == null) {
		alert("电话号码不能为空哦！");
		return false;
	}
	if(!isDigit(mobile)) {
		alert("电话号码必须是数字哦！");
		return false;
	}
	
	var type = "${type}";
	if(type == "ADD") {
		var img = $("#img").val();
		if(img == "") {
			alert("图片不能为空哦！");
			return;
		}
	}
	
	var orderby = $("#orderby").val();
	if (orderby == ""||orderby == null) {
		alert("排序不能为空哦！");
		return false;
	}
	if(!isDigit(orderby)) {
		alert("排序必须是数字哦！");
		return false;
	}
	
	var remark = $("#remark").val();
	if (remark == ""||remark == null) {
		alert("描述不能为空哦！");
		return false;
	}
	if(remark.length > 20) {
		alert("描述不要超过20个字符哦！");
		return false;
	}
	
	$("#add_ajax").ajaxSubmit({
		dataType : 'text',
		success : function(msg) {
			if (msg == "0") {
				alert("编辑成功！");
				location.href="${path}/shop/preEditCon?type=${type}&id=${con.id}";
			} else {
				alert("编辑失败！");
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
						<i class="icon-edit"></i>编辑便民
					</h2>
				</div>
				<div class="box-content">
					<form action="${path}/shop/editCon" id="add_ajax" method="post" enctype="multipart/form-data" class="form-horizontal" />
						<fieldset>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									标题：
								</label>
								<div class="controls">
									<input id="title" name="title" value="${con.title}" type="text" class="span6 typeahead" />
									<p class="help-block">标题不要超过10个字符哦！</p>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									电话号码：
								</label>
								<div class="controls">
									<input id="mobile" name="mobile" value="${con.mobile}" type="text" class="span6 typeahead"/>
									<p class="help-block">电话号码不要超过11个数字哦！</p>
								</div>
							</div>
							<c:if test="${!empty goods.img}">
								<div class="control-group">
									<label class="control-label" for="typeahead">
										原图：
									</label>
									<div class="controls">
										<img alt="缩略图" src="<%=imgPath %>${con.img}" style="width: 160px;height: 120px;">
									</div>
								</div>
							</c:if>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									图片上传：
								</label>
								<div class="controls">
									<input id="img" name="img" type="file" class="input-file uniform_on" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									排序：
								</label>
								<div class="controls">
									<input id="orderby" name="orderby" onkeyup="this.value=this.value.substring(0,3)" value="${con.orderby}" type="text" class="span6 typeahead"/>
									<p class="help-block">排序只能填写数字哦！</p>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									描述：
								</label>
								<div class="controls">
									<textarea id="remark" name="remark" style="width: 400px; height: 100px;">${con.remark}</textarea>
									<p class="help-block">描述不要超过20个字符哦！</p>
								</div>
							</div>
							<div class="form-actions">
								<input type="hidden" id="id" name="id" value="${con.id}" />
								<input type="hidden" id="type" name="type" value="${type}" />
								<button type="button" onclick="check()" class="btn btn-primary">保存</button>
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