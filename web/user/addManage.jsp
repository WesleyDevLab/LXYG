<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %> 
<!DOCTYPE HTML>
<html>
<head>
    
 <title>添加管理员</title>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript"  >
function init(){
	initRow();			
}
function toUrl(url,type){
	 
}
function formsubmit(type) {
$.ajax( {
		url:"${path }/user/add?type=0",
			type:"POST",
			dataType : 'text',
			data:{"user.username":$("#username").val(),"password":$("#password").val(),"realname":$("#realname").val(),"mobile":$("#mobile").val(),"address":$("#address").val()},		success : function(msg) {
			if(msg==0){
				alert("添加成功");
				location.href="${path}/user/list?type="+type;
			}else{
				alert("用户名已经存在");
			}
			
		}
	});
}
</script>
<style type="text/css">
	.bor_con ul li span{width:80px; float: left;}
</style>

  </head>
  	<%@ include file="../common/top.jsp"%>
<body onload="init();">
	<!--  <div class="caozuo">
		<span class="title caozuo_span ">
		<input type="button" value="添加" onclick="formsubmit('0');" class="caozuo_input f_l" /> 
		</span>
    </div>
    <div class="caozuo">
		 
    </div>
 	<div class="bor_con">
 	<form id="add" action="${path }/user/add?type=0" method="post">
		<ul>
			<li><span > </span> </li>
			<li><span >用户名：</span><input type="text" name="user.username" class="width_35" /></li>
            <li><span >密码：</span><input type="password" name="password" class="width_35" /></li>
            <li><span >确认密码：</span><input type="password" name="rpass" class="width_35" /></li>
            <li><span >姓名：</span><input type="text" name="realname" class="width_35" /></li>
            <li><span >手机号：</span><input type="text" name="mobile" class="width_35" /></li>
           
            <li><span >地址：</span><input type="text" name="address" class="width_45" /></li>
		</ul>
		</form>
</div>
    -->
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
							<label class="control-label" for="typeahead">用户名：</label>
							<div class="controls">
								<input type="text" name="user.username" id="username"  class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">密码：</label>
							<div class="controls">
								<input type="password" name="password" id="password" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">确认密码：</label>
							<div class="controls">
								<input type="password" name="rpass" id="rpass" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
							</div>
						</div>
					<div class="control-group">
							<label class="control-label" for="typeahead">姓名：</label>
							<div class="controls">
								<input type="text" name="realname" id="realname" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">手机：</label>
							<div class="controls">
								<input type="text" name="mobile" id="mobile" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">地址：</label>
							<div class="controls">
								<input type="text" name="address" id="address" onkeyup="this.value=this.value.substring(0,36)" class="span6 typeahead" />
							</div>
						</div>
						<div class="form-actions">
							
							<input type="button" value="保存" class="btn btn-primary" onclick="formsubmit('0')" />
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
