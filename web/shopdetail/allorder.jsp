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
<script type="text/javascript" src="<%=basePath%>public/js/public.js"></script>
<script type="text/javascript" src="${path }/public/js/My97DatePicker/WdatePicker.js"></script>
<script type="text/javascript">

var page=1;
var totalPage=1;
var totalRows=0;


$(document).ready(function(){
	var payType="<option value=0> 全部... </option>";
    var url="${path}/goods/loadGoodsAttribute";
    $.get(url,function(result){
       if(result.code==10010){
	       for(var i=0;i<result.payType.length;i++){
	           payType+="<option value="+result.payType[i].id+"> "+result.payType[i].pay_type_name+" </option>"
	       }
	       $("#column_payType").append(payType);
       }
    }); 
    check("",1);
});


function toUrl(url) {
	location.href=url;
}

function loadDataByPage(type,pageNum){
   if(type==0){
      page=1;
   }
   if(type==3){
     page=totalPage;
   }
   if(type==1){
      if(totalPage-page<=0){
         alert("最后一页");
         return false;
      }else{
         page++;      
      }
   }
   if(type==2){
      if(page-1<=0){
         alert("这是首页");
         return false;
      }else{
         page--;      
      }
   }
   
   if(type==4){
     if(pageNum>totalPage){
        alert("没有那么多页说");
         return false;
     }else{
        page=pageNum
     }
   }
   check("",page);
}


function check(str,page) {
	str=searchItem();
	$.post("${path}/order/allOrderJson",{"pg":page,"searchItem":str},function(result){
	   if(result.code==10002){
		   console.info(result);
		   var pageHtml="";
	         var item="";
	         $("#tbody").html(item);
			 totalPage=result.allOrder.totalPage;
		     totalRows=result.allOrder.totalRow;
		     $("#page").html(pageHtml);
	        for(var i=0;i<result.allOrder.list.length;i++){
	           var order=result.allOrder.list[i];
	           var status=statusName(order.order_status);
	           item+="<tr>" +
					   "<td style='display:none'>"+order.order_id+"</td>"+
					   "<td>"+order.order_no+"</td>"+
	                  "<td>"+order.send_name+"</td>"+
	                  "<td>"+order.user_name+"</td>"+
	                  "<td>"+order.phone+"</td>"+
	                  "<td>"+order.shop_name+"</td>"+
	                  "<td>"+order.shop_phone+"</td>"+
	                  "<td>"+order.pay_name+"</td>"+
	                  "<td>"+order.cash_pay+"</td>"+
	                  status+
	                  "<td>￥ "+order.price/100+"</td>"+
					  "<td><span  style='color:steelblue' >"+order.sep+"</span><a id="+order.order_id+"  style='color:firebrick'   href='javascript:void(0)' onclick='detail(this.id)'>详细信息</a></td></tr>"
	        }
		    pageHtml+="第"+page+"/"+totalPage+"页    共"+totalRows+"条";
	       console.info(item);
		   $("#tbody").append(item);
		   $("#page").append(pageHtml);
	   }
	});
}

function detail(o){
	window.location.href="${path}/order/getSpartOrder?orderId="+o;
}


function searchItem(){
	var startDate = $("#fromTime").val();
	var endDate = $("#toTime").val();
	var shopname = $("#shopname").val();
	var payMode = $('#column_payType option:selected').val();

	if (startDate != "" && endDate != "") {
		if(!compareTime(startDate, endDate)) {
			return false;
		}
	}
	var str="{"
	if(startDate!=""&& endDate != ""){
	    str+="startTime:"+startDate+",endTime:"+endDate+",";
	}
	if(shopname!=""){
	   str+="shopName:"+shopname+",";
	}
	if(payMode!=undefined && payMode!=0) {
	   str+="payType:"+payMode+",";
	}
	//str+="type:web,";
	if(str.length>1){
	   str=str.substr(0,str.length-1);
	   str+="}";
	}else{
	  str="";
	}
	return str;
}


function statusName(code){
   var str="";
   if(code==-1){
     str="<td>初始订单</td>";
   }
	if(code==0){
		str="<td>已支付</td>";
	}
   if(code==1){
     str="<td>可抢订单</td>";
   }
   if(code==2){
     str="<td><span style='color: #df8505'>待发货</span></td>";
   }
   if(code==3){
     str="<td><span style='color: #df8505'>待收货</span></td>";
   }
   if(code==4){
     str="<td><span style='color: #df8505'>已完成</span></td>";
   }
   if(code==5){
     str="<td><span style='color: red'>拒收</span></td>";
   }
   if(code==6){
     str="<td><span style='color:#bce774'>让单</span></td>";
   }
    if(code==7){
     str="<td><span style='color:red'>流单</span></td>";
   }
   return str;
   
}



function compareTime(startDate, endDate) {  
 	if (startDate.length > 0 && endDate.length > 0) {
	
	    var arrStartDate = startDate.split("-");  
	    var arrEndDate = endDate.split("-");   
	
		var allStartDate = new Date(arrStartDate[0], arrStartDate[1], arrStartDate[2]);  
		var allEndDate = new Date(arrEndDate[0], arrEndDate[1], arrEndDate[2]);  
	
		if (allStartDate.getTime() > allEndDate.getTime()) {  
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
</head>
<%@ include file="../common/top.jsp"%>
<body>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>订单管理
					</h2>
				</div>
				<div class="box-content">
					<div style="margin:10px 0;">
                        <form id="form1" action="<%=basePath %>shop/allOrders?type=4" method="post">
					    <table>
                             <tr>
                                <td><input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" id="fromTime" name="fromTime" value="${fromTime}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
                                <td>-</td>
                                <td><input type="text" style="margin-bottom: -2px;width:170px;" class="input-xlarge Wdate" id="toTime" name="toTime" value="${toTime}" onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" /></td>
                            	
								<td  valign="middle" style="padding-left:20px;  padding-right:10px;" >商家名称:</td>
								<td>
									<div class="dataTables_filter" id="DataTables_Table_0_filter">
										<input type="text" style="margin-bottom: -2px;width:170px;" id="shopname" name="shopname" value="${shopname}" aria-controls="DataTables_Table_0">
									</div>
								</td>
								<%--<td valign="top"><button type="submit" class="btn btn-primary">搜索</button></td>--%>
								
								<td style="padding-left:20px; padding-right:10px;" >付款方式</td>
								<td>
									<select id="column_payType" name="payMode" style="margin-bottom: -2px;" class="inpt_sec" >
									   
									</select>
								</td>
                                <td valign="top" style="padding-left:20px;"><button type="button" onclick="check('',1)" class="btn btn-primary">搜索</button></td>
                              </tr>
                            </table>
                            </form>
                            <div style="margin-top: 10px;" class="btn_sx"> 
								<div class="btn_sx">
									<ul>
										
									</ul>
								</div>
							</div>
						  </div>
						<table class="table table-bordered table-striped table-condensed">
							<thead>
								<tr>
									<th>订单号</th>
									<th>配送类型</th>
									<th>顾客</th>
									<th>顾客电话</th>
									<th>商铺</th>
									<th>商铺电话</th>
									<th>付款方式</th>
									<th>优惠券</th>
									<th>订单状态</th>
									<th>付款金额</th>
									<th>订单分析</th>
								</tr>
							</thead>
							<tbody id="tbody">
								
							</tbody>
						</table>
						 <div class="pagination pagination-centered">
                               <div class="bg">
									<div class="r_page">
									    <li id="page"></li>
										<li><a onclick="loadDataByPage(0,1)">首页</a></li>
										<li><a class="active" onclick="loadDataByPage(2,0)">上一页</a></li>
										<li><a class="active"  onclick="loadDataByPage(1,0)">下一页</a></li>
										<li><a onclick="loadDataByPage(3,1)">末页</a></li>
										 跳转到第  
										<input id="toPage" style="width:20px;ime-mode:disabled;" size="4">
										  页  
										<a class="label label-success"  onclick="loadDataByPage(4,$(this).prev('input').val())">跳转</a>
									</div>
									<div class="clear"></div>
								</div>
                            </div>
					</div>
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

