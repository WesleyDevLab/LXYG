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
	<style>
		.white_content {
			border-radius: 5px;
			display: none;
			position: absolute;
			top: 80%;
			left: 83%;
			width: 15%;
			height: 15%;
			padding: 20px;
			border: 0px solid ;
			background-color: rgba(230,26,95,0.8);
			z-index:1002;
			overflow: auto;
			box-shadow:2px 2px 10px #909090;
		}
	</style>

<script type="text/javascript">
	var page=1;
	var totalPage=1;
	var totalRows=0;

$(document).ready(function(){
	loadData(page);
	setInterval("loadData(page)",1000*60*1);
});

	function loadData(pg){
		$.post("${path}/order/loadOrderLis",{"pg":page},function(result){
			if(result.code==10002){
				var inner="";
				$("#inner").html(inner);
				var pageHtml="";
				$("#page").html(pageHtml);
				console.info(result);
				for(var i=0;i<result.orders.list.length;i++){
					var order=result.orders.list[i];
					var order_id=order.order_id;
					totalPage=result.orders.totalPage;
					totalRows=result.orders.totalRow;
					var str="";
					var status=statusName(order.order_status);

					if(order.process_status==0){
						str="<button type='button' class='btn btn-primary' value='"+order_id+"'  onclick='JavaScript:update($(this));'>确认</button><button type='button' class='btn' value='"+order_id+"' >异常单处理</button>";
						show();
					}
					if(order.process_status==1){
						str="<span>已确认</span>";
					}

					var more="<a style='color:firebrick' href='${path}/order/loadOrderInfo?orderId="+order_id+"' >详细信息</a>";
					inner+="<tr>" +
							"<td style='display:none'>"+order_id+"</td>"+
							"<td>"+order.order_no+"</td>"+
							"<td>"+order.name+"</td>"+
							"<td>"+order.phone+"</td>"+
							"<td>"+order.shop_name+"</td>"+
							"<td>"+order.shop_phone+"</td>"+
							"<td>"+order.price/100+"</td>"+
							"<td>"+order.create_time+"</td>"+
							status+
							"<td><span style='color: red'>"+order.error_msg+"</span></td>"+
							"<td>"+str+"</td>"+
							"<td>"+more+"</td></tr>"
				}
				pageHtml+="第"+page+"/"+totalPage+"页    共"+totalRows+"条";
				$("#inner").append(inner);
				$("#page").append(pageHtml);
			}
		});
	}


	function update(obj){
		console.info(obj);
		var orderId=obj.val();
		console.info(orderId);
		$.post("${path}/order/updateLis",{"orderId":orderId},function(res){
			if(res.code==10002){
				loadData();
			}
		});
	}


	function statusName(code){
		var str="";
		if(code==-1){
			str="<td>初始订单</td>";
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
			str="<td><span style='color: green'>已完成</span></td>";
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
		loadData(page);
	}


	function show(){
		$("#light").html("");
		$("#light").append('<span style="color: white;font-size: 16px">有新的订单出现异常,请及时查看</span></br>' +
				'' +
				'</br><a href = "javascript:void(0)" onclick = "hide()" style="color: white">点这里关闭本窗口</a>');
		$("#light").fadeIn();
	}
	function hide(){
		$("#light").fadeOut();
	}

</script>
</head>
<%@ include file="../common/top.jsp"%>
<body>
<div id="light" class="white_content"></div>
	<!-- start: Content -->
	<div id="content" class="span10">
		<div class="row-fluid">
			<div class="box span12">
				<div class="box-header">
					<h2>
						<i class="icon-edit"></i>订单监控
					</h2>
				</div>
				<div class="box-content">
					<div style="margin:10px 0;">

					</div>
					<table class="table table-bordered table-striped table-condensed">
	                    <thead>
		                    <tr>
			                    <th>订单号</th>
			                    <th>用户</th>
			                    <th>用户电话</th>
			                    <th>商家</th>
			                    <th>商家电话</th>
			                    <th>订单总价</th>
			                    <th>下单时间</th>
								<th>订单状态</th>
								<th>异常信息</th>
								<th>操作</th>
								<th>更多操作</th>
		                    </tr>
	                    </thead>
	                    <tbody id="inner">

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

