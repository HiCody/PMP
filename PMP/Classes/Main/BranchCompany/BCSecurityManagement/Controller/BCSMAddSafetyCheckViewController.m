//
//  BCSMAddSafetyCheckViewController.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMAddSafetyCheckViewController.h"
#import "DCSMAddTitleView.h"
#import "BCSMSpotCheckListViewController.h"
#import "BCSMPeopleInfoCell.h"
#import "BCSMEngineeringSurveyCell.h"
#import "BCSMProjectPersonnelInformationViewController.h"
#import "BCSMProjectSummaryViewController.h"
#import "BCSMCheckPointViewController.h"
#import "BCSMAddSafetyCheckTableViewCell.h"
#import "BCSMCheckPointModel.h"
#import "NSString+NumRevretToChinese.h"
#import <MWCommon.h>
#import <MWPhotoBrowser.h>
#import "UIImage+fixOrientation.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "SMSafetyCheckAddProViewController.h"
#import "SMSafetyContent.h"
#import "BCSMSafetyCheckDetailModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "AccountModel.h" 
#import "NetRequestClass.h"
#import "WHUCalendarPopView.h"
#import "BRPlaceholderTextView.h"
@interface BCSMAddSafetyCheckViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextFieldDelegate,MWPhotoBrowserDelegate,UITextViewDelegate>{
    BOOL isClose;

    BOOL isShut;
    
    NSInteger spotProNum;//记录存在问题个数
     dispatch_queue_t _serialQueue;
    
    WHUCalendarPopView* _pop;
    
    NSIndexPath *popIndexPath;
    NSString *begindateStr;
    NSString *enddateStr;
    NSString *checkdateStr;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)DCSMAddTitleView *addTitleView;
@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)BCSMCheckPointModel *checkPoint;
@property(nonatomic,strong)NSMutableArray *checkPointList;//检查部位数组
@property(nonatomic,strong)NSArray *photos;
@property(nonatomic,strong)BCSMSafetyCheckDetailModel *checkDetailModel;
@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSString *dateStr;
@property(nonatomic,strong)BRPlaceholderTextView *enhancementRequestsTextView;
@property(nonatomic,strong)UILabel *placeholderLabel;

@end

@implementation BCSMAddSafetyCheckViewController
- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

- (NSMutableArray *)checkPointList{
    if (!_checkPointList) {
        _checkPointList  = [[NSMutableArray alloc] init];
    }
    return _checkPointList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"安全检查";
    spotProNum=-1;
    
    [self queryHistoryInfoWithCompanyId];
    [self setUpCommintButton];
    [self configCalendar];
    
    isClose =YES;
    isShut =YES;
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(W(100), 0, WinWidth-W(100), 44)];
    self.textField.delegate = self;
    self.textField.placeholder=@"请填写形象进度";
    self.textField.font =[UIFont systemFontOfSize:14.0];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)configCalendar{
    
    _pop=[[WHUCalendarPopView alloc] init];
    __weak typeof(self)weakself = self;
    _pop.onDateSelectBlk=^(NSDate* date){
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [format stringFromDate:date];
 
        if (popIndexPath.row==0&&popIndexPath.section==2 ) {
       
            NSDate *lastdate  =  [format dateFromString:weakself.checkDetailModel.endDate];
            NSComparisonResult result3 = [date compare:lastdate];
            if (result3==NSOrderedDescending) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开工日期晚于结束时间，请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else{
                
                begindateStr =  dateStr;
                weakself.checkDetailModel.beginDate = dateStr;
            }

            
        }else if(popIndexPath.row==1&&popIndexPath.section==2){
            
            NSDate *lastdate  =  [format dateFromString:weakself.checkDetailModel.beginDate];
            NSComparisonResult result3 = [date compare:lastdate];
            if (result3==NSOrderedAscending) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"完工日期早于开始时间，请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else{
                
                enddateStr  = dateStr;
                weakself.checkDetailModel.endDate = dateStr;
                
            }

            
        }else {
            checkdateStr  = dateStr;
            weakself.checkDetailModel.checkDate=dateStr;
        }
        
        
        [weakself.tableView reloadData];
        
    };
}


-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    
    [self.view endEditing:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpCommintButton{
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commintSafetyCheck)];
    self.navigationItem.rightBarButtonItem  = rightBarBtn;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

#pragma  mark 此处添加提交接口
- (void)commintSafetyCheck{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"提交服务器" otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        if (!self.checkDetailModel.manageManName.length||!self.checkDetailModel.manageManTel.length||!self.checkDetailModel.technologyManName.length||!self.checkDetailModel.technologyManTel.length||!self.checkDetailModel.qualityManName.length||!self.checkDetailModel.qualityManTel.length||!self.checkDetailModel.safetyManName.length||!self.checkDetailModel.safetyManTel.length) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整项目人员信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.buildAreaSize.length||!self.checkDetailModel.costOfConstruction.length||!self.checkDetailModel.landUp.length||!self.checkDetailModel.landDown.length||!self.checkDetailModel.strutClassName.length||!self.checkDetailModel.buildPersons.length){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整项目概况" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.beginDate.length){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择实际开工日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.endDate.length){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择实际完工日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.progress.length){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写形象进度" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.checkDate.length){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.spotInfos.count){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择抽查情况" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkDetailModel.improve.length){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写改进要求" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else if(!self.checkPointList.count){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加相关问题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else{
            
            if (self.checkDetailModel.checkImagesArr.count!=self.checkPointList.count) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加检查图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else if(self.checkDetailModel.safetyContentArr.count!=self.checkPointList.count){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加检查问题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                
                self.hud =  [MBProgressHUD showMessage:@"正在上传中..."];
                
                 [self uploadFileByHttp];
                
            }
       
        }
 
    }
}


-(void)subitTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = [self projectNameView] ;
    self.tableView.tableFooterView =[[UIView alloc] init];
    
//    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableView setSeparatorInset:UIEdgeInsetsMake(43.5, 8, WinWidth-16, 8)];
//        
//    }
//    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self.tableView setLayoutMargins:UIEdgeInsetsMake(43.5, 8, WinWidth-16, 8)];
//    }
    
}

- (UIView *)projectNameView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    
    UILabel *projectLable =[[UILabel alloc] initWithFrame:CGRectMake(12, 0, WinWidth-12*2, 40)];
    projectLable.font = [UIFont boldSystemFontOfSize:17.0];
    projectLable.text =self.checkDetailModel.deptName;
    [view addSubview:projectLable];
    view.backgroundColor=[UIColor whiteColor];

    
    return view;
}


#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section ==0) {
        if (isClose) {
            return 0;
        }
        return 4;
    }
    if (section ==1) {
        if (isShut) {
            return 0;
        }
        return 3;
    }
    if (section==2) {
        return 3;
    }
    else if(section==2){
        return 3;
    }else if(section==3){
        return 2;
    }
    else if (section ==4) {
        return  1;
    }
    if (section==5) {
        if (self.checkPointList.count) {
            return self.checkPointList.count;
        }else{
            return 1;
        }
    }
    
     return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            //删除并进行重新分配
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    if (indexPath.section ==0) {
        if (!isClose) {
            static NSString *identifier1 = @"cell1";
            UITableViewCell  *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier1];
            cell1.selectionStyle=UITableViewCellSelectionStyleNone;
            cell1.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell1.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell1.detailTextLabel.textColor = [UIColor blackColor];
            if (indexPath.row==0) {
                
                if (self.checkDetailModel.manageManName) {
                    cell1.textLabel.text = [NSString stringWithFormat:@"项目经理：%@",self.checkDetailModel.manageManName];
                }else{
                     cell1.textLabel.text =@"项目经理：";
                }
                
                if (self.checkDetailModel.manageManTel) {
                    cell1.detailTextLabel.text = self.checkDetailModel.manageManTel;
                }
                
   
            }else if(indexPath.row==1){
                
                if (self.checkDetailModel.technologyManName) {
                    
                    cell1.textLabel.text = [NSString stringWithFormat:@"技术负责人：%@",self.checkDetailModel.technologyManName];
                }else{
                    cell1.textLabel.text =@"技术负责人：";
                }
               
                if (self.checkDetailModel.technologyManTel) {
                    cell1.detailTextLabel.text = self.checkDetailModel.technologyManTel;
                }
                
                
                UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(WinWidth-25,36.5, W(15), 7.5)];
                img.image = [UIImage imageNamed:@"001"];
                img.contentMode =NSTextAlignmentRight;
                img.contentMode = UIViewContentModeScaleAspectFit;
                [cell1.contentView addSubview:img];

    
            }else if(indexPath.row==2){
                if (self.checkDetailModel.qualityManName) {
                    cell1.textLabel.text = [NSString stringWithFormat:@"质检员：%@",self.checkDetailModel.qualityManName];
                }else{
                   cell1.textLabel.text =@"质检员：";
                }
                
                if (self.checkDetailModel.qualityManTel) {
                    cell1.detailTextLabel.text = self.checkDetailModel.qualityManTel;
                }
                
                
                UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(WinWidth-25,0, W(15), 7.5)];
                img.image = [UIImage imageNamed:@"002"];
                img.contentMode =NSTextAlignmentRight;
                img.contentMode = UIViewContentModeScaleAspectFit;
                [cell1.contentView addSubview:img];

            }else if(indexPath.row==3){
                if (self.checkDetailModel.safetyManName) {
                    cell1.textLabel.text = [NSString stringWithFormat:@"安全员：%@",self.checkDetailModel.safetyManName];
                }else{
                     cell1.textLabel.text =@"安全员：";
                }
                
                if (self.checkDetailModel.safetyManTel) {
                     cell1.detailTextLabel.text = self.checkDetailModel.safetyManTel;
                }
               

            }
             cell1.accessoryView  = [[UIView alloc] init];
            
            return cell1;

        }
     
        
    }else if (indexPath.section ==1) {
        if (!isShut) {
            static NSString *identifier5 = @"cell5";
            UITableViewCell  *cell5 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier5];
            cell5.selectionStyle=UITableViewCellSelectionStyleNone;
            cell5.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell5.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell5.detailTextLabel.textColor = [UIColor blackColor];
            if (indexPath.row==0) {
                
                if (self.checkDetailModel.buildAreaSize) {
                    cell5.textLabel.text = [NSString stringWithFormat:@"建筑面积：%@㎡",self.checkDetailModel.buildAreaSize];
                }else{
                    cell5.textLabel.text =@"建筑面积：";
                }
                
                if (self.checkDetailModel.costOfConstruction) {
                     cell5.detailTextLabel.text = [NSString stringWithFormat:@"造价：%@万元",self.checkDetailModel.costOfConstruction];
                }else{
                    cell5.detailTextLabel.text =@"造价：";
                }
                cell5.accessoryView  = [[UIView alloc] init];
                

            }else if(indexPath.row==1){
                
                if (self.checkDetailModel.landUp) {
                    cell5.textLabel.text = [NSString stringWithFormat:@"结构层数：地上:%@层",self.checkDetailModel.landUp];
                }else{
                    cell5.textLabel.text =@"结构层数：地上:";
                }
                
                if (self.checkDetailModel.landDown) {
                     cell5.detailTextLabel.text = [NSString stringWithFormat:@"地下：%@层",self.checkDetailModel.landDown];
                }else{
                  cell5.detailTextLabel.text =@"地下：";
                    
                }
               cell5.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      
            }else if(indexPath.row==2){
                if (self.checkDetailModel.strutClassName) {
                    cell5.textLabel.text = [NSString stringWithFormat:@"结构类型：%@",self.checkDetailModel.strutClassName];
                }else{
                      cell5.textLabel.text =@"结构类型：";
                }
                
                if (self.checkDetailModel.buildPersons) {
                    cell5.detailTextLabel.text = [NSString stringWithFormat:@"参建人数：%@人",self.checkDetailModel.buildPersons];
                    
                }else{
                    
                    cell5.detailTextLabel.text =@"参建人数：";
                }
                 cell5.accessoryView  = [[UIView alloc] init];
        
            }
           
            
             return cell5;

        }
        
    }else if (indexPath.section==2) {
        
        static NSString *identifier6 = @"cell6";
        UITableViewCell  *cell6 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier6];
        cell6.selectionStyle=UITableViewCellSelectionStyleNone;
        cell6.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell6.detailTextLabel.font = [UIFont systemFontOfSize:14.0];

        cell6.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
            cell6.textLabel.text = @"实际开工日期";
            if (self.checkDetailModel.beginDate) {
                cell6.detailTextLabel.text = self.checkDetailModel.beginDate;
            }
            
        }else  if (indexPath.row==1) {
            cell6.textLabel.text = @"计划完工日期";
            if (self.checkDetailModel.endDate) {
                cell6.detailTextLabel.text = self.checkDetailModel.endDate;
            }
            
        }else  if (indexPath.row==2) {
            cell6.textLabel.text = @"形象进度：";
            [cell6.contentView addSubview:self.textField];
            cell6.accessoryType =UITableViewCellAccessoryNone;
        }
       
        return  cell6;
        
    }else if(indexPath.section ==3){
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
            cell.textLabel.text = @"检查日期";
            NSDate *  senddate=[NSDate date];

            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            
            [dateformatter setDateFormat:@"YYYY-MM-dd"];
            
            NSString *  locationStr=[dateformatter stringFromDate:senddate];
            
            if (!self.checkDetailModel.checkDate) {
                
                self.checkDetailModel.checkDate = locationStr;
          }
            
            cell.detailTextLabel.text =  self.checkDetailModel.checkDate;
           
        }else if(indexPath.row==1) {
            cell.textLabel.text = @"抽查情况";
         
            if(spotProNum==-1){
                
                cell.detailTextLabel.text  = @"请选择抽查情况";
                
            }else if(spotProNum==0){
                
                cell.detailTextLabel.text  = @"不存在问题";
                
            }else{
                
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%li项存在问题",(long)spotProNum];
            }
            

        }
    }else if (indexPath.section ==4){
        static NSString *identifier7 = @"cell7";
        UITableViewCell  *cell7 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier7];
        cell7.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        [self.enhancementRequestsTextView.layer setCornerRadius:10];
        self.enhancementRequestsTextView =[[BRPlaceholderTextView alloc]initWithFrame:CGRectMake(12, 5, WinWidth-24, 78)];
        self.enhancementRequestsTextView.delegate =self;
        self.automaticallyAdjustsScrollViewInsets =NO;
        self.enhancementRequestsTextView.textAlignment =NSTextAlignmentLeft;
        self.enhancementRequestsTextView.font =[UIFont systemFontOfSize:14.0];
        self.enhancementRequestsTextView.editable =YES;
        self.enhancementRequestsTextView.backgroundColor =[UIColor clearColor];
        self.enhancementRequestsTextView.layer.cornerRadius =6.0f;
        self.enhancementRequestsTextView.layer.borderWidth =1;
        self.enhancementRequestsTextView.layer.borderColor =NAVI_SECOND_COLOR.CGColor;
        self.enhancementRequestsTextView.placeholder = @"请输入改进要求";

        [cell7.contentView addSubview:self.enhancementRequestsTextView];
        
        self.enhancementRequestsTextView.text = self.checkDetailModel.improve;

        return cell7;
        
    }
    else if (indexPath.section ==5){
        if (self.checkPointList.count) {
            
            BCSMAddSafetyCheckTableViewCell *addSafetyCell =(BCSMAddSafetyCheckTableViewCell *)[self getCellWithTableView:tableView andIndexPath:indexPath];
            
            for (NSDictionary *dict in self.checkDetailModel.checkImagesArr) {
                NSIndexPath *indexPath1 = dict[@"indexPath"];
                if (indexPath1.row  == indexPath.row) {
                    addSafetyCell.sendImageArr  =dict[@"checkImages"];
                }
            }
            
            NSArray *tempContentArr;
            for (NSDictionary *dict in self.checkDetailModel.safetyContentArr) {
                NSIndexPath *indexPath1 = dict[@"indexPath"];
                if (indexPath1.row  == indexPath.row) {
                     tempContentArr =dict[@"safetyContent"];
                }
            }
            addSafetyCell.contentArr= tempContentArr;
            
            BCSMCheckPointModel *checkPoint  = self.checkPointList[indexPath.row];
            NSString *numStr  =[NSString stringWithFormat:@"%li",(long)indexPath.row+1];
            NSString *positionName  =[NSString stringWithFormat:@"%@.%@",[NSString translation:numStr],checkPoint.positionName];
            addSafetyCell.checkPointName = positionName;
            
            __weak typeof(self)weakself = self;
            addSafetyCell.addImagesBlock = ^(){
                
                [weakself takePhotoWithIndexPaht:indexPath];
                
            };
            
            addSafetyCell.deletateImageBlock=^(){
                
                [weakself.tableView reloadData];
            };
            
            
            addSafetyCell.showImageView=^(NSArray *imgArr,NSInteger tag){
                
                [weakself scanPhotoWithImgArr:imgArr andTag:tag];
                
            };
            
            addSafetyCell.addProblem= ^(){
                
                SMSafetyCheckAddProViewController *smsafetyCheckFLVC =[[SMSafetyCheckAddProViewController alloc] init];
                smsafetyCheckFLVC.isEditing=NO;
                smsafetyCheckFLVC.compareArr = tempContentArr;
                
                smsafetyCheckFLVC.passCheckPro = ^(SMSafetyContent *safetyContent){
                    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:weakself.checkDetailModel.safetyContentArr];
                
                    NSInteger num = 0;
                    NSMutableArray *tempArr2 = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict1 in weakself.checkDetailModel.safetyContentArr) {
                        NSIndexPath *indexPath1 = dict1[@"indexPath"];
                        if (indexPath1.row==indexPath.row) {
                            num++;
                            NSArray *contentArr = dict1[@"safetyContent"];
                            
                            [tempArr2 addObjectsFromArray:contentArr];
                            [tempArr2 addObject:safetyContent];
                            
                            [tempArr removeObject:dict1];
                        }
                    }
                    
                    if (num==0) {
                        [tempArr2 addObject:safetyContent];
                    }
                    
                    NSDictionary *dict = @{@"indexPath":indexPath,@"safetyContent":tempArr2};
                    
                    [tempArr addObject:dict];
                    
                    weakself.checkDetailModel.safetyContentArr =tempArr;
                    [weakself.tableView reloadData];
                    
                };
                
                [self.navigationController pushViewController:smsafetyCheckFLVC animated:YES];
                
            };
            
            addSafetyCell.deleteProCell  =  ^(SMSafetyContent *safetyContent){
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:weakself.checkDetailModel.safetyContentArr];
                
                for (NSDictionary *dict1 in weakself.checkDetailModel.safetyContentArr) {
                    NSIndexPath *indexPath1 = dict1[@"indexPath"];
                    NSArray *contentArr = dict1[@"safetyContent"];
                    NSMutableArray *tepArr=[[NSMutableArray alloc] initWithArray:contentArr];
                    if (indexPath1.row==indexPath.row) {
                        
                        [tepArr removeObject:safetyContent];
                        
                        if (tepArr.count==0) {
                        
                            [tempArr removeObject:dict1];
                        
                        }else{
                            
                            NSDictionary *dict = @{@"indexPath":indexPath,@"safetyContent":tepArr};
                            [tempArr removeObject:dict1];
                            [tempArr addObject:dict];
                            
                        }
                        
                        break;
                    }
                }
                
        
                
                weakself.checkDetailModel.safetyContentArr =tempArr;
                
                [weakself.tableView reloadData];
            };
            
            addSafetyCell.editProblem  = ^(SMSafetyContent *safetyContent){
                
                SMSafetyCheckAddProViewController *safetycheckAddProVC=[[SMSafetyCheckAddProViewController alloc] init];
                
                safetycheckAddProVC.safetyContent  =safetyContent;
                
                safetycheckAddProVC.passCheckPro=^(SMSafetyContent *safetyContent2){
                    
                    NSInteger num = 0;
                    for (SMSafetyContentSecondDetail *secondDetail in safetyContent2.sections) {
                        if (secondDetail.isOpen) {
                            num++;
                        }
                    }
                    
                    
                    NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:weakself.checkDetailModel.safetyContentArr];
                    
                    for (NSDictionary *dict1 in weakself.checkDetailModel.safetyContentArr) {
                        NSIndexPath *indexPath1 = dict1[@"indexPath"];
                        if (indexPath1.row == indexPath.row) {
                            
                            NSArray *contentArr = dict1[@"safetyContent"];
                            NSMutableArray *tepArr=[[NSMutableArray alloc] initWithArray:contentArr];
                            if (num) {
                                
                                for (int i =0;i<contentArr.count;i++) {
                                    SMSafetyContent *tempContent = contentArr[i];
                                    if (tempContent==safetyContent) {
                                        [tepArr insertObject:safetyContent2 atIndex:i];
                                        [tepArr removeObject:tempContent];
                                    }
                                }
                                
                                NSDictionary *dict = @{@"indexPath":indexPath,@"safetyContent":tepArr};
                                [tempArr removeObject:dict1];
                                [tempArr addObject:dict];
                                
                            }else{
                                
                                for (int i =0;i<contentArr.count;i++) {
                                    SMSafetyContent *tempContent = contentArr[i];
                                    if (tempContent==safetyContent) {
                                        
                                        [tepArr removeObject:tempContent];
                                    }
                                }
                                 NSDictionary *dict = @{@"indexPath":indexPath,@"safetyContent":tepArr};
                                
                                [tempArr removeObject:dict1];
                                if (tepArr.count) {
                                    [tempArr addObject:dict];
                                }
            
                            }
                            
                        }
                        
                    }
                    
                    weakself.checkDetailModel.safetyContentArr = tempArr;
                    [weakself.tableView reloadData];
                    
                };
                
                safetycheckAddProVC.isEditing=YES;
                [self.navigationController pushViewController:safetycheckAddProVC animated:YES];
                
                
                
            };
            
            //删除整个cell
            addSafetyCell.deleteAll = ^(){
                [self.checkPointList removeObjectAtIndex:indexPath.row];
                NSMutableArray *tempArr = [[NSMutableArray alloc] initWithArray:weakself.checkDetailModel.checkImagesArr];
                NSInteger num=0;
                for (NSDictionary *dict in weakself.checkDetailModel.checkImagesArr) {
                    NSIndexPath *indexPath1 = dict[@"indexPath"];
                    if (indexPath1.row  == indexPath.row) {
                        num  = indexPath1.row;
                        [tempArr removeObject:dict];
                    }
                }
                
                NSMutableArray *tempArr3 = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in tempArr) {
                     NSIndexPath *indexPath1 = dict[@"indexPath"];
                    
                    if (indexPath1.row>num) {
                        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath1.row-1 inSection:indexPath1.section];
                        NSArray *imgArr =  dict[@"checkImages"];
                        NSDictionary *dict2 = @{@"indexPath":indexPath2,@"checkImages":imgArr};
                         [tempArr3 addObject:dict2];
                    }else{
                        [tempArr3 addObject:dict];
                    }
                   
                   
                }
                weakself.checkDetailModel.checkImagesArr = tempArr3;
                
                NSMutableArray *tempArr2 = [[NSMutableArray alloc] initWithArray:weakself.checkDetailModel.safetyContentArr];
                for (NSDictionary *dict in weakself.checkDetailModel.safetyContentArr) {
                    NSIndexPath *indexPath1 = dict[@"indexPath"];
                    if (indexPath1.row  == indexPath.row) {
                        [tempArr2 removeObject:dict];
                    }
                }
                
                NSMutableArray *tempArr4 = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in tempArr2) {
                    NSIndexPath *indexPath1 = dict[@"indexPath"];

                    if (indexPath1.row>num) {
                        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:indexPath1.row-1 inSection:indexPath1.section];
                        NSArray  *contentArr =  dict[@"safetyContent"];
                        NSDictionary *dict2 = @{@"indexPath":indexPath2,@"safetyContent":contentArr};
                        [tempArr4 addObject:dict2];
                        
                    }else{
                        [tempArr4 addObject:dict];
                    }

                }
                
                weakself.checkDetailModel.safetyContentArr = tempArr4;
                
                [weakself.tableView reloadData];
            };
            
            return addSafetyCell;
   
        }else{
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 44.0)];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font =[UIFont systemFontOfSize:15.0];
            [btn setTitle:@"添加改进要求" forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"2-2"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(increasedEnhancementRequests:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btn];
            
        }

    
    
    }
    
    
    return cell;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (void)takePhotoWithIndexPaht:(NSIndexPath *)indexPath{
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    
    NSInteger num = 0;
    for (NSDictionary *dict in self.checkDetailModel.checkImagesArr) {
        NSIndexPath *indexPaht1  = dict[@"indexPath"];
        if (indexPaht1.row == indexPath.row) {
            num++;
            NSArray *tempArr = dict[@"checkImages"];
            pickerVc.maxCount  = 5-tempArr.count;
        }
    }
    if (num==0) {
        pickerVc.maxCount  = 5;
    }
    
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        
        NSMutableArray *imagelist = [[NSMutableArray alloc] initWithArray: weakSelf.checkDetailModel.checkImagesArr];
    
        NSMutableArray *photoArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in self.checkDetailModel.checkImagesArr) {
            NSIndexPath *indexPaht1  = dict[@"indexPath"];
            if (indexPaht1.row == indexPath.row) {
                NSArray *tempArr = dict[@"checkImages"];
                [photoArr addObjectsFromArray:tempArr];
                [imagelist removeObject:dict];
    
            }
        }
        
        for (MLSelectPhotoAssets *asset in assets) {
            UIImage *image =[MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [photoArr addObject:image];
        }
        
        NSDictionary *dict = @{@"indexPath":indexPath,@"checkImages":photoArr};
        [imagelist addObject:dict];
        self.checkDetailModel.checkImagesArr = imagelist;
        
        [weakSelf.tableView reloadData];
    };
    
}

- (void)scanPhotoWithImgArr:(NSArray *)imgArr andTag:(NSInteger)tag{
    NSMutableArray *photosArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<imgArr.count; i++) {
        MWPhoto *photo = [MWPhoto photoWithImage:imgArr[i]];
        [photosArr  addObject:photo];
    }
    self.photos  = photosArr;
    
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:tag];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index1 {
    if (index1 < self.photos.count)
        return [self.photos objectAtIndex:index1];
    return nil;
}


//新增检查部位
-(void)increasedEnhancementRequests:(UIButton*)btn{
    
    BCSMCheckPointViewController *checkpointVC =[[BCSMCheckPointViewController alloc]init];
    __weak typeof(self)weakself = self;
    checkpointVC.passValue =^(BCSMCheckPointModel *checkpoint){
        
        [weakself.checkPointList addObject:checkpoint];
        [weakself.tableView reloadData];
       
    };

    [self.navigationController pushViewController:checkpointVC animated:YES];


}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{

    BCSMAddSafetyCheckTableViewCell   *cell=[[BCSMAddSafetyCheckTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    return cell;
}

//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        if (isClose) {
            return 0;
        }
        return 44.0;
    }
    if (indexPath.section ==1) {
        if (isShut) {
            return 0;
        }
        return 44.0;
    }
    if (indexPath.section ==4) {
        
        return  44.0*2;
    }
    if (indexPath.section == 5) {
        if (self.checkPointList.count) {
            BCSMAddSafetyCheckTableViewCell *addSafetyCell =(BCSMAddSafetyCheckTableViewCell *)[self getCellWithTableView:tableView andIndexPath:indexPath];
            
            for (NSDictionary *dict in self.checkDetailModel.checkImagesArr) {
                NSIndexPath *indexPath1 = dict[@"indexPath"];
                if (indexPath1.row  == indexPath.row) {
                    addSafetyCell.sendImageArr  =dict[@"checkImages"];
                }
            }
            
            for (NSDictionary *dict in self.checkDetailModel.safetyContentArr) {
                NSIndexPath *indexPath1 = dict[@"indexPath"];
                if (indexPath1.row  == indexPath.row) {
                    addSafetyCell.contentArr  =dict[@"safetyContent"];
                }
            }
            BCSMCheckPointModel *checkPoint  = self.checkPointList[indexPath.row];
            addSafetyCell.checkPointName = checkPoint.positionName;
          
            return addSafetyCell.cellHeight;
        }
    }
    return 44.0;
    
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __block typeof(self)weakself =self;
    if (indexPath.section ==0) {
        
        BCSMProjectPersonnelInformationViewController *personnelInfoVC =[[BCSMProjectPersonnelInformationViewController alloc]init];
        personnelInfoVC.detailModel  = self.checkDetailModel;
        personnelInfoVC.passPersonnelInfo = ^(BCSMSafetyCheckDetailModel *safetyCheckDetailModel){
            
            weakself.checkDetailModel = safetyCheckDetailModel;
            
            weakself.checkDetailModel.isModify = 1;
            
            [weakself.tableView reloadData];
            
        };
        [self.navigationController pushViewController:personnelInfoVC animated:YES];
        
    }else if (indexPath.section==1) {
        
        BCSMProjectSummaryViewController *summaryVC =[[BCSMProjectSummaryViewController alloc]init];
        summaryVC.detailModel = self.checkDetailModel;

        summaryVC.passProjectSummary = ^(BCSMSafetyCheckDetailModel *safetyCheckDetailModel){
            
            weakself.checkDetailModel = safetyCheckDetailModel;

            weakself.checkDetailModel.isModify = 1;
            
            [weakself.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:summaryVC animated:YES];
        
    }else if (indexPath.section ==2&&(indexPath.row ==0||indexPath.row ==1)) {
        
        popIndexPath = indexPath;
        [_pop show];
        
    }else if (indexPath.section ==3&&indexPath.row ==0) {
        
         popIndexPath = indexPath;
        [_pop show];
        
    }else if (indexPath.section ==3&&indexPath.row ==1) {
        
        BCSMSpotCheckListViewController *spotVC=[[BCSMSpotCheckListViewController alloc] init];
            
            __weak typeof(self)weakself = self;
            spotVC.passSpotCheck  =^(NSArray *spotInfos){
                
                weakself.checkDetailModel.spotInfos = spotInfos;
                
                NSInteger num=0;
                for (BCSMSpotinfos *spot in spotInfos) {
                    if (spot.spotId==2||spot.spotId==4) {
                        num++;
                    }
                }
                spotProNum = num;
                [weakself.tableView reloadData];
            };
            spotVC.isEdit =YES;
            spotVC.spotInfos = [self.checkDetailModel.spotInfos mutableCopy];
            [self.navigationController pushViewController:spotVC animated:YES];
    }else if (indexPath.section ==4&&indexPath.row==0) {
        
        NSRange range = NSMakeRange([self.enhancementRequestsTextView.text length]-1, 1);
        [self.enhancementRequestsTextView scrollRangeToVisible:range];
        
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *arr = @[@"项目人员信息",@"项目概况",@"项目时间与进展",@"请填写检查情况",@"请填写改进要求",@"相关问题"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,20 , 20)];
    imageView.image = [UIImage imageNamed:@"checkHeadImage-1"];
    [view addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 10, WinWidth-50, 20)];
    lable.text = arr[section];
    lable.font = [UIFont boldSystemFontOfSize:15.0];
    lable.textColor = NAVI_SECOND_COLOR;
    
    [view addSubview:lable];

    
    if (section==0) {
     
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(WinWidth-40, 0, 40, 40)];
        [view addSubview:btn];
        if (isClose) {
            [btn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
            UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 39.5, WinWidth, 0.5)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [view addSubview:lineView];
        }
        else if (!isClose){
            [btn setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
        }
        btn.tag =100;
        [btn addTarget:self action:@selector(showContracterDetail:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if(section==1){
        
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(WinWidth-40, 0, 40, 40)];
        [view addSubview:btn];
        if (isShut) {
             [btn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:UIControlStateNormal];
            UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, 39.5, WinWidth, 0.5)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [view addSubview:lineView];
        }
        else if (!isShut){
             [btn setImage:[UIImage imageNamed:@"arrow_up.png"] forState:UIControlStateNormal];
        }
        
        btn.tag =101;
        
        [btn addTarget:self action:@selector(showEnginSurveyDetail:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (section ==5){
        UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(WinWidth-70, 0, 60, 40)];
         button.hidden=YES;
        [button setTitle:@"添加" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0] forState:UIControlStateNormal];
        button.titleLabel.font =[UIFont systemFontOfSize:15.0];
        [button addTarget:self action:@selector(increasedEnhancementRequests:) forControlEvents:UIControlEventTouchUpInside];
        button.tag =102;
        [view addSubview:button];
        
        if(self.checkPointList.count){
            button.hidden=NO;
        }
    
    }
    
    return view;
}



//更多联系人
- (void)showContracterDetail:(UIButton *)btn{
    btn.selected =!btn.selected;
    isClose =!isClose;
    
    [self.tableView reloadData];
    
}

//工程详细
- (void)showEnginSurveyDetail:(UIButton *)btn{
    btn.selected =!btn.selected;
    isShut =!isShut;
    
    [self.tableView reloadData];
}

#pragma mark TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *strUrl = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length) {
        self.checkDetailModel.improve = textView.text;
    }else{
        textView.text= nil;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString *strUrl = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (strUrl.length) {
        self.checkDetailModel.progress = textField.text;
    }else{
        textField.text= nil;
    }


}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section==0||indexPath.section==1) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(43.5, 8, WinWidth-W(16),24)];

    }else{
         [cell setSeparatorInset:UIEdgeInsetsMake(43.5, 8, WinWidth-W(16),8)];
    }
}



//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//拉取单条最新项目信息接口
- (void)queryHistoryInfoWithCompanyId{
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"加载中..."];
    NSDictionary *parameters  = @{@"companyId":self.companyId,
                                  };
    [NetRequestClass NetRequestGETWithRequestURL:kSubQueryHistoryInfoWithCompanyId WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        hud.hidden = YES;
        NSDictionary *dict= returnValue;
        
        NSDictionary *contentDict=dict[@"items"];
        
        BCSMSafetyCheckDetailModel *detailModel  =[BCSMSafetyCheckDetailModel mj_objectWithKeyValues:contentDict];
        
        self.checkDetailModel = detailModel;
        
        [self subitTableView];
        
    } WithErrorCodeBlock:^(id errorCode) {
        hud.hidden = YES;
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        hud.hidden = YES;
    }];

}


//上传图片
- (void)uploadFileByHttp{
    NSMutableArray *tempArr =[[NSMutableArray alloc] initWithArray:self.checkDetailModel.checkImagesArr];
    for (int i=0; i<tempArr.count; i++) {
        
        NSDictionary *dict = tempArr[i];
            
            __block    NSDictionary *imagesDict  =dict;
            
            NSArray *imageArr = dict[@"checkImages"];
            
            NSMutableArray *pathArr=[[NSMutableArray alloc] init];
            for (int j =0; j<imageArr.count; j++) {
                
                dispatch_async([self serialQueue], ^{
                    dispatch_suspend([self serialQueue]);
                    
                    
                    NSDictionary *parameters =@{};
                    
                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                    AccountModel *account =[AccountModel shareAccount];
                    [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"mobile"];
                    [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
                    [manager.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
                    
                    long long dateNum = [[NSDate date] timeIntervalSince1970] * 1000;
                    
                    NSString *sha1str=[NSString stringWithFormat:@"%@%lld",account.credential,dateNum];
                    sha1str =  [BCSMAddSafetyCheckViewController sha1:sha1str];
                    [manager.requestSerializer setValue:sha1str forHTTPHeaderField:@"encryptBody"];
                    
                    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",dateNum] forHTTPHeaderField:@"timestamp"];
                    
                    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                    NSMutableArray *tempImgArr=[[NSMutableArray alloc] init];
                    [manager POST:kSubCompanyUploadFileByHttp parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                        
                        
                        UIImage *image = imageArr[j];
                        NSData *data = UIImageJPEGRepresentation(image.fixOrientation, 1) ;
                        CGFloat length = [data length]/1000;
                        
                        if (length>500) {
                            data = UIImageJPEGRepresentation(image.fixOrientation, 0.2) ;
                        }
                        length = [data length]/1000;
                        NSLog(@"%f",length) ;
                        NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                        NSDate *date=[NSDate date];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
                        NSString *currentDateStr = [formatter stringFromDate:date];
                        jpgPath = [jpgPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",currentDateStr]];
                        [data writeToFile:jpgPath atomically:YES];
                        // 将本地的文件上传至服务器
                        NSURL *fileURL = [NSURL fileURLWithPath:jpgPath];
                        [tempImgArr addObject:[NSString stringWithFormat:@"%@.jpg",currentDateStr]];
                        [formData appendPartWithFileURL:fileURL name:@"0" fileName:[NSString stringWithFormat:@"%@.jpg",currentDateStr] mimeType:@"image/jpeg" error:nil];
                        
                        
                    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        dispatch_resume([self serialQueue]);
                        
                        for (NSString *str in tempImgArr) {
                            [self clearUploadImageCachesWithImgName:str];
                        }
                        
                        if (operation.response.allHeaderFields[@"credential"]) {
                            account.credential =operation.response.allHeaderFields[@"credential"];
                        }
                        if (operation.response.allHeaderFields[@"token"]) {
                            account.token      =operation.response.allHeaderFields[@"token"];
                        }
                        
                        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                        
                        NSLog(@"完成 %@", result);
                        if ([dic[@"msg"] isEqualToString:@"非法请求!"]) {
                            self.hud.hidden=YES;
                            [self restartLogin];
                        }else{
                            [pathArr addObject: dic[@"items"]];
                            if (j==imageArr.count-1) {
                                NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithDictionary:self.checkDetailModel.checkImagesArr[i]];
                                 NSString *str=[pathArr componentsJoinedByString:@"|"];
                                [dict2 setObject:str forKey:@"imagePath"];
                                
                                imagesDict = [dict2 copy];
                                
                                [tempArr replaceObjectAtIndex:i withObject:dict2];
                                
                                self.checkDetailModel.checkImagesArr = [tempArr copy];
                
                           }
                            
                            if (i==self.checkDetailModel.checkImagesArr.count-1&&j==imageArr.count-1) {
                                [self addCheckInfoRequset];
                            }
                            
                        }
                        
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        for (NSString *str in tempImgArr) {
                            [self clearUploadImageCachesWithImgName:str];
                        }
                        self.hud.hidden=YES;
                        [MBProgressHUD showError:@"上传失败" toView:self.view];
                        NSLog(@"错误 %@", error);
                    }];
                });
                
                
            }

    }
    
}


- (void)addCheckInfoRequset{
    
    self.checkDetailModel.progress  = self.textField.text;
    self.checkDetailModel.improve = self.enhancementRequestsTextView.text;
    
    NSMutableArray *tempArr =[[NSMutableArray alloc] init];
    
    for ( int h =0; h<self.checkDetailModel.safetyContentArr.count; h++) {
        NSDictionary *dict = self.checkDetailModel.safetyContentArr[h];
        
        NSIndexPath *indexPath = dict[@"indexPath"];
        
        NSInteger classType =indexPath.row;
        
        NSArray *contentArr  = dict[@"safetyContent"];
        
        for (SMSafetyContent *content in contentArr) {
            
            for (int i =0; i<content.sections.count; i++) {
                SMSafetyContentSecondDetail *secondDetail =content.sections[i];
                
                if (secondDetail.isOpen) {
                    
                    for (int j =0; j<secondDetail.sections.count; j++) {
                        
                        SMSafetyContentThirdDetail *thirdDetail  =secondDetail.sections[j];
                        
                        if (thirdDetail.isOpen) {
                            
                            BCSMCompanycheckdetails *smacheckInfoDelist=[[BCSMCompanycheckdetails alloc] init];
                            smacheckInfoDelist.checkContentId=content.classID;
                            smacheckInfoDelist.checkItemId   =secondDetail.classID;
                            if ([thirdDetail.classID isEqualToString:@"-1"]) {
                                
                                smacheckInfoDelist.problemDesc=thirdDetail.name;
                                
                            }else{
                                
                                smacheckInfoDelist.checkProblemId=thirdDetail.classID;
                            }
                            
                            smacheckInfoDelist.classType = classType;
                            [tempArr addObject:smacheckInfoDelist];
                        }
                        
                    }
                }
                
            }
            
            
        }
 
    }
    
    NSArray *proArr=[BCSMCompanycheckdetails mj_keyValuesArrayWithObjectArray:tempArr];
    
    NSMutableArray *tempArr2= [[NSMutableArray alloc] init];
    for (int h=0; h<self.checkDetailModel.checkImagesArr.count; h++) {
        NSDictionary *dict = self.checkDetailModel.checkImagesArr[h];
        NSIndexPath *indexPath = dict[@"indexPath"];
        NSInteger classType =indexPath.row;
        NSString  *imagePath = dict[@"imagePath"];
        BCSMCompanycheckimages *checkImages =[[BCSMCompanycheckimages alloc] init];
        checkImages.classType = classType;
        checkImages.imagePath = imagePath;
        BCSMCheckPointModel *checkPoint = self.checkPointList[h];
        checkImages.checkPosId = checkPoint.checkPosId.integerValue;
        checkImages.positionName = checkPoint.positionName;
        [tempArr2 addObject:checkImages];
    }
    
    NSArray *imagesArr  =[BCSMCompanycheckimages mj_keyValuesArrayWithObjectArray:tempArr2];
    
    NSArray *spotInfos = [BCSMSpotinfos mj_keyValuesArrayWithObjectArray:self.checkDetailModel.spotInfos];

    NSDictionary *parameters =@{@"manageManName":self.checkDetailModel.manageManName,
                                @"manageManTel":self.checkDetailModel.manageManTel,
                                @"qualityManName":self.checkDetailModel.qualityManName,
                                @"qualityManTel":self.checkDetailModel.qualityManTel,
                                @"deptName":self.checkDetailModel.deptName,
                                @"technologyManName":self.checkDetailModel.technologyManName,
                                @"technologyManTel":self.checkDetailModel.technologyManTel,
                                @"safetyManName":self.checkDetailModel.safetyManName,
                                @"safetyManTel":self.checkDetailModel.safetyManTel,
                                @"buildAreaSize":self.checkDetailModel.buildAreaSize,
                                @"costOfConstruction":self.checkDetailModel.costOfConstruction,
                                
                                @"landUp":self.checkDetailModel.landUp,
                                
                                @"landDown":self.checkDetailModel.landDown,
                                @"strutClass":[NSString stringWithFormat:@"%li",self.checkDetailModel.strutClass],
                                @"strutClassName":self.checkDetailModel.strutClassName,
                                @"buildPersons":self.checkDetailModel.buildPersons,
                                
                                @"beginDate":self.checkDetailModel.beginDate,
                                @"endDate":self.checkDetailModel.endDate,
                                @"checkDate":self.checkDetailModel.checkDate,
                                @"progress":self.checkDetailModel.progress,
                                @"improve":self.checkDetailModel.improve,
                                
                                @"historyCompanyId":[NSString stringWithFormat:@"%li",self.checkDetailModel.companyId],
                                @"companyCheckImages":imagesArr,
                                @"companyCheckDetails":proArr,
                                @"spotInfos":spotInfos,
                                @"isModify":[NSString stringWithFormat:@"%li",self.checkDetailModel.isModify]
                                };
    
    [NetRequestClass NetJsonRequestPOSTWithRequestURL:kSubAddCompanyCheckInfo WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        self.hud.hidden=YES;
        
        [MBProgressHUD showSuccess:@"上传成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kSecurityCheckList" object:@YES];
        
        [self.navigationController  popViewControllerAnimated:YES];
        
    } WithErrorCodeBlock:^(id errorCode) {
        self.hud.hidden=YES;
        [MBProgressHUD showError:@"上传失败" toView:self.view];
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
    } WithFailureBlock:^{
        
        self.hud.hidden=YES;
        [MBProgressHUD showError:@"上传失败" toView:self.view];
        
    }];
    



}

- (void)clearUploadImageCachesWithImgName:(NSString *)imgName{
    NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    jpgPath = [jpgPath stringByAppendingPathComponent:imgName];
    NSError *error = nil;
    if([[NSFileManager defaultManager] removeItemAtPath:jpgPath error:&error]) { NSLog(@"文件移除成功");
    }
    else { NSLog(@"error=%@", error);
    }
}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag=10;
    [alert show];
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10) {
        
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        
    }
}


+ (NSString *)sha1:(NSString *)inputStr {
    
    const char *cstr = [inputStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithBytes:cstr length:inputStr.length];
    
    
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    
    
    NSMutableString *outputStr = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        
        [outputStr appendFormat:@"%02x", digest[i]];
        
    }
    
    return outputStr;
    
}


@end
