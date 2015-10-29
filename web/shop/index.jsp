<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>商家后台办公系统</title>
<link href="<%=basePath %>shop/css/css.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="<%=basePath %>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/yfweb.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/artDialog.js?skin=green"></script>
<script type="text/javascript" src="<%=basePath %>public/js/iframeTools.js"></script> 
<script type="text/javascript">
//弹出窗
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock:true,
		title: text,
		width: '800px',
		height:'500px'
	});
}

function edit() {
	$("#red_opa").html(" ");
	$("#red_rpa").html(" ");
	var opa = $("#oldPassword").val();
	var npa = $("#newPassword").val();
	var rpa = $("#rPassword").val();
	var check = true;
	if (isString6_20(opa) < 6) {
		alert("旧密码只能输入6-16个字母、数字、下划线哦！");
		check = false;
	} else if (isString6_20(npa) < 6) {
		alert("新密码只能输入6-16个字母、数字、下划线哦！");
		check = false;
	} else if (npa == opa) {
		alert("新密码不能和原密码相同！");
		check = false;
	} else if (npa != rpa) {
		alert("新密码前后两次不一致！");
		check = false;
	}

	if (check) {
		$.post('<%=basePath %>user/editPa', {"opa" : opa, "npa" : npa},
		function(data) {
			if(data == "0") {
				alert("修改成功，请重新登录");
				closeDiv('popupdiv_psw2');
				window.location.href="<%=basePath%>user/exit";
			} else {
				alert("修改失败！");
			}
		});
	}
}

function exit(){
	if(confirm("请问您确认退出系统吗?")){
		location.href="<%=basePath%>user/exit";
	}
}
</script>
 
</head>

<body>
<div class="top">
	<ul>
	    <li>
		    <a href="<%=basePath%>shop/balance/balance.jsp"  target="mainFrame">
		    	<img src="<%=basePath %>shop/images/banknote.png" width="37" height="37" />结算
		    </a>
	    </li>
	    <li>
		    <a href="<%=basePath%>goods"  target="mainFrame">
		    	<img src="<%=basePath %>shop/images/t-shirt.png" width="39" height="36" />产品查看
		    </a>
	    </li>
	    <li>
		    <a href="<%=basePath%>shop"  target="mainFrame">
		    	<img src="<%=basePath %>shop/images/shop.png" width="33" height="33" />查看评论
		    </a>
	    </li>
	    <li>
		    <a href="<%=basePath%>shop/order4Shop?type=0"  target="mainFrame">
		    	<img src="<%=basePath %>shop/images/graph chart 1.png" width="36" height="32" />查看订单
		    </a>
	    </li>
	    <li>
		    <a href="<%=basePath%>shop/stint4Shop?type=2"  target="mainFrame">
		    	<img src="<%=basePath %>shop/images/hyukk.png" width="25" height="33" />结算记录
		    </a>
	    </li>
	    <li>
		    <a href="javascript:void(0)" onclick="show('popupdiv_psw','bar_blue')">
		    	<img src="<%=basePath %>shop/images/-.png" width="33" height="33" />帮助
		    </a>
	    </li>
    </ul>
</div>
<div class="left">
    <div class="clear">
		<c:if test="${!empty sessionScope.user.photo}">
		<img src='${imgPath}${sessionScope.user.photo}' width="116" height="115" align="left" class="ma_r_l" />
		</c:if>
		<c:if test="${empty session['user'].photo}">
		<img class="ma_r_l" src="<%=basePath %>shop/images/Ellipse 2 copy 3.png" alt="" width="116" height="115" align="left" />
		</c:if>
		<span class="username"> ${shopName}<b>欢迎您的登录！</b>
		<b class="psw"><a href="javascript:void(0)" onclick="show('popupdiv_psw2','bar_blue')">[修改密码 ]</a></b>
		</span>
	</div>
    <ul>
        <%--<li>
	        <a href="<%=basePath %>card/cardList" target="mainFrame">
	        	<img src="<%=basePath %>shop/images/tag.png" width="23" height="18"/>折扣管理
	        </a>
        </li>
        <li>
	        <a href="<%=basePath%>finance/today" target="mainFrame">
	        	<img src="<%=basePath %>shop/images/search.png" width="25" height="28"/>今日交易明细
	        </a>
        </li>--%>
        <li>
	        <a href="javascript:void(0)" onclick="show('popupdiv_psw','bar_blue')">
	        	<img src="<%=basePath %>shop/images/diamond.png" width="22" height="16"/>我要认证
	        </a>
        </li>
        <li>
	        <a href="javascript:void(0)" onclick="show('popupdiv_psw','bar_blue')" >
	        	<img src="<%=basePath %>shop/images/Shape.png" width="19" height="14"/>联系客服
	        </a>
        </li>
        <li>
	        <a href="javascript:void(0)" onclick="exit()">
	        	<img src="<%=basePath %>shop/images/Shape 16.png" width="20" height="20"/>退出系统
	        </a>
        </li>
    </ul>
</div>
<div class="main"> 
	<iframe frameborder="0" src="<%=basePath%>shop/balance/balance.jsp" name="mainFrame"></iframe>
</div>
<%-- 弹出层begin --%>
<div id="popupdiv_psw" style="display:none;" class="kefu">
	请拨打服务热线<br/>
	0374-8080868 / 8080168<br/>
	进行咨询 <br/>
	<div class="bor">
		<input type="button"  value="点击返回" class="add_pro2" onclick="closeDiv('popupdiv_psw')" />
	</div>
</div>
<%-- 弹出层end --%>
<div id="popupdiv_psw2" style="display:none;" class="mima">
	<div class="mima">
		<ul>
			<li>
				<span>请输入旧密码：</span>
				<input type="password" name="oldPassword" id="oldPassword" class="{required:true,isWord:true,minlength:6,messages:{required:'请确认新密码',isWord:'密码必须为数字、字母.',minlength:'长度至少为6'}}"/>
			</li>
			<li>
				<span>请输入新密码：</span>
				<input type="password" name="newPassword" id="newPassword" class="{required:true,isWord:true,minlength:6,messages:{required:'请确认新密码',isWord:'密码必须为数字、字母.',minlength:'长度至少为6'}}"/>
			</li>
			<li>
				<span>请确认密码：</span>
				<input type="password" name="rPassword" id="rPassword" class="{required:true,isWord:true,minlength:6,messages:{required:'请确认新密码',isWord:'密码必须为数字、字母.',minlength:'长度至少为6'}}"/>
			</li>
		</ul>
	</div>
	<div class="clear" style="margin-left:150px;">
		<input type="button" value="取消" class="yzbtn2" onclick="closeDiv('popupdiv_psw2')" />
		<input type="button" value="确定" class="yzbtn2" onclick="edit()" />
	</div>
</div>
<div class="foot">Copyright©  2014  郑州云峰计算机科技有限公司 版权所有</div>
</body>
</html>
