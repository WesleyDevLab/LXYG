<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
	function init() {
		initRow();
	}

	function delMess(val) {
		$.post("${path }/news/delMessage",
		{
			"messId" : val
		},
		function(data) {
			if (data == '0') {
				alert("删除成功！");
				location.href = "${path }/news/getMessage?newsId=${newsId }&parentId=${parentId }";
			} else {
				alert("删除失败！");
			}
		});
	}
</script>
</head>

<body onload="init()">
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-align-justify"></i><span class="break"></span>评论管理
					</h2>
				</div>
				<div class="box-content">
					<table class="table table-bordered table-striped table-condensed">
						<tbody>
							<c:if test="${empty pageBean.list}">
								<tr>
									<td colspan="10" style="text-align:center;">
										<font style="font-size:16px;" color="red">暂无相关数据!</font>
									</td>
								</tr>
							</c:if>
							<c:forEach items="${pageBean.list}" var="mes" varStatus="status">
								<tr>
									<td colspan="1">${mes.username }</td>
									<td colspan="1">${mes.createtime}</td>
									<td colspan="1">
										<button type="button" class="btn" onclick="delMess('${mes.mid }')">删除</button>
									</td>
								</tr>
								<tr>
									<td colspan="3">${mes.mcontent }</td>
								</tr>
								<tr height="10px;" bgcolor="#fff;">
									<td colspan="3"></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<div class="pagination pagination-centered">
						<div class="bg">
							<div class="r_page">
								<script type="text/javascript">
									var url = location.href;
									var pageOne = new PageObject(url,'${pg}','${pageBean.totalPage}','${pageBean.totalRow}','pageOne');
								</script>
							</div>
							<div class="clear"></div>
						</div>
					</div>
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
	<!-- <footer>
		<p>
			<span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
		</p>

	</footer> -->
	<!--/.fluid-container-->
	<%-- <div class="right_con">
    <div class="tab">
		<table border="0" cellpadding="4" cellspacing="1" width="100%">
		<c:if test="${empty pageBean.list}">
				<tr>
					<td colspan="10" style="text-align:center;"><font
						style="font-size:16px;" color="red">暂无相关数据!</font>
					</td>
				</tr>
			</c:if>
		<c:forEach items="${pageBean.list}" var="mes" varStatus="status">
		<tr >
			<td colspan="1"  >${mes.username }</td><td colspan="1" >${mes.createtime}</td><td colspan="1" ><a href="javaScript:delMess('${mes.mid }');">删除</a></td>
		</tr>
		<tr>
			<td colspan="3"  >${mes.mcontent }</td>
		</tr>
		<tr height="10px;" bgcolor="#fff;"><td colspan="3"></td></tr>
		</c:forEach>
		<tr>
			<td colspan="6"><div class="bg">
			<div class="r_page">
				<script type="text/javascript">
					var url = location.href;
					var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
				</script>
				<div class="clear"></div>
			</div>
			<div class="clear"></div>
		</div></td>
		</tr>
		</table>
	</div>
	</div> --%>
</body>
</html>
