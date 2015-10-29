<%@ page language="java"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript">
function exit(){

	if(confirm("确定退出?")){
		location.href="${path}/user/exit";
	}
}
</script>

 <!-- start: Header -->
    <div class="navbar">
        <div class="navbar-inner">
            <div class="container-fluid">
                <a class="btn btn-navbar" data-toggle="collapse" data-target=".top-nav.nav-collapse,.sidebar-nav.nav-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </a>
                <a id="main-menu-toggle" class="hidden-phone open"><i class="icon-reorder"></i></a>
                <div class="row-fluid">
                    <a class="brand span2" href="${path }/home"><span>乐享云购后台管理系统</span></a>
                </div>
                <!-- start: Header Menu -->
                <div class="nav-no-collapse header-nav">
                    <ul class="nav pull-right">
                        <!-- start: User Dropdown -->
                        <li class="dropdown">
                            <a class="btn account dropdown-toggle" data-toggle="dropdown" href="#">
                                <div class="avatar">
                                    <%-- <img src="${imgPath}${session['user'].photo}" alt="Avatar" /> --%>
                                    <img src="${path}/public/img/avatar.jpg" alt="Avatar" />
                                </div>
                                <div class="user">
                                    <span class="hello">欢迎!</span>
                                    <span class="name">	管理员</span>
                                </div>
                            </a>
                            <ul class="dropdown-menu">
                                <li class="dropdown-menu-title"></li>
                                <li><a href="${path}/home"><i class="icon-user"></i>后台首页</a></li>
                                <li><a href="${path}/home/toEdit"><i class="icon-cog"></i>修改密码</a></li>
                                <li><a href="#"><i class="icon-envelope"></i>消息中心</a></li>
                                <li><a href="javascript:exit()"><i class="icon-off"></i>退出系统</a></li>
                            </ul>
                        </li>
                        <!-- end: User Dropdown -->
                    </ul>
                </div>
                <!-- end: Header Menu -->

            </div>
        </div>
    </div>
    <!-- start: Header -->
    
    <div class="container-fluid-full">
        <div class="row-fluid">
            <!-- start: Main Menu -->
            <div id="sidebar-left" class="span2">
                <!-- <div class="row-fluid actions">
                    <input type="text" class="search span12" placeholder="..." />
                </div> -->

                <div class="nav-collapse sidebar-nav">
                    <ul class="nav nav-tabs nav-stacked main-menu">
                       <c:forEach items="${session.rl}" var="res">
                        <c:if test="${res.restype==0}">
                        <li>
                            <a class="dropmenu" href="javascript:void(0)">
                            <c:if test="${res.resid==1 }">
                            <i class="icon-bar-chart"></i>
                            </c:if>
                            <c:if test="${res.resid==2 }">
                            <i class="icon-eye-open"></i>
                            </c:if>
                            <c:if test="${res.resid==3}">
                            <i class="icon-dashboard"></i>
                            </c:if>
                            <c:if test="${res.resid==4}">
                            <i class="icon-folder-close-alt"></i>
                            </c:if>
                            <c:if test="${res.resid==5}">
                            <i class="icon-edit"></i>
                            </c:if>
                            <c:if test="${res.resid==6}">
                            <i class="icon-list-alt"></i>
                            </c:if>
                            <c:if test="${res.resid==7}">
                            <i class="icon-font"></i>
                            </c:if>
                            <c:if test="${res.resid==8}">
                            <i class="icon-picture"></i>
                            </c:if>
                            
                            <span class="hidden-tablet">${res.resname }</span>
                            </a>
                            <ul>
                               	<c:forEach items="${session.rl}" var="res2">
	                               	<c:if test="${res.resid==res2.parentid&&res2.restype!=0}">
	                               	<li><a class="submenu" href="${path }/${res2.url}"><i class="icon-hdd"></i><span class="hidden-tablet">${res2.resname }</span></a></li>
						        	</c:if>
					          	</c:forEach>
                            </ul>
                        </li>
                     </c:if>
                   	</c:forEach>
                    </ul>
                </div>
            </div>
            <!-- end: Main Menu -->