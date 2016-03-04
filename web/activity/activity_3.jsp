<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>

<head>
    <title>三八妇女节活动</title>
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0;" name="viewport" />
    <link href="<%=basePath%>public/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="<%=basePath%>public/js/jquery-1.10.2.min.js"></script>
    <script src="<%=basePath%>public/js/bootstrap.min.js"></script>
</head>
<body>
<img src="<%=basePath%>/activity/act_3.jpg" alt="..." class="img-thumbnail">
</body>
</html>
