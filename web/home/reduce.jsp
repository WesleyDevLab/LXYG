<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<html>
<head>
    <title>满减风暴来袭</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1,user-scalable=no">
    <link rel="stylesheet" href="${path}/LXYG/join_us/bootstrap.min.css">
    <link rel="stylesheet" href="${path}/LXYG/home/reduce.css">
    <script type="text/javascript" src="${path}/LXYG/join_us/jquery-2.1.4.min.js"></script>
    <script type="text/javascript" src="${path}/LXYG/join_us/bootstrap.min.js"></script>

</head>

<body>
<div id="home">

</div>

<section id="form">
    <div class="container">
        <div class="row">
            <div class="col-md-12 col-sm-12">
                <h1 style="color: red">蜂域智能社区  优惠风暴</h1>
                <h3>购物满28元减1元</h3>
                <h3>购物满48元减2元</h3>
                <h3>购物满68元减3元</h3>
                <h3>购物满88元减4元</h3>
                <h3>购物满98元减5元</h3>
                <h2 style="color: red">买的越多减的越多</h2>
                <h4 style="color: cornflowerblue">还有更多优惠来袭</h4>
            </div>
        </div>
    </div>
</section>
</body>
</html>
