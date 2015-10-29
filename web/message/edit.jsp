<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML>
<html>
<head>
<script type="text/javascript" src="${path }/public/js/query/jquery.js"></script>
<script type="text/javascript" src="${path }/public/js/jquery.form.js"></script>
<script type="text/javascript" src="${path }/public/kindeditor/kindeditor.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="content"]',{
		heigth : '200px',
		cssPath : '<%=basePath %>public/kindeditor/plugins/code/prettify.css',
		uploadJson : '<%=basePath %>public/kindeditor/jsp/upload_json.jsp',
		fileManagerJson : '<%=basePath %>public/kindeditor/jsp/file_manager_json.jsp',
		allowFileManager : true,
		items : [
				'fontname', 'fontsize', '|', 'forecolor', 'hilitecolor', 'bold', 'italic', 'underline',
				'removeformat', '|', 'justifyleft', 'justifycenter', 'justifyright', 'insertorderedlist',
				'insertunorderedlist', '|', 'emoticons'],
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
function check() {
	var type = $("#type").val();
	var palyId = $("#palyId").val();
	var content = editor.text();
	if(type == 2) {
		if (palyId == 0) {
			alert("请选择玩乐标题！");
			return false;
		} else if (content == "") {
			alert("请认真填写消息内容！");
			return false;
		}  else {
			$("#add_ajax").submit();
		}
	} else {
		if (content == "") {
			alert("请认真填写消息内容！");
			return false;
		}  else {
			$("#add_ajax").submit();
		}
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
						<i class="icon-edit"></i>修改玩乐消息
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="add_ajax" action="<%=basePath%>message/edit" method="post" />
					<fieldset>
						<%-- <c:if test="${type == 2}">
							<div class="control-group">
								<label class="control-label" for="typeahead">玩乐标题：</label>
								<div class="controls">
									<select name="playId" id="palyId">
										<option value="0">请选择...</option>
										<c:forEach items="${list}" var="p">
											<option value="${p.playid}">${p.title}</option>
										</c:forEach>
									</select>
									<p class="help-block">* 请选择玩乐标题</p>
								</div>
							</div>
						</c:if> --%>
						<div class="control-group hidden-phone">
							<label class="control-label" for="textarea2">消息内容：</label>
							<div class="controls">
								<textarea name="content" id="content" rows="3" onkeyup="this.value=this.value.substring(0,200)" style="width:700px;height:400px;">${msg.content}</textarea>
								<p class="help-block">* 消息内容不要超过200字</p>
							</div>
						</div>
						<div class="form-actions">
							<input type="hidden" name="mid" id="mid" value="${msg.mid}" />
							<input type="hidden" name="type" id="type" value="${type}" />
							<input type="button" value="保存" class="btn btn-primary" onclick="check()" />
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

