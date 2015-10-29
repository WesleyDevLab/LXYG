<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.kaka.platform.util.ConfigUtils"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	String imgPath = ConfigUtils.getProperty("nginx.root");
%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>商家后台办公系统</title>
<link href="<%=basePath%>shop/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/jquery.form.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/yfweb.js"></script>
<style type="text/css">
#popupdiv_logo {
	width: 500px;
	height: 190px;
	position: absolute;
	z-index: 1000;
	border: 2px solid #ffffff;
	background: #ffffff;
}
</style>
<script type="text/javascript">
function init() {
	initRow();
}

function uploadImg(form, file) {
	extArray = new Array(".gif", ".jpg", ".png");
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
				alert("保存成功！");
				document.getElementById('img').value = msg;
			}
		});
	} else {
		alert("对不起，只能上传以下格式的文件:  " + (extArray.join("  "))
				+ "\n请重新选择符合条件的文件再上传.");
	}
}

//表单提交验证
function checkForm() {
	var shopname = $("#shopname_text").val();
	var address = $("#address_text").val();
	var telphone = $("#telphone_text").val();
	var remark = $("#remark_text").val();
	if (shopname == "") {
		alert("请认真填写商家名称！");
		return false;
	} else if (address == "") {
		alert("请认真填写商家地址！");
		return false;
	} else if (telphone == "") {
		alert("请认真填写商家联系方式！");
		return false;
	} else {
		$("#shopname").val(shopname);
		$("#address").val(address);
		$("#telphone").val(telphone);
		$("#remark").val(remark);
		$("#shop_ajax").ajaxSubmit( {
			dataType : 'text',
			success : function(msg) {
				alert("保存成功！");
				if (msg == "0")
					window.location.href = "<%=basePath%>shop";
				else
					window.location.href = "<%=basePath%>login/login.jsp";
			}
		});
	}
}

function toUrl(url) {
	location.href = url;
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：店铺管理
	</div>
	<h1 class="tittle">店铺管理</h1>
	<div class="con">
		<input name="button" type="button" onclick="toUrl('<%=basePath %>shop/drawList')" value="店铺图片展示" class="add_pro2" />
		<b class="dian_name">店标</b> 
		<c:if test="${empty shop.img}">
			<img src="<%=basePath %>public/images/icon.jpg" width="214" height="147" />
		</c:if>
		<c:if test="${!empty shop.img}">
			<img src="<%=imgPath %>${shop.img}" width="214" height="147" />
		</c:if>
		<input name="input" id="show" onclick="show('popupdiv_logo','bar_blue')" type="text" value="修改" class="xiugai_btn mar_t" /> 
		<b class="dian_name">您的店铺名称</b> 
		<input name="shopname_text" id="shopname_text" type="text" class="inp_bor" value="${shop.shopname}"/>
		 
		<b class="dian_name">您的地址</b>
		<input name="address_text" id="address_text" type="text" class="inp_bor" value="${shop.address }" /> 
		
		<b class="dian_name">联系电话</b>
		<input name="telphone_text" id="telphone_text" type="text" class="inp_bor" value="${shop.telphone }" />
		
		<b class="dian_name">备注</b>
		<input name="remark_text" id="remark_text" type="text" class="inp_bor" value="${shop.remark }" /> 
		
		<form id="shop_ajax" action="<%=basePath %>shop/update" method="post">
			<input type="hidden" name="shopid" id="shopid" value="${shop.shopid }" />
			<input type="hidden" name="shopname" id="shopname" />
			<input type="hidden" name="img" id="img" value="${shop.img }" />
			<input type="hidden" name="telphone" id="telphone" />
			<input type="hidden" name="address" id="address" />
			<input type="hidden" name="remark" id="remark" />
			<input type="hidden" name="weixin" id="weixin" value="${shop.weixin }" />
			<input type="hidden" name="qrcode" id="qrcode" value="${shop.qrcode }" />
			<input name="button" type="button" onclick="checkForm()" value="保存" class="baocun" />
		</form>
	</div>
	<%-- 弹出层begin --%>
	<div id="popupdiv_logo" style="display:none;">
         	<div id="bar_blue" class="bar_blue">更改店标</div>
			<div class="changelogo">
		 		<div class="changelogo_left">
		 			<c:if test="${empty shop.img}">
		 				<img src="<%=basePath %>public/images/icon.jpg" width="146" height="113" />
		 			</c:if>
		 			<c:if test="${!empty shop.img}">
		 				<img src="<%=imgPath %>${shop.img}" width="146" height="113" />
		 			</c:if>
		 		</div> 
		 		<div class="changelogo_right"> 
					<form action="<%=basePath %>upload/files?type=Img" method="post" enctype="multipart/form-data" id="uploadform" name="uploadform">
						<span>你可以上传一张照片作为商家logo</span>
						<span>
							<input class="no_bor" type="file" name="file" id="file" />
						</span> 
						<span> 
							<input type="button" value="保存" onclick="uploadImg(this.form,this.form.file.value)" class="xiugai_btn" />
							<input type="button" value="返回" class="xiugai_btn" onclick="closeDiv('popupdiv_logo')" />
						</span>
					</form>
		 		</div>
  			</div>
			<div class="tishi_black width_500">* (可上传.jpg,.png,.gif,格式)</div>
		</div>
		<%-- 弹出层end --%>
</body>
</html>

