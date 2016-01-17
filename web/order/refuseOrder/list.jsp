<%--
  Created by IntelliJ IDEA.
  User: 秦帅
  Date: 2016/1/14
  Time: 16:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ page language="java" import="com.lxyg.app.customer.platform.util.*" pageEncoding="utf-8" %>
<%@ include file="/common/taglibs.jsp" %>
<html>
<head>
    <jsp:include page="/metro.jsp"></jsp:include>
    <title></title>
</head>
<%@ include file="/common/top.jsp" %>
<body>
<!-- start: Content -->
<div id="content" class="span10">
    <div class="row-fluid">
        <div class="box span12">
            <div class="box-header">
                <h2 id="plat_name1"><i class="icon-align-justify"></i><span class="break"></span>乐享云购退款管理</h2>

                <div class="box-icon">
                    <c:if test="${viewKey!=3 }">
                        <a href="${path}/pageTo/addproduct" class="btn-add">
                            <i class="icon-edit" style="width:60px">添加</i>
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="box-content" style="min-height: 100%">
                <div style="margin-b:10px 0;" class="form-inline">
                    <div class="form-group">
                        <div style="padding: 10px">

                            <div class="btn-group">
                                <div class="controls"><select class="form-control" id="pay" onchange="searchByPay(this.value)">
                                    <option value="0">支付方式</option>
                                </select>
                                </div>
                            </div>

                            <div class="btn-group">
                                <div class="controls"><select class="form-control" id="order" onchange="searchByStatus(this.value)">
                                    <option value="0">退款状态</option>
                                    <option value="5">申请拒收/退款订单</option>
                                    <option value="6">退款中</option>
                                    <option value="7">退款成功</option>
                                </select></div>
                            </div>

                            <div class="btn-group">
                                <input type="text" id="search_pros" style="height: 30px;">
                                <button style="margin-left: 5px" type="button" onclick="search()"
                                        class="btn btn-primary">
                                    订单搜索
                                </button>
                            </div>

                        </div>

                        <table class="table table-bordered table-striped table-condensed" style="font-size: 14px;">
                            <thead  >
                            <tr>
                                <th >订单号</th>
                                <th>商铺</th>
                                <th>商铺电话</th>
                                <th>顾客</th>
                                <th>顾客电话</th>
                                <th>付款方式</th>
                                <th>订单状态</th>
                                <th>付款金额</th>
                                <th>操作</th>
                            </tr>
                            </thead>
                            <tbody id="innerOrders">
                            </tbody>
                        </table>

                        <div class="pagination pagination-centered">
                            <div class="bg">
                                <div class="r_page">
                                    <li id="page"></li>
                                    <li><a onclick="loadDataByPage(0,1)">首页</a></li>
                                    <li><a class="active" onclick="loadDataByPage(2,0)">上一页</a></li>
                                    <li><a class="active" onclick="loadDataByPage(1,0)">下一页</a></li>
                                    <li><a onclick="loadDataByPage(3,1)">末页</a></li>
                                    跳转到第
                                    <input id="toPage" style="width:20px;ime-mode:disabled;" size="4">
                                    页
                                    <a class="label label-success"
                                       onclick="loadDataByPage(4,$(this).prev('input').val())">跳转</a>
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
<div class="modal hide fade" id="myModal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>删除操作</h3>
    </div>

    <div class="modal-body">
        <p>您确定要删除该信息吗？...</p>
    </div>

    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">取消</a>
        <a href="#" class="btn btn-primary">删除</a>
    </div>

</div>


<div class="clearfix">

</div>
<footer>
    <p>
        <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
    </p>
</footer>
<script>
    var pay_type;
    var order_status;

    $(document).ready(function(){
        var url="${path}/goods/payType";
        $.getJSON(url,function(data){
            for(var i=0;i<data.payType.length;i++){
                $("#pay").append("<option value="+data.payType[i].id+">"+data.payType[i].pay_type_name+"</option>");
            }
        });
        loadData();
    });

    var loadData=function (){
        var postDataUrl="${path}/order/refuseOrderList";
        $("#innerOrders").html("");
        var postParm={
            "pay_type":pay_type,
            "order_status":order_status,
            "page":1
        };
        $.post(postDataUrl,postParm,function(data){
            var json=data.orders.list;
            var innerOrders="";
            $.each(json,function(i,order){
                innerOrders+="<tr><td>"+order.order_no+"</td><td>"+order.s_name+"</td><td>"+order.s_phone+"</td><td>"+order.u_name+"</td><td>"+order.u_phone+"</td>" +
                        "<td>"+order.pay_name+"</td><td>"+order.order_status+"</td><td>"+order.price+"</td><td><button type='button' class='btn btn-primary'>退款</button></td></tr>";
            });
            $("#innerOrders").append(innerOrders);
        });
    }



    function searchByPay(val){
        pay_type=val;
        loadData();
    }

    function searchByStatus(val){
        order_status=val;
        loadData();
    }



</script>
</body>
<%@include file="/common/bottom.jsp" %>
</html>
