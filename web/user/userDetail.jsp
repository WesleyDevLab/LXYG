<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML >
<html>
<head>

<title>会员信息页面</title>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function init() {
	//initCity();
	initRow();
}

function alertJsp(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
}

function check() {
	var uid = $("#uid").val();
	var realname = $("#realname").val();
	var mobile = $("#mobile").val();
	var address = $("#address").val();
	if(realname=="") {
		alert("真实姓名不能为空！");
		return;
	}
	if(mobile=="") {
		alert("手机号码不能为空！");
		return;
	}
	if(address=="") {
		alert("地址不能为空！");
		return;
	}
	$("#userDetail").ajaxSubmit({
		dataType : 'text',
		success : function(msg) {
			if (msg == 0) {
				alert("添加成功");
				location.href = "${path}/user/detail?uid=" + uid;
			} else {
				alert("用户名已经存在");
			}
		}
	});
}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>会员详情
					</h2>

				</div>
				<div class="box-content">
					<form id="userDetail" action="${path }/user/update" method="post" class="form-horizontal" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">用户头像：</label>
							<div class="controls">
								<img style="width:100px;height:100px;" src="<%=imgPath %>${userinfo.photo}">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">用户名：</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="${userinfo.username}" class="span6 typeahead" />
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" for="typeahead">真实姓名：</label>
							<div class="controls">
								<input type="text" name="realname" id="realname" value="${userinfo.realname}" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">手机号：</label>
							<div class="controls">
								<input type="text" name="mobile" id="mobile" value="${userinfo.mobile}" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">地址：</label>
							<div class="controls">
								<input type="text" name="address" id="address" value="${userinfo.address}" class="span6 typeahead" />	
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">身份证：</label>
							<div class="controls">
								<input type="text" name="idCard" id="idCard" value="${userinfo.idcard}" class="span6 typeahead" />	
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">会员类型：</label>
							<div class="controls">
								<select id="isSelleer" name="isSeller">
									<c:choose>
										<c:when test="${userinfo.isseller==0}">
											<option value="0" selected="selected">管理员</option>
											<option value="1">商家</option>
											<option value="2">普通会员</option>
										</c:when>
										<c:when test="${userinfo.isseller==1}">
											<option value="0">管理员</option>
											<option value="1" selected="selected">商家</option>
											<option value="2">普通会员</option>
										</c:when>
										<c:otherwise>
											<option value="0">管理员</option>
											<option value="1">商家</option>
											<option value="2" selected="selected">普通会员</option>
										</c:otherwise>
									</c:choose>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">持卡数：</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="${r.ccard }个" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">优惠次数：</label>
							<div class="controls">
								<input type="text" value="${r.cconsume}次" readonly="readonly" class="span6 typeahead" />
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" for="typeahead">消费金额：</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="<fmt:formatNumber type='number' value='${r.ctotal/100}' maxFractionDigits='2' pattern="#,##0.00#" />元" class="span6 typeahead" />
							</div>
						</div>


						<div class="control-group">
							<label class="control-label" for="typeahead">现有钱包余额：</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="<fmt:formatNumber type='number' value='${r.crebate/100}' maxFractionDigits='2' pattern="#,##0.00#"/>元" class="span6 typeahead" />
							</div>
						</div>
						
						<div class="form-actions">
							<input type="hidden" name="uid" id="uid" value="${userinfo.uid}"/> 
							<input type="button" class="btn btn-primary" onclick="check()" value="保存"/>
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
	<footer>
		<p>
			<span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
		</p>
	</footer>
	<!--/.fluid-container-->
</body>
</html>
