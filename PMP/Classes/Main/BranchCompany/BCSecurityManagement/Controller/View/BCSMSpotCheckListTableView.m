//
//  BCSMSpotCheckListTableView.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSpotCheckListTableView.h"
#import "BCSMSpotCheckListCell.h"
@interface BCSMSpotCheckListTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *numList;
@end


@implementation BCSMSpotCheckListTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if ([super initWithFrame:frame style:style]) {
        self.dataSource = self;
        self.delegate = self;
        self.bounces  =NO;
        self.datalist=@[
                        @[@[@"4.2.3",@"现行有效的管理性、技术性、经营性等内部文件和规范图纸、设计（洽商）变更等外部资料清单及收发文登记"],@[@"4.2.4",@"1、施工质量记录清单",@"2、综合月报表"]],
                        @[@[@"5.4.1",@"工程质量、安全、环境目标"],@[@"5.4.4",@"1、重大环境因素和重大危险源清单及应对措施",@"2、基坑支护、模板工程、起重作业等安全技术措施",@"3、“安全三宝”使用情况及脚手架防护措施",@"4、焊接作业、施工用电安全操作和规范管理",@"5、“四口五临边”及高处作业的安全防护措施",@"6、生产污水沉淀池、食堂隔油池设置情况",@"7、噪声、粉尘和光污染的应对措施",@"8、易燃易爆危险品、有害有毒物质的防护措施"]],
                        @[@[@"6.2",@"人力资源",@"1、管理人员、特殊工种、操作工人有效持证台帐",@"2、劳动合同及保险"]],
                        @[@[@"6.3.2",@"机械设备台帐及维护保养",@"1、机械设备台帐",@"2、维护保养记录"]],
                        @[@[@"6.4",@"安全文明管理及环境保护节能降耗等实施情况",@"1、噪声、污水、粉尘、检测和控制措施及有毒有害物质排放、光污染控制、易燃易爆管理，巡查记录",@"2、设有分类封闭的垃圾箱",@"3、临时用电的专项验收和生活设施的总体验收",@"4、消防安全设施的验收和实施情况",@"5、节电、节水措施及巡查记录",@"6、办公区、生活区环境卫生及食堂隔油池设置",@"7、八牌一图",@"7、八牌一图"]],
                        @[@[@"7.17.2",@"1、合同及施组控制",@"2、建全项目部管理组织机构",@"3、施组和单项施工方案编、审情况",@"4、月作业计划、周作业计划编制执行",@"5、合同注册备案及施工人员备案",@"6、顾客和及其相关方的沟通"]],
                        @[@[@"7.4",@"材料采购控制",@"1、合格分供方调查、考核、管理及合同评审",@"2、材料计划编制和审核签发记录",@"3、物资进场检验及出库台帐记录"]],
                        @[@[@"7.5",@"施工过程控制",@"1、技术、经济和函件等文字资料收集与整理",@"2、施工过程（含特殊关键工序）的备忘记录（相关工程资料和施工日记）",@"3、产品标志及相关方告知实施情况",@"4、顾客提供产品管理（交接检）",@"5、产品防护"]],
                        @[@[@"7.6",@"监测设备控制",@"2、监测设备检定记录（水准仪、经纬仪、磅秤等）",@"3、钢卷尺、混凝土坍落度筒等自校记录安全、环境防护措施"],@[@"7.7",@"1、三级安全教育记录",@"2、安全、环境技术交底",@"3、员工持证上岗检查",@"4、大型设备、防护设施使用许可证和验收合格证",@"5、专项安全施工方案审批执行和应急预案制定",@"6、易燃易爆危险品安全管理实施情况",@"7、施工现场安全、环境检查记录"]],
                        @[@[@"8.2.1",@"用户回访满意度评价",@"定期用户回访计划、满意度评价及回访记录"]],
                        @[@[@"8.2.38.2.4",@"1、过程及产品试验、检验",@"2、预检、隐检",@"3、检验批（材料及成品等）",@"4、分部分项单位工程质量验收记录"]],
                        @[@[@"8.3",@"不合格品控制及纠正预防措施",@"1、质量控制措施（方案、管理）",@"2、质量不合格问题的纠正措施及验证"]],
                        @[@[@"其他",@"1、财务管理",@"2、按合同应收款、实收款及支付款情况",@"3、工资分配制度或经济协议及支付",@"3、工资分配制度或经济协议及支付"]]
                        ];
      
    }
    return self;
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.datalist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   BCSMSpotCheckListCell *cell =(BCSMSpotCheckListCell *)[self getProCellWithTableView:tableView];
    cell.isEditing = self.isEditing;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *infolist = self.datalist[indexPath.row];
    
    NSInteger num=0;
    for (BCSMSpotinfos *spotInfo in self.spotInfoArr) {
        if (spotInfo.order-1==indexPath.row) {
            num++;
            cell.spotInfos = spotInfo;
        }
    }
    
    if (num==0) {
        cell.spotInfos = nil;
    }
    cell.infoList=infolist;
   
    __weak typeof(self)weakself = self;
    cell.chooseSpotCheck = ^(UIButton *btn){
        weakself.chooseBySpotCheck(btn,indexPath.row+1);
    };
    
    return cell;
}

-(UITableViewCell *)getProCellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"cell";
    BCSMSpotCheckListCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell=[[BCSMSpotCheckListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
 
       
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BCSMSpotCheckListCell *cell =(BCSMSpotCheckListCell *)[self getProCellWithTableView:tableView];
    NSArray *infolist = self.datalist[indexPath.row];
      cell.infoList=infolist;
    if (cell.cellHeight<70) {
        
        cell.cellHeight = 70;
        
    }
    
    return cell.cellHeight;
 
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 50)];
    view.backgroundColor=[UIColor whiteColor];
    UILabel *numLable  =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 39.5, view.height)];
    numLable.textAlignment=NSTextAlignmentCenter;
    numLable.numberOfLines =0;
    numLable.text  =@"序号";
    numLable.font  =[UIFont systemFontOfSize:16.0];
    [view addSubview:numLable];
    
    UIView *lineView1 =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numLable.frame), 0, 0.5, view.height)];
    lineView1.backgroundColor =[UIColor lightGrayColor];
    [view addSubview:lineView1];
    
    UILabel *contntLable  =[[UILabel alloc] initWithFrame:CGRectMake(40, 0, W(240)+10, view.height)];
    contntLable.textAlignment=NSTextAlignmentCenter;
    contntLable.numberOfLines =0;
    contntLable.text  =@"检查内容";
    contntLable.font  =[UIFont systemFontOfSize:16.0];
    [view addSubview:contntLable];
    
    UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(contntLable.frame)+10, 0, 0.5, view.height)];
    lineView2.backgroundColor =[UIColor lightGrayColor];
    [view addSubview:lineView2];
    
    UILabel *spotLable   =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView2.frame), 0,WinWidth-CGRectGetMaxX(lineView2.frame), view.height)];
    spotLable.textAlignment=NSTextAlignmentCenter;
    spotLable.numberOfLines =0;
    spotLable.text  =@"抽查情况";
    spotLable.font  =[UIFont systemFontOfSize:16.0];
    [view addSubview:spotLable];
    
    UIView *lineView3 =[[UIView alloc] initWithFrame:CGRectMake(0, view.height, WinWidth, 0.5)];
    lineView3.backgroundColor =[UIColor lightGrayColor];
    [view addSubview:lineView3];
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

@end
