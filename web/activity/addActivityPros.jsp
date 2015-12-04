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
        function openTable(Goods) {
            console.info(Goods);
            console.info(Goods.id);
            var str1=product.substring(product.indexOf("{"),product.length);
            var str= JSON.stringify(str1.name);
            console.info(str);
            var str= $.parseJSON(str1);

//           console.info(str);
//            $("#p_name").val(product.NAME);
//            $("#p_price").val(product.price);
//            $("#p_title").val(product.title);
//            $("#p_num").val(0);
//
//            $("#proInfo").show();
        }

        function closeTable(){
            $("#proInfo").hide();
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
                        <input class="span5 " disabled id="p_name">
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">活动价格：</label>
                    <div class="controls">
                        <input class="span5 " id="p_price" type="text">
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
                        <input class="span5 " id="p_num" type="number">
                    </div>
                </div>

                <div class="form-actions" >
                    <button class="btn btn-info" onclick="">保存</button>
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
                            <tr>
                                <td>${product.NAME}</td>
                                <td><img src="${product.cover_img}" width="40px" height="40px">

                                </td>
                                <td>￥ ${product.price} </td>
                                <td>${product.p_type_name}</td>
                                <td>${product.p_brand_name}</td>
                                <td>
                                    <button class="btn btn-info" onclick="openTable('<json:json goods="${product}"/>') ">选择</button>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>

                </div>


                <div class="pagination pagination-centered">
                    <div class="bg">
                        <div class="r_page">
                            <li id="page">
                            </li>
                            <li><a onclick="page(1)">首页</a></li>
                            <li><a class="active" onclick="page(2)">上一页</a></li>
                            <li><a class="active" onclick="page(3)">下一页</a></li>
                            <li><a onclick="page(4)">末页</a></li>
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
