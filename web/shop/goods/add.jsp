<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page import="com.kaka.platform.util.ConfigUtils"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
<script type="text/javascript">
function init(){
	initRow();			
}

function uploadImg(form, file, a) {
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
				document.getElementById('img').value = msg;
			}
		});
	} else {
		alert("对不起，只能上传以下格式的文件:  " + (extArray.join("  "))
				+ "\n请重新选择符合条件的文件再上传.");
	}
}

//表单提交验证
function check() {
	var goodsname = $("#goodsname_text").val();
	var price = Number($("#price_text").val());
	var note = $("#note_text").val();
	var remark = $("#remark_text").val();
	if (goodsname == "") {
		alert("请认真填写产品名称！");
		return false;
	} else if (price == "") {
		alert("请认真填写产品价格！");
		return false;
	} else if(!isDigit1(price)) {
		alert("请输入合法的产品价格！");
		return false;
	} else if (note == "") {
		alert("请认真填写产品注释！");
		return false;
	} else if (remark == "") {
		alert("请认真填写产品描述！");
		return false;
	} else {
		$("#goodsname").val(goodsname);
		$("#price").val(Number(price)*100);
		$("#note").val(note);
		$("#remark").val(remark);
		$("#add_ajax").ajaxSubmit( {
			dataType : 'text',
			success : function(msg) {
				if (msg == "0") {
					alert("添加成功！");
					window.location.href = "<%=basePath%>goods";
				} else {
					alert("长时间未操作，请重新登录！");
					window.location.href = "<%=basePath%>login.jsp";
				}
			}
		});
	}
}
</script>
</head>

<body onload="init();">
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：产品管理
	</div>
	<h1 class="tittle">添加产品</h1>
	<div class="con">
		<table width="600" border="0" cellspacing="0" cellpadding="0" class="ad_car">
			<tr>
				<td align="right"><span class="span_font">产品名称：</span></td>
				<td>
					<input id="goodsname_text" name="goodsname_text" type="text" class="inp_bor" />
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">产品价格：</span></td>
				<td>
					<input id="price_text" name="price_text" type="text" class="inp_bor_short" /> 元<span class="hui">（只可输入数字和小数点）</span>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">产品预览图：</span></td>
				<td>
					<p>
						<img id="img_text" src="<%=basePath%>shop/images/addimg.png" width="192" height="85" class="img" />
					</p> 
					<form action="<%=basePath%>upload/files?type=Img" method="post" enctype="multipart/form-data" id="uploadform" name="uploadform">
						<input class="inp_bor" onchange="uploadImg(this.form,this.form.file.value)" type="file" name="file" id="file" />
					</form>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">产品注释：</span></td>
				<td>
					<textarea id="note_text" name="note_text" cols="45" rows="5" class="benzhu"></textarea>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">产品描述：</span></td>
				<td>
					<textarea id="remark_text" name="remark_text" cols="45" rows="5" class="benzhu"></textarea>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<form action="<%=basePath%>goods/add" id="add_ajax" method="post">
						<input type="hidden" name="goodsname" id="goodsname" /> 
						<input type="hidden" name="price" id="price" /> 
						<input type="hidden" name="img" id="img" /> 
						<input type="hidden" name="note" id="note" /> 
						<input type="hidden" name="remark" id="remark" />
						<input name="button" type="button" onclick="check();" value="保存" class="baocun" /> 
					</form>
				</td>
			</tr>
		</table>


	</div>
</body>
</html>

