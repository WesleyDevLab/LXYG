<%@ page language="java" import="java.util.* " pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>产品展示效果</title>
<link href="${path }/public/css/tbPic.css" type="text/css" rel="stylesheet">	
<script src="${path }/public/js/query/jquery.js" type=text/javascript></script>
<script src="${path }/public/js/tbPic/base.js" type=text/javascript></script>
</head>

<body style="text-align:center"> 
<div id="preview">
	<div class="jqzoom" id="spec-n1" >
	<c:forEach items="${pageBean.list }" var="bigImg" end="0">
		<img height=350 src="${imgPath }${bigImg.img_url}" jqimg="${imgPath }${bigImg.img_url}" width=350>
	</c:forEach>
	</div>
	<div id="spec-n5">
		<div class="control" id="spec-left">
			<img src="${path }/public/images/left.gif" />
		</div>
		<div id="spec-list">
			<ul class="list-h">
				<c:forEach items="${pageBean.list }" var="img">
					<li><img src="${imgPath }${img.img_url}"></li>
				</c:forEach>
			</ul>
		</div>
		<div class="control" id="spec-right">
			<img src="${path }/public/images/right.gif" />
		</div>		
    </div>
</div>
<div id="download">
	<c:forEach items="${pageBean.list }" var="img" varStatus="st">
		<li><a href="${path}/upload/download?url=${imgPath }${img.img_url}">文件下载${ st.index}</a></li>
	</c:forEach>
		<li><a href="http://127.0.0.1:8018/yuzhou/Doc/20140711172720653t01a1376825d5a757d9.doc">文件下载${ st.index}</a></li>
</div>
<script type="text/javascript">
	$(function(){			
	   $(".jqzoom").jqueryzoom({
			xzoom:400,
			yzoom:400,
			offset:10,
			position:"right",
			preload:1,
			lens:1
		});
		$("#spec-list").jdMarquee({
			deriction:"left",
			width:350,
			height:56,
			step:2,
			speed:4,
			delay:10,
			control:true,
			_front:"#spec-right",
			_back:"#spec-left"
		});
		$("#spec-list img").bind("mouseover",function(){
			var src=$(this).attr("src");
			$("#spec-n1 img").eq(0).attr({
				src:src.replace("\/n5\/","\/n1\/"),
				jqimg:src.replace("\/n5\/","\/n0\/")
			});
			$(this).css({
				"border":"2px solid #ff6600",
				"padding":"1px"
			});
		}).bind("mouseout",function(){
			$(this).css({
				"border":"1px solid #ccc",
				"padding":"2px"
			});
		});				
	});
	</script>
<script src="${path }/public/js/tbPic/lib.js" type=text/javascript></script>
<script src="${path }/public/js/tbPic/163css.js" type=text/javascript></script> 

</body>
</html>