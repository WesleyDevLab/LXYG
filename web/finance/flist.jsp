<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript" src="${path }/public/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
	console.info("${orders}");
function init(){
	initRow();			
}

function toUrl(url,ctype){
	location.href = url + "?ctype=" + ctype;
}

function trade(id){
	$.post("${path }/finance/editConsume", {
			"consumeId" : id
	}, function(data) {
		if (data == '0') {
			alert("操作成功！");
			location.href = "${path }/home/newConsume?viewKey=8&ctype=2";
		} else {
			alert("操作失败！");
		}
	});
}

function check() {
	var startDate = $("#fromTime").val();
	var endDate = $("#toTime").val();
	var shopname = $("#shopname").val();
	var payMode = $('#payMode option:selected').val();
	if (startDate != "" && endDate != "") {
		if(!compareTime(startDate, endDate)) {
			return false;
		}
	}
	if ((startDate != "" && endDate != "") || shopname !="" || payMode != 0) {
		$("#form1").submit();
	} else {
		alert("请填写搜索条件！");
		return false;
	}
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
</script>
</head  >
<%@ include file="../common/top.jsp"%>
<body onload="init()">
	 <!-- start: Content -->
            <div id="content" class="span10">
                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>消费统计</h2>
                        </div>
                        <div class="box-content">
							<div style="margin:10px 0;">						
								<form name="form1" id="form1" action="${path }/finance/finance2?type=1" method="post">
									<input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" id="fromTime" name="fromTime" value="${fromTime}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
									<span>至</span>
									<input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" id="toTime" name="toTime" value="${toTime}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
									<span style="margin-left:20px;">商家名称：</span>
									<input id="shopname" name="shopname" value="${shopname}" type="text" style="margin-bottom: -2px;width:150px;" class="input-xlarge" />
									<span style="margin-left:20px;">付款方式：</span>
									<select id="payMode" name="payMode" style="margin-bottom: -2px;" class="inpt_sec" >
									   <c:choose>
											<c:when test="${payMode == 1}">
												<option value="0">-请选择-</option>
												<option value="1" selected="selected">在线支付</option>
											    <option value="2">到店支付</option>
											</c:when>
											<c:when test="${payMode == 2}">
												<option value="0">-请选择-</option>
												<option value="1">在线支付</option>
										    	<option value="2" selected="selected">到店支付</option>
											</c:when>
											<c:otherwise>
												<option value="0" selected="selected">-请选择-</option>
												<option value="1">在线支付</option>
											    <option value="2">到店支付</option>
											</c:otherwise>
										</c:choose>
									</select>
									<input type="button" onclick="check()" value="搜索" class="btn btn-primary" />
								</form>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>分类</th>
                                        <th>店铺名称</th>
                                        <th>联系电话</th>
                                        <th>订单号</th>
                                        <th>消费总额</th>
                                        <th>产品名称</th>
										<th>数量</th>
										<th>付款方式</th>
										<th>结算状态</th>
										<th>消费时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pg.list}" var="r" varStatus="loopStatus">
                                    <tr>
                                        <td>${loopStatus.count}</td>
                                        <td>${r.cname}</td>
                                        <td class="center">${r.sname}</td>
                                        <td class="center">${r.phone}</td>
                                        <td class="center">${r.orderNo}</td>
										<td class="center">
											 <span class="font_red"><script type="text/javascript">formatNum(${r.totalCost});</script></span>元
										</td>
										<td class="center">${r.ordername}</td>
										<td class="center">${r.totalCount}</td>
										<td class="center"><c:if test="${r.payMode==1}">在线支付</c:if><c:if test="${r.payMode==2}">到店支付</c:if></td>
										<td class="center"><c:if test="${r.isbalance==0}">未结算</c:if><c:if test="${r.isbalance==1}">已结算</c:if></td>
										<td class="center">${r.contime}</td>
                                    </tr>
								</c:forEach>
                                </tbody>
                            </table>
                            <div class="pagination pagination-centered">
                            <div class="bg">
								<div class="r_page">
									<script type="text/javascript">
										var url = location.href;
										var type = "${type}";
										if (type == 1) {
											var fromTime = "${fromTime}";
											var toTime = "${toTime}";
											var shopname = "${shopname}";
											var payMode = "${payMode}";
											if (fromTime != "" && toTime != "") {
												url = url + "&fromTime=" + fromTime + "&toTime=" + toTime;
											}
											if (shopname != "") {
												url = url + "&shopname=" + shopname;
											}
											url = url + "&payMode=" + payMode;
										}
										var pageOne = new PageObject(url, '${page}', '${pg.totalPage}', '${pg.totalRow}', 'pageOne');
									</script>
								</div>
								<div class="clear"></div>
                            </div>
							<div>
								消费统计合计：本时间段内， 共有${record.ucount}个会员 共计在${record.scount}家店铺当中 消费 <span class="font_red"> 
								<script type="text/javascript">formatNum(${record.total});</script>
							</span>元
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
    <footer>
        <p>
            <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
        </p>
    </footer>
    <!--/.fluid-container-->
</body>
</html>
