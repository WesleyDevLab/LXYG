<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>商家后台办公系统</title>
<link href="<%=basePath%>shop/css/css.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="<%=basePath %>shop/balance/style.css" />
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/yfweb.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/jquery.form.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/uuid.js"></script>
<script type="text/javascript">
function init(){
	initRow();	
	/* document.getElementById("b2").disabled=true; */
	/* var int; */		
}

function check() {
	var field = $("#field").val();
	if (!isDigit(field) && !isMobile(field)) {
		alert("输入信息不正确！");
	} else {
		$.post('<%=basePath %>shop/check',
			{"field": field}, 
		function(msg){
			var data = eval(msg);
			if (data.code == "0") {
				alert("验证成功！");
				$("#mobile").val(data.userinfo.mobile);
				$("#hcval").val(data.userinfo.hcval);
				$("#discount").val(data.userinfo.discount);
				$("#userinfo").removeClass("mista");
				var str = "会员信息： " + data.userinfo.realname + "<br />电话： " + data.userinfo.mobile + "<br />拥有本店：  " + data.userinfo.cardname + "<br />领卡时间：  " + data.userinfo.createtime + "<br />所享折扣： " + Number(data.userinfo.discount)/10 + "折<br />";
			    $("#userinfo").html(str);
			} else {
				alert("还不是会员！");
			}
		});
	};
} 

function change() {
	var total = $("#total_text").val().trim();
	var sum = Number(total)*100;
	var discount = $("#discount").val();
	var hcval = $("#hcval").val();
	if("" != discount && null != discount) {
		if(isDigit1(total)) {
			var distotal = sum*discount;
			var rebate = distotal*hcval;
			var xreb = parseInt(Number(rebate)/10000);
			$("#rebate").val(xreb);
			$("#total").val(sum);
			var str = "<span class='red'>本次消费： "+parseFloat(total).toFixed(2)+"元</span><br/><span class='red'>折 扣 价： "+parseFloat(distotal/10000).toFixed(2)+"元</span>";
			$("#coninfo").html(str);
		} else {
			alert("消费总额输入不是数字！");
			return;
		}
	} else {
		alert("请先确认会员手机号码或者会员卡号！");
		return;
	}
}

function checkForm() {
	var uuid = new UUID().createUUID();
	$("#uuid").val(uuid);
	var field = $("#mobile").val();
	var total = $("#total").val();
	if (!isDigit(total)) {
		alert("输入消费总额不正确！");
	} else {
		document.getElementById("b1").disabled = true;
		/* document.getElementById("b2").disabled = false;
		$("#b2").removeClass('qiqubtnh'); */
		$("#b1").removeClass('qiqubtn');
		/* $("#b2").addClass('qiqubtn'); */
		$("#b1").addClass('qiqubtnh');
		/* int = setInterval('showUnreadNews()', 5 * 1000);
		showDiv(); */
		$("#step2form").ajaxSubmit({
			dataType : 'text',
			success : function(msg) {
				if (msg == "0") {
					/* alert("交易成功！"); */
					show('popupdiv_jiesuan','bar_blue');
				} else {
					alert("交易失败！");
				}
			}
		});
	};
}

function toUrl() {
	closeDiv('popupdiv_jiesuan');
	window.location.href = "<%=basePath %>shop/balance/index.jsp";
}

function showDiv(){
	document.getElementById('loading').style.display='block';
	document.getElementById('bg').style.display='block';
}

function closeDiv(){
	document.getElementById('loading').style.display='none';
	document.getElementById('bg').style.display='none';
}
</script>
</head>

<body onload="init()">
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：结算
	</div>
	<h1 class="tittle">消费结算</h1>
	<div class="con">
	<form name="step2form" id="step2form" action="<%=basePath %>shop/confirmation" method="post">
		<table width="600" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td rowspan="2" valign="top">
					<table width="300" border="0" cellspacing="0" cellpadding="0" class="tab2">
						<tr>
							<td class="tit_blue" height="40">消息结算</td>
						</tr>
						<tr>
							<td rowspan="2">
								<b class="dian_name">请输入顾客会员卡号或手机号</b> 
								<input name="field" id="field" type="text" class="inp_bor2" /> 
								<b class="dian_name">请输入客户本次消费金额</b>
								<div class="clear">
									<input name="total_text" id="total_text" type="text" onchange="change()" class="inp_bor3" placeholder="0.00" title="0.00" />元
								</div> 
								<b class="dian_name">请输入消费明细 <span class="red">(可选)</span> </b> 
								<textarea name="remark" id="remark" class="inp_bor2"></textarea>
								<div class="clear">
									<input type="hidden" name="mobile" id="mobile">
									<input type="hidden" name="uuid" id="uuid" />
									<input type="hidden" name="discount" id="discount" />
									<input type="hidden" name="total" id="total" />
									<input type="hidden" name="hcval" id="hcval" />
									<input type="hidden" name="rebate" id="rebate" />
									<input id="b1" type="button" onclick="checkForm()" class="qiqubtn" value="确认交易" /> 
									<%-- <input id="b2" type="button" onclick="toUrl('<%=basePath %>shop/balance/index.jsp');" class="qiqubtnh" value="确认交易" /> --%>
								</div>
							</td>
						</tr>
					</table> 
					<img src="<%=basePath%>shop/images/bot.png" width="321" height="10" />
				</td>
				<td height="197" valign="top">
					<span class="clear"> 
						<input name="input" type="button" onclick="check()" class="yzbtn" value="验证" style="margin-top:130px;" /> 
					</span>
				</td>
				<td rowspan="2" valign="top">
					<table width="300" border="0" cellspacing="0" cellpadding="0" class="tab2">
						<tr>
							<td class="tit_blue" height="40">提示栏</td>
						</tr>
						<tr>
							<td rowspan="2">
								<b class="dian_name">
									<div id="userinfo" class="mista">
										该会员没有领取会员卡<br/>
										或会员信息输入有误，请确认输入信息
									</div>
									<img src="<%=basePath%>shop/images/line.png" width="261" height="3" class="pad_t" /> 
									<div id="coninfo">
									</div>
								</b>
							</td>
						</tr>
					</table> 
					<img src="<%=basePath%>shop/images/bot.png" width="321" height="10" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>
	</form>
	</div>
	<div id="loading" style="display:none; border:1px #000000 solid">
		<div class="loading-indicator">会员正在确认中,请不要离开本页面...</div>
	</div>
	<%-- 弹出层begin --%>
	<div id="popupdiv_jiesuan" style="display:none;">
		<div class="bor">
			<input type="button" value="点击返回" class="add_pro3" onclick="toUrl()" />
		</div>
	</div>
	<%-- 弹出层end --%>
	<div id="bg" class="bg" style="display:none;"></div>
</body>
</html>
