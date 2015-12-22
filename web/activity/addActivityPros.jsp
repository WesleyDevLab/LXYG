<%--
  Created by IntelliJ IDEA.
  User: 秦帅
  Date: 2015/12/4
  Time: 10:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<%@ taglib uri="http://www.bpk.com/html" prefix="json"%>
<html>
<head>
    <title></title>
    <jsp:include page="/metro.jsp"></jsp:include>
    <style>
        #proInfo {
            border-radius: 5px;
            display: none;
            position: absolute;
            top: 20%;
            left: 30%;
            width: 40%;
            height: 40%;
            padding: 10px 20px 20px 20px;
            border: 0px solid;
            background-color: #ffffff;
            z-index: 1002;
            overflow: auto;
            box-shadow: 2px 2px 10px #909090;
        }
    </style>
    <script>
        console.info("${products.totalPage}");
        function openTable(pid) {
            $.post("${path}/activity/loadProInfo",{"p_id":pid},function(result){
                if(result.code==10002){
                    $("#p_id").val(result.data.productId);
                    $("#p_name").val(result.data.name);
                    $("#p_price").val((result.data.price/100).toFixed(2));
                    $("#p_title").val(result.data.title);
                    $("#p_num").val(1);
                    $("#proInfo").show();
                }
            });
        }

        function closeTable(){
            $("#proInfo").hide();
        }

        function addActivityPros(){
            var title=$("#p_title").val();
            var p_id=$("#p_id").val();
            var act_price=$("#p_price").val()*100;
            var limit_num=$("#p_num").val();
            $.post("${path}/activity/addActivityPros",{"act_id":${sa_id},"title":title,"p_id":p_id,"act_price":act_price,"limit_num":limit_num},function(result){
                if(result.code==10002){
                    alert("添加成功");
                    $("#proInfo").hide();
                }
            });
        }

        function page(num){
            if(num<1){
                alert("已经是第一页");
                return;
            }
            if(num>${products.totalPage}){
                alert("已经是最后一页");
                return;
            }
            window.location.href="${path}/pageTo/toAddActPros?sa_id=${sa_id}&pg="+num;
        }
    </script>
</head>
<%@ include file="../common/top.jsp" %>
<body>
    <div class="box-content" id="proInfo">
        <div class="form-horizontal">
            <fieldset >
                <div class="control-group">
                    <label class="control-label">产品名字：</label>
                    <div class="controls">
                        <input style="display: none" id="p_id">
                        <input class="span5 " disabled id="p_name">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">活动价格：</label>
                    <div class="controls">
                        <input class="span5 " id="p_price" type="text"><p class="help-block red" >* 单位元</p>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">活动产品描述：</label>
                    <div class="controls">
                        <input class="span5 " id="p_title" type="text">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">活动产品限购数量：</label>
                    <div class="controls">
                        <input class="span5 " id="p_num" type="number"><p class="help-block red" >* 活动 产品数量 不能为0</p>
                    </div>
                </div>
                <div class="form-actions" >
                    <button class="btn btn-info" onclick="addActivityPros()">保存</button>
                    <button class="btn btn-danger" onclick="closeTable();">关闭</button>
                </div>
            </fieldset>
        </div>
    </div>

<div class="span10" id="content">
    <div class="row-fluid">
        <div class="span12 box">
            <div class="box-header">
                <h2 id="plat_name1"><i class="icon-align-justify"></i><span class="break"></span>添加活动产品</h2>

                <div class="box-icon">
                    <a href="${path}/pageTo/activityPros?sa_id=${sa_id}"    class="btn-add">
                        <i class="icon-edit" style="width:60px">返回</i>
                    </a>
                </div>
            </div>
            <div class="box-content" style="min-height: 800px ">
                <div class="table-responsive">

                    <table class="table table-bordered table-striped "
                                    style="font-size: 14px;font-style: normal">
                    <thead>
                    <tr>
                        <th width="40%">产品</th>
                        <th width="10%">产品图片</th>
                        <th>价格</th>
                        <th>分类</th>
                        <th>品牌</th>
                        <th>选择</th>
                    </tr>
                    </thead>
                    <tbody id="dateBody">
                    <c:forEach items="${products.list}" var="product" varStatus="loopStatus">
                        <c:choose>
                            <c:when test="${product.id==null}">
                               <div class="box-content">
                                    <h1 class="red ">该店暂无上货</h1>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td>${product.name}</td>
                                    <td><img src="${product.cover_img}" width="40px" height="40px">
                                    </td>
                                    <td>￥
                                        <fmt:parseNumber var="i" type="number" value="${product.price}" />
                                        <fmt:formatNumber value="${i/100}" maxFractionDigits="2" pattern="0.00"/>
                                    </td>
                                    <td>${product.p_type_name}</td>
                                    <td>${product.p_brand_name}</td>
                                    <td>
                                        <button class="btn btn-info" onclick="openTable(${product.id})">选择</button>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    </tbody>
                </table>

                </div>
                <div class="pagination pagination-centered">
                    <div class="bg">
                        <div class="r_page">
                            <li id="page">
                                第${products.pageNumber}/${products.totalPage}页 共${products.totalRow}条
                            </li>
                            <li><a onclick="page(1);">首页</a></li>
                            <li><a class="active" onclick="page('${products.pageNumber-1}')">上一页</a></li>
                            <li><a class="active" onclick="page('${products.pageNumber+1}')">下一页</a></li>
                            <li><a onclick="page('${products.totalPage}')">末页</a></li>
                            跳转到第
                            <input id="toPage" style="width:20px;ime-mode:disabled;" size="4">
                            页
                            <a class="label label-success"
                               onclick="page($(this).prev('input').val())">跳转</a>
                        </div>
                        <div class="clear"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="clearfix"></div>
<footer>
    <p>
        <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
    </p>
</footer>
</body>
</html>
