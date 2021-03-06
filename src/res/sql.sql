/**
帖子内容
*/
DROP TABLE IF EXISTS kk_form;
CREATE TABLE IF NOT EXISTS kk_form(
   id INT(11) NOT NULL AUTO_INCREMENT,
   title VARCHAR(200) CHARACTER SET utf8 NOT NULL,
   content VARCHAR(255) CHARACTER SET utf8 DEFAULT NULL,
   create_time DATETIME NOT NULL,
   u_uid VARCHAR (17) NOT NULL,
   PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/**
帖子图片
*/
DROP TABLE IF EXISTS kk_form_img;
CREATE TABLE IF NOT EXISTS kk_form_img(
   id INT(11) NOT NULL AUTO_INCREMENT,
   form_id INT(11) NOT NULL,
   img_url VARCHAR (255) CHARACTER SET utf8 NOT NULL,
   PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;


/**
帖子回复
*/
DROP TABLE IF EXISTS kk_form_replay;
CREATE TABLE IF NOT EXISTS kk_form_replay(
   id INT(11) NOT NULL AUTO_INCREMENT,
   form_id INT(11) NOT NULL,
   u_uid VARCHAR (17) CHARACTER SET utf8 NOT NULL,
   to_u_uid VARCHAR (17) CHARACTER SET utf8 NOT NULL,
   content VARCHAR(255) CHARACTER SET utf8 DEFAULT '',
   PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/**
帖子赞列表
*/
DROP TABLE IF EXISTS kk_form_zan;
CREATE TABLE IF NOT EXISTS kk_form_zan(
   id INT(11) NOT NULL AUTO_INCREMENT,
   form_id INT(11) NOT NULL,
   u_uid VARCHAR (17) CHARACTER SET utf8 NOT NULL,
   PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/**
登录签到 记录
*/
DROP TABLE if EXISTS kk_login_log;
CREATE TABLE if NOT EXISTS kk_login_log(
 id INT(11) NOT NULL AUTO_INCREMENT,
 u_uid VARCHAR (17) CHARACTER SET utf8 NOT NULL,
 create_time DATETIME NOT NULL,
 PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/**
登录签到 次数
*/
DROP TABLE if EXISTS kk_login_sign;
CREATE TABLE if NOT EXISTS kk_login_sign(
 id INT(11) NOT NULL AUTO_INCREMENT,
 u_uid VARCHAR (17) CHARACTER SET utf8 NOT NULL,
 num INT(11) not null DEFAULT 0,
 create_time DATETIME NOT NULL,
 PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

/**
联系我们记录
*/
DROP  TABLE if EXISTS kk_join_info;
CREATE TABLE if NOT EXISTS kk_join_info(
  id INT(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR (255) DEFAULT NULL ,
  phone VARCHAR (15) DEFAULT NULL ,
  content VARCHAR (255) DEFAULT null,
  address varchar (255) DEFAULT null,
   PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER  TABLE kk_product_activity ADD limit_num int(5) DEFAULT 0; -- 限购数量
ALTER  TABLE kk_product_activity ADD surplus_num int(5) DEFAULT 0; -- 剩余数量
ALTER TABLE kk_product add code VARCHAR (50) DEFAULT NULL ; -- 产品条形码
/**
用户积分
*/
DROP  TABLE if EXISTS kk_integral;
CREATE TABLE if not EXISTS kk_integral(
 id int(11) not null AUTO_INCREMENT,
 u_uid VARCHAR (17) CHARACTER SET utf8 NOT NULL,
 integral int(11) not null DEFAULT 0,
 create_time DATETIME NOT NULL,
 PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE kk_shop_activity add activity_id int not null DEFAULT 0; -- 活动类型(新手/抢购/团购/预售)

DROP TABLE if EXISTS kk_activity;
CREATE TABLE if not EXISTS kk_activity(
 id int(11) not null AUTO_INCREMENT,
 name varchar(100) CHARACTER SET utf8 not null,
 PRIMARY  KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE kk_product_activity add p_type_id int not null DEFAULT 0,
 add p_type_name VARCHAR(100) CHARACTER set utf8 not null,
 add p_brand_id int not null DEFAULT 0,
 add p_brand_name VARCHAR(100) CHARACTER set utf8 not null;


/**
*2015-12-8 节点
*/
alter TABLE kk_product add p_number int not null DEFAULT 0,add supplier_price DECIMAL;

DROP TABLE if EXISTS kk_product_log;
CREATE TABLE if NOT EXISTS kk_product_log(
 id int(11) not null AUTO_INCREMENT,
 p_id int(11) not null,
 price DECIMAL,
 market_price DECIMAL ,
 supplier_price DECIMAL,
 p_number int not null DEFAULT 0,
 create_time DATETIME NOT NULL,
 PRIMARY  KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

DROP TABLE if EXISTS kk_product_data;
  CREATE TABLE if not EXISTS kk_product_data(
  id int(11) not null AUTO_INCREMENT,
  p_category_id int (11) not null DEFAULT 0,
  p_type_id int (11) not null DEFAULT 0,
  p_brand_id int (11) not null DEFAULT 0,
  p_category_name varchar(255) DEFAULT null,
  p_type_name varchar(255) DEFAULT null,
  p_brand_name varchar(255) DEFAULT null,
  name varchar(255) DEFAULT null,
  p_unit_name varchar(25) DEFAULT null,
  txm_code VARCHAR (50)DEFAULT null,
  min_stock_all int(11) DEFAULT 0,
  min_stock_shop int(11) DEFAULT 0,
  supplier_price DECIMAL,
  box_specification int(11) DEFAULT 0,
  min_quantity int (11)  DEFAULT 0,
  quantity int(11)  DEFAULT 0,
  p_desc VARCHAR(255) DEFAULT null,
  gross_profit int(11)  DEFAULT 0,
  PRIMARY  KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE  kk_order_activity add s_uid VARCHAR (17) not null;
ALTER TABLE kk_shop add scope VARCHAR(17) DEFAULT null;

ALTER TABLE kk_shop_activity add price_rule VARCHAR (255) DEFAULT null;


DROP TABLE if EXISTS kk_push_content;
CREATE TABLE kk_push_content(
id int(11) NOT null AUTO_INCREMENT,
content VARCHAR(255) not null ,
push_time int(11) DEFAULT 0,
PRIMARY  KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE kk_order add remark VARCHAR (255);
ALTER TABLE kk_order_activity add remark VARCHAR (255);

ALTER TABLE  kk_shop_product add sort_id int(4) DEFAULT 1;

DROP TABLE if EXISTS kk_form_irr;
CREATE TABLE kk_form_irr(
  id int(11) NOT null AUTO_INCREMENT,
  form_id int(11) not null,
  uid VARCHAR(17) not null,
  cause VARCHAR(255),
  PRIMARY  KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

ALTER TABLE  kk_login_sign add mg int(2) not null default 1;

ALTER TABLE  kk_integral add type int(2) not null default 1;

ALTER TABLE  kk_product_brand add sort_id int(6) not null default 100;

Alter Table kk_order_item add activity_id int(11) not null default 0;
Alter Table kk_order add send_goods_type varchar(15) ;

Alter Table kk_product_activity add hide int(2) default 1;


DROP TABLE if EXISTS kk_push_msg;
CREATE TABLE kk_push_msg(
  id int(11) NOT null AUTO_INCREMENT,
  content VARCHAR(255) not null,
  s_uid VARCHAR(17),
  PRIMARY  KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;



Drop Table if EXISTS  kk_shop_fb;
CREATE TABLE kk_shop_fb(
  id int(11) NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) not NULL ,
  s_uid VARCHAR(17)  not NULL ,
  cover_img VARCHAR(255)  not NULL ,
  link_man VARCHAR(255),
  phone VARCHAR(11)  not NULL ,
  password VARCHAR(17),
  full_address VARCHAR(255),
  lat DOUBLE,
  lng DOUBLE,
  create_time DATETIME NOT NULL,
  fb_uid VARCHAR(17) not null,
  hide int(2) not NULL  DEFAULT 0,
  title VARCHAR(255),
  sale_num int(17) not null DEFAULT 0,
  send_price int(10) not null DEFAULT 0,
  delivery_price int(10) not null DEFAULT 0,
  delivery_time int(10) not null DEFAULT 0,
  PRIMARY KEY (id)
)ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

Alter Table kk_product add fb_uid VARCHAR(17);
Alter Table kk_product add sale_num int(10) not null DEFAULT 0;

Alter table kk_shop add title varchar(255) DEFAULT null;

ALTER TABLE `kk_product_fb` ADD COLUMN `sale_num`  int(255) NULL DEFAULT 0 COMMENT '月售' AFTER `s_uid`;
ALTER TABLE `kk_product_fb` ADD COLUMN `zan_num`  int(255) NULL DEFAULT 0 COMMENT '好评数' AFTER `sale_num`;
ALTER TABLE `kk_product_fb` ADD COLUMN `fb_category`  int(10) NULL DEFAULT 0 COMMENT '非标产品分类' AFTER `zan_num`;
ALTER TABLE `kk_product_fb` ADD COLUMN `fb_category_name`  varchar(70) NULL DEFAULT NULL COMMENT '非标产品分类text' AFTER `fb_category`;

ALTER TABLE `kk_shop` ADD COLUMN `push_phone`  varchar(255) NULL DEFAULT NULL COMMENT '店铺title' AFTER `work_time`;

ALTER TABLE kk_shop add COLUMN off INT(4) not null DEFAULT 0;

DROP TABLE `kk_product_sybase`;
create table if not exists `kk_product_sybase`(
  `product_tm` VARCHAR(50) NOT NULL COMMENT '条码',
  `product_name` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '产品名称',
  `product_price` BIGINT NOT NULL DEFAULT '0' COMMENT '产品售价',
  `product_spbm` VARCHAR(20) not NULL COMMENT '商品编码',
  `product_unit` VARCHAR(5) NOT NULL COMMENT '商品单位',
  `product_csbm` VARCHAR(20) not NULL COMMENT '厂商编码',
  `product_category` int(11) NOT NULL DEFAULT 0 COMMENT '产品分类编码',
  `create_time` TIMESTAMP not null DEFAULT current_timestamp comment '创建时间',
  PRIMARY KEY (`product_tm`),
  key idx_product_tm(`product_tm`),
  key idx_product_name(`product_name`),
  key idx_product_category(`product_category`),
  key idx_create_time(`create_time`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT 'sybase数据库产品表';

CREATE TABLE if NOT EXISTS `kk_category_sybase`(
  `category_id` int(11) NOT NULL DEFAULT 0 COMMENT '类别编码',
  `category_name` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '类别名称',
  `create_time` TIMESTAMP not null DEFAULT current_timestamp comment '创建时间',
  PRIMARY KEY (`category_id`),
  key idx_category_id(`category_id`)
)ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT 'sybase数据库分类表';