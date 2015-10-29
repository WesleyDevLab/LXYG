<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript" src="${path }/public/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
function toUrl(url) {
	location.href=url;
}

function del(shopId) {
	var url = "<%=basePath%>user/delShop";
	if (confirm("确定要删除吗?", "警告")) {
		$.post(url, {
			"shopId" : shopId
		}, function(data) {
			if (data == 0) {
				alert("删除成功！");
				location.href = "${path }/user/list?type=1";
			} else {
				alert("删除失败！");
			}
		});
	}
}

function check() {
	$("shopname").html("");
	var startDate = $("#fromTime").val();
	var endDate = $("#toTime").val();
	return compareTime(startDate, endDate);
}

function compareTime(startDate, endDate) {  
 	if (startDate.length > 0 && endDate.length > 0) {  
	    var startDateTemp = startDate.split(" ");  
	    var endDateTemp = endDate.split(" ");  
	
	    var arrStartDate = startDateTemp[0].split("-");  
	    var arrEndDate = endDateTemp[0].split("-");  
	
	    var arrStartTime = startDateTemp[1].split(":");  
	    var arrEndTime = endDateTemp[1].split(":");  
	
		var allStartDate = new Date(arrStartDate[0], arrStartDate[1], arrStartDate[2], arrStartTime[0], arrStartTime[1], arrStartTime[2]);  
		var allEndDate = new Date(arrEndDate[0], arrEndDate[1], arrEndDate[2], arrEndTime[0], arrEndTime[1], arrEndTime[2]);  
	
		if (allStartDate.getTime() >= allEndDate.getTime()) {  
		        alert("开始时间不能大于结束时间！");  
		        return false;  
		} else {  
		    return true;  
	    }  
	} else {  
	    alert("时间不能为空！");  
	    return false;  
    }  
}  

function change(value) {
	var url = "<%=basePath %>shop/balance";
	if (value == 1) {
		url = url + "?type=3";
	} else {
		url = url + "?type=4";
	}
	toUrl(url);
}
</script>
</head>
<%@ include file="../common/top.jsp"%>
<body onload="init()">
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
                    <h2><i class="icon-align-justify"></i><span class="break"></span>结算记录</h2>
                    <div class="box-icon">
                        <c:if test="${viewKey==10}">
                        	<a href="javascript:void(0)" onclick="toUrl('<%=basePath %>home/viewDate?type=${viewKey}')" class="btn-add">
                         	<i class="icon-edit" style="width:60px;">审阅</i>
                         </a>
                        </c:if>
                    </div>
                </div>
				<div class="box-content">
					<%--<div style="margin:10px 0;">
						<table>
		                    <tr>
			                    <form action="<%=basePath %>shop/balance?type=1" method="post">
	                                <td><input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" id="fromTime" name="fromTime" value="${fromTime}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
	                                <td>-</td>
	                                <td><input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" id="toTime" name="toTime" value="${toTime}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
	                                <td valign="top" ><button type="submit" onclick="return check()" class="btn btn-primary">查询</button></td>
                             	</form>
			                    
								<form action="<%=basePath %>shop/balance?type=2" method="post">
									<td  valign="middle" style="padding-left:20px;  padding-right:10px;" >商家名称:</td>
									<td>
										<div class="dataTables_filter" id="DataTables_Table_0_filter">
											<input type="text" style="margin-bottom: -2px;width:170px;" id="shopname" name="shopname" value="${shopname}" aria-controls="DataTables_Table_0">
										</div>
									</td>
									<td valign="top"><button type="submit" class="btn btn-primary">搜索</button></td>
								</form>
								
								<td style="padding-left:20px; padding-right:10px;" >付款方式</td>
								<td>
									<select onchange="change(this.value)" style="margin-bottom: -2px;" class="inpt_sec" >
										<c:if test="${type==3}">
											<option value="1" selected="selected">在线支付</option>
										    <option value="2">到店支付</option>
										</c:if>
										<c:if test="${type!=3}">
											<option value="1">在线支付</option>
									    	<option value="2" selected="selected">到店支付</option>
										</c:if>
									</select>
								</td>
							</tr>
	                    </table>
					</div>--%>
					<table class="table table-bordered table-striped table-condensed">
	                    <thead>
		                    <tr>
			                    <th>序号</th>
			                    <th>订单号</th>
			                    <th>联系电话</th>
			                    <th>产品名称</th>
			                    <th>金额</th>
			                    <th>付款方式</th>
			                    <th>结算状态</th>
			                    <th>结算时间</th>
			                    <!--<th>操作</th>
		                    --></tr>
	                    </thead>
	                    <tbody>
		                    <c:forEach items="${pageBean.list}" var="order" varStatus="loopStatus">
								<tr>
									<td>${loopStatus.count}</td>
									<td>
										${order.orderNo}
									</td>
									<td>
										${order.phone}
									</td>
									<td>
										${order.orderName}
									</td>
									<td>
										<script type="text/javascript">formatNum(${order.totalCost});</script>元
									</td>
									<td>
										<c:if test="${order.payMode == 1}">
											在线支付
										</c:if>
										<c:if test="${order.payMode == 2}">
											到店支付
										</c:if>
									</td>
									<td>
										<c:if test="${order.isbalance == 1}">
											已结算
										</c:if>
										<c:if test="${order.isbalance == 0}">
											未结算
										</c:if>
									</td>
									<td>${order.baltime}</td>
									<!--<td>
										<button type="button" class="btn btn-danger">点击结算</button>
                                        <button type="button" class="btn btn-primary">结算记录</button>
									</td>
								--></tr>
							</c:forEach>
							<tr>
								<td colspan="8">
									<div class="pagination pagination-centered">
										<div class="bg">
											<div class="r_page">
												<script type="text/javascript">
													var url = location.href;
													var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
												</script>
											</div>
											<div class="clear"></div>
										</div>
									</div>
								</td>
							</tr>
	                    </tbody>
                    </table>
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
	<footer>
	<p>
		<span style="text-align: left; float: left">Copyright &copy;
			2014.乐享云购 All rights reserved.</span>
	</p>
	</footer>
</body>
</html>

