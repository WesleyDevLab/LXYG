<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE HTML >
<html>
<head>

<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
//表单提交验证
function checkForm() {
	var cname = $("#cname").val();
	if (cname == "") {
		alert("产品类不能为空！");
		return;
	} else {
	   $.post("${path}/goods/addProductType",{"ptype":cname},function(result){
	      if(result.code==10010){
	         alert(result.message);
	         window.location.href="${path}/pageTo/productType";
	      }else{
	         alert(result.message);
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
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="add" action="${path }/column/addCol" method="post" enctype="multipart/form-data" />
						<fieldset>
							<div class="control-group">
								<label class="control-label" for="typeahead">栏目名称：</label>
								<div class="controls">
									<input type="text" name="column.cname" id="cname" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								</div>
							</div>
						
							<div class="form-actions">
								<input type="button" value="确定" class="btn btn-primary" onclick="checkForm()" />
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
	<!-- end: Content -->
	<div class="clearfix"></div>
	<%@include file="/common/bottom.jsp"%>
</body>
</html>
