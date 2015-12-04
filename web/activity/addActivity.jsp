<%--
  Created by IntelliJ IDEA.
  User: 秦帅
  Date: 2015/12/2
  Time: 17:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<html lang="en">
<head>
    <title>添加店面活动</title>
  <script type="text/javascript" src="${path }/public/js/My97DatePicker/WdatePicker.js"></script>
  <jsp:include page="/metro.jsp"></jsp:include>
</head>
<%@ include file="../common/top.jsp"%>
<script>

  function init(){
    var activities;
    var shops;
    var actinnerHtml='<option value=0> 选择活动</option>';
    var sinnerHtml="<option value=0> 选择店</option>";
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

  function addActivity(){
    var act_id=$("#act").val();
    var shopId=$("#shops").val();
    var title=$("#title").val();
    var start_time=$("#fromTime").val();
    var end_time=$("#endTime").val();
    var limit=$("#limit_e").val();
    if(act_id==0||shopId==0){
      alert("请选择店或活动");
      return;
    }
    if(title==null||title==""){
      alert("填写主题");
      return;
    }
    if(start_time==""||end_time==""){
      alert("填写开始与结束时间");
      return;
    }
    $.post("${path}/activity/addActivity",{"shop_id":shopId,"act_id":act_id,"title":title,
      "start_time":start_time,"end_time":end_time,"limit":limit},function(result){
      console.info(result);
      if(result.code==10002){
        window.location.href="${path}/pageTo/toAddActPros?sa_id="+result.activity.id;
      }
    });
  }


</script>
<body onload="init()">
<div class="span10" id="content">
  <div class="row-fluid">
    <div class="span12 box">
      <div class="box-header">
        <h2 id="plat_name1">活动产品添加</h2>
      </div>
      <div class="box-content" style="min-height: 800px">
        <form class="form-horizontal"  action="${path}/activity/addActivity">
          <fieldset>
            <div class="control-group">
            <label class="control-label">店铺：</label>
            <div class="controls">
              <select id="shops" name="shop_id"></select>
            </div>
          </div>
            <div class="control-group">
              <label class="control-label">活动：</label>
              <div class="controls">
                <select id="act" name="act_id"></select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">活动主题：</label>
              <div class="controls">
               <input type="text" class="span6 typeahead" id="title" name="title">
              </div>
            </div>

            <div class="control-group">
              <label class="control-label">活动时间：</label>
              <div class="controls">
                <input type="text" style="margin-bottom: -2px;width:170px;height: 30px" class="input-xlarge Wdate" id="fromTime" name="start_time"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />-
                <input type="text" style="margin-bottom: -2px;width:170px;height: 30px" class="input-xlarge Wdate" id="endTime" name="end_time"  onfocus="WdatePicker({dateFmt:'yyyy-MM-dd'})" />
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">限制购买数量：</label>
              <div class="controls">
                <input type="text" class="span2 typeahead" id="limit_e" name="limit">
                <p class="help-block" style="color:red">* 不限制  填写0</p>
              </div>
            </div>

            <div class="form-actions">
              <input type="button" value="保存" class="btn btn-primary"  onclick="addActivity()"/>
              <input type="reset" class="btn" value="重置" />
            </div>
          </fieldset>
        </form>

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
