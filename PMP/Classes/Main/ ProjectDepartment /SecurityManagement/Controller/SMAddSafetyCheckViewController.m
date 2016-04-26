//
//  SMAddSafetyCheckViewController.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMAddSafetyCheckViewController.h"
#import "SMAddSafetyCheckTableViewCell.h"
#import "SMSafetyCheckTableViewController.h"
#import "REFrostedViewController.h"
#import "BaseNavigationController.h"
#import "SMIssureCell.h"
#import "SMSafetyContent.h"
#import "SMCheckpointViewController.h"
#import "WHUCalendarPopView.h"
#import "PopMenuTableView.h"
#import "KLCPopup.h"
#import "NetRequestClass.h"
#import "SMIssureAnalysisModel.h"
#import "AccountModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "SMSolveUserList.h"
#import "SMSolveUserListTableViewController.h"
#import "ZJSwitch.h"
#import "SMDraftViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MWCommon.h>
#import <MWPhotoBrowser.h>
#import "UIImage+fixOrientation.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "SMCheckpointModel.h"
#import "SMSafetyCheckFirstLevelViewController.h"
#import "SMSafetyCheckAddProViewController.h"
#import "SMAddSafetyProCell.h"
#define kLableHeight 30

#define kLableWidthLeft W(80)
#define kLableWidthRight W(160)

@interface SMAddSafetyCheckViewController ()<UITableViewDelegate,UITableViewDataSource,SMSafetyCheckViewDelegate,UIActionSheetDelegate,PopMenuDelegate,UIAlertViewDelegate,MWPhotoBrowserDelegate>{
    dispatch_queue_t _serialQueue;
    
    NSInteger lastDeleteIndex;
     WHUCalendarPopView* _pop;
}
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NSMutableArray *issueArr;

@property(nonatomic,strong) NSMutableArray *imgArr;

@property(nonatomic,strong)NSMutableArray *problemArr;

@property(nonatomic,strong)UIView *bottomView;

//日期
@property(nonatomic,strong)NSString *dateString;

@property(nonatomic,strong)NSString *typeStr;

@property(nonatomic,strong)KLCPopup* popup;

@property(nonatomic,strong)ZJSwitch *sw;

@property(nonatomic,strong)MBProgressHUD *hud;

@property(nonatomic,strong)SMSolveUserList *solveUserList;

@property(nonatomic,assign)BOOL isHasPro;

@property(nonatomic,strong)NSUserDefaults *userDefaults;

@property(nonatomic,strong)NSArray *photos;

@property(nonatomic,strong)SMCheckpointModel *checkpoint;

@property(nonatomic,strong)UIButton *addProBtn;

@end

@implementation SMAddSafetyCheckViewController
- (UIButton *)addProBtn{
    if (!_addProBtn) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(WinWidth-80,0 , 50, 55.0)];
        // btn.tag=50;
        btn.titleLabel.font=[UIFont systemFontOfSize:15.0];
        [btn setTitleColor:[UIColor colorWithRed:41/255.0 green:163/255.0 blue:226/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn setTitle:@"添加" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [btn addTarget:self action:@selector(checkIssure:) forControlEvents:UIControlEventTouchUpInside];
        _addProBtn = btn;
    }
    return _addProBtn;
}

- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

- (NSMutableArray *)problemArr{
    if (!_problemArr) {
        _problemArr=[[NSMutableArray alloc]init];
    }
    return _problemArr;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr  =[[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (NSMutableArray *)issueArr{
    if (!_issueArr) {
        _issueArr  =[[NSMutableArray alloc] init];
    }
    return _issueArr;
}

- (NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr =[[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增安全检查";
    self.view.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    
     self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self configSw];
    [self setUpBackBtn];
    [self setUpCommintButton];
    [self configTableView];
    [self configCalendar];
    [self initData];

}

- (void)configSw{
    
    ZJSwitch *sw = [[ZJSwitch alloc] initWithFrame:CGRectMake(WinWidth-70,10,60, 31)];
    sw.backgroundColor = [UIColor clearColor];
    sw.tintColor = [UIColor orangeColor];
    sw.onText = @"有";
    sw.offText = @"无";
    [sw addTarget:self action:@selector(swhasProblem:) forControlEvents:UIControlEventValueChanged];
    self.sw=sw;
    
}

- (void)configCalendar{
    _pop=[[WHUCalendarPopView alloc] init];
    __weak typeof(self)weakself = self;
    _pop.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        weakself.dateString = [format stringFromDate:date];
        
        weakself.issureDetailModel.checkDate=weakself.dateString;
        [weakself.tableView reloadData];
    };
}

- (void)initData{
    if (!self.issureDetailModel) {
        self.issureDetailModel=[[SMIssureDetailModel alloc] init];
        self.issureDetailModel.checkInfoProblemClassList=[[NSMutableArray alloc] init];
        self.isHasPro = YES;
        self.issureDetailModel.hasProblem=1;
        self.issureDetailModel.state  =2;
        
        Checkinfoproblemclasslist *proList = [[Checkinfoproblemclasslist alloc] init];
        proList.imageArr =[[NSMutableArray alloc] init];
        
        proList.classType  = 0;
        
        [self.issureDetailModel.checkInfoProblemClassList addObject:proList];
        
    }else{
        self.solveUserList=[[SMSolveUserList alloc] init];
        //self.bottomView.hidden=YES;
        self.dateString=self.issureDetailModel.checkDate;
        if ( self.issureDetailModel.checkTypeId==1) {
            self.typeStr= @"日常检查";
        }else{
            self.typeStr= @"专项检查";
        }
        
        self.solveUserList.userName = self.issureDetailModel.solveUserName;
        self.solveUserList.realName = self.issureDetailModel.solveRealName;
        if (self.issureDetailModel.hasProblem==1) {
            
            self.isHasPro = YES;
            
        }else{
            self.isHasPro = NO;
        }
        
        self.checkpoint = [[SMCheckpointModel alloc] init];
        self.checkpoint.checkPosId = self.issureDetailModel.checkPosId;
        self.checkpoint.positionName  =self.issureDetailModel.positionName;
        
        for (Checkinfoproblemclasslist *prolist in self.issureDetailModel.checkInfoProblemClassList) {
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (int i=0; i<prolist.imageArr.count; i++) {
                NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                jpgPath = [jpgPath stringByAppendingPathComponent:prolist.imageArr[i]];
                
                UIImage *image=[UIImage imageWithContentsOfFile:jpgPath];
                
                [tempArr addObject:image];
                
            }
            
            [prolist.imageArr removeAllObjects];
            [prolist.imageArr addObjectsFromArray:tempArr];
            
        }
        
    }

}

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpCommintButton{
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(commintSafetyCheck)];
    self.navigationItem.rightBarButtonItem  = rightBarBtn;
}

#pragma  mark 此处添加提交接口
- (void)commintSafetyCheck{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"提交服务器" otherButtonTitles:@"保存本地", nil];
    [actionSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    Checkinfoproblemclasslist *prolist=self.issureDetailModel.checkInfoProblemClassList.firstObject;
    if (buttonIndex==0) {
        if(self.issureDetailModel.checkDate.length ==0){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查日期" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        
        
        }else if(!self.typeStr.length){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查类型" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if(!self.checkpoint.positionName.length){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查位置" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if(self.isHasPro&&!self.solveUserList.realName.length){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择处理人员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if(!prolist.imageArr.count){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if(!prolist.safetyContentArr.count&&self.issureDetailModel.hasProblem==1){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查问题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else{
            
        [self.view endEditing:YES];
       
        self.hud =  [MBProgressHUD showMessage:@"正在上传中..."];
        
            if (self.issureDetailModel.checkInfoProblemClassList.count) {
                NSInteger num=0;
                for (Checkinfoproblemclasslist *prolist in self.issureDetailModel.checkInfoProblemClassList) {
                    if (prolist.imageArr.count) {
                        num++;
                        
                    }
                }
                if (num!=0) {
                    [self uploadFileByHttp];
                }else{
                    [self addCheckInfoRequset];
                }
            }else{
                [self addCheckInfoRequset];
            }
       
            
        }
    }else if(buttonIndex==1){
        
        for (Checkinfoproblemclasslist *prolist in self.issureDetailModel.checkInfoProblemClassList) {
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            for (int i=0; i<prolist.imageArr.count; i++) {
                if ([prolist.imageArr[i] isKindOfClass:[UIImage class]]) {
                    UIImage *image = prolist.imageArr[i];
                    NSData *data = UIImageJPEGRepresentation(image, 1) ;
                    
                    NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSDate *date=[NSDate date];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
                    NSString *currentDateStr = [formatter stringFromDate:date];
                    jpgPath = [jpgPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%i.jpg",currentDateStr,i]];
                    [data writeToFile:jpgPath atomically:YES];
                    
                    [tempArr addObject:[NSString stringWithFormat:@"%@%i.jpg",currentDateStr,i]];

                }else{
                    
                     [tempArr addObject:prolist.imageArr[i]];
                }
                
            }
            if (tempArr.count) {
                [prolist.imageArr removeAllObjects];
                [prolist.imageArr addObjectsFromArray:tempArr];
            }
            
        }
        NSMutableArray *tempArr = [[self getDataFromSandBox] mutableCopy];
        NSString *numStr = [self.userDefaults objectForKey:@"kNum"];
        if (!numStr.length) {
            numStr=@"0";
        }
        self.issureDetailModel.saveType = 2;

        self.issureDetailModel.checkId=numStr.integerValue-1;
        NSDictionary *statusDict = self.issureDetailModel.mj_keyValues;
        NSLog(@"%@",statusDict);
        
        [tempArr insertObject:statusDict atIndex:0];
    
        [self.userDefaults setObject:tempArr forKey:kDraft];
        [self.userDefaults setObject:[NSString stringWithFormat:@"%li",(long)self.issureDetailModel.checkId] forKey:@"kNum"];
        [MBProgressHUD showSuccess:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}



- (NSArray *)getDataFromSandBox{
    NSArray *draftArr  = [self.userDefaults  arrayForKey:kDraft];
    NSMutableArray *smArr=[[NSMutableArray alloc]  initWithArray:draftArr];
    for (int i=0; i<smArr.count; i++) {
        NSDictionary *dict = smArr[i];
        SMIssureDetailModel *detailModel = [SMIssureDetailModel mj_objectWithKeyValues:dict];
        if (detailModel.saveType==2&&detailModel.checkId==self.issureDetailModel.checkId) {
            for (Checkinfoproblemclasslist *prolist in detailModel.checkInfoProblemClassList) {

                for (int i=0; i<prolist.imageArr.count; i++) {
                    
                    [self clearCachesWithImgName:prolist.imageArr[i]];
                    
                }
                
            }
            
            [smArr removeObject:dict];
        }
    }
    return smArr;
    
}


- (void)clearCachesWithImgName:(NSString *)imgName{
    NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    jpgPath = [jpgPath stringByAppendingPathComponent:imgName];
    NSError *error = nil;
    if([[NSFileManager defaultManager] removeItemAtPath:jpgPath error:&error]) { NSLog(@"文件移除成功");
    }
    else { NSLog(@"error=%@", error);
    }
}

- (void)configTableView{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    CGFloat  topHeight=rectStatus.size.height+rectNav.size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-topHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: self.tableView];
}


#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }else{
        Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[section-1];
     
        if (self.isHasPro) {
            if (proClassList.safetyContentArr.count) {
                return 2+proClassList.safetyContentArr.count;
            }else{
                return 2;
            }
            
        }else{
            return 1;
        }
        
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];

    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        if (indexPath.row==0) {
            static NSString *identifier8 = @"cell8";
            UITableViewCell  *cell1 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier8];
            cell1.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell1.accessoryType = UITableViewCellAccessoryNone;
            cell1.textLabel.text=@"存在问题";
           
            self.sw.on=self.isHasPro;
            [cell1.contentView addSubview:self.sw];
            return cell1;
            
        }else if(indexPath.row==1){
            cell.textLabel.text=@"检查日期";
            NSDate *  senddate=[NSDate date];
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            
            [dateformatter setDateFormat:@"YYYY-MM-dd"];
            
            NSString *  locationString=[dateformatter stringFromDate:senddate];
 
            if (!self.dateString) {
                self.dateString=locationString;
                cell.detailTextLabel.text =  locationString;
                self.issureDetailModel.checkDate = self.dateString;
            }
            else {
                cell.detailTextLabel.text =  self.dateString;
            }

        }else if(indexPath.row==2){
            cell.textLabel.text=@"检查人员";
            UserInfo *userInfo = [UserInfo shareUserInfo];
            cell.detailTextLabel.text=userInfo.realName;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if(indexPath.row==3){
            
            cell.textLabel.text=@"检查类型";
            if(!self.typeStr){
                self.typeStr=@"日常检查";
                self.issureDetailModel.checkTypeId=1;
                cell.detailTextLabel.text = @"日常检查";
            }
            else {
            cell.detailTextLabel.text = self.typeStr;
            }
        }else if(indexPath.row==4){
             cell.textLabel.text=@"检查位置";
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if(!self.checkpoint.positionName){
                self.checkpoint.positionName=@"请选择检查位置";
                 cell.detailTextLabel.text = @"请选择检查位置";
            }
            else {
                cell.detailTextLabel.text = self.checkpoint.positionName;
            }

            
        }else {
            cell.textLabel.text=@"处理人员";
            cell.detailTextLabel.text = self.solveUserList.realName;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if(!self.solveUserList.realName){
                self.checkpoint.positionName=@"请选择处理人员";
                cell.detailTextLabel.text = @"请选择处理人员";
            }
            else {
                cell.detailTextLabel.text = self.solveUserList.realName;
            }

        }
        
    }else{
        if (indexPath.row==0) {
            SMAddSafetyCheckTableViewCell *secondcell =(SMAddSafetyCheckTableViewCell *)[self getCellWithTableView:tableView];
            
            secondcell.proInTeger =self.issureDetailModel.hasProblem;
            
            Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[indexPath.section-1];
            secondcell.sendImageArr  = proClassList.imageArr;
            
            secondcell.itemArr =proClassList.safetyContentArr;
            __weak typeof(self)weakself = self;
            secondcell.addImagesBlock = ^(){
                
                [weakself takePhoto];
                
            };
            
            secondcell.deletateImageBlock=^(){
                
                [weakself.tableView reloadData];
            };
            
            
            secondcell.showImageView=^(NSArray *imgArr,NSInteger tag){
                
                [weakself scanPhotoWithImgArr:imgArr andTag:tag];
                
            };
            return secondcell;
            
        }else if(indexPath.row==1){
            static NSString *identifier9 = @"cell8";
            UITableViewCell  *cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier9];
            cell2.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell2.textLabel.text= @"检查问题";
            cell2.accessoryView   = self.addProBtn;
      
            return cell2;

            
        }else{
            Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[indexPath.section-1];
            SMSafetyContent *content =proClassList.safetyContentArr[indexPath.row-2];

            
            //检查问题列表
            SMAddSafetyProCell *procell =(SMAddSafetyProCell *) [self getProCellWithTableView:tableView];
            procell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            procell.content =content;
            
           // __weak typeof(self)weakself = self;
            procell.deleteProCell=^(SMSafetyContent *tempSafetyContent){
                lastDeleteIndex = indexPath.row;
               UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除当前检查内容？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                alert.tag = 60;
                [alert show];

            };

            procell.selectionStyle = UITableViewCellSelectionStyleNone;
            return procell;
        }

    }
        
 
        
    return cell;
}


//跳转到检查问题添加界面
- (void)checkIssure:(UIButton *)btn{
    
    SMSafetyCheckAddProViewController *smsafetyCheckFLVC =[[SMSafetyCheckAddProViewController alloc] init];
    smsafetyCheckFLVC.isEditing=NO;
    
    Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[0];
    if (proClassList.safetyContentArr.count) {
        smsafetyCheckFLVC.compareArr=proClassList.safetyContentArr;
    }
    
    __weak typeof(self)weakself = self;
    smsafetyCheckFLVC.passCheckPro=^(SMSafetyContent *safetyContent){
        NSInteger num = 0;
        for (SMSafetyContentSecondDetail *secondDetail in safetyContent.sections) {
            if (secondDetail.isOpen) {
                num++;
            }
        }
        if (num) {
            Checkinfoproblemclasslist  *proClassList=weakself.issureDetailModel.checkInfoProblemClassList[0];
            NSMutableArray *tempArr= [[NSMutableArray alloc] initWithArray:proClassList.safetyContentArr];
            [tempArr addObject:safetyContent];
            proClassList.safetyContentArr  =[tempArr copy];
            [weakself.tableView reloadData];

        }
   
    };
    
    
    [self.navigationController pushViewController:smsafetyCheckFLVC animated:YES];
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


- (void)swhasProblem:(UISwitch *)sw{
  
    self.isHasPro = sw.on;
    
    if (sw.on) {
        self.issureDetailModel.hasProblem=1;
        self.issureDetailModel.state  =2;
    }else{
        
        self.issureDetailModel.hasProblem=0;
        self.issureDetailModel.state  =1;
       
    }
    
    [self.tableView reloadData];

}

- (void)takePhoto{
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    Checkinfoproblemclasslist *tempproList= self.issureDetailModel.checkInfoProblemClassList.firstObject;
    pickerVc.maxCount = 5-tempproList.imageArr.count;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        Checkinfoproblemclasslist *tempproList= weakSelf.issureDetailModel.checkInfoProblemClassList.firstObject;
     
        for (MLSelectPhotoAssets *asset in assets) {
            UIImage *image =[MLSelectPhotoPickerViewController getImageWithImageObj:asset];
            [tempproList.imageArr addObject:image];
        }
    
        [weakSelf.tableView reloadData];
    };

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.5;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"cell2";
    SMAddSafetyCheckTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMAddSafetyCheckTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
   
    return cell;
}

-(UITableViewCell *)getProCellWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"cell3";
    SMAddSafetyProCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMAddSafetyProCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1&&indexPath.row==0) {

        SMAddSafetyCheckTableViewCell *cell =(SMAddSafetyCheckTableViewCell *)[self getCellWithTableView:tableView];
        cell.proInTeger =self.issureDetailModel.hasProblem;
        Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[indexPath.section-1];
        cell.sendImageArr  = proClassList.imageArr;
        [SMAddSafetyCheckTableViewCell SecondcellHeightWithObj:proClassList.imageArr];
        cell.itemArr =proClassList.safetyContentArr;

        return cell.cellHeight;
        
    }else if(indexPath.section==1&&indexPath.row>1){
        Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[indexPath.section-1];
        SMSafetyContent *content =proClassList.safetyContentArr[indexPath.row-2];
        //检查问题列表
        SMAddSafetyProCell *procell =(SMAddSafetyProCell *) [self getProCellWithTableView:tableView];
        
        procell.content =content;
        
        return procell.cellHeight;
    }
    return 55.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0 &&indexPath.row==1) {
        
        [_pop show];
    }else if (indexPath.section ==0 &&indexPath.row ==3) {
        
        [self popMenuView];
        
    }else if(indexPath.section ==0 &&indexPath.row ==4){
 //跳转到检查部位获取界面
        SMCheckpointViewController  *checkpointVC=[[SMCheckpointViewController alloc] init];
        typeof(self)weakself = self;
        checkpointVC.passValue =^(SMCheckpointModel *checkpoint){
            weakself.checkpoint = checkpoint;
            weakself.issureDetailModel.checkPosId = checkpoint.checkPosId ;
            weakself.issureDetailModel.positionName = checkpoint.positionName;
            [weakself.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        checkpointVC.checkpoint =  self.checkpoint;
         [self.navigationController pushViewController:checkpointVC animated:YES];
        
    }else if(indexPath.section ==0 &&indexPath.row ==5){
//跳转到处理人员获取界面
        SMSolveUserListTableViewController *sulTVC=[[SMSolveUserListTableViewController alloc] init];
        typeof(self)weakself = self;
        sulTVC.passSolveUser=^(SMSolveUserList *userlist){
            weakself.issureDetailModel.solveUserId=[NSString stringWithFormat:@"%li",(long)userlist.userId];
            weakself.issureDetailModel.solveUserName = userlist.userName ;
            weakself.issureDetailModel.solveRealName = userlist.realName;
            weakself.solveUserList =userlist;
            
            [weakself.tableView reloadData];
            
        };
        sulTVC.solveuserlist = self.solveUserList;
        [self.navigationController pushViewController:sulTVC animated:YES];
    }else if(indexPath.section ==1 &&indexPath.row >1){
        
        SMSafetyCheckAddProViewController *safetycheckAddProVC=[[SMSafetyCheckAddProViewController alloc] init];
        
        Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[indexPath.section-1];
        SMSafetyContent *content =proClassList.safetyContentArr[indexPath.row-2];
        safetycheckAddProVC.safetyContent =content;
        
         __weak typeof(self)weakself = self;
        safetycheckAddProVC.passCheckPro=^(SMSafetyContent *safetyContent){
            
            NSInteger num = 0;
            for (SMSafetyContentSecondDetail *secondDetail in safetyContent.sections) {
                if (secondDetail.isOpen) {
                    num++;
                }
            }
            
            Checkinfoproblemclasslist  *proClassList=weakself.issureDetailModel.checkInfoProblemClassList[0];
            NSMutableArray *arr=[[NSMutableArray alloc] initWithArray:proClassList.safetyContentArr];
            
            if (num) {
               
                [arr replaceObjectAtIndex:indexPath.row-2 withObject:safetyContent];
                
                proClassList.safetyContentArr  =[arr copy];
                [weakself.tableView reloadData];
                
            }else{
                
                [arr removeObjectAtIndex:indexPath.row-2];
                proClassList.safetyContentArr  =[arr copy];
                [weakself.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
                
            }
   
            
        };

        safetycheckAddProVC.isEditing=YES;
        [self.navigationController pushViewController:safetycheckAddProVC animated:YES];
    }
}

//弹出视图
-(void)popMenuView{
    
    PopMenuTableView *view = [[PopMenuTableView alloc] initWithFrame:CGRectMake(0, 0,W(300), 2*55)];
    view.arr = @[@"日常检查",@"专项检查"];
    view.menuDelegate=self;
    self.popup = [KLCPopup popupWithContentView:view
                                       showType:KLCPopupShowTypeNone
                                    dismissType:KLCPopupDismissTypeNone
                                       maskType:KLCPopupMaskTypeNone
                       dismissOnBackgroundTouch:YES
                          dismissOnContentTouch:NO];
    
    self.popup.backgroundColor =[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:0.5f];
    [self.popup show];
}


#pragma mark PopMenuDelegate
- (void)openWithTitle:(NSString *)title{
    [self.popup dismiss:YES];
 
    self.typeStr=title;
    if ([self.typeStr isEqualToString:@"日常检查"]) {
        self.issureDetailModel.checkTypeId=1;
    }else{
        self.issureDetailModel.checkTypeId=2;
    }
    [self.tableView reloadData];
}

#pragma mark SMSafetyCheckViewDelegate
- (void)SMSafetyCheckViewPassData:(NSArray *)listArr AtIndex:(NSInteger)index{
    Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[index];
    
    proClassList.checkInfoDetailList = [[NSMutableArray alloc] init];
    proClassList.safetyContentArr =listArr;

    [self.tableView reloadData];
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
        
    }else if (alertView.tag==60){
        
        if (buttonIndex==1) {
            
            Checkinfoproblemclasslist  *proClassList=self.issureDetailModel.checkInfoProblemClassList[0];
            NSMutableArray *tempArr= [[NSMutableArray alloc] initWithArray:proClassList.safetyContentArr];
            [tempArr removeObjectAtIndex:lastDeleteIndex-2];
            proClassList.safetyContentArr  =[tempArr copy];
           
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:lastDeleteIndex inSection:1]] withRowAnimation:0];
         
        }
        
    }
}

//上传图片
- (void)uploadFileByHttp{
    
    for (int i=0; i<self.issureDetailModel.checkInfoProblemClassList.count; i++) {
        
        Checkinfoproblemclasslist *checkInfoProList =self.issureDetailModel.checkInfoProblemClassList[i];
        NSMutableArray *pathArr=[[NSMutableArray alloc] init];
        for (int j =0; j<checkInfoProList.imageArr.count; j++) {
            
            dispatch_async([self serialQueue], ^{
                dispatch_suspend([self serialQueue]);

                
                NSDictionary *parameters =@{
                                            };
                
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                AccountModel *account =[AccountModel shareAccount];
                [manager.requestSerializer setValue:@"true" forHTTPHeaderField:@"mobile"];
                 [manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
                [manager.requestSerializer setValue:account.token forHTTPHeaderField:@"token"];
                
                long long dateNum = [[NSDate date] timeIntervalSince1970] * 1000;
                
                NSString *sha1str=[NSString stringWithFormat:@"%@%lld",account.credential,dateNum];
                sha1str =  [SMAddSafetyCheckViewController sha1:sha1str];
                [manager.requestSerializer setValue:sha1str forHTTPHeaderField:@"encryptBody"];
                
                [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",dateNum] forHTTPHeaderField:@"timestamp"];
                
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                NSMutableArray *tempImgArr=[[NSMutableArray alloc] init];
                [manager POST:kUploadFileByHttpInterface parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    

                        UIImage *image = checkInfoProList.imageArr[j];
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
                        if (j==checkInfoProList.imageArr.count-1) {
                            Checkinfoproblemclasslist *checkInfoProList =self.issureDetailModel.checkInfoProblemClassList[i];
                            NSString *str=[pathArr componentsJoinedByString:@"|"];
                            checkInfoProList.imagePath = str;
                        }
                        
                        if (i==self.issureDetailModel.checkInfoProblemClassList.count-1&&j==checkInfoProList.imageArr.count-1) {
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
    NSString *checkTypeId = [NSString stringWithFormat:@"%li",self.issureDetailModel.checkTypeId];
    NSString *hasProblem  =[NSString stringWithFormat:@"%li",self.issureDetailModel.hasProblem];
     NSString *stateStr  =[NSString stringWithFormat:@"%li",self.issureDetailModel.state];
    
    NSMutableArray *tempArr =[[NSMutableArray alloc] init];
    for (Checkinfoproblemclasslist *proClasslist in self.issureDetailModel.checkInfoProblemClassList) {
        SMACheckinfoproblemclasslist *smacheckProClasslist= [[SMACheckinfoproblemclasslist alloc] init];
        
        smacheckProClasslist.classType=proClasslist.classType;
        smacheckProClasslist.imagePath=proClasslist.imagePath;
        NSMutableArray *tempArr2 = [[NSMutableArray alloc] init];
        if (self.issureDetailModel.hasProblem==0) {
          
            SMACheckinfodetaillist *smacheckInfoDelist=[[SMACheckinfodetaillist alloc] init];
            smacheckInfoDelist.checkContentId=@"";
            smacheckInfoDelist.checkItemId   =@"";
            smacheckInfoDelist.checkProblemId=@"";
            [tempArr2 addObject:smacheckInfoDelist];
            
        }else{
            for (SMSafetyContent *content in proClasslist.safetyContentArr) {
                
                for (int i =0; i<content.sections.count; i++) {
                    SMSafetyContentSecondDetail *secondDetail =content.sections[i];
                    
                    if (secondDetail.isOpen) {
                        
                        for (int j =0; j<secondDetail.sections.count; j++) {
                            
                            SMSafetyContentThirdDetail *thirdDetail  =secondDetail.sections[j];
                            
                            if (thirdDetail.isOpen) {
                               
                                SMACheckinfodetaillist *smacheckInfoDelist=[[SMACheckinfodetaillist alloc] init];
                                smacheckInfoDelist.checkContentId=content.classID;
                                smacheckInfoDelist.checkItemId   =secondDetail.classID;
                                if ([thirdDetail.classID isEqualToString:@"-1"]) {
                                
                                    smacheckInfoDelist.problemDesc=thirdDetail.name;
                                    
                                }else{
                                    
                                    smacheckInfoDelist.checkProblemId=thirdDetail.classID;
                                }
                                
                                
                                [tempArr2 addObject:smacheckInfoDelist];
                            }
                            
                        }
                    }
             
                }
                
            }

        }
        
        smacheckProClasslist.checkInfoDetailList = tempArr2;
        [tempArr addObject:smacheckProClasslist];
    }
    
//    for (SMACheckinfoproblemclasslist *smacheckProClasslist in tempArr) {
//  
//    
//            for (SMACheckinfodetaillist *infodetail in smacheckProClasslist.checkInfoDetailList) {
//                infodetail.checkId=nil;
//                
//                // NSLog(@"%@",infodetail.checkId);
//            }
//       
//    }
    
    NSArray *arr=[SMACheckinfoproblemclasslist mj_keyValuesArrayWithObjectArray:tempArr];
    
    if (!arr.count&&hasProblem.integerValue!=0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加检查详情" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        if (!self.issureDetailModel.solveUserId) {
            self.issureDetailModel.solveUserId=@"";
        }
        if (!self.issureDetailModel.solveUserName) {
            self.issureDetailModel.solveUserName=@"";
        }
        
        NSDictionary *parameters =@{@"checkTypeId":checkTypeId,
                                    @"hasProblem":hasProblem,
                                    @"state":stateStr,
                                    @"checkDate":self.issureDetailModel.checkDate,
                                    @"checkInfoProblemClassList":arr,
                                    @"solveUserId":self.issureDetailModel.solveUserId,
                                    @"solveUserName":self.issureDetailModel.solveUserName,
                                    @"checkPosId":self.issureDetailModel.checkPosId,
                                    @"positionName":self.issureDetailModel.positionName
                                    };
        
       
        [NetRequestClass NetJsonRequestPOSTWithRequestURL:kAddCheckInfoInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
            self.hud.hidden=YES;
            [MBProgressHUD showSuccess:@"上传成功"];
            
            NSArray *imgArr=[self getDataFromSandBox];
            [self.userDefaults setObject:imgArr forKey:kDraft];
            
            if ([self.issureDetailModel.checkPosId isEqualToString:@"0"]) {
                NSMutableArray *tempArr=[[self.userDefaults objectForKey:kPosition] mutableCopy];
                [tempArr removeObject:self.issureDetailModel.positionName];
                [self.userDefaults setObject:tempArr forKey:kPosition];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheckInformationRefresh object:@YES];
            
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
