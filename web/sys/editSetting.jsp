<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp"%>

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
	 editor = K.create('textarea[name="content"]', {
		heigth : '400px',
		cssPath : '${path }/public/kindeditor/plugins/code/prettify.css',
		uploadJson : '${path }/public/kindeditor/jsp/upload_json.jsp',
		fileManagerJson : '${path }/public/kindeditor/jsp/file_manager_json.jsp',
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
	var sname = $("#sname").val();
	var content = editor.html();
	var id = $("#id").val();
	if (sname == "") {
		alert("标题不能为空！");
		return false;
	} else if (content == "") {
		alert("内容不能为空！");
		return false;
	} else {
		$ .ajax(
		{
			url:"${path}/setting/edit",
			type:"POST",
			dataType : 'text',
			data:{"sname":sname,"content":content,"id":id},
			success : function(msg) {
				if (msg == "0") {
					alert("修改成功");
					if(id == 1) {
						window.location.href = "${path}/setting/preEdit";
					} else {
						window.location.href = "${path}/setting/preUpdate";
					}
				} else {
					window.location.href = "${path}/login.jsp";
				}
			}
		});
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
<!--  <div class="c_m_bj">
		<span class="title02">关于管理</span>
	</div>
	<div class="right_con">
		<div class="chaxun">修改关于</div>
		<div class="bor">
			<div class="bar_blue">填写关于信息</div>
			<div class="bor_con">
				<form id="forum_ajax" action="${path}/setting/edit" method="post">
					<div class="form_style">
						<span class="label_name">标题：</span>
						<div class="group">
							<input type="text" class="b_block width_95" id="sname" name="sname" value="${setting.sname}" />
						</div>
						<span class="redfont"></span><span class="hui">* 标题，不要超过50个字</span>	
					</div>
					<div class="form_style">
						<span class="label_name">内容：</span>
						<div class="group">
							<textarea cols="100" rows="10" class="b_block width_95" name="content" id="content">${setting.content}</textarea>
						</div>
					</div>
					<div class="btn_bg clr">				
				        <input type="hidden" name="id" id="id" value="${setting.id}" />
						<input type="button" value="确定" class="caozuo_input f_l" onclick="checkForm()"/>
				        <input name="input" type="button" value="返回" onclick="javascript:history.back()" class="caozuo_input f_l" />
					</div>
				</form>
			</div>
		</div>
	</div>-->
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>关于管理
					</h2>
				</div>
				<div class="box-content">
					<form id="forum_ajax" action="${path}/setting/edit" method="post">
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">标题：</label>
							<div class="controls">
								<input type="text" name="sname" id="sname" onkeyup="this.value=this.value.substring(0,14)" value="${setting.sname}" class="span6 typeahead" />
								<p class="help-block">* 请填写标题，不要超过50个字</p>
							</div>
						</div>
						<div class="control-group hidden-phone">
							<label class="control-label" for="textarea2">内容：</label>
							<div class="controls">
								<textarea name="content" id="content" rows="3" style="width:700px;height:400px;">${setting.content}</textarea>
							</div>
						</div>
						<div class="form-actions">
							 <input type="hidden" name="id" id="id" value="${setting.id}" />
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