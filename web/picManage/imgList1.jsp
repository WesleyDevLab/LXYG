<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>jquery五幅焦点图片特效</title>
<script src="http://www.codefans.net/ajaxjs/jquery-1.7.2.min.js" type="text/javascript"></script>
<style> 
*{margin:0;padding:0;border:none}
body{background:#CCCCCC;padding:20px}
.com{width:490px;height:170px;overflow:hidden;position:relative;background:black}
.com ul{width:3000px;font-size:0;}
.com ul li{vertical-align:bottom;height:100%;overflow:hidden;float:left;background:white url(/jscss/demoimg/201307/loading.gif) no-repeat center center;vertical-align:bottom;list-style:none;overflow:hidden}
.com ol{position:absolute;right:0;bottom:20px;;z-index:10;list-style:none;height:21px}
.com ol li{width:15px;background:white;border:1px solid #74A8ED;border-radius:10px;color:#74A8ED;cursor:pointer;float:left;font:12px Arial;height:15px;margin:2px 3px;text-align:center;}
.com ol li.on{height:19px;width:19px;background:#74A8ED;border:1px solid #EEEEEE;color:#FFFFFF;font-size:16px;font-weight:bold;line-height:19px;margin:0 3px;}
</style>
</head>
<body>
<div id="ppt" class="com">
			<ul>
				<li><a href="#"><img src="/jscss/demoimg/201307/1.png"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/3.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/4.jpg"></a></li>
			</ul>
</div>
<hr/>
<div id="ppt5" class="com">
			<ul>
				<li><a href="#"><img src="/jscss/demoimg/201307/1.png"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/3.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/4.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
			</ul>
</div>
 
 
<hr/>
<div id="ppt4" class="com">
			<ul>
				<li><a href="#"><img src="/jscss/demoimg/201307/1.png"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/3.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/4.jpg"></a></li>
			
			</ul>
</div>
<hr/>
<div id="ppt2" class="com">
			<ul>
				<li><a href="#"><img src="/jscss/demoimg/201307/1.png"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/3.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/4.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
			</ul>
</div><hr/>
<div id="ppt3" class="com">
			<ul>
				<li><a href="#"><img src="/jscss/demoimg/201307/1.png"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/2.gif"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/3.jpg"></a></li>
				<li><a href="#"><img src="/jscss/demoimg/201307/4.jpg"></a></li>
				
			</ul>
</div><hr/> 
</body>
<script> 
(function(e){function t(e,t){this.$ele=t,this.set=e,this.WH=this.set.vertical?t.height():t.width(),this.lis=t.find("ul li"),this.idx=0,this.timer=null}e.fn.myPic=function(n){return e.fn.myPic.defaults={vertical:!1,button:!0,auto:!0,effect:"scroll",onMouse:"mouseover"},this.each(function(){var r=n?e.extend(e.fn.myPic.defaults,n):e.fn.myPic.defaults,i=new t(r,e(this));r.button&&i.generate(e(this)),r.auto&&i.auto()}),this},t.prototype={generate:function(t){var n=e("<ol></ol>").appendTo(t),r=this;e.each(this.lis,function(t,r){e("<li>"+(t+1)+"</li>").appendTo(n)}),this.olis=t.find("ol li"),this.olis.eq(0).attr("class","on");switch(this.set.effect){case"scroll":t.find("ul").css({position:"absolute",left:0,top:0}),this.set.vertical&&this.lis.css({"float":"none"});break;case"flip":case"fade":this.lis.css({position:"absolute",left:0,top:0,"float":"none"}).eq(0).css("zIndex","2");break;case"in":this.lis.css({display:"none"}).eq(0).css("display","block");break;default:}t.delegate("ol li",this.set.onMouse,function(){var $this=e(this);setTimeout(function(){r.start($this.index())},300),r.stop()}).delegate("ol li","mouseout",function(){r.auto()})},start:function(e){this.idx=e,this.idx!=this.from&&(this.effect(this),this.reset())},effect:function(t){var n=t.idx,r={};switch(t.set.effect){case"scroll":r[t.set.vertical?"top":"left"]=-(n*this.WH),this.$ele.find("ul").stop(!0,!0).animate(r),r=null;break;case"flip":this.lis.eq(n).css("zIndex",1),this.lis.eq(this.from||0).stop(!0,!0).css("opacity",.8).animate({left:-100,opacity:0},600,function(){e(this).css({zIndex:0,opacity:1,left:0}),t.lis.eq(n).css("zIndex","2")});break;case"fade":this.lis.eq(n).css("zIndex","1"),this.lis.eq(this.from||0).stop(!0,!0).fadeOut(500,function(){e(this).css({zIndex:0,display:"block"}),t.lis.eq(n).css("zIndex","2")});break;case"in":this.lis.eq(this.from||0).stop(!0,!0).fadeOut(400,function(){t.lis.eq(n).stop(!0,!0).fadeIn(700)});default:}},reset:function(){this.olis.eq(this.from||0).attr("class",""),this.olis.eq(this.idx).attr("class","on"),this.from=this.idx||0},stop:function(){var e=this;clearInterval(e.timer)},auto:function(){var e=this,t=this.lis.length;this.timer=setInterval(function(){e.idx=e.idx>=t-1?0:++e.idx,e.start(e.idx)},3e3)}}})(jQuery);
$('#ppt').myPic({
	vertical:true
	
});
$('#ppt2').myPic({
	effect:"in"
});
$('#ppt3').myPic({
	effect:"fade"
});
$('#ppt4').myPic({
	effect:"flip"
});
$('#ppt5').myPic(); 
</script>
</html>