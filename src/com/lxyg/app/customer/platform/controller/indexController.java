package com.lxyg.app.customer.platform.controller;

import com.jfinal.core.Controller;

/**
 * Created by Administrator on 2015/9/1.
 */
public class indexController extends Controller {

    public void index(){
        render("/login.jsp");
    }
}
