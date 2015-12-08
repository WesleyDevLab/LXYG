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
<%@ taglib uri="http://www.bpk.com/html" prefix="json" %>
<html>
<head>
    <title></title>
    <jsp:include page="/metro.jsp"></jsp:include>
    <script type="text/javascript" src="${path}/upYun/lib/async.js"></script>
    <script type="text/javascript" src="${path}/upYun/lib/spark-md5.js"></script>
    <script type="text/javascript" src="${path}/upYun/lib/upyun-mu.js"></script>
    <script type="text/javascript" src="${path}/upYun/lib/uuid.js"></script>
    <style>
        #proInfo {
            border-radius: 5px;
            display: none;
            position: absolute;
            top: 20%;
            left: 30%;
            width: 40%;
            height: 60%;
            padding: 10px 20px 20px 20px;
            border: 0px solid;
            background-color: #ffffff;
            z-index: 1002;
            overflow: auto;
            box-shadow: 2px 2px 10px #909090;
        }
    </style>
    <script>
        var imgCover="";
        function openTable(ap_id){
            $.post("${path}/activity/aProduct",{"ap_id":ap_id},function(result){
                console.info(result.data);
                if(result.code==10002){
                    $("#p_id").val(ap_id);
                    $("#p_name").val(result.data.name);
                    $("#p_type_name").val(result.data.p_type_name);
                    $("#p_brand_name").val(result.data.p_brand_name);
                    $("#p_price").val((result.data.price/100).toFixed(2));
                    $("#p_title").val(result.data.title);
                    $("#p_num").val(1);
                    $("#img").append("<img src="+result.data.cover_img+" width=100px height=100px>");
                    $("#proInfo").show();
                    imgCover=result.data.cover_img;
                }
            });
        }
        function closeTable(){
            $("#proInfo").hide();
        }

        function showImg(type){
            $("#img").html("");
            if(type==1){
                var files=document.getElementById('coverFile').files;
                console.info(files);
                for(var i=0;i<files.length;i++){
                    var file=files[i];
                    var fileReader=new FileReader();
                    fileReader.onloadend=function(e){
                        $("#img").append('<img width="100px" height="100px"  src='+e.target.result+'></img>')
                    }
                    fileReader.readAsDataURL(file);
                }
                imgCover=selectFile(files)[0];
            }
            if(type==2){
                var files=document.getElementById('coverFiles').files;
                for(var i=0;i<files.length;i++){
                    var file=files[i];
                    var fileReader=new FileReader();
                    fileReader.onloadend=function(e){
                        $("#img").append('<img width="100px" height="100px"  src='+e.target.result+'></img>')
                    }
                    fileReader.readAsDataURL(file);
                }
                imgs=selectFile(files);
            }
        }

        function selectFile(files){
            var img_urls=new Array();
            for(var i=0;i<files.length;i++){
                var ext = '.' +files[i].name.split('.').pop();
                var path='/platform/' + Math.uuid(16,"")+ext;
                uploadImg(path,files[i])
                img_urls[i]="http://lxyg8.b0.upaiyun.com"+path;
            }
            return img_urls;
        }

        function uploadImg(path,file){
            var config={
                bucket:'lxyg8',
                expiration: parseInt((new Date().getTime() + 3600000) / 1000),
                form_api_secret: 'Jcrn4om4KRTt6FTvMb04r72P4XU='
            };
            var instance=new Sand(config);
            var options = {
                'notify_url': 'http://upyun.com'
            };
            instance.setOptions(options);
            instance.upload(path,file);
        };
        function updatePro() {
           if(confirm("确定要修改嘛？")){
               var postData={
                   "ap_id":$("#p_id").val(),
                   "title":$("#p_title").val(),
                   "price":$("#p_price").val()*100,
                   "ap_num":$("#p_num").val(),
                   "ap_cover":imgCover
               }
               $.post("${path}/activity/updatePro",postData,function(result){
                   if(result.code==10002){
                       alert("修改成功");
                       location.reload();
                   }
               })
           }
        }
        function delPro(ap_id) {
            if(confirm("确定要删出嘛？")){
                $.post("${path}/activity/delAPro",{"ap_id":ap_id},function(result){

                });
            }
        }
        function page(num){
            if(num<1){
                alert("已经是第一页了");
                return;
            }
            if(num>${products.totalPage}){
                alert("已经是最后一页了");
                return;
            }
            window.location.href="${path}/pageTo/activityPros?sa_id=${sa_id}&pg="+num;
        }

    </script>
</head>
<%@ include file="../common/top.jsp" %>
<body>

<div class="box-content" id="proInfo">
    <div class="form-horizontal" style="margin-left: 20px;margin-top:20px ">
        <fieldset >
            <div class="control-group">
                <label class="control-label">产品名字：</label>
                <div class="controls">
                    <input style="display: none" id="p_id">
                    <input class="span5 " disabled id="p_name">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">产品分类：</label>
                <div class="controls">
                    <input class="span5 " disabled id="p_type_name">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">产品品牌：</label>
                <div class="controls">
                    <input class="span5 " disabled id="p_brand_name">
                </div>
            </div>


            <div class="control-group">
                <label class="control-label">活动产品描述：</label>
                <div class="controls">
                    <input class="span5 " id="p_title" type="text">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">活动产品价格：</label>
                <div class="controls">
                    <input class="span5 " id="p_price" type="text">
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">活动产品限购数量：</label>
                <div class="controls">
                    <input class="span5 " id="p_num" type="number"><p class="help-block red" >* 活动 产品数量 不能为0</p>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">产品图片：</label>
                <input id="coverFile" name="file"  type="file" onchange="showImg(1)" /><p class="help-block red" >* 产品图仅限一张</p><br/>
                <div class="controls" id="img">
                </div>
            </div>

            <div class="form-actions">
                <button class="btn btn-info" onclick="updatePro()">保存</button>
                <button class="btn btn-danger" onclick="closeTable();">关闭</button>
            </div>
        </fieldset>
    </div>
</div>

<div class="span10" id="content">
    <div class="row-fluid">
        <div class="span12 box">
            <div class="box-header">
                <h2 id="plat_name1"><i class="icon-align-justify"></i><span class="break"></span>活动产品列表</h2>

                <div class="box-icon">
                    <a href="javascript:void(0)"
                       onclick="javascript:window.location.href='${path}/pageTo/toAddActPros?sa_id=${sa_id}'"
                       class="btn-add">
                        <i class="icon-edit" style="width:120px">添加活动产品</i>
                    </a>
                </div>
            </div>
            <div class="box-content" style="min-height: 800px ">
                <div class="table-responsive">
                    <table class="table table-bordered table-striped "
                           style="font-size: 14px;font-style: normal">
                        <thead>
                        <tr>
                            <th>产品</th>
                            <th>产品图片</th>
                            <th>产品标题</th>
                            <th>活动价格</th>
                            <th>类别</th>
                            <th>品牌</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody id="dateBody">
                        <c:forEach items="${products.list}" var="product" varStatus="loopStatus">
                            <tr>
                                <td>${product.name}</td>
                                <td><img src="${product.cover_img}" width="40px" height="40px"></td>
                                <td>${product.title}
                                </td>
                                <td>￥
                                    <fmt:parseNumber var="i" type="number" value="${product.price}"/>
                                    <fmt:formatNumber value="${i/100}" maxFractionDigits="2" pattern="0.00"/>
                                </td>
                                <td>${product.p_type_name}</td>
                                <td>${product.p_brand_name}</td>
                                <td>
                                    <button class="btn btn-info" onclick="openTable('${product.id}');">修改</button>
                                    <button class="btn btn-danger" onclick="delPro();">删除</button>
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
                                第${products.pageNumber}/${products.totalPage}页 共${products.totalRow}条
                            </li>
                            <li><a onclick="page(1)">首页</a></li>
                            <li><a class="active" onclick="page('${products.pageNumber-1}')">上一页</a></li>
                            <li><a class="active" onclick="page('${products.pageNumber+1}')">下一页</a></li>
                            <li><a onclick="page('${products.totalPage}')">末页</a></li>
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
