package com.lxyg.app.customer.platform.validator;

import com.jfinal.core.Controller;
import com.jfinal.validate.Validator;

public class GoodsValidator extends Validator {

	@Override
	protected void validate(Controller c) {
		validateRequiredString("name", "nameMsg", "请输入用户名");
		validateRequiredString("price", "priceMsg", "请输入价格");
		validateRequiredString("marketPrice", "marketPriceMsg", "请输入市场价格");
		validateRequiredString("typeId", "typeMsg", "请选择产品类型");
		validateRequiredString("brandId", "brandMsg", "请选择品牌");
		validateRequiredString("unitId", "unitMsg", "请选择单元");
		validateRequiredString("descripation", "descripationMsg", "请输入产品详细描述");
		validateRequiredString("serverId", "serverMsg", "请选择产品平台");
		validateRequiredString("payment", "paymentMsg", "请选择支付方式");
	}

	@Override
	protected void handleError(Controller c) {
		c.renderJson("error", "添加产品错误");
	}

}
