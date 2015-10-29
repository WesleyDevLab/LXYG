<%@ page import="com.lxyg.app.customer.platform.model.User"%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%> 
<%@ include file="common/taglibs.jsp" %> 

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>管理员登录</title>
<link href="${path }/public/css/login.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${path}/public/js/query/jquery.js"></script>
<script type="text/javascript">
$(function(){
	$("#A1").addClass('cli');
});
//登陆限制   不能为空	 
function login(){
	var name = document.getElementById("txtUserName").value.replace(/^\s+|\s+$/g,"");
	var pass = document.getElementById("txtPassword").value.replace(/^\s+|\s+$/g,"");

	if (name == "") {
		document.getElementById("txtUserName").focus();
		$("#txtUserNameTip").html("用户名不能为空！");
	} else if(pass == "") {
		document.getElementById("txtPassword").focus();
		$("#txtPasswordTip").html("密码不能为空！");
	} else { 
		$("#logform").submit();
	}
}

if (window != top) 
	top.location.href = location.href; 
</script>
</head>

<body>
<div class="top">
	<!--  <img src="${path }/public/images/img.jpg" width="980" height="90" class="mar" />-->
</div>

<div class="bg">
	<div class="con">
		<form id="logform" action="${path }/user/login" method="post">
			<div class="login">
				<div class="user">
					<input name="username" type="text" id="txtUserName" class="input_bg_user" placeholder="用户名" title="用户名" />
				</div>
				<div class="red red_bt"><b id="txtUserNameTip">请输入用户名</b></div>
				<div class="user">
					<input name="password" type="password" id="txtPassword" class="input_bg_psw" placeholder="密码" title="密码" />
				</div>
				<div class="red red_bt"><b id="txtPasswordTip">请输入密码</b></div>
				<div class="user">
					<input type="button" onclick="login();" name="btnSubmit" value="登 录" id="btnSubmit" class="login_btn" />
					<div class="red red_bt"><b id="errMsg">${msg }</b></div>
				</div>
			</div>
		</form>
	</div>
</div>
<div class="bot">乐享云购 Copyright © 2005-2014 版权所有<br/>
	全国客服热线：400-8000-138 服务咨询企业QQ：138059708 版权所有，提醒您谨防假冒与抄袭！网站备案：豫ICP备0fsdfsd14号-10
</div>

</body>
</html>
