<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2015/8/24
  Time: 17:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
</head>
<body>
<style type="text/css">
    *{margin:0; padding:0;}
    img{max-width: 100%; height: auto;}
    .test{height: 600px; max-width: 600px; font-size: 40px;}
</style>
<div class="test">
    <a href="">乐享云购下载</a>
</div>

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
    var winHeight = typeof window.innerHeight != 'undefined' ? window.innerHeight : document.documentElement.clientHeight;
    function loadHtml(){
        var div = document.createElement('div');
        div.id = 'weixin-tip';
        div.innerHTML = '<p><img src="wx.png" alt="微信打开"/></p>';
        document.body.appendChild(div);
    }

    function loadStyleText(cssText) {
        var style = document.createElement('style');
        style.rel = 'stylesheet';
        style.type = 'text/css';
        try {
            style.appendChild(document.createTextNode(cssText));
        } catch (e) {
            style.styleSheet.cssText = cssText; //ie9以下
        }
        var head=document.getElementsByTagName("head")[0]; //head标签之间加上style样式
        head.appendChild(style);
    }
    var cssText = "#weixin-tip{position: fixed; left:0; top:0; background: rgba(0,0,0,0.8); filter:alpha(opacity=80); width: 100%; height:100%; z-index: 100;} #weixin-tip p{text-align: center; margin-top: 10%; padding:0 5%;}";

    var userAgent = navigator.userAgent.toLowerCase();
    var ios = userAgent.match(/(iphone|ipod|ipad|wechat)/);
    var android=userAgent.match(/(android|wechat)/);
    if(android){
        if(isWeixin){
            loadHtml();
            loadStyleText(cssText);
        }
        var path="http://7xk59r.com2.z0.glb.qiniucdn.com/KKWUBiz081903.apk";
        window.top.location.href=path;
    }
    if(ios){
        if(isWeixin){
            loadHtml();
            loadStyleText(cssText);
        }
        var path="http://www.pgyer.com/WCRq";
        window.top.location.href=path;
    }

</script>
</body>
</html>
