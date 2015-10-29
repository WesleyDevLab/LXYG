<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="../common/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head>

<jsp:include page="/metro.jsp"></jsp:include>
<script type="text/javascript">
function init(){
	initRow();			
}

function toUrl2(url,type){
	location.href = url + "?type=" + type;
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
                            <h2><i class="icon-align-justify"></i><span class="break"></span>交易统计</h2>
                            <div class="box-icon">
                                <c:if test="${viewKey==7||viewKey==8}">
	                                <a href="javascript:void(0)" onclick="toUrl2('${path }/home/viewDate','${viewKey}')" class="btn-setting">
	                                	<i class="icon-wrench" style="width:60px;">审阅</i>
	                                </a> 
								</c:if>
                            </div>
                        </div>
                        <div class="box-content">
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
									<tr>
										<c:choose>
											<c:when test="${ctype==3}">
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
											</c:when>
											<c:otherwise>
												<th>序号</th>
												<th>会员姓名</th>
												<th>联系电话</th>
												<th>充值/提现额度</th>
												<th>请求时间</th>
												<th>账户</th>
											</c:otherwise>
										</c:choose>
									</tr>
								</thead>
                                <tbody>
                                	<tr>
                                	<c:choose>
										<c:when test="${ctype == 3}">
											<c:forEach items="${pageBean.list}" var="r" varStatus="loopStatus">
												<tr>
													<td>${loopStatus.count}</td>
			                                        <td>${r.cname}</td>
			                                        <td class="center">${r.shopname}</td>
			                                        <td class="center">${r.phone}</td>
			                                        <td class="center">${r.orderNo}</td>
													<td class="center">
														 <span class="font_red"><fmt:formatNumber type='number' value='${r.totalCost/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
													</td>
													<td class="center">${r.ordername}</td>
													<td class="center">${r.totalCount}</td>
													<td class="center"><c:if test="${r.payMode==1}">在线支付</c:if><c:if test="${r.payMode==2}">到店支付</c:if></td>
													<td class="center"><c:if test="${r.isbalance==0}">未结算</c:if><c:if test="${r.isbalance==1}">已结算</c:if></td>
													<td class="center">${r.contime}</td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<c:forEach items="${pageBean.list}" var="r" varStatus="loopStatus">
												<tr>
													<td>
														${loopStatus.count}
													</td>
													<td>
														${r.realname}
													</td>
													<td>
														${r.mobile}
													</td>
													<td>
														<span class="font_red"><fmt:formatNumber type='number' value='${r.total/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
													</td>
													<td>
														${r.createtime}
													</td>
													<td>
														${r.account}
													</td>
												</tr>
											</c:forEach>
										</c:otherwise>
									</c:choose>
									</tr>
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
    <footer>
        <p>
            <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
        </p>
    </footer>
<%-- <form name="form1" id="form1" method="post">
<div class="c_m_bj"><span class="title02">交易统计</span></div>

	<div class="right_con">
	  <div class="caozuo">
	  <c:choose>
			<c:when test="${viewKey==7||viewKey==8 }">
				<input type="button" value="审阅" onclick="toUrl('${path }/home/viewDate','${viewKey }');" class="caozuo_input f_l" /> 
			</c:when>
		</c:choose>
	  </div>
	<div class="tab">
	 
		<table border="0" cellpadding="4" cellspacing="1" width="100%">
		<thead>
			<tr>
				<th>选择</th> 
				<th>会员名称</th> 
				<th>交易类型</th>
				<th>账户金额</th>
				<th>交易金额</th>
				<th>交易账户</th>
				<th>商家名称</th>
				<th>交易时间</th>
				<th>状态</th>
				<c:if test="${viewKey!=7&&viewKey!=8 }">
					<th>操作</th>
				</c:if>
			</tr>
		</thead>

		<tbody>
			<c:if test="${empty pageBean.list}">
				<tr>
					<td colspan="10" style="text-align:center;"><font
						style="font-size:16px;" color="red">暂无相关数据!</font>
					</td>
				</tr>
			
			</c:if>
			<c:forEach items="${pageBean.list}" var="user" varStatus="status">
				<tr>
					<td><input type="checkbox" name="ids" id="10" class="nobor" />
					</td>
					<td align="left">${user.username }</td>
					<td><c:if test="${user.ctype==1 }">提现</c:if><c:if test="${user.ctype==2 }">充值</c:if><c:if test="${user.ctype==3 }">消费</c:if> </td>
					<td><span style="color: green;">${user.balance }</span></td>
					<td><span style="color: red;"><fmt:formatNumber type='number' value='${user.total/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span></td>
					<td>${user.account }</td>
					<td>${user.shopname }</td>
					<td>${user.createtime }</td>
					<td><c:if test="${user.flag==0 }">已处理</c:if><c:if test="${user.flag==1}">未处理</c:if></td>
					<c:if test="${viewKey!=7&&viewKey!=8 }">
						<td>
							<a href="${path }/user/detail?uid=${user.uid}">查看详细</a>	
							<c:if test="${user.flag==1}">				
								<a href="javaScript:trade('${user.consumeid}');"> | 处理</a>
							</c:if>
						</td>
					</c:if>
				</tr>
			</c:forEach> 
			<tr>
				<td colspan="10">
					<div class="bg">
						<div class="r_page">
							<script type="text/javascript">
								var url = location.href;
								var pageOne = new PageObject(url, '${pg}', '${pageBean.totalPage}', '${pageBean.totalRow}', 'pageOne');
							</script>
							<div class="clear"></div>
						</div>
					</div>
				</td>
			</tr>
		</tbody>
		</table>
	</div>
	 
	</div>
	
	</form> --%>
     
</body>
</html>
