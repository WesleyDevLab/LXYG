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
	var parentId = $("#parentId").val();
	var cname = $("#cname").val();
	var orderby = $("#orderby").val();
	/* if(parentId == 4) {
		var img = $("#img").val();
		if(img == "") {
			alert("图片不能为空！");
			return;
		}
	} */
	if (cname == "") {
		alert("栏目名称不能为空！");
		return;
	} else {
		$("#add").submit();
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
						<c:choose>
                      		<c:when test="${parentId == 2}">
								<i class="icon-edit"></i>添加动态栏目
                      		</c:when>
                      		<c:when test="${parentId == 3}">
                      			<i class="icon-edit"></i>添加玩乐栏目
                      		</c:when>
                      		<c:otherwise>
                      			<i class="icon-edit"></i>添加分类
                      		</c:otherwise>
                      	</c:choose>
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="add" action="${path }/column/updateCol" method="post" enctype="multipart/form-data" />
						<fieldset>
							<div class="control-group">
								<label class="control-label" for="typeahead">栏目名称：</label>
								<div class="controls">
									<input type="text" name="cname" id="cname" value="${col.cname}" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								</div>
							</div>
							<c:if test="${parentId == 4}">
								<div class="control-group">
									<label class="control-label" for="typeahead">描述：</label>
									<div class="controls">
										<input type="text" name="remark" id="remark"  value="${col.remark}" onkeyup="this.value=this.value.substring(0,20)" class="span6 typeahead" />
										<p class="help-block">请填写栏目描述</p>
									</div>
								</div>
							</c:if>
							<div class="control-group">
								<label class="control-label" for="typeahead">排序：</label>
								<div class="controls">
									<input type="text" name="orderby" id="orderby"  value="${col.orderby}" onkeyup="this.value=this.value.substring(0,3)" class="span6 typeahead" />
									<p class="help-block">请填写排序数字</p>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">图片:</label>
								<div class="controls">
									<input class="input-file uniform_on" type="file" name="img" id="img" />
									<p class="help-block">*请上传78*78的图片</p>
								</div>
							</div>
							<div class="form-actions">
								<input type="hidden" name="colId" id="colId" value="${col.id}" />
								<input type="hidden" value="${parentId }" id="parentId" name="parentId">
								<input type="hidden" value="${resParId }" name="resParId">
								<input type="button" value="保存" class="btn btn-primary" onclick="checkForm()" />
								<input type="reset" class="btn" value="重置"/>
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
