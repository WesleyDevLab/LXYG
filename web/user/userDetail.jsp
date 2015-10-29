<%@ page language="java" import="java.util.*" pageEncoding="gbk"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML >
<html>
<head>

<title>��Ա��Ϣҳ��</title>
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
		alert("��ʵ��������Ϊ�գ�");
		return;
	}
	if(mobile=="") {
		alert("�ֻ����벻��Ϊ�գ�");
		return;
	}
	if(address=="") {
		alert("��ַ����Ϊ�գ�");
		return;
	}
	$("#userDetail").ajaxSubmit({
		dataType : 'text',
		success : function(msg) {
			if (msg == 0) {
				alert("��ӳɹ�");
				location.href = "${path}/user/detail?uid=" + uid;
			} else {
				alert("�û����Ѿ�����");
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
						<i class="icon-edit"></i>��Ա����
					</h2>

				</div>
				<div class="box-content">
					<form id="userDetail" action="${path }/user/update" method="post" class="form-horizontal" />
					<fieldset>
						<div class="control-group">
							<label class="control-label" for="typeahead">�û�ͷ��</label>
							<div class="controls">
								<img style="width:100px;height:100px;" src="<%=imgPath %>${userinfo.photo}">
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">�û�����</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="${userinfo.username}" class="span6 typeahead" />
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" for="typeahead">��ʵ������</label>
							<div class="controls">
								<input type="text" name="realname" id="realname" value="${userinfo.realname}" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">�ֻ��ţ�</label>
							<div class="controls">
								<input type="text" name="mobile" id="mobile" value="${userinfo.mobile}" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">��ַ��</label>
							<div class="controls">
								<input type="text" name="address" id="address" value="${userinfo.address}" class="span6 typeahead" />	
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">���֤��</label>
							<div class="controls">
								<input type="text" name="idCard" id="idCard" value="${userinfo.idcard}" class="span6 typeahead" />	
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="selectError3">��Ա���ͣ�</label>
							<div class="controls">
								<select id="isSelleer" name="isSeller">
									<c:choose>
										<c:when test="${userinfo.isseller==0}">
											<option value="0" selected="selected">����Ա</option>
											<option value="1">�̼�</option>
											<option value="2">��ͨ��Ա</option>
										</c:when>
										<c:when test="${userinfo.isseller==1}">
											<option value="0">����Ա</option>
											<option value="1" selected="selected">�̼�</option>
											<option value="2">��ͨ��Ա</option>
										</c:when>
										<c:otherwise>
											<option value="0">����Ա</option>
											<option value="1">�̼�</option>
											<option value="2" selected="selected">��ͨ��Ա</option>
										</c:otherwise>
									</c:choose>
								</select>
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">�ֿ�����</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="${r.ccard }��" class="span6 typeahead" />
							</div>
						</div>
						<div class="control-group">
							<label class="control-label" for="typeahead">�Żݴ�����</label>
							<div class="controls">
								<input type="text" value="${r.cconsume}��" readonly="readonly" class="span6 typeahead" />
							</div>
						</div>

						<div class="control-group">
							<label class="control-label" for="typeahead">���ѽ�</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="<fmt:formatNumber type='number' value='${r.ctotal/100}' maxFractionDigits='2' pattern="#,##0.00#" />Ԫ" class="span6 typeahead" />
							</div>
						</div>


						<div class="control-group">
							<label class="control-label" for="typeahead">����Ǯ����</label>
							<div class="controls">
								<input type="text" readonly="readonly" value="<fmt:formatNumber type='number' value='${r.crebate/100}' maxFractionDigits='2' pattern="#,##0.00#"/>Ԫ" class="span6 typeahead" />
							</div>
						</div>
						
						<div class="form-actions">
							<input type="hidden" name="uid" id="uid" value="${userinfo.uid}"/> 
							<input type="button" class="btn btn-primary" onclick="check()" value="����"/>
							<input type="reset" class="btn" value="����" />
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
			<span style="text-align: left; float: left">Copyright &copy; 2014.�����ƹ� All rights reserved.</span>
		</p>
	</footer>
	<!--/.fluid-container-->
</body>
</html>
