<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>财务统计</title>
<link href="<%=basePath%>shop/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/query/jquery.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="<%=basePath%>shop/js/page.js"></script>
<script type="text/javascript">
function init(){
	initRow();			
}

function showUnreadNews() {
    $(document).ready(function() {
        $.ajax({
            type: "post",
            url: "<%=basePath%>shop/ensure",
			dataType : "json",
			success : function(msg) {
				if (msg == "0") {
					alert("商铺保证金已经低于设定值，请及时充值！");
				}
			}
		});
	});
}
//setInterval('showUnreadNews()', 5 * 60 * 1000);


function toUrl(url) {
	location.href = url;
}
</script>
</head>

<body>
	<div class="position">
		<img src="<%=basePath%>shop/images/pimg.png" width="18" height="51" />您当前的位置：财务统计
	</div>
	<h1 class="tittle">财务统计</h1>
	<div class="con">
		<div class="search">
			<form name="form1" id="form1" action="<%=basePath %>finance/searchByShopId" method="post">
				<input type="hidden" name="type" value="${type}">
				<c:if test="${type == 1}">
					<input name="fromTime" class="Wdate " type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
						style="width:150px; height:28px; border:1px solid #CCC"> 
					<span>至</span>
					<input name="toTime" class="Wdate " type="text" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"
						style="width:150px; height:28px; border:1px solid #CCC">
					<input class="data_search" type="submit" value="按日期查询" />
				</c:if>
				<input name="str" type="text" class="search_input" placeholder="会员姓名" title="会员姓名" />
				<input type="submit" value="搜索" class="search_btn" />
			</form>
		</div>
		<div class="font_info">
			本时间段内， 会员共计在本店消费 <span class="font_red"> <fmt:formatNumber type='number' value='${record.total/100}' maxFractionDigits='2' pattern="#,##0.00#" /> </span> 元; 
			现金支付 <span class="font_red"> <fmt:formatNumber type='number' value='${record.cash/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
			 钱包支付<span class="font_red"> <fmt:formatNumber type='number' value='${record.purse/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元 
			共有 ${record.count} 个会员在本店消费
		</div>
		<div class="clear">
			<span class="fl font">详细财务报表</span> 
			<c:if test="${type == 1}">
				<input type="button" onclick="toUrl('<%=basePath %>finance/exportExcel')" class="daochu_btn fr" value="导出Excal" />
			</c:if>
			<c:if test="${type == 2}">
				<input type="button" onclick="toUrl('<%=basePath %>finance/export2Excel')" class="daochu_btn fr" value="导出Excal" />
			</c:if>
		</div>

		<table width="100%" border="0" cellspacing="1" cellpadding="1" class="tab_list" bgcolor="#e6e6e6">
			<thead>
				<tr>
					<th>序号</th>
					<th>会员姓名</th>
					<th>会员卡号</th>
					<th>联系电话</th>
					<th>消费总额</th>
					<th>现金支付</th>
					<th>钱包支付</th>
					<th>所持卡种</th>
					<th>消费时间</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty pg.list}">
					<tr height="30" style="text-align: center;">
						<td colspan="9"><font style="font-size:16px;" color="red">暂无相关数据!</font>
						</td>
					</tr>
				</c:if>
				<c:if test="${!empty pg.list}">
					<c:forEach items="${pg.list}" var="r" varStatus="loopStatus">
						<tr>
							<td>
								${loopStatus.count}
							</td>
							<td>
								${r.realname}
							</td>
							<td>
								${r.id}
							</td>
							<td>
								${r.mobile}
							</td>
							<td>
								 <span class="font_red"><fmt:formatNumber type='number' value='${r.total/100}' maxFractionDigits='2' pattern="#,##0.00#" /> </span>元
							</td>
							<td>
								 <span class="font_red"><fmt:formatNumber type='number' value='${r.cash/100}' maxFractionDigits='2' pattern="#,##0.00#" /></span>元
							</td>
							<td>
								 <span class="font_red"><fmt:formatNumber type='number' value='${r.purse/100}' maxFractionDigits='2' pattern="#,##0.00#" /> </span>元
							</td>
							<td>
								${r.cardname}
							</td>
							<td>
								${r.createtime}
							</td>
						</tr>
					</c:forEach>
					<tr>
						<td colspan="9">
							<div class="bg">
								<div class="r_page">
								<script type="text/javascript">
									var url = location.href;
									var pageOne = new PageObject(url,'${page}','${pg.totalPage}','${pg.totalRow}','pageOne');
								</script>
							</div>
						</div>
						</td>
					</tr>
				</c:if>	
			</tbody>
		</table>
	</div>
</body>
</html>

