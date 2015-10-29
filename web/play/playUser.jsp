<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function init() {
	initRow();
};

function alertJsp(text, url) {
	art.dialog.open(url, {
		lock : true,
		title : text,
		width : '800px',
		height : '500px'
	});
};

function toUrl(url) {
	location.href = url;
}

function operate(playId, ope) {
	$.post("${path}/play/playUserOperateAll", {
		"playId" : playId,
		"operate" : ope
	}, function(data) {
		location.reload(true);
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
						<i class="icon-align-justify"></i><span class="break"></span>玩乐参与人
					</h2>
				</div>
				<div class="box-content">
					<div style="margin:10px 0;">
						<input type="button" onclick="operate('${playId}',0);" value="全部接受" class="btn btn-danger" /> 
						<input type="button" onclick="operate('${playId}',2);" value="全部拒绝" class="btn btn-primary" />
					</div>
					<table class="table table-bordered table-striped table-condensed">
						<thead>
							<tr>
								<th>姓名</th>
								<th>联系电话</th>
								<th>身份证号</th>
								<th>详细地址</th>
								<th>状态</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${empty userList}">
								<tr>
									<td colspan="10" style="text-align:center;">
										<font style="font-size:16px;" color="red">暂无相关数据!</font>
									</td>
								</tr>
							</c:if>
							<c:forEach items="${userList}" var="user" varStatus="status">
								<tr>
									<td align="left">${user.realname }</td>
									<td>${user.mobile }</td>
									<td>${user.idcard }</td>
									<td>${user.address }</td>
									<td>
										<c:choose>
											<c:when test="${user.operate==0 }">
												已接受
											</c:when>
											<c:when test="${user.operate==2 }">
												已拒绝
											</c:when>
											<c:otherwise>
												<input type="button" onclick="toUrl('${path }/play/playUserOperate?playId=${playId}&uid=${user.uid}&operate=0')" value="接受" class="btn btn-danger" /> 
												<input type="button" onclick="toUrl('${path }/play/playUserOperate?playId=${playId}&uid=${user.uid}&operate=2')" value="拒绝" class="btn btn-primary" />
											</c:otherwise>
										</c:choose>
									</td>
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
	<%-- <div class="right_con">
		<div class="caozuo">
			<input name="" type="button" onclick="operate('${playId}',0);" value="全部接受" class="caozuo_input f_l" /> 
			<input name="" type="button" onclick="operate('${playId}',2);" value="全部拒绝" class="caozuo_input f_l" />
		</div>

		<div class="tab">
			<table border="0" cellpadding="4" cellspacing="1" width="100%">
				<thead>
					<tr>
						<th>姓名</th>
						<th>联系电话</th>
						<th>身份证号</th>
						<th>详细地址</th>
						<th>状态</th>
					</tr>
				</thead>

				<tbody>
					<c:if test="${empty userList}">
						<tr>
							<td colspan="10" style="text-align:center;"><font
								style="font-size:16px;" color="red">暂无相关数据!</font></td>
						</tr>
					</c:if>
					<c:forEach items="${userList}" var="user" varStatus="status">
						<tr>

							<td align="left">${user.realname }</td>
							<td>${user.mobile }</td>
							<td>${user.idcard }</td>
							<td>${user.address }</td>
							<td><c:choose>
									<c:when test="${user.operate==0 }">
							已接受
							</c:when>
									<c:when test="${user.operate==2 }">
							已拒绝
							</c:when>
									<c:otherwise>
										<a
											href="${path }/play/playUserOperate?playId=${playId}&uid=${user.uid}&operate=0">接受</a>|
								<a
											href="${path }/play/playUserOperate?playId=${playId}&uid=${user.uid}&operate=2">拒绝</a>
									</c:otherwise>
								</c:choose></td>

						</tr>
					</c:forEach>
					<tr>
						<td colspan="6">
							<div class="bg">
								<div class="r_page">
									<script type="text/javascript">
										var url = location.href;
										var pageOne = new PageObject(url,
												'${pg}',
												'${pageBean.totalPage}',
												'${pageBean.totalRow}',
												'pageOne');
									</script>
									<div class="clear"></div>
								</div>
							</div></td>
					</tr>
				</tbody>
			</table>
		</div>
	</div> --%>
</body>
</html>
