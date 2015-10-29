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
	editor = K.create('textarea[name="news.content"]',
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
	var subtitle = $("#subtitle").val();
	var content = editor.html();
	var img = $("#img").val();
	var creator = $("#creator").val();
	var columnId = $("#columnId").val();
	if (title == "") {
		alert("请认真填写动态标题！");
		return false;
	} else if (subtitle == "") {
		alert("请认真填写动态副标题！");
		return false;
	} else if (columnId == 0) {
		alert("请选择动态所属栏目！");
		return false;
	}  else if (img == "") {
		alert("动态图片为空！");
		return false;
	}  else if (content == "") {
		alert("请认真填写资讯内容！");
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
<body>
<%@ include file="../common/top.jsp"%>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>添加动态
					</h2>
				</div>
				<div class="box-content">
					<form class="form-horizontal" id="news_ajax" enctype="multipart/form-data" action="${path}/news/add" method="post" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">标题：</label>
							<div class="controls">
								<input type="text" name="news.title" id="title" onkeyup="this.value=this.value.substring(0,14)" class="span6 typeahead" />
								<p class="help-block">* 请填写标题，不要超过14个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">摘要：</label>
							<div class="controls">
								<input type="text" name="news.subtitle" id="subtitle" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
								<p class="help-block">* 请填写副标题，不要超过36个字</p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">所属栏目：</label>
							<div class="controls">
								<select name="news.columnid" id="columnId">
									<option value="0"> 请选择... </option>
									<c:forEach items="${colList}" var="col">
										<c:if test="${fn:contains(resColList,col.cname)}">
											<option value="${col.id}">
												${col.cname}
											</option>
										</c:if>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">来源：</label>
							<div class="controls">
								<input type="text" name="news.creator" onkeyup="this.value=this.value.substring(0,25)" id="creator" class="span6 typeahead" />
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
								<textarea name="news.content" id="content" rows="3" style="width:700px;height:400px;"></textarea>
							</div>
						</div>
						<div class="form-actions">
							<input type="hidden" name="parentId" id="parentId" value="${parentId}" />
							<input type="hidden" name="news.author" id="author" value="${session.user.uid }"/>
							<input type="hidden" name="news.type" id="type" value="1"/>
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
	<%-- <div class="c_m_bj">
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
				<table width="100%" border="0" cellspacing="0" cellpadding="0"
					class="tab_heig">
					<tr>
						<td width="52%" valign="top">
							<table width="100%" border="0" cellpadding="0" cellspacing="0"
								class="iphone">
								<tr>
									<td valign="top">
										<span class="width_100">标题：</span>
									</td>
									<td colspan="3">
										<input type="text" name="title" id="title1" onkeyup="this.value = this.value.substring(0,14)"
											class="b_block width_85" />
										<span class="hui">* 请填写标题，不要超过14个字</span>
									</td>
								</tr>
								<tr>
									<td valign="top">
										<span class="width_100">摘要：</span>
									</td>
									<td colspan="3">
										<input type="text" name="subtitle" onkeyup="this.value = this.value.substring(0,36)" id="subtitle1" />
										<span class="hui">* 请填写副标题，不要超过36个字</span>
									</td>
									

								</tr>
								<tr>
									<td width="4%" valign="top">
										<span class="width_100">所属栏目：</span>
									</td>
									<td width="45%">
										<select name="columnId" id="columnId1" onchange="news_columnId_change(this.value)" class="b_block  width_85">
											<option value="0">
												请选择...
											</option>
											<c:forEach items="${colList}" var="col">
												<c:if test="${fn:contains(resColList,col.cname)}">
													<option value="${col.id}">
														${col.cname}
													</option>
												</c:if>
											</c:forEach>
										</select>
										<span class="hui">* 请选择新闻所属栏目 您拥有管理权限的模块：<c:forEach items="${colList}" var="col">
											<c:if test="${fn:contains(resColList,col.cname)}">
												 
													${col.cname}.
											 
												</c:if>
											</c:forEach></span>
									</td>
									
								</tr>
								  
								<tr>
								<td width="4%" valign="top">
										来源：
									</td>
									<td width="46%">
										<input type="text" name="news.creator" onkeyup="this.value = this.value.substring(0,25)" id="creator1" />
										<span class="hui">* 请填写来源，不要超过25个字</span>
									</td>
								</tr>
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
									<td>
										新闻内容：
									</td>
									<td colspan="3">
										<form id="form1" name="form1" method="post" action="">
											<label for="textarea"></label>
											<textarea name="content1" id="content1" cols="100" rows="20"
												style="visibility: hidden;" class="b_block width_95"></textarea>
										</form>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td valign="top">
							<div class="btn_bg clr">
								<form id="news_ajax" action="${path}/news/add" method="post">
									<input type="hidden" name="news.title" id="title" />
									<input type="hidden" name="news.subtitle" id="subtitle" />
									<input type="hidden" name="news.author" id="author" value="${session['user'].uid }"/>
									<input type="hidden" name="news.creator" id="creator" />
									<input type="hidden" name="news.content" id="content" />
									<input type="hidden" name="news.img" id="img" />
									<input type="hidden" name="news.type" id="type" value="1"/>
									<input type="hidden" name="news.columnid" id="columnId" />
									<input type="button" value="确定" class="caozuo_input f_l" onclick="checkForm()" />
									<input name="input" type="button" value="返回" onclick="javascript:history.back()" class="caozuo_input f_l" />
								</form>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div> --%>
</body>
</html>