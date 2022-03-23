//
//  AmsUser.h
//  HealthXiLanDoctor
//
//  Created by adtech on 16/3/14.
//  Copyright © 2016年 adtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AmsUser : NSObject

/*USER_ID        BigDecimal    用户ID
USER_TYPE_ID        BigDecimal    用户类型ID
USER_CODE        String    推荐人编码
LOGON_ACCT        String    登录帐号
LOGON_WAY        String    注册来源 来源reg_way表 code列
NICK_NAME        String    昵称
LOGO        String    图标
LOGON_PWD        String    登录密码
PWD_TIPS        String    密码提示
LOGON_QU        String    安全问题
QU_KEY        String    安全问题答案
CREATE_TIME        String    注册日期
NAME_CN        String    姓名中文
NAME_EN        String    姓名英文
HOME_TEL        String    联系电话
BIRTH        String    出生日期
SEX        String    性别编码 1男2女3未知
FOLK        BigDecimal    民族编码
WEDLOCK        BigDecimal    婚姻状况类别代码(10 未婚 20已婚 21 初婚 22 再婚 23复婚 30 丧偶 40 离婚 90 其他)
VOCATION        BigDecimal    职业类别代码
E_MAIL        String    电子邮件
ID_CARD        String    身份证号
MONEY_BAG        BigDecimal    收入状况
BIRTH_CITY        BigDecimal    出生城市
RESIDE_CITY        BigDecimal    居住城市
HOME_ADDR        String    家庭住址
LEGAL_REP        String    法定代表人
FAX_PHONE        String    传真电话
OWNSHIP        String    所有制形式
REG_FUND        String    注册资金
LICENSE_NO        BigDecimal    执业许可证登记号
STAFF_NUM        String    职工人数
STATUS        String    状态
OPERATOR        String    操作员
OP_TIME        String    操作日期
ORG_ID        BigDecimal    机构ID
MOBILE        String    手机号码
IS_ACTIVE        String    激活状态(0未激活1激活2冻结)
QQ        String    QQ号码
PAY_PHONE        String    付费号码(通常是非电信手机)
HOME_ADDR_NUM        String    邮政编码
UNIT_ADDR        String    所属单位
DZBL_ID        String    电子病历ID
YB_ID        String    医保卡号
PUBLIC_E_CARD        String    一卡通号
IDENTITY        String    身份
HIS_USER_ID        String    关联HIS数据库中用户ID
USER_STATUS        String    0:用户数据正常,1:用户数据异常
JKDA_ID        String    健康档案ID
LOGIN_COUNT        String    登录次数
LAST_LOGIN_TIME        String    上次登录时间
OTHERCARD_TYPE_ID        String    其他证件号码类型ID
OTHERCARD_NUMBER        String    其他证件号码
IMG_ICON        String    用户头像（该字段逐渐被icon_url取代）
ICON_URL        String    用户头像地址存放URL
IS_CERT         String    是否实名认证  1已认证 
 */

@property (copy,nonatomic) NSString * USER_ID;
@property (copy,nonatomic) NSString * USER_UNIQUE_ID;
@property (copy,nonatomic) NSString * USER_TYPE_ID;
@property (copy,nonatomic) NSString * USER_CODE;
@property (copy,nonatomic) NSString * LOGON_ACCT;
@property (copy,nonatomic) NSString * LOGON_WAY;
@property (copy,nonatomic) NSString * NICK_NAME;
@property (copy,nonatomic) NSString * LOGO;
@property (copy,nonatomic) NSString * LOGON_PWD;
@property (copy,nonatomic) NSString * PWD_TIPS;
@property (copy,nonatomic) NSString * LOGON_QU;
@property (copy,nonatomic) NSString * QU_KEY;
@property (copy,nonatomic) NSString * CREATE_TIME;
@property (copy,nonatomic) NSString * NAME_CN;
@property (copy,nonatomic) NSString * NAME_EN;
@property (copy,nonatomic) NSString * HOME_TEL;
@property (copy,nonatomic) NSString * BIRTH;
@property (copy,nonatomic) NSString * SEX;
@property (copy,nonatomic) NSString * FOLK;
@property (copy,nonatomic) NSString * WEDLOCK;
@property (copy,nonatomic) NSString * VOCATION;
@property (copy,nonatomic) NSString * E_MAIL;
@property (copy,nonatomic) NSString * ID_CARD;
@property (copy,nonatomic) NSString * MONEY_BAG;
@property (copy,nonatomic) NSString * BIRTH_CITY;
@property (copy,nonatomic) NSString * RESIDE_CITY;
@property (copy,nonatomic) NSString * HOME_ADDR;
@property (copy,nonatomic) NSString * LEGAL_REP;
@property (copy,nonatomic) NSString * FAX_PHONE;
@property (copy,nonatomic) NSString * OWNSHIP;
@property (copy,nonatomic) NSString * REG_FUND;
@property (copy,nonatomic) NSString * LICENSE_NO;
@property (copy,nonatomic) NSString * STAFF_NUM;
@property (copy,nonatomic) NSString * STATUS;
@property (copy,nonatomic) NSString * OPERATOR;
@property (copy,nonatomic) NSString * OP_TIME;
@property (copy,nonatomic) NSString * ORG_ID;
@property (copy,nonatomic) NSString * MOBILE;
@property (copy,nonatomic) NSString * IS_ACTIVE;
@property (copy,nonatomic) NSString * QQ;
@property (copy,nonatomic) NSString * PAY_PHONE;
@property (copy,nonatomic) NSString * HOME_ADDR_NUM;
@property (copy,nonatomic) NSString * UNIT_ADDR;
@property (copy,nonatomic) NSString * DZBL_ID;
@property (copy,nonatomic) NSString * YB_ID;
@property (copy,nonatomic) NSString * PUBLIC_E_CARD;
@property (copy,nonatomic) NSString * IDENTITY;
@property (copy,nonatomic) NSString * HIS_USER_ID;
@property (copy,nonatomic) NSString * USER_STATUS;
@property (copy,nonatomic) NSString * JKDA_ID;
@property (copy,nonatomic) NSString * LOGIN_COUNT;
@property (copy,nonatomic) NSString * LAST_LOGIN_TIME;
@property (copy,nonatomic) NSString * OTHERCARD_TYPE_ID;
@property (copy,nonatomic) NSString * OTHERCARD_NUMBER;
@property (copy,nonatomic) NSString * IMG_ICON;
@property (copy,nonatomic) NSString * ICON_URL;

@property (copy,nonatomic) NSString * IS_CERT;
@property (copy,nonatomic) NSString * SCORE;

@property (nonatomic) NSString * age;
@property (nonatomic) NSString * sexStr;

@property (assign,nonatomic) NSInteger phoneType;
@end
