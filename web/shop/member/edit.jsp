<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<title>产品管理</title>
<link href="<%=basePath %>shop/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath %>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/jquery.form.js"></script>
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
	var cardname = $("#cardname_text").val();
	var discount = $("#discount_text").val();
	var request = $("#request_text").val();
	var instruction = $("#instruction_text").val();
	var note = $("#note_text").val();
	var remark = $("#remark_text").val();
	if (cardname == "") {
		alert("请认真填写会员卡名称！");
		return false;
	} else if (discount == "") {
		alert("请认真填写会员卡折扣！");
		return false;
	} else if (request == "") {
		alert("请认真填写会员卡需要积分！");
		return false;
	} else if (instruction == "") {
		alert("请认真填写会员卡使用说明！");
		return false;
	} else if (note == "") {
		alert("请认真填写会员卡注意事项！");
		return false;
	} else if (remark == "") {
		alert("请认真填写会员卡描述！");
		return false;
	} else {
		$("#cardname").val(cardname);
		$("#discount").val(Number(discount)*10);
		$("#request").val(Number(request)*100);
		$("#instruction").val(instruction);
		$("#note").val(note);
		$("#remark").val(remark);
		$("#add_ajax").ajaxSubmit( {
			dataType : 'text',
			success : function(msg) {
				if (msg == "0") {
					alert("更新成功！");
					window.location.href = "<%=basePath%>card/cardList";
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
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：折扣管理
	</div>
	<h1 class="tittle">修改会员卡</h1>
	<div class="con">
		<table width="600" border="0" cellspacing="0" cellpadding="0" class="ad_car">
			<tr>
				<td align="right"><span class="span_font">会员卡名称：</span></td>
				<td>
					<input name="cardname_text" id="cardname_text" type="text" class="inp_bor" value="${card.cardname}" />
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">该会员卡提供折扣:</span></td>
				<td>
					<input name="discount_text" id="discount_text" type="text" value="<fmt:formatNumber type='number' value='${card.discount/10}' maxFractionDigits='1' pattern='0.0#' />" class="inp_bor_short" /> 折<span class="hui">（只可输入数字和小数点）</span>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">需要累计消费:</span></td>
				<td>
					<input name="request_text" id="request_text" type="text" value="<fmt:formatNumber type='number' value='${card.request/100}' maxFractionDigits='2' pattern='#,##0.00#' />" class="inp_bor_short" /> 金额即可领取 <span class="hui">（只可输入数字和小数点）</span>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">上传会员卡图片：</span></td>
				<td>
					<p>
						<c:if test="${empty card.img}">
							<img src="<%=basePath %>shop/images/addimg.png" width="192" height="85" class="img" />
						</c:if>
						<c:if test="${!empty card.img}">
							<img src="<%=imgPath %>${card.img}" width="192" height="85" class="img" />
						</c:if>
					</p> 
					<form action="<%=basePath %>upload/files?type=Img" method="post" enctype="multipart/form-data" id="uploadform" name="uploadform">
						<input class="inp_bor" onchange="uploadImg(this.form,this.form.file.value)" type="file" name="file" id="file" />
					</form>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">使用说明：</span></td>
				<td>
					<textarea name="instruction_text" id="instruction_text" cols="45" rows="5" class="benzhu">${card.instruction}</textarea>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">注意事项：</span></td>
				<td>
					<textarea name="note_text" id="note_text" cols="45" rows="5" class="benzhu">${card.notice}</textarea>
				</td>
			</tr>
			<tr>
				<td align="right"><span class="span_font">会员卡描述：</span></td>
				<td>
					<textarea name="remark_text" id="remark_text" cols="45" rows="5" class="benzhu">${card.remark}</textarea>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<form action="<%=basePath%>card/update" id="add_ajax" method="post">
						<input type="hidden" name="cardid" id="cardid" value="${card.cardid}"/>
						<input type="hidden" name="cardname" id="cardname" />
						<input type="hidden" name="discount" id="discount" />
						<input type="hidden" name="request" id="request" />
						<input type="hidden" name="img" id="img" value="${card.img}"/>
						<input type="hidden" name="instruction" id="instruction" />
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

