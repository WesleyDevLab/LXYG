<%@ page language="java" import="java.util.*" pageEncoding="utf-8" %>
<%@ include file="/common/taglibs.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <jsp:include page="/metro.jsp"></jsp:include>

    <script type="text/javascript">
        var index_search = "${index_search}";
        var page = 1;
        var totalPage = 1;
        var totalRows = 0;
        var _typeId = 0;
        var _brandId = 0;

        $(document).ready(function () {
            var brand = "";
            var type = "";
            $.get("${path}/goods/loadGoodsAttribute", function (result) {
                if (result.code != 10010) {
                } else {
                    for (var i = 0; i < result.brand.length; i++) {
                        brand += "<li><a href='javascript:void(0);' value='" + result.brand[i].id + "'  onclick='searchByBrand($(this))' >" + result.brand[i].name + "</a></li>";
                    }
                    for (var j = 0; j < result.type.length - 1; j++) {
                        type += "<li><a href='javascript:void(0);' value='" + result.type[j].id + "'  onclick='searchByType($(this))' >" + result.type[j].name + "</a></li>";
                    }
                    $("#brand_search").append(brand);
                    $("#type_search").append(type);
                }
            });

            loadData(page, 0, 0);
        });

        function loadDataByPage(type, pageNum) {
            if (type == 0) {
                page = 1;
            }
            if (type == 3) {
                page = totalPage;
            }
            if (type == 1) {
                if (totalPage - page <= 0) {
                    alert("最后一页");
                    return false;
                } else {
                    page++;
                }
            }
            if (type == 2) {
                if (page - 1 <= 0) {
                    alert("这是首页");
                    return false;
                } else {
                    page--;
                }
            }

            if (type == 4) {
                if (pageNum > totalPage) {
                    alert("没有那么多页说");
                    return false;
                } else {
                    page = pageNum
                }
            }

            loadData(page, _brandId, _typeId);
        }

        function loadData(page, brandId, typeId, proName) {
            var url = "${path}/goods/index";

            if (index_search == null || index_search == "") {
                index_search = "bz";
            }
            $.post(url, {
                "pg": page,
                "brandId": brandId,
                "typeId": typeId,
                "index_search": index_search,
                "proName": proName
            }, function (result) {
                if (result.code == 10010) {
                    var goods = result.goods.list;
                    totalPage = result.goods.totalPage;
                    totalRows = result.goods.totalRow;
                    var innerHtml = "";
                    var pageHtml = "";
                    $("#innerGoods").html(innerHtml);
                    $("#page").html(pageHtml);
                    for (var i = 0; i < goods.length; i++) {
                        var p = goods[i];
                        if (index_search == "fbz") {
                            innerHtml += "<tr><td>" + p.name + "</td><td><img src=" + p.cover_img + " style='width:100px;height:50px'></td><td class='center'>" + p.create_time + "</td>" +
                                    "<td class='center'>" + (p.price / 100).toFixed(2) + "</td><td class='center'>" + (p.market_price / 100).toFixed(2) + "</td>" +
                                    "<td class='center'>" + p.cash_pay + "</td>" +
                                    "<td class='center'>" +
                                    "<button type='button' class='btn btn-primary' value='" + p.id + "' onclick='JavaScript:updateRecord($(this));'>修改</button>" +
                                    "<button type='button' class='btn' value='" + p.id + "' onclick='JavaScript:delRecord($(this));'>删除</button></td><tr>";
                        } else {
                            innerHtml += "<tr><td>" + p.name + "</td><td><img src=" + p.cover_img + " style='width:100px;height:50px'></td><td class='center'>" + p.create_time + "</td>" +
                                    "<td class='center'>" + (p.price / 100).toFixed(2) + "</td><td class='center'>" + (p.market_price / 100).toFixed(2) + "</td>" +
                                    "<td class='center'>" + p.cash_pay + "</td><td class='center'>" + p.server_name + "</td>" +
                                    "<td class='center'>" + p.p_brand_name + "</td><td class='center'>" +
                                    "<button type='button' class='btn btn-primary' value='" + p.id + "' onclick='JavaScript:updateRecord($(this));'>修改</button>" +
                                    "<button type='button' class='btn' value='" + p.id + "' onclick='JavaScript:delRecord($(this));'>删除</button></td><tr>";
                        }
                    }
                    pageHtml += "第" + page + "/" + totalPage + "页    共" + totalRows + "条";
                    $("#innerGoods").append(innerHtml);
                    $("#page").append(pageHtml);
                }
            });
            // cutFBStyle();
        }


        //function cutFBStyle(){
        //    if(index_search=="fbz"){
        //        $("#plat_name").text("乐享云购非标产品管理");
        //        $("#plat_name1").text("乐享云购非标产品管理");
        //        $("#brand").hide();
        //        $("#type").hide();
        //        $("#product_s").hide();
        //        $("#brand_s").hide();
        //    }
        //    if(index_search=="bz"){
        //        $("#plat_name").text("乐享云购产品管理");
        //        $("#plat_name1").text("乐享云购产品管理");
        //        $("#brand").show();
        //        $("#type").show();
        //        $("#product_s").show();
        //        $("#brand_s").show();
        //    }
        //}

        //    function cunFB(){
        //        if(index_search=="fbz"){
        //            index_search="bz";
        //            loadData(page,0,0);
        //            return;
        //        }
        //
        //        if(index_search=="bz"){
        //            index_search="fbz";
        //            loadData(page,0,0);
        //            return;
        //        }
        //    }

        function searchByBrand(v) {
            var brandId = v.attr("value");
            _brandId = brandId;
            loadData(page, brandId, 0);
        }
        function searchByType(v) {
            var typeId = v.attr("value");
            _typeId = typeId;
            loadData(page, 0, typeId);
        }


        function delRecord(obj) {
            if (confirm("确定要删除产品嘛？这样做或许会出现重大错误")) {
                var v = obj.val();
                $.post("${path}/goods/deleteByGoodsId", {"goodsId": v}, function (result) {
                    if (result.code == 10010) {
                        obj.parent().parent().remove();
                        alert(result.message);
                    } else {
                        alert(result.message);
                    }
                });
            }
        }


        function updateRecord(obj) {
            var v = obj.val();
            location.href = "${path}/pageTo/updateProduct?productId=" + v + "&index_search=" + index_search;

        }
        function search() {
            var proName = $("#search_pros").val();
            if (proName != null && proName != "") {
                loadData(page, 0, 0, proName);
            }
        }


    </script>

</head>
<%@ include file="../common/top.jsp" %>
<body>
<!-- start: Content -->

<div id="content" class="span10">
    <div class="row-fluid">
        <div class="box span12">
            <div class="box-header">
                <h2 id="plat_name1"><i class="icon-align-justify"></i><span class="break"></span>乐享云购平台产品管理</h2>

                <div class="box-icon">
                    <c:if test="${viewKey!=3 }">
                        <a href="${path}/pageTo/addproduct" class="btn-add">
                            <i class="icon-edit" style="width:60px">添加</i>
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="box-content" style="min-height: 100%">
                <div style="margin:10px 0;" class="form-inline">
                    <div class="form-group">
                        <div style="padding: 10px">
                            <button type="button" class="btn btn-primary" id="plat_name">乐享云购平台产品管理</button>
                            <div class="btn-group">
                                <div class="controls"><select class="form-control" id="type"></select></div>
                            </div>

                            <div class="btn-group">
                                <div class="controls"><select class="form-control" id="brand"></select></div>
                            </div>

                            <div class="btn-group" >
                                <input type="text"  id="search_pros">
                                <button style="margin-left: 5px" type="button" onclick="search()" class="btn btn-primary">
                                    搜索
                                </button>
                            </div>
                        </div>

                        <table class="table table-bordered table-striped table-condensed">
                            <thead>
                            <tr>
                                <th>产品名字</th>
                                <th>产品图片</th>
                                <th>添加时间</th>
                                <th>乐享云购价格</th>
                                <th>市场价格</th>
                                <th>可用电子代金券</th>
                                <th id="product_s">产品来源</th>
                                <th id="brand_s">产品品牌</th>
                                <c:if test="${viewKey!=3 }">
                                    <th>操作</th>
                                </c:if>
                            </tr>
                            </thead>
                            <tbody id="innerGoods">

                            </tbody>
                        </table>
                        <div class="pagination pagination-centered">
                            <div class="bg">
                                <div class="r_page">
                                    <li id="page"></li>
                                    <li><a onclick="loadDataByPage(0,1)">首页</a></li>
                                    <li><a class="active" onclick="loadDataByPage(2,0)">上一页</a></li>
                                    <li><a class="active" onclick="loadDataByPage(1,0)">下一页</a></li>
                                    <li><a onclick="loadDataByPage(3,1)">末页</a></li>
                                    跳转到第
                                    <input id="toPage" style="width:20px;ime-mode:disabled;" size="4">
                                    页
                                    <a class="label label-success"
                                       onclick="loadDataByPage(4,$(this).prev('input').val())">跳转</a>
                                </div>
                                <div class="clear"></div>
                            </div>
                        </div>
                    </div>
                </div>
                <!--/span-->
            </div>
            <!--/row-->
        </div>
        <!-- end: Content -->

    </div>
    <!--/fluid-row-->
    <!--/row-->

</div>
<!--/fluid-row-->
<div class="modal hide fade" id="myModal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>
        <h3>删除操作</h3>
    </div>
    <div class="modal-body">
        <p>您确定要删除该信息吗？...</p>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">取消</a>
        <a href="#" class="btn btn-primary">删除</a>
    </div>
</div>


<div class="clearfix"></div>
<footer>
    <p>
        <span style="text-align: left; float: left">Copyright &copy; 2014.乐享云购 All rights reserved.</span>
    </p>

</footer>


</body>

</html>