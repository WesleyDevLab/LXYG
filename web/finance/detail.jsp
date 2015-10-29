<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
    

<jsp:include page="/metro.jsp"></jsp:include>
 <script type="text/javascript" src="${path }/public/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">
function init(){
	initRow();			
}

function toUrl(url,type){
	location.href = url + "?type=" + type;
}
</script>
</head  >
<%@ include file="../common/top.jsp"%>
<body onload="init();">
      <!-- start: Content -->
            <div id="content" class="span10">

                <div class="row-fluid">
                    <div class="box span12">
                        <div class="box-header">
                            <h2><i class="icon-align-justify"></i><span class="break"></span>会员消费统计</h2>
                        </div>
                        <div class="box-content">
							<div style="margin:10px 0;">						
								<form name="form1" id="form1" action="${path }/finance/search4Uid" method="post">
									<input type="hidden" name="uid" value="${uid}">
									<input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" name="fromTime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
									<span>至</span>
									<input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" name="toTime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
									<input type="submit" class="btn btn-primary" value="按日期查询" />
								</form>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
										<th>序号</th>
										<th>会员姓名</th>
										<th>联系电话</th>
										<th>消费类型</th>
										<th>
											提现/充值/消费额度
										</th>
										<th>
											请求/消费时间
										</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pg.list}" var="user" varStatus="status">
                                    <tr>
                                        <td>
                                            ${status.count}
                                        </td>
                                        <td>
											${user.realname}
										</td>
										<td>
											${user.mobile}
										</td>
										<td>
											<c:choose>
												<c:when test="${user.ctype==3}">
													消费
												</c:when>
												<c:when test="${user.ctype==2}">
													充值
												</c:when>
												<c:otherwise>
													提现
												</c:otherwise>
											</c:choose>
										</td>
										<td>
											<c:choose>
											<c:when test="${ctype==3}">
												<span class="font_red"><fmt:formatNumber type='number' value='${user.cash/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
											</c:when>
											<c:otherwise>
												<span class="font_red"><fmt:formatNumber type='number' value='${user.total/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
											</c:otherwise>
										</c:choose>
										</td>
										<td>
											${user.createtime}
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
											var pageOne = new PageObject(url, '${page}', '${pg.totalPage}', '${pg.totalRow}', 'pageOne');
										</script>
									</div>
									<div class="clear"></div>
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
