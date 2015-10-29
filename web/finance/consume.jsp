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
								<form name="form1" id="form1" action="${path }/finance/search" method="post">
									<input type="hidden" name="ctype" value="${ctype}">
									<input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" name="fromTime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
									<span>至</span>
									<input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" name="toTime" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"/>
									<input type="submit" class="btn btn-primary" value="按日期查询" />
									<span>商家名称：</span>
									<input name="str" type="text" style="margin-bottom: -2px;width:150px;" class="input-xlarge" />
									<input type="submit" value="搜索" class="btn btn-primary" />
								</form>
							</div>
                            <table class="table table-bordered table-striped table-condensed">
                                <thead>
                                    <tr>
                                        <th>序号</th>
                                        <th>会员姓名</th>
                                        <th>会员卡号</th>
                                        <th>联系电话</th>
                                        <th>消费总额</th>
                                        <th>原价</th>
                                        <th>折扣</th>
										<th>消费商家</th>
										<th>所持卡种</th>
										<th>消费时间</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${pg.list}" var="r" varStatus="loopStatus">
                                    <tr>
                                        <td>
                                            ${loopStatus.count}
                                        </td>
                                        <td>${r.realname}</td>
                                        <td class="center">${r.id}
                                        </td>
                                        <td class="center">${r.mobile}
                                        </td>
                                      <td class="center">
														 <span class="font_red"><fmt:formatNumber type='number' value='${r.cash/100}' maxFractionDigits='2' pattern="#,##0.00#" /> </span>元
													</td>
													<td class="center">
														 <span class="font_red"><fmt:formatNumber type='number' value='${r.total/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
													</td>
													<td class="center">
														 <span class="font_red"><fmt:formatNumber type='number' value='${r.discount/10}' maxFractionDigits='1' pattern="#,##0.0#" /> </span>折
													</td>
										 <td class="center">${r.shopname}
                                        </td>
										<td class="center">${r.cardname}
                                        </td>
										<td class="center">${r.createtime}
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
							<div>
								消费统计合计：本时间段内， 共有${record.count}个会员 共计在${record.count1}家店铺当中 消费 <span class="font_red"> 
								<fmt:formatNumber type='number' value='${record.total/100}' maxFractionDigits='2' pattern="#,##0.00#"/> 
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
