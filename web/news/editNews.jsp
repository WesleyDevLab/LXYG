<%@ page language="java" contentType="text/html;" pageEncoding="UTF-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<script type="text/javascript" src="${path }/public/kindeditor/kindeditor.js"></script>

<script type="text/javascript">
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="content"]',
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

function change(value) {
	$("#columnid").val(value);
}

//表单提交验证
function checkForm() {
	var title = $("#title").val();
	var subtitle = $("#subtitle").val();
	var content = editor.html();
	var creator = $("#creator").val();
	var columnId = $("#columnid").val();
	if (title == "") {
		alert("请认真填写动态标题！");
		return false;
	} else if (subtitle == "") {
		alert("请认真填写动态副标题！");
		return false;
	} else if (columnId == "") {
		alert("请选择动态所属栏目！");
		return false;
	} else if (content == "") {
		alert("动态内容不能为空！");
		return false;
	} else {
		/* $("#news_ajax").ajaxSubmit(
		{
			dataType : 'text',
			success : function(msg) {
				alert("添加成功！");
				if (msg == "0")
					window.location.href = "${path}/news/list?parentId=${parentId }&resParId=76";
				else
					window.location.href = "${path}/login.jsp";
			}
		}); */
		$("#news_ajax").submit();
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
						<i class="icon-edit"></i>修改动态
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="news_ajax" enctype="multipart/form-data" action="${path}/news/edit" method="post" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">标题：</label>
							<div class="controls">
								<input type="text" name="title" id="title" onkeyup="this.value=this.value.substring(0,14)" value="${news.title}" class="span6 typeahead" />
								<p class="help-block">* 请填写标题，不要超过14个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">摘要：</label>
							<div class="controls">
								<input type="text" name="subtitle" onkeyup="this.value=this.value.substring(0,36)" id="subtitle" value="${news.subtitle}" class="span6 typeahead" />
								<p class="help-block">* 请填写副标题，不要超过36个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">所属栏目：</label>
							<div class="controls">
								<select name="columnId" id="columnId" onchange="change(this.value)">
									<c:forEach items="${colList}" var="col">
										<c:if test="${fn:contains(resColList,col.cname)}">
											<c:choose>
												<c:when test="${col.id == news.columnid}">
													<option value="${col.id}" selected="selected">${col.cname}</option>
												</c:when>
												<c:otherwise>
													<option value="${col.id}">${col.cname}</option>
												</c:otherwise>
											</c:choose>
										</c:if>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">来源：</label>
							<div class="controls">
								<input type="text" name="creator" onkeyup="this.value = this.value.substring(0,25)" id="creator" value="${news.creator}" class="span6 typeahead" />
								<p class="help-block">* 请填写来源，不要超过25个字</p>
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" for="fileInput">图片：</label>
							<div class="controls">
								<input class="input-file uniform_on" name="img" id="img" type="file" />
							</div>
						</div>
						<div class="control-group hidden-phone">
							<label class="control-label" for="textarea2">新闻内容：</label>
							<div class="controls">
								<textarea name="content" id="content" rows="3" style="width:700px;height:400px;">${news.content}</textarea>
							</div>
						</div>
						<div class="form-actions">
							<input type="hidden" name="columnid" id="columnid" value="${news.columnid}" />
							<input type="hidden" name="parentId" id="parentId" value="${parentId}" />
							<input type="hidden" name="newsid" id="newsid" value="${news.newsid}"/> 
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