<%--
  Created by IntelliJ IDEA.
  User: 秦帅
  Date: 2015/11/26
  Time: 16:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<html>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
  <link rel="stylesheet" href="bootstrap.min.css">
  <link rel="stylesheet" href="join_us.css">
  <script type="text/javascript" src="jquery-2.1.4.min.js"></script>
  <script type="text/javascript" src="bootstrap.min.js"></script>
  <title>蜂趣·智能社区</title>
</head>
<body>
<script>
  function upload(){
    console.info("${path}");
    var name=$("#name").val();
    var phone=$("#phone").val();
    var area=$("#area").val();
    var address=area+$("#address").val();
    $.post("${path}/LXYG/pageTo/addInfo",{'name':name,'phone':phone,"address":address},function(e){
      console.info(e);
    });
  }
</script>
<section id="home"></section>

<section id="form">
  <div class="container">
    <div class="row">
      <div class="col-md-12 col-sm-12">
        <h4>通过APP,在小区里租一个仓库</h4>
        <h4>开一家虚拟便利店，为小区居民提供私人生活助理服务</h4>
      </div>
    </div>
    <div class="row">
      <div class="col-md-12 col-sm-12">
        <form>
          <input type="text" class="form-control" placeholder="姓名" name="name" id="name">
          <input type="tel" class="form-control" placeholder="电话" name="phone" id="phone">
          <input type="text" class="form-control" placeholder="省/市/区" name="area" id="area">
          <input type="text" class="form-control" placeholder="具体地址" name="address" id="address">
          <input type="button" onclick="upload()"  class="form-control" value="提交">
        </form>
      </div>
    </div>
  </div>
</section>

</body>
</html>
