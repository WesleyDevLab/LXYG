<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
	$(function() {
		var user = "${session['user'].uid}";
		if (user == 12) {
			$("#val").attr("disabled", true);
			$("#but").css("display", "black");
		} else {
			$("#val").attr("disabled", true);
			$("#but").attr("display", "none");
		}
	});

	function upval() {
		var butval = $("#but").val();
		if (butval == "修改") {
			$("#val").attr("disabled", false);
			$("#but").val("确认");
		} else {
			var valval = $("#val").val();
			$.ajax({
				type : "POST",
				url : "${path}/card/editReback",
				data : {
					"val" : valval,
					"type" : 1
				},
				dataType : "json",
				success : function(data) {
					if (data == "0") {
						alert("修改成功！");
						location.href = "${path}/card/getReback?type=1";
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
						<i class="icon-edit"></i>返利管理
					</h2>

				</div>
				<div class="box-content">
					<form class="form-horizontal" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">返利：</label>
							<div class="controls">
								<input type="text" id="val" class="span6 typeahead" value="${reback.hcval}" style="width:50px;" />
								<p class="help-block">*点击修改开始操作，书写格式：如返利5％，这输入数字‘5’，点击确定完成修改</p>
							</div>
						</div>

						<div class="form-actions">
							<input type="button" value="修改" class="btn btn-primary" id="but" onclick="upval()">
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
	<footer>
		<p>
			<span style="text-align: left; float: left">Copyright &copy;
				2014.乐享云购 All rights reserved.</span>
		</p>
	</footer>
	<!--/.fluid-container-->
	<%-- <div class="right_con">
		<div class="bor">
			<div class="bar_blue">修改返利</div>
			<div class="bor_con" style="margin-bottom:20px;">
				<div>
					<input type="text" value="${reback.hcval}" class="caozuo_input f_l" id="val"> 
					<input type="button" value="修改" class="caozuo_input f_l" id="but" onclick="upval()">
					<span style="color:red;">*点击修改开始操作，书写格式：如返利5％，这输入数字‘5’，点击确定完成修改</span>
				</div>
			</div>
		</div>
	</div> --%>
</body>
</html>
