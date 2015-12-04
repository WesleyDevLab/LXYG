package com.lxyg.app.customer.tencent.common;

import com.alibaba.fastjson.JSONObject;
import com.lxyg.app.customer.platform.model.Goods;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.TagSupport;
import java.io.IOException;

/**
 * Created by ÇØË§ on 2015/12/4.
 */
public class JsonTag extends TagSupport {
    private Goods goods;

    public void setGoods(Goods goods) {
        this.goods = goods;
    }

    @Override
    public int doEndTag() throws JspException {

        String str = JSONObject.toJSONString(goods);
        try {
            pageContext.getOut().write(str);
        } catch (IOException e) {
            e.printStackTrace();
        }

        return super.doEndTag();
    }
}
