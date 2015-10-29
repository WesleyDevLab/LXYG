<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<script type="text/javascript" src="<%=basePath %>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath %>public/js/public.js"></script>
<script type="text/javascript" src="${path }/public/kindeditor/kindeditor.js"></script>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
var editor;
KindEditor.ready(function(K) {
	editor = K.create('textarea[name="remark"]',
	{
		heigth : '400px',
		width : '90%',
		cssPath : '${path}/public/kindeditor/plugins/code/prettify.css',
		uploadJson : '${path}/public/kindeditor/jsp/upload_json.jsp',
		fileManagerJson : '${path}/public/kindeditor/jsp/file_manager_json.jsp',
		allowFileManager : true,
		afterCreate : function() {
			this.sync();
		},
		afterChange : function() {
			this.sync();
		}
	});
	prettyPrint();
});

//弹出窗
function alertJsp(text,url) {
	art.dialog.open(url,{
		lock : true,
		title : text,
		width : '800px',
		height :'500px'
	});
}

function change(isstint) {
	//alert(isstint);
	if(isstint == 1) {
		document.getElementById("id_qua").style.display="block";
	} else {
		document.getElementById("id_qua").style.display="none";
	}
}

function toUrl(url) {
	location.href=url;
}

//表单提交验证
function check() {
	var goodsname = $("#goodsname").val();
	var marketprice = Number($("#marketprice").val());
	var price = Number($("#price").val());
	var memberprice = Number($("#memberprice").val());
	var instock = Number($("#instock").val());
	var note = $("#note").val();
	var remark = editor.html();;
	if (goodsname.trim() == "") {
		alert("请认真填写产品名称！");
		return false;
	} else if (marketprice == "") {
		alert("请认真填写产品原价！");
		return false;
	} else if(!isDigit1(marketprice)) {
		alert("请输入合法的产品原价！");
		return false;
	} else if (price == "") {
		alert("请认真填写产品价格！");
		return false;
	} else if(!isDigit1(price)) {
		alert("请输入合法的产品价格！");
		return false;
	} else if (memberprice == "") {
		alert("请认真填写产品会员价！");
		return false;
	} else if(!isDigit1(memberprice)) {
		alert("请输入合法的产品会员价！");
		return false;
	} else if (instock == "") {
		alert("请认真填写产品库存！");
		return false;
	} else if(!isDigit(instock)) {
		alert("请输入合法的产品库存！");
		return false;
	} else if (note == "") {
		alert("请认真填写产品注释！");
		return false;
	} else if (remark == "") {
		alert("请认真填写产品描述！");
		return false;
	} else {
		$("#marketprice").val(marketprice*100);
		$("#price").val(price*100);
		$("#memberprice").val(memberprice*100);
		$("#add_ajax").ajaxSubmit({
			dataType : 'text',
			success : function(msg) {
				if (msg == "0") {
					alert("编辑成功！");
					location.href="<%=basePath%>goods/preEdit?shopId=${shopId}&type=${type}&goodsId=${goods.goodsid}";
				} else {
					alert("编辑失败！");
				}
			}
		});
	}
}
</script>
</head>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>编辑产品
					</h2>
				</div>
				<div class="box-content">
					<form action="<%=basePath%>goods/edit" id="add_ajax" method="post" enctype="multipart/form-data" class="form-horizontal" />
						<fieldset>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									产品名称：
								</label>
								<div class="controls">
									<input id="goodsname" name="goodsname" value="${goods.goodsname}" type="text" class="span6 typeahead" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">产品原价：</label>
								<div class="controls">
									<input id="marketprice" name="marketprice" type="text" class="span6 typeahead" value="<fmt:formatNumber type='number' value='${goods.marketprice/100}' maxFractionDigits='2' pattern="#,##0.00#" />" style="width: 100px;" />
									元<span class="hui">（只可输入数字和小数点）</span>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">现价：</label>
								<div class="controls">
									<input id="price" name="price" type="text" value="<fmt:formatNumber type='number' value='${goods.price/100}' maxFractionDigits='2' pattern="#,##0.00#" />" class="span6 typeahead" style="width: 100px;" />
									元<span class="hui">（只可输入数字和小数点）</span>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">会员价：</label>
								<div class="controls">
									<input id="memberprice" name="memberprice" type="text" value="<fmt:formatNumber type='number' value='${goods.memberprice/100}' maxFractionDigits='2' pattern="#,##0.00#" />" class="span6 typeahead" style="width: 100px;" />
									元<span class="hui">（只可输入数字和小数点）</span>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">是否限购：</label>
								<div class="controls">
									<select id="isstint" name="isstint" onchange="change(this.value)" style="width: 60px;">
										<c:choose>
											<c:when test="${goods.isstint == 0}">
												<option value="1">是</option>
												<option value="0" selected="selected">否</option>
											</c:when>
											<c:when test="${goods.isstint == 1}">
												<option value="1" selected="selected">是</option>
												<option value="0">否</option>
											</c:when>
											<c:otherwise>
												<option value="1">是</option>
												<option value="0" selected="selected">否</option>
											</c:otherwise>
										</c:choose>
									</select>
								</div>
							</div>
							<c:choose>
								<c:when test="${goods.isstint == 1}">
									<div id="id_qua" style="display:block;" class="control-group">
										<label class="control-label" for="typeahead">
											每人限购数量：
										</label>
										<div class="controls">
											<input id="quaeach" name="quaeach" value="${goods.quaeach}" type="text" class="span6 typeahead" style="width: 70px;" />
										</div>
									</div>
								</c:when>
								<c:otherwise>
									<div id="id_qua" style="display: none;" class="control-group">
										<label class="control-label" for="typeahead">
											每人限购数量：
										</label>
										<div class="controls">
											<input id="quaeach" name="quaeach" value="${goods.quaeach}" type="text" class="span6 typeahead" style="width: 70px;" />
										</div>
									</div>
								</c:otherwise>
							</c:choose>
							
							<div class="control-group">
								<label class="control-label" for="typeahead">
									库存：
								</label>
								<div class="controls">
									<input id="instock" name="instock" value="${goods.instock}" type="text" class="span6 typeahead" style="width: 70px;" />
								</div>
							</div>
							<c:if test="${!empty goods.img}">
								<div class="control-group">
									<label class="control-label" for="typeahead">
										原图：
									</label>
									<div class="controls">
										<img alt="缩略图" src="<%=imgPath %>${goods.img}" style="width: 160px;height: 120px;">
									</div>
								</div>
							</c:if>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									产品图片上传：
								</label>
								<div class="controls">
									<input id="img" name="img" type="file" class="input-file uniform_on" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									产品注释：
								</label>
								<div class="controls">
									<textarea id="note" name="note" cols="" rows="" style="width: 400px; height: 100px;">${goods.note}</textarea>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label" for="typeahead">
									产品简介：
								</label>
								<div class="controls">
									<textarea id="remark" name="remark" style="width: 400px; height: 100px;">${goods.remark}</textarea>
								</div>
							</div>
							<div class="form-actions">
								<input type="hidden" id="goodsId" name="goodsId" value="${goods.goodsid}" />
								<input type="hidden" id="shopId" name="shopId" value="${shopId}" />
								<input type="hidden" id="type" name="type" value="${type}" />
								<button type="button" onclick="check()" class="btn btn-primary">保存</button>
								<button type="reset" class="btn">重置</button>
							</div>
						</fieldset>
					</form>
				</div>
			</div>
			<!--/span-->

		</div>
		<!--/row-->


	</div>

	</div>
	<!--/fluid-row-->
	<!--/row-->

	</div>
	<!--/fluid-row-->

	<div class="clearfix"></div>
	<!--<footer>
	<p>
		<span style="text-align: left; float: left">Copyright &copy;
			2014.乐享云购 All rights reserved.</span>
	</p>
	</footer>
--></body>
</html>