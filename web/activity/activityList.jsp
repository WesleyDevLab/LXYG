<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>

<html lang="en">
<head>
    <title>店面活动产品列表</title>
    <jsp:include page="/metro.jsp"></jsp:include>
</head>
<%@ include file="../common/top.jsp"%>
<script>
    var curPage;
    var totalPage;
    var totalRows;
    function init(){
        var activities;
        var shops;
        var actinnerHtml='<option value="0">所有活动</option>';
        var sinnerHtml="";
        $.post("${path}/activity/searchInfo",function(result){
            if(result.code==10002){
                activities=result.activities;
                shops=result.shops;
                for(var i=0;i<activities.length;i++){
                    actinnerHtml+='<option value='+activities[i].id+' >'+activities[i].name+'</option>';
                }
                for(var j=0;j<shops.length;j++){
                    sinnerHtml+='<option value='+shops[j].id+' >'+shops[j].name+'</option>';
                }
                $("#act").append(actinnerHtml);
                $("#shops").append(sinnerHtml);
            }
        });
    }

    function loadActPros(pg){
        var act_id=$("#act").val();
        var shopId=$("#shops").val();
        var innerHtml="";
        $("#dateBody").html(innerHtml);
        $("#page").html("");
        $.post("${path}/activity/loadActivity",{"shop_id":shopId,"activity_id":act_id,"pg":pg},function(result){
            if(result.code=10002){
                if(result.data.list.length==0){
                    alert("该店暂无添加活动");
                    return;
                }
                curPage=result.data.pageNumber;
                totalPage=result.data.totalPage;
                totalRows=result.data.totalRow;
                for(var i=0;i<result.data.list.length;i++){
                    var obj=result.data.list[i];
                    if(obj.activity_type!=5&&obj.activity_type!=7){
                        innerHtml+="<tr><th>"+obj.sname+"</th>"+
                                "<th>"+obj.label_cn+"</th>"+
                                "<th>"+obj.aname+"</th>"+
                                "<th>"+obj.start_time+"</th>"+
                                "<th>"+obj.end_time+"</th>"+
                                "<th>"+obj.limit_num+"</th>"+
                                "<th><button class='btn btn-info' onclick='checkPros("+obj.id+")'>活动产品</button> <button class='btn btn-danger' onclick='delActivity("+obj.id+");'>删除</button></th></tr>"
                    }else{
                        innerHtml+="<tr><th>"+obj.sname+"</th>"+
                                "<th>"+obj.label_cn+"</th>"+
                                "<th>"+obj.aname+"</th>"+
                                "<th>"+obj.start_time+"</th>"+
                                "<th>"+obj.end_time+"</th>"+
                                "<th>"+obj.limit_num+"</th>"+
                                "<th><button class='btn btn-danger'  onclick='delActivity("+obj.id+");'>删除</button></th></tr>"
                    }
                }
                $("#dateBody").append(innerHtml);
                $("#page").append("第"+curPage+"/"+totalPage+"页    共"+totalRows+"条");
            }
        });
    }
    function checkPros(sa_id){
        window.location.href="${path}/pageTo/activityPros?sa_id="+sa_id;
    }

    function page(temp){
        if(temp==1){
            curPage=1
        }

        if(temp==2){
            if(curPage<=1){
                alert("已经是第一页");
                return;
            }
            curPage=curPage-1;
        }
        if(temp=3){
            if(curPage=totalPage){
                alert("已经是最后一页");
                return;
            }
            curPage=curPage-1;
        }
        if(temp=4){
            curPage=totalPage;
        }
        loadActPros(curPage);
    }
    function addActPros(){
        var shopId=$("#shops").val();
        window.location.href="${path}/pageTo/toAddAct?shop_id="+shopId;
    }
    function delActivity(act_id){
        if(confirm("是否确认要删除该活动？")){
            $.post("${path}/activity/delActivity",{"act_id":act_id},function(result){
                if(result.code==10002){
                    alert("删除成功");
                    loadActPros(curPage);
                }
            });
        }
    }
</script>
<body onload="init()">
<div id="content" class="span10">
    <div class="row-fluid">
        <div class="span12 box">
            <div class="box-header">
                <h2 id="plat_name1"><i class="icon-align-justify"></i><span class="break"></span>活动产品管理</h2>
                <div class="box-icon">
                    <c:if test="${viewKey!=3 }">
                        <a href="javascript:void(0)" onclick="addActPros()" class="btn-add">
                            <i class="icon-edit" style="width:60px">添加</i>
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="box-content" style="min-height: 800px ">
                <div style="margin:10px 0;" class="form-inline">
                    <div class="form-group">
                        <button type="button"  class="btn btn-primary" id="plat_name" >乐享云购活动产品管理</button>

                        <select class="form-control" id="act" >

                        </select>

                        <select class="form-control" id="shops">

                        </select>
                       <button style="margin-left: 5px" type="button" onclick="loadActPros()"  class="btn btn-primary">搜索</button>
                     </div>
                </div>
                <table class="table table-bordered table-striped table-condensed" style="font-size: 14px;font-style: normal">
                    <thead>
                        <tr>
                            <th>店名</th>
                            <th>活动主题</th>
                            <th>活动类型</th>
                            <th>开始时间</th>
                            <th>结束时间</th>
                            <th>限购数量</th>
                            <th>操作</th>
                        </tr>
                    </thead>
                    <tbody id="dateBody">

                    </tbody>
                </table>
                <div class="pagination pagination-centered">
                    <div class="bg">
                        <div class="r_page">
                            <li id="page">
                            </li>
                            <li><a onclick="page(1)">首页</a></li>
                            <li><a class="active" onclick="page(2)">上一页</a></li>
                            <li><a class="active"  onclick="page(3)">下一页</a></li>
                            <li><a onclick="page(4)">末页</a></li>
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
</div>

<div class="clearfix"></div>
<footer>
    <p>
        <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
    </p>

</footer>


</body>
</html>
