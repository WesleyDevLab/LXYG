<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %> 
 

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>  
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function foucu(val){
	if(val=="分类名称"){
		$("#fname1").val("");
	}
} 

//新闻图片上传
function uploadImg(form, file) {
extArray = new Array(".gif", ".jpg", ".png");
	//file = file.value;
	allowSubmit = false;
	if (!file) {
		alert("请选择要上传的文件！");
		return;
	}
	while (file.indexOf("\\") != -1)
		file = file.slice(file.indexOf("\\") + 1);		
	ext = file.slice(file.lastIndexOf(".")).toLowerCase();
	for ( var i = 0; i < extArray.length; i++) {
		if (extArray[i] == ext) {
			allowSubmit = true;
			break;
		}
	}
	if (allowSubmit) { 
		$("#uploadform").ajaxSubmit( {
			dataType : 'text',
			success : function(msg) {
				document.getElementById('img').value = msg;
			}
		});
		//alert("上传成功！");   			
	} else {
		alert("对不起，只能上传以下格式的文件:  " + (extArray.join("  "))
				+ "\n请重新选择符合条件的文件再上传.");
	}
}
//表单提交验证
function checkForm() {
	var fname=$("#fname1").val();
	var parentid=$("#parentid1").val();
	var content=$("#content1").val();
	var img=$("#img").val();
	var url=$("#url1").val();
	var orderby=$("#orderby1").val();
		if (fname == ""||fname=="分类名称") {
			alert("请认真填写资讯标题！");
			return false;
		} else if (content == "") {
			alert("请认真填写资讯副标题！");
			return false;
		} else if (img == "") {
			alert("请认真填写资讯内容！");
			return false;
		} else if (orderby == "") {
			alert("请认真填写资讯内容！");
			return false;
		} else {
			$("#news_ajax").submit();
					//window.location.href = "${path}/forum/list?parentId=${parentId }";
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
	<!-- <div class="c_m_bj">
		<span class="title02">资讯管理</span>
	</div>
	<div class="right_con">
		<div class="chaxun">
			添加资讯
		</div>
		<div class="bor">
			<div class="bar_blue">
				填写资讯信息
			</div>
			<div class="bor_con">
			<table border="0" cellpadding="3" cellspacing="1" width="100%" class="iphone" style="font-size: 14px;">
				  
					<tr>
					<td>分类名称</td><td> <input type="text" value="分类名称" name="forum.fname" id="fname1" onfocus="foucu(this.value);"> </td></tr>
					<tr>
					
					<td>父类别<td> <select name="forum.parentid" id="parentid1">
					<option value="0">无</option>
						<c:forEach items="${faList}" var="forum">
							<option value="${forum.forum.fid }">${forum.fname }</option>
						</c:forEach>
					</select> </td></tr>
					<tr>
					<td>URL</td><td> <input type="text"  name="forum.url" id="url1"><span style="color:red;">如：http://www.yzsdx.com/forum.php?mod=forumdisplay&fid=202&mobile=2</span> </td>
					</tr>
					<tr><td>排序：</td><td><input type="text"  name="forum.orderby" id="orderby1"><span style="color:red;">如：http://www.yzsdx.com/forum.php?mod=forumdisplay&fid=202&mobile=2</span> </td></tr>
				<tr>
					<td width="5%" valign="top">
						图片：
					</td>
					<td colspan="3">
						<form action="${path}/upload/files?type=Img"
							method="post" enctype="multipart/form-data" id="uploadform"
							name="uploadform">
							<input class="m-wrap span12"
								onchange="uploadImg(this.form,this.form.file.value)"
								type="file" name="file" id="file" />
						</form>
					</td>
				</tr> 
				<tr>
					<td>简介</td><td> <textarea rows="" cols="" name="forum.content" id="content1"></textarea> </td></tr>
					<tr>
				<tr>
						<td valign="top">
							<div class="btn_bg clr">
								<form id="forum_ajax" action="${path}/forum/add"
									method="post">
									<input type="hidden" name="forum.fname" id="fname" />
									<input type="hidden" name="forum.content" id="content" />
									<input type="hidden" name="forum.parentid" id="parentid" />
									<input type="hidden" name="forum.url" id="url" />
									<input type="hidden" name="forum.img" id="img" /> 
									<input type="hidden" name="forum.orderby" id="orderby" /> 
									<input type="button" value="确定" class="caozuo_input f_l"
										onclick="checkForm()" />
									<input name="input" type="button" value="返回"
										onclick="javascript:history.back()" class="caozuo_input f_l" />
								</form>
							</div>
						</td>
					</tr> 
			</table>
		</div>
		</div>
	</div> -->
	
	  <!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>修改资讯
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="news_ajax" enctype="multipart/form-data" action="${path}/forum/edit" method="post" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">分类名称：</label>
							<div class="controls">
								<input type="text" name="forum.fname" id="fname1"  value="${forum.fname }" onfocus="foucu(this.value);" class="span6 typeahead" />
							</div>
						</div>
						<input type="hidden" value="${forum. fid}" name="forum.fid">
						<div class="control-group">
							<label class="control-label" for="typeahead">父类别：</label>
							<div class="controls">
								<select name="forum.parentid" id="parentid1">
					<option value="0">无</option>
						<c:forEach items="${faList}" var="fa">
							<option value="${fa.fid }" <c:if test="${fa.fid==forum.parentid }">selected=='selected'</c:if>>${fa.fname }
						</c:forEach>
					</select> 
								</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">URL：</label>
							<div class="controls">
								<input type="text" name="forum.url" id="url1"  value="${forum.url }"  class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">排序：</label>
							<div class="controls">
								<input type="text" name="forum.orderby" id="orderby1"  value="${forum.orderby }" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
							</div>
						</div>
					<div class="control-group">
							<label class="control-label" for="typeahead">图片：</label>
							<img src="${imgPath }${forum.img}" width="40px;">
							<div class="controls">
								<input type="file" name="file" id="file"  class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">简介：</label>
							<div class="controls">
								<input type="text" rows="8" cols="30" name="forum.content" id="content1"  value="${forum.content }" class="span6 typeahead" /> 
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