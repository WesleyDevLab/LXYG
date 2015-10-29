<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %> 

<!DOCTYPE HTML>
<html>
<head>  
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function addRole() {
	var name = $("#name").val();
	var orderno = $("#orderno").val();
	var remark=$("#remark").val();
	if(name == "") {
		alert("角色名称不能为空！");
		return;
	}
	if(orderno == "") {
		alert("排序不能为空！");
		return;
	}
	$.ajax( {
		url:"${path }/role/add",
		type:"POST",
		dataType : 'text',
		data:{"role.name":name,"role.orderno":orderno,"role.remark":remark},
		success : function(msg) {
			if(msg==0){
				alert("添加成功");
				art.dialog.close();
			}
		}
	});
}	
</script>
</head>
<body onload="initRow()">
	<!-- <div class="c_m_bj"> 
	</div>
	<div class="right_con">
		<div class="caozuo">
			 <input type="button" value="添加" onclick="addRole()" class="caozuo_input f_l" /> 
		</div>
		<div class="tab">
		<form id="roleForm" action="${path }/role/add" method="post" >
			<input type="hidden" id="restype" name="res.restype">
			<input type="hidden" id="flag" name="res.flag" value="1">
			<table border="0" cellpadding="3" cellspacing="1" width="100%" style="font-size: 14px;">
				 
					<tr>
						<td>角色名称</td> 
						<td><input type="text" id="name" name="role.name"></td> 
					</tr>
					<tr>
						<td>描述</td> 
						<td><input type="text" id="remark" name="role.remark"></td> 
					</tr>
					<tr>
						<td>排序</td> 
						<td><input type="text" id="orderno" name="role.orderno"></td> 
					</tr>
			</table>
		</form>
		</div>
	</div> -->
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>添加
					</h2>
				</div>
				<div class="box-content">
					<form id="roleForm" action="${path }/role/add" method="post" >
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">角色名称：</label>
							<div class="controls">
								<input type="text" name="role.name" id="name" class="span6 typeahead" />
								<p class="help-block">* </p>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">描述：</label>
							<div class="controls">
								<input type="text" name="role.remark" id="remark"  class="span6 typeahead" />
								<p class="help-block"> </p>
							</div>
						</div>
						
						<div class="control-group">
							<label class="control-label" for="typeahead">排序：</label>
							<div class="controls">
								<input type="text" name="role.orderno"  id="orderno" class="span6 typeahead" />
								<p class="help-block">* </p>
							</div>
						</div>
						<div class="form-actions">
							<input type="hidden" id="restype" name="res.restype">
							<input type="hidden" id="flag" name="res.flag" value="1">
							<input type="button" value="保存" class="btn btn-primary" onclick="addRole()" />
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
</body>
</html>