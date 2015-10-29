<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
  <script type="text/javascript" src="../public/js/jquery-1.10.2.min.js"></script>

</head>
<body>

<style type="text/css">
  *{margin:0; padding:0;}
  img{max-width: 100%; height: auto;}
  .test{height: 600px; max-width: 600px; font-size: 40px;}
</style>
<div class="test"><a href="http://mp.weixin.qq.com/mp/redirect?url=http://mobile.xinlianwang.com/android/distributor/DistributorApp.apk#weixin.qq.com#wechat_redirect ">有效跳转</a></div>
<script type="text/javascript" src="http://libs.useso.com/js/jquery/1.9.0/jquery.min.js"></script>

<script type="text/javascript">
  function is_weixin() {
    var ua = navigator.userAgent.toLowerCase();
    if (ua.match(/MicroMessenger/i) == "micromessenger") {
      return true;
    } else {
      return false;
    }
  }

  var isWeixin = is_weixin();
  var weixinTip = $('<div id="weixinTip"><p><img src="wx.png" alt="微信打开"/></p></div>');

  var userAgent = navigator.userAgent.toLowerCase();
  var ios = userAgent.match(/(iphone|ipod|ipad|wechat)/);
  var android=userAgent.match(/(android|wechat)/);

  if(android){
    if(isWeixin){
      $("body").append(weixinTip);
    }else{
      var path="http://7xk59r.com2.z0.glb.qiniucdn.com/KKWUBiz0827.apk";
      window.top.location.href=path;
    }

    $("#weixinTip").css({
      "position":"fixed",
      "left":"0",
      "top":"0",
      "height":5000,
      "width":"100%",
      "z-index":"1000",
      "background-color":"rgba(0,0,0,0.8)",
      "filter":"alpha(opacity=80)",
    });

    $("#weixinTip p").css({
      "text-align":"center",
      "margin-top":"10%",
      "padding-left":"5%",
      "padding-right":"5%"
    });

  }


  if(ios){
    if(isWeixin){
      $("body").append(weixinTip);
    }else{
      var path="http://www.pgyer.com/WCRq";
      window.top.location.href=path;
    }
    $("#weixinTip").css({
      "position":"fixed",
      "left":"0",
      "top":"0",
      "height":5000,
      "width":"100%",
      "z-index":"1000",
      "background-color":"rgba(0,0,0,0.8)",
      "filter":"alpha(opacity=80)",
    });

    $("#weixinTip p").css({
      "text-align":"center",
      "margin-top":"10%",
      "padding-left":"5%",
      "padding-right":"5%"
    });

  }
</script>

</body>
</html>
