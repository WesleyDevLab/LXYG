<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="/common/taglibs.jsp" %>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<!DOCTYPE HTML>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <jsp:include page="/metro.jsp"></jsp:include>
</head>
<body>
<%@ include file="common/top.jsp"%>
<!-- start: Content -->
<div id="content" class="span10"></div>
<!-- end: Content -->

</div>
<!--/fluid-row-->

<div class="clearfix"></div>

<%@include file="/common/bottom.jsp" %>

</div>
</body>
</html>