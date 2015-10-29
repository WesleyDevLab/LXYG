<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglibs.jsp" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<html>
<head>
    <meta charset="UTF-8">
    <meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" name="viewport">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-status-bar-style" content="black-translucent">
    <meta name="format-detection" content="telephone=no" />
    <meta name="format-detection" content="email=no" />
    <title>乐享云购</title>
    <link rel="stylesheet" href="jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.css">
    <link rel='icon' href='img/zzz.gif' type=‘image/x-ico’/>
    <script src="js/jquery-2.1.4.min.js"></script>
    <script src="jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.js"></script>
    <script src="js/kaka.js"></script>
    <style>
        .content {
            background: #eee;
            padding: 0px;
        }

        .span {
            font-size: 10px;
        }

        .padding5 {
            padding: 5px;
        }

        .content .top {
            width: 100%;
            background-color: #e0e0e0;
            border: 0px seashell;
            height: 40px;
        }

        .font .span {
            font-size: 15px;
            color: black;
        }

        #content .ui-grid-b {
            background-color: white;
        }
        .box-shadow{
            box-shadow: 2px 2px 10px #909090;
        }
        #recomm {
            margin: 10px;
            border: 0.5px solid #8F8F8F;
            border-radius: 10px;
            padding: 3px;
        }
        .border-radius{
             border-radius: 3px;
         }
    </style>

</head>
<body>
<div id="star" data-role="page" data-quicklinks="true">
    <div id="starContent" data-role="content" class="content">
        <div id="wrapper">
            <div id="banner">

            </div>

            <div id="category" style="background: white;">
                <div class="ui-grid-c">

                </div>
            </div>

            <div id="content" >



            </div>

        </div>

    </div>
    <div data-role="footer" data-position="fixed" id="footer"  data-tap-toggle="false" style="background-color: #ffffff;opacity: 0.8;">
       <div class="ui-grid-b"  style="min-height:40px;padding:5px">
           <div class="ui-block-a" style="text-align: center">
               <div>
                   <img src="img/ic_home_s.png" style="width: 20px;height: 20px"/>
               </div>
               <div>
                   <span style="font-size: 12px">
                       首页
                   </span>
               </div>
           </div>
           <div class="ui-block-b" style="text-align: center">
               <div>
                   <img src="img/ic_car_n.png" style="width: 20px;height: 20px"/>
               </div>
               <div>
                   <span style="font-size: 12px">
                      购物车
                   </span>
               </div>
           </div>
           <div class="ui-block-c" style="text-align: center">
               <div>
                   <img src="img/ic_my_n.png" style="width: 20px;height: 20px"/>
               </div>
               <div>
                   <span style="font-size: 12px">
                       我
                   </span>
               </div>
           </div>
       </div>
    </div>


</div>
<script type="text/javascript">
    var height = $(window).height * 0.3;
    $("#star").ready(function () {
        navLocation(function () {
            load();
        });
    });

    function load() {
        $.ajax({
            type: "POST",
            url: "${path}/app/user/v2/homePage",
            dataType: "json",
            data: "info={lat:" + _.latitude + ",lng:" + _.longitude + "}",
            headers: {
                "appid": "999999",
                "chnl": "10086",
                "dev": "huawei",
                "m": "addShopInfo",
                "os": "android",
                "t": "122545450",
                "ver": "1.0.0",
                "secret": "caca51",
                "sign": "6096d5f16dd845407822f96865ad7237"
            },
            success: function (result) {
                if (result.code == 10002) {
                    console.info(result);
                    var activitys = result.data.shopActivits;
                    var category = result.data.category;
                    var recommGoods=result.data.recommGoods;
                    var types=result.data.types;
                    for (var i = 0; i < activitys.length; i++) {
                        $("#banner").append("<img height='" + height + "' width='100%' src='" + activitys[i].img_url + "'>");
                    }
                    loadCatagory(category);

                    if(recommGoods.length!=0){
                        loadRecommProducts(recommGoods);
                        $("#recommTitle").show();
                    }
                    if(types.length!=0){
                        loadTypes(types);
                        $("#recommTitle").hide();
                    }
                } else {
                    console.info(result.msg);
                }
            }
        });
    }

    function loadCatagory(category){
        $("#category .ui-grid-c").append("<div class='ui-block-a'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[0].img + "'></div><div><span class='span'>" + category[0].name + "</span></div></div>  </div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-b'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[1].img + "'></div><div><span class='span'>" + category[1].name + "</span></div></div></div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-c'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[2].img + "'></div><div><span class='span'>" + category[2].name + "</span></div></div></div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-d'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[3].img + "'></div><div><span class='span'>" + category[3].name + "</span></div></div></div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-a'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[4].img + "'></div><div><span class='span'>" + category[4].name + "</span></div></div></div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-b'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[5].img + "'></div><div><span class='span'>" + category[5].name + "</span></div></div></div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-c'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[6].img + "'></div><div><span class='span'>" + category[6].name + "</span></div></div></div></div>");
        $("#category .ui-grid-c").append("<div class='ui-block-d'><div class='ui-bar' style='text-align: center'><div><div class='padding5'><img height='30px' width='30px' src='" + category[7].img + "'></div><div><span class='span'>" + category[7].name + "</span></div></div></div></div>");
    }


    function loadRecommProducts(recommGoods){
       var html =" <div class='ui-bar-a content top' ><div class='ui-block-a' style='float: left;margin-left: 15px'> <div style='font-size:10px ;color: #8F8F8F ;padding: 10px'>本店推荐</div>"+
        " </div> <div class='ui-block-b' style='float: right;margin-right:15px'> <div style='font-size:10px ;color: #8F8F8F; padding: 10px'>更多>></div> </div> </div>";
        html+="<div class='ui-grid-b box-shadow'><div  class='border-radius' >";
        html+="<table>";
        var recommLength=recommGoods.length;
        var hrLength=recommLength/3;
        for(var i=0;i<hrLength;i++){
            html+="<tr>";
            for(var j=i*3;j<(i+1)*3;j++){
                html+="<td width='30%' height='30px'><div><div><img src='"+recommGoods[j].cover_img+"' width='100%'></div>" +
                        "<div class='ui-grid-b'>"+
                        "<div class='ui-block-a' style='float: left;margin-left: 2px'><span class='font span'>"+recommGoods[j].name+"</span><br/><span class='font span'>￥"+recommGoods[j].price/100+"</span></div>"+
                "<div class='ui-block-b' style='float: right;margin-right: 10px'><img width='30' height='30' src='img/add_cart.png'></div></div></div><div class='border-radius' style='background-color: darkgray;text-align: center'>"+
                        "<span style='font-size: 10px;color: white '>红包抵现 ￥"+recommGoods[j].cash_pay/100+"</span></div></td>"
            }
            html+="</tr>";
        }
        html+="</table></div></div>";
        $("#content").append(html);
    }
    function loadTypes(types){
        var html="";
        for(var i=0;i<types.length;i++){
            var products=types[i].products;
            var type=types[i].type;
            html+=" <div class='ui-bar-a content top' ><div class='ui-block-a' style='float: left;margin-left: 15px'> <div style='font-size:10px ;color: #8F8F8F ;padding: 10px'>"+type.name+"</div>"+
                   " </div> <div class='ui-block-b' style='float: right;margin-right:15px'> <div style='font-size:10px ;color: #8F8F8F; padding: 10px'>更多>></div> </div> </div>";
            html+="<div class='ui-grid-b box-shadow'><div  class='border-radius' ><table>";
            for(var j=0;j<2;j++){
                html+="<tr>";
                for(var k=j*3;k<(j+1)*3;k++){
                    var p=products[k];
                    html+="<td width='30%' height='30px'><div><div><img src='"+p.cover_img+"' width='100%'></div>" +
                            "<div class='ui-grid-b'>"+
                            "<div class='ui-block-a' style='float: left;margin-left: 2px'><span class='font span'>"+p.name+"</span><br/><span class='font span'>￥"+p.price/100+"</span></div>"+
                            "<div class='ui-block-b' style='float: right;margin-right: 10px'><img width='30' height='30' src='img/add_cart.png'></div></div></div><div class='border-radius' style='background-color: darkgray;text-align: center'>"+
                            "<span style='font-size: 10px;color: white '>红包抵现 ￥"+p.cash_pay/100+"</span></div></td>"
                }
                html+="</tr>";
            }
            html+="</td></div></div>";
        }
        $("#content").append(html);
    }
</script>
</body>
</html>
