<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!-- start: Meta -->
<meta charset="utf-8" />
<title>乐享云购后台管理系统</title>
<meta name="description" content="乐享云购后台管理系统" />
<meta name="author" content="乐享云购后台管理系统" />
<meta name="keyword" content="乐享云购后台管理系统" />
<!-- end: Meta -->
<!-- start: Mobile Specific -->
<meta name="viewport" content="width=device-width, initial-scale=1" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- end: Mobile Specific -->

<!-- start: CSS -->
<link href="<%=basePath%>public/css/bootstrap.min.css" rel="stylesheet" />
<link href="<%=basePath%>public/css/bootstrap-responsive.min.css" rel="stylesheet" />
<link href="<%=basePath%>public/css/style.min.css" rel="stylesheet" />
<link href="<%=basePath%>public/css/style-responsive.min.css" rel="stylesheet" />
<link href="<%=basePath%>public/css/retina.css" rel="stylesheet" />
<!-- end: CSS -->
<!-- The HTML5 shim, for IE6-8 support of HTML5 elements -->


<!-- start: Favicon and Touch Icons -->
<link rel="apple-touch-icon-precomposed" sizes="144x144" href="<%=basePath%>public/ico/apple-touch-icon-144-precomposed.png" />
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="<%=basePath%>public/ico/apple-touch-icon-114-precomposed.png" />
<link rel="apple-touch-icon-precomposed" sizes="72x72" href="<%=basePath%>public/ico/apple-touch-icon-72-precomposed.png" />
<link rel="apple-touch-icon-precomposed" href="<%=basePath%>public/ico/apple-touch-icon-57-precomposed.png" />
<link rel="shortcut icon" href="<%=basePath%>public/ico/favicon.png" />
<!-- end: Favicon and Touch Icons -->
<!-- start: JavaScript-->
<script src="<%=basePath%>public/js/jquery-1.10.2.min.js"></script>
<script src="<%=basePath%>public/js/jquery-migrate-1.2.1.min.js"></script>
<script src="<%=basePath%>public/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="<%=basePath%>public/js/jquery.ui.touch-punch.js"></script>
<script src="<%=basePath%>public/js/modernizr.js"></script>
<script src="<%=basePath%>public/js/bootstrap.min.js"></script>
<script src="<%=basePath%>public/js/jquery.cookie.js"></script>
<script src='<%=basePath%>public/js/fullcalendar.min.js'></script>
<script src='<%=basePath%>public/js/jquery.dataTables.min.js'></script>
<script src="<%=basePath%>public/js/excanvas.js"></script>
<script src="<%=basePath%>public/js/jquery.flot.js"></script>
<script src="<%=basePath%>public/js/jquery.flot.pie.js"></script>
<script src="<%=basePath%>public/js/jquery.flot.stack.js"></script>
<script src="<%=basePath%>public/js/jquery.flot.resize.min.js"></script>
<script src="<%=basePath%>public/js/jquery.flot.time.js"></script>

<script src="<%=basePath%>public/js/jquery.chosen.min.js"></script>
<script src="<%=basePath%>public/js/jquery.uniform.min.js"></script>
<script src="<%=basePath%>public/js/jquery.cleditor.min.js"></script>
<script src="<%=basePath%>public/js/jquery.noty.js"></script>
<script src="<%=basePath%>public/js/jquery.elfinder.min.js"></script>
<script src="<%=basePath%>public/js/jquery.raty.min.js"></script>
<script src="<%=basePath%>public/js/jquery.iphone.toggle.js"></script>
<script src="<%=basePath%>public/js/jquery.uploadify-3.1.min.js"></script>
<script src="<%=basePath%>public/js/jquery.gritter.min.js"></script>
<script src="<%=basePath%>public/js/jquery.imagesloaded.js"></script>
<script src="<%=basePath%>public/js/jquery.masonry.min.js"></script>
<script src="<%=basePath%>public/js/jquery.knob.modified.js"></script>
<script src="<%=basePath%>public/js/jquery.sparkline.min.js"></script>
<script src="<%=basePath%>public/js/counter.min.js"></script>
<script src="<%=basePath%>public/js/raphael.2.1.0.min.js"></script>
<script src="<%=basePath%>public/js/justgage.1.0.1.min.js"></script>
<script src="<%=basePath%>public/js/jquery.autosize.min.js"></script>
<script src="<%=basePath%>public/js/retina.js"></script>
<script src="<%=basePath%>public/js/jquery.placeholder.min.js"></script>
<script src="<%=basePath%>public/js/wizard.min.js"></script>
<script src="<%=basePath%>public/js/core.min.js"></script>
<script src="<%=basePath%>public/js/charts.min.js"></script>
<script src="<%=basePath%>public/js/custom.min.js"></script>
<script src="<%=basePath%>public/js/jquery.form.js"></script>
<script type="text/javascript" src="<%=basePath%>public/js/artDialog.js?skin=blue"></script>
<script type="text/javascript" src="<%=basePath%>public/js/iframeTools.js"></script>
<link href="<%=basePath%>public/css/right.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="<%=basePath%>public/js/page.js"></script>
<!-- end: JavaScript-->
