//
//  WebInterface.h
//  PMP
//
//  Created by mac on 15/12/3.
//  Copyright © 2015年 mac. All rights reserved.
//

#ifndef WebInterface_h
#define WebInterface_h
#define ADD(A,B) [NSString stringWithFormat:@"%@%@",A,B]
//真实112.124.102.108:8080  测试192.168.1.31:8080
//登录
#define kLoginCheck   ADD(kPort,@"/mobileLoginCheck")

//所有问题列表(分页)(State: -1:全部 1: 未发现问题  2：待复查  3：复查未通过 4：复查通过)
#define kCheckResultInterface  ADD(kPort,@"/security/check/queryCheckInfoByStateOrUserId")

//检查问题
#define kCheckResultDetailInfoInterface  ADD(kPort,@"/security/check/checkResultDetailInfo")

//问题图片上传
#define kUploadFileByHttpInterface ADD(kPort,@"/security/check/uploadFileByHttp")

//检查问题上传
#define kAddCheckInfoInterface ADD(kPort,@"/security/check/addCheckInfo")

//复查问题
#define  kAddRecheckInfoInterface ADD(kPort,@"/security/check/addRecheckInfo")

//安全管理图片列表查询
#define kQueryUploadFileListByMenuIdAndFileType ADD(kPort,@"/security/check/queryUploadFileListByMenuIdAndFileType")

//查询负责人的接口
#define kQuerySolveUserList ADD(kPort,@"/security/check/querySolveUserList")

//总包单位所含个数
#define kQueryPicCount ADD(kPort,@"/security/check/queryPicCount")

//拉取推送消息

#define kQueryMenuWithParentId ADD(kPort,@"/security/check/queryMenuWithParentId")


//检查部位字典表拉取
#define kQueryCheckPosition ADD(kPort,@"/security/check/queryCheckPosition")

//拉取推送消息
#define kQueryCheckMsg ADD(kPort,@"/security/check/queryCheckMsg")

//标记已读
#define kReadCheckMsg  ADD(kPort,@"/security/check/readCheckMsg")

//处理人完成
#define kSolveUserAgree  ADD(kPort,@"/security/check/solveUserAgree")

//组织切换
#define kSwitchOrg ADD(kPort,@"/switchOrg")

#pragma mark 分公司
//项目一览(分页)
#define  kQueryProjectInfos ADD(kPort,@"/security/companyCheck/queryProjectInfos")

//安全检查一览
#define kQueryCompanyCheckInfo ADD(kPort,@"/security/companyCheck/queryCompanyCheckInfoWithMobile")

//问题图片上传
#define kSubCompanyUploadFileByHttp ADD(kPort,@"/security/companyCheck/uploadFileByHttp")

//安全检查录入
#define kSubAddCompanyCheckInfo ADD(kPort,@"/security/companyCheck/addCompanyCheckInfo")

//拉取单条最新项目信息接口
#define kSubQueryHistoryInfoWithCompanyId ADD(kPort,@"/security/companyCheck/queryHistoryInfoWithCompanyId")

//结构类型接口
#define kQueryStrutClass ADD(kPort,@"/security/companyCheck/queryStrutClass")

#endif /* WebInterface_h */
