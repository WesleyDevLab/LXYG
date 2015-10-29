<%@ page language="java" contentType="text/html;" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>

<!DOCTYPE HTML>
<html>
<head>

<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<script charset="utf-8" src="${path }/public/kindeditor/kindeditor.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
KindEditor.ready(function(K) {
	var editor1 = K.create('textarea[name="desc"]',
	{
		heigth : '400px',
		cssPath : '${path}/public/kindeditor/plugins/code/prettify.css',
		uploadJson : '${path}/public/kindeditor/jsp/upload_json.jsp',
		fileManagerJson : '${path}/public/kindeditor/jsp/file_manager_json.jsp',
		allowFileManager : true,
		afterCreate : function() {
			this.sync();
		},
		afterChange : function() {
			this.sync();
		}
	});
	prettyPrint();
});

//表单提交验证
function checkForm() {
	var title = $("#title").val();
	var desc = $("#desc").val();
	var img = $("#img").val();
	var orderby = $("#orderby").val();
	var columnId = $("#columnId").val();
	if (title == "") {
		alert("请认真填写资讯标题！");
		return false;
	} else if (orderby == "") {
		alert("排序不能为空！");
		return false;
	} else {
		$("#draw_ajax").submit();
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
                      		<c:when test="${parentId == 1}">
                       			 <i class="icon-edit"></i>修改首页广告
                      		</c:when>
                      		<c:when test="${parentId == 2}">
								<i class="icon-edit"></i>修改动态广告
                      		</c:when>
                      		<c:when test="${parentId == 3}">
                      			<i class="icon-edit"></i>修改玩乐广告
                      		</c:when>
                      		<c:otherwise>
                      			<i class="icon-edit"></i>修改优惠广告
                      		</c:otherwise>
                      	</c:choose>
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="draw_ajax" enctype="multipart/form-data" action="${path}/draw/edit" method="post">
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">标题：</label>
							<div class="controls">
								<input type="text" name="title" id="title" value="${draw.title}" onkeyup="this.value=this.value.substring(0,50)" class="span6 typeahead" />
								<p class="help-block">请填写标题，不要超过50个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">所属栏目：</label>
							<div class="controls">
								<c:if test="${parentId==4}">
									<select name="columnid" id="columnId">
										<c:choose>
											<c:when test="${draw.columnid == 4}">
												<option value="4" selected="selected">优惠首页</option>
												<option value ="6">四图活动</option>
												<option value="7">优惠商家页</option>
											</c:when>
											<c:when test="${draw.columnid == 6}">
												<option value="4">优惠首页</option>
												<option value ="6" selected="selected">四图活动</option>
												<option value="7">优惠商家页</option>
											</c:when>
											<c:otherwise>
												<option value="4">优惠首页</option>
												<option value ="6">四图活动</option>
												<option value="7" selected="selected">优惠商家页</option>
											</c:otherwise>
										</c:choose>
									</select>
								</c:if>
								<c:if test="${parentId!=4}">
									<select name="columnid" id="columnId">
										<option value="0">请选择...</option>
										<c:forEach items="${colList}" var="col">
											<c:choose>
												<c:when test="${draw.columnid == col.id}">
													<option value="${col.id}" selected="selected">${col.cname}</option>
												</c:when>
												<c:otherwise>
													<option value="${col.id}">${col.cname}</option>
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</select>
								</c:if>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">排序：</label>
							<div class="controls">
								<input type="text" name="orderby" value="${draw.orderby}" onkeyup="this.value=this.value.substring(0,3)" id="orderby" class="span6 typeahead" style="width:60px;" />
								<p class="help-block">请填写排序数字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="fileInput">图片：</label>
							<div class="controls">
								<input class="input-file uniform_on" type="file" name="img" id="img" />
							</div>
						</div>
						<div class="control-group hidden-phone">
							<label class="control-label" for="textarea2">内容:</label>
							<div class="controls">
								<textarea name="desc" id="content" rows="3" style="width:700px;height:400px;">${draw.desc}</textarea>
							</div>
						</div>
						<div class="form-actions">
							<input type="hidden" name="drawid" id="drawid" value="${draw.drawid }" />
							<input type="hidden" name="parentId" id="parentId" value="${parentId}" />
							<input type="hidden" name="columnId" value="${columnId}" />
							<input type="button" value="确定" class="btn btn-primary" onclick="checkForm()" />
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
    <%@include file="/common/bottom.jsp" %>
</body>
</html>