//
//  SMCheckdetailViewController.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMCheckdetailViewController.h"
#import "PhotoBrowserViewController.h"
#import "SMAddSafetyCheckTableViewCell.h"
#import "WHUCalendarPopView.h"
#import "SMSafetyCheckDetailCell.h"
#import "SMSafetyCheckDetailSecondCell.h"
#import "DCToolBar.h"
#import "AccountModel.h"
#import <CommonCrypto/CommonDigest.h>
#import <MWCommon.h>
#import <MWPhotoBrowser.h>
#import "SMDraftViewController.h"
#import "UIImage+fixOrientation.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
@interface SMCheckdetailViewController ()<UITableViewDataSource,UITableViewDelegate,DCToolBarDelegate,UIAlertViewDelegate,MWPhotoBrowserDelegate>{
    
    dispatch_queue_t _serialQueue;
    WHUCalendarPopView* _pop;
    NSInteger  index;
    NSInteger uploadIndex;
    
}
@property(nonatomic,strong)SMIssureDetailModel *issureModel;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *imgArr;
@property(nonatomic,strong)NSString *dateString;
@property(nonatomic,strong)DCToolBar *dcToolBar;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)NSUserDefaults *userDefaults;
@property(nonatomic,strong)NSMutableArray *recheckArr;

@property(nonatomic,strong)MBProgressHUD *hud;
@property(nonatomic,strong)NSArray *photos;
@end

@implementation SMCheckdetailViewController
- (NSMutableArray *)recheckArr{
    if (!_recheckArr) {
        _recheckArr = [[NSMutableArray alloc] init];
    }
    return _recheckArr;
}

- (NSMutableArray *)imgArr{
    if (!_imgArr) {
        _imgArr =[[NSMutableArray alloc] init];
    }
    return _imgArr;
}

- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"安全检查详细信息";
    self.view.backgroundColor =[UIColor whiteColor];
    self.userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.issureModel  =[[SMIssureDetailModel alloc] init];
    self.issureModel.recheckProblemList=[[NSMutableArray alloc] init];
    
    [self subitTableView];
    
    if (self.msgId.length) {
        [self readCheckMsgRequset];
    }else{
        [self requestCheckResultDetailInfoData];
    }

    _pop=[[WHUCalendarPopView alloc] init];
    
    //次数添加日历
    __weak typeof(self)weakself = self;
    _pop.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        weakself.dateString = [format stringFromDate:date];

        weakself.recheckProList.reCheckDate = weakself.dateString;
        
        [weakself.tableView reloadData];
    };

    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
}

- (void)setUpNavBar{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   [NAVI_SECOND_COLOR CGColor]);
    CGContextFillRect(context, rect);
    
    
    self.navigationController.navigationBar.barTintColor = NAVI_SECOND_COLOR;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)subitTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,WinWidth, self.view.height-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView =[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}



//添加底部工具栏
- (void)configToolBar{
//    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
//   
//    CGRect rectNav = self.navigationController.navigationBar.frame;
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-50, WinWidth, 50)];
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame: self.bottomView.bounds];
    imgView.image =[UIImage imageNamed:@"toolbar_bg"];
    [ self.bottomView addSubview:imgView];
    
    self.dcToolBar = [[DCToolBar alloc] init];
    
    self.dcToolBar.frame = CGRectMake(0, 0, WinWidth, 50);
    
    self.dcToolBar.backgroundColor=[UIColor clearColor];
    
    self.dcToolBar.delegate = self;
    if (self.issureModel.state==2||self.issureModel.state==4) {
 //判断是否本人就是处理人
        UserInfo *userInfo = [UserInfo shareUserInfo];
        if ([userInfo.userId isEqualToString:self.issureModel.solveUserId]) {
            [self.dcToolBar addTabButtonWithImgName:@"singn_yes" andImaSelName:@"singn_yes" andTitle:@"处理"];
            [ self.bottomView addSubview:self.dcToolBar];
             [self.view addSubview:self.bottomView];
        }
        

    }else{
        
        [self.dcToolBar addTabButtonWithImgName:@"singn_yes" andImaSelName:@"singn_yes" andTitle:@"通过"];
        [self.dcToolBar addTabButtonWithImgName:@"singn_no" andImaSelName:@"singn_no" andTitle:@"不通过"];
        
        [ self.bottomView addSubview:self.dcToolBar];
        for (int i=0; i<1; i++) {
            UIView *lineView= [[UIView alloc] initWithFrame:CGRectMake((i+1)*WinWidth/2, (self.dcToolBar.frame.size.height-20)/2.0, 0.5, 20)];
            lineView.backgroundColor=[UIColor lightGrayColor];
            [ self.bottomView addSubview:lineView];
        }
        
        UserInfo *userInfo=[UserInfo shareUserInfo];
        
        NSArray *arr =[userInfo.right componentsSeparatedByString:@";"];
     //复查权限
        if ([arr containsObject:@"10037"]&&[userInfo.userId isEqualToString:[NSString stringWithFormat:@"%li",self.issureModel.checkUserId]]) {
              [self.view addSubview:self.bottomView];
        }
      
    }
    
    
}


//返回的按钮
-(void)coustomNavigtion{
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    
}


#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.issureModel.checkInfoProblemClassList) {
        return self.issureModel.checkInfoProblemClassList.count+1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (self.issureModel.recheckProblemList.count||(self.issureModel.state!=5&&self.issureModel.state!=1&&self.issureModel.state!=2&&self.issureModel.state!=4)) {
            return 7;
        }else{
            
            return 5;
        }
    }
    return  1;
}

//头部间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.5;
    }
    
    return 20;
    
}

//返回每行cell的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }

    [self.tableView setSeparatorColor:[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0]];
    if (indexPath.section==0){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableArray *tempArr= [[NSMutableArray alloc] init];
        NSMutableArray *tempArr2=[[NSMutableArray alloc] init];
        
        if (self.issureModel.checkDate) {
            [tempArr addObject:self.issureModel.checkDate];
        }else{
            [tempArr addObject:@""];
        }
        
        if (self.issureModel.checkUserName) {
             [tempArr addObject:self.issureModel.checkUserName];
        }else{
            [tempArr addObject:@""];
        }
        
 
        if (self.issureModel.checkTypeId==1) {
            [tempArr addObject:@"日常检查"];
        }else{
            [tempArr addObject:@"专项检查"];
        }
        
        if (self.issureModel.positionName) {
            [tempArr addObject:self.issureModel.positionName];
        }else{
            [tempArr addObject:@""];
        }
        
        if (self.issureModel.solveUserName) {
             [tempArr addObject:self.issureModel.solveUserName];
        }else{
            [tempArr addObject:@""];
        }
        [tempArr2 addObjectsFromArray:@[@"检查日期",@"检查人员",@"检查类型",@"检查位置",@"处理人员"]];
        if ((self.issureModel.state!=5&&self.issureModel.state!=1&&self.issureModel.state!=2&&self.issureModel.state!=4)||self.issureModel.recheckProblemList.count) {
            Recheckproblemlist *proList =self.issureModel.recheckProblemList.firstObject;
       
            if (proList.reCheckUserName) {
                 [tempArr insertObject:proList.reCheckUserName atIndex:0];
            }else{
                if(self.recheckProList){
                  [tempArr insertObject:self.recheckProList.reCheckUserName atIndex:0];
                }
                else{
                    [tempArr insertObject:@"" atIndex:0];
                }
            }
            
            if (proList.reCheckDate) {
                [tempArr insertObject:proList.reCheckDate atIndex:0];
            }else{
                [tempArr insertObject:@"" atIndex:0];
            }
    
            [tempArr2 insertObject:@"复查人员" atIndex:0];
            [tempArr2 insertObject:@"复查日期" atIndex:0];
        }

        cell.textLabel.text=tempArr2[indexPath.row];
        cell.detailTextLabel.text=tempArr[indexPath.row];
        if (self.issureModel.state!=5&&self.issureModel.state!=1&&self.issureModel.state!=2&&self.issureModel.state!=4) {
            if (indexPath.row==0) {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                cell.detailTextLabel.text = self.dateString ;

            }
        }else{
            cell.accessoryType=UITableViewCellAccessoryNone;
        }
    }else{
 //已完成，无问题的cell
        if (self.smcheckState==5||self.smcheckState==1||self.smcheckState==4) {
            Checkinfoproblemclasslist *infoProList=self.issureModel.checkInfoProblemClassList[indexPath.section-1];
            
            SMSafetyCheckDetailCell *detailCell=(SMSafetyCheckDetailCell *)[self getCellWithTableView:tableView];
            detailCell.selectionStyle=UITableViewCellSelectionStyleNone;
            detailCell.proInteger =self.smcheckState;
            NSMutableArray *tempArr =[[NSMutableArray alloc] init];
            for (Recheckproblemlist *recheckProList in self.issureModel.recheckProblemList) {
    
                    if (self.issureModel.checkId == recheckProList.checkId) {
                        [tempArr addObject:recheckProList];
                  
                    }
               
            }
             __weak typeof(self)weakself = self;
            detailCell.showImageView=^(NSArray *imgArr,NSInteger tag){
                [weakself scanPhotoWithImgArr:imgArr andTag:tag];
            };
            
            
        
            [detailCell setInfoProLst:infoProList andRecheckproblemlist:tempArr];
            return  detailCell;
            
        }else{
 //复查，未通过，待处理的cell
            Checkinfoproblemclasslist *infoProList=self.issureModel.checkInfoProblemClassList[indexPath.section-1];
            
            SMSafetyCheckDetailSecondCell *detailCell=(SMSafetyCheckDetailSecondCell *)[self getCellWithTableView:tableView];
            detailCell.state = self.issureModel.state;
            detailCell.selectionStyle=UITableViewCellSelectionStyleNone;
            Recheckproblemlist *tempRecheckProList;
             __weak typeof(self)weakself = self;
            
            detailCell.addImagesBlock = ^(){
                index  = indexPath.section-1;
                [weakself takePhoto];
                
            };
            
            detailCell.deletateImageBlock=^(){
                [weakself.tableView reloadData];
            };
            
            detailCell.showImageView=^(NSArray *imgArr,NSInteger tag){
                [weakself scanPhotoWithImgArr:imgArr andTag:tag];
            };
            
            detailCell.showPhotoView=^(NSArray *imgArr,NSInteger tag){
                [weakself scanPhotoWithImgArr:imgArr andTag:tag];
            };
            
            Recheckinfolist *recheckInfolist=self.recheckProList.recheckInfoList[indexPath.section-1];
            detailCell.sendImageArr=recheckInfolist.imageArr;
            [detailCell setInfoProLst:infoProList andRecheckproblemlist:tempRecheckProList];
            
            return  detailCell;
            
            
        }
    }
   
    
    return cell;
    
    
}

- (void)scanPhotoWithImgArr:(NSArray *)imgArr andTag:(NSInteger)tag{
    NSMutableArray *photosArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<imgArr.count; i++) {
        if ([imgArr[i] isMemberOfClass:[UIImage class]]) {
            MWPhoto *photo = [MWPhoto photoWithImage:imgArr[i]];
            [photosArr  addObject:photo];

        }else{
            NSString *jpgpath=imgArr[i];
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:jpgpath]];
            [photosArr  addObject:photo];
        }
      
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


-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView{
    if (self.smcheckState==5||self.smcheckState==1||self.smcheckState==4) {
        static NSString *itemCellIdentifier=@"cell1";
        SMSafetyCheckDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (cell==nil) {
            cell=[[SMSafetyCheckDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        }
          return cell;
    }else{
        static NSString *itemCellIdentifier=@"cell2";
        SMSafetyCheckDetailSecondCell *cell=[tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (cell==nil) {
            cell=[[SMSafetyCheckDetailSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        }
        return cell;
    }

  
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (void)takePhoto{
    
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 5;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        
        Checkinfoproblemclasslist *checkInfoProList=self.issureModel.checkInfoProblemClassList[index];
        
        for (Recheckinfolist *recheckInfolist in self.recheckProList.recheckInfoList) {
            if (recheckInfolist.classType==checkInfoProList.classType) {
                
                for (MLSelectPhotoAssets *asset in assets) {
                    UIImage *image =[MLSelectPhotoPickerViewController getImageWithImageObj:asset];
                    [recheckInfolist.imageArr addObject:image];
                }
               
            }
        }
        
        [weakSelf.tableView reloadData];
    };
}



//返回每行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 50;
    }else{
        if (self.smcheckState==5||self.smcheckState==1||self.smcheckState==4) {
            
            SMSafetyCheckDetailCell *detailCell=(SMSafetyCheckDetailCell *)[self getCellWithTableView:tableView];
            
            Checkinfoproblemclasslist *infoProList=self.issureModel.checkInfoProblemClassList[indexPath.section-1];
            detailCell.proInteger =self.smcheckState;
            NSMutableArray *tempArr =[[NSMutableArray alloc] init];
            for (Recheckproblemlist *recheckProList in self.issureModel.recheckProblemList) {
           
                    if (self.issureModel.checkId == recheckProList.checkId) {
                        
                        [tempArr addObject:recheckProList];
                    }
             
            }
            
            [detailCell setInfoProLst:infoProList andRecheckproblemlist:tempArr];
        //  NSLog(@"%f",detailCell.cellHeight);
            return detailCell.cellHeight;
            
        }else{
            Checkinfoproblemclasslist *infoProList=self.issureModel.checkInfoProblemClassList[indexPath.section-1];
            
            SMSafetyCheckDetailSecondCell *detailCell=(SMSafetyCheckDetailSecondCell *)[self getCellWithTableView:tableView];
            detailCell.state = self.issureModel.state;
            
            Recheckinfolist *recheckInfolist=self.recheckProList.recheckInfoList[indexPath.section-1];
            detailCell.sendImageArr = recheckInfolist.imageArr;
           
            Recheckproblemlist *tempRecheckProList;
            [SMSafetyCheckDetailSecondCell SecondcellHeightWithObj:recheckInfolist.imageArr];
            [detailCell setInfoProLst:infoProList andRecheckproblemlist:tempRecheckProList];
            
            return  detailCell.cellHeight;

        }
        
    }
}

//选中某行做某事
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0&&indexPath.row ==0&&self.issureModel.state!=5&&self.issureModel.state!=1&&self.issureModel.state!=2&&self.issureModel.state!=4) {
        
        [_pop show];
    }
    
 
}


//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

#pragma mark DCToolBarDelegate
- (void)willSelectIndex:(NSInteger)selIndex{
    if (self.issureModel.state==2||self.issureModel.state==4) {
        
        [self solveUserAgreeRequest];
        
    }else{
        Checkinfoproblemclasslist *checkInfoProList=self.issureModel.checkInfoProblemClassList[index];
        NSArray *picArr =[NSArray array];
        for (Recheckinfolist *recheckInfolist in self.recheckProList.recheckInfoList) {
            if (recheckInfolist.classType==checkInfoProList.classType) {
                
                picArr=recheckInfolist.imageArr;
            }
        }
        if (!self.recheckProList.reCheckDate.length) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择复查日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if(!picArr.count){
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加复查图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else{
            
            if (selIndex==0) {
                //复查通过
                uploadIndex = 5;
                
            }else{
                //复查未通过
                uploadIndex = 4;
                
            }
            
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交到服务器",@"保存到本地", nil];
            
            [alertView show];
            
        }
 
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//非法请求！
    if (alertView.tag==10) {
        
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
        
    }else{
        if (buttonIndex==1) {
            //     [self.view endEditing:YES];
            self.hud =  [MBProgressHUD showMessage:@"正在上传中..."];
            //上传服务器
            [self uploadFileByHttp];
            
            
        }
        else if(buttonIndex==2){
            //保存本地
            self.recheckProList.state  =uploadIndex;
            for (int i=0; i<self.recheckProList.recheckInfoList.count; i++) {
                Recheckinfolist *recheckInfoList =self.recheckProList.recheckInfoList[i];
                NSMutableArray *tempArr=[[NSMutableArray alloc] init];
                for (int j =0; j<recheckInfoList.imageArr.count; j++) {
                    if ([recheckInfoList.imageArr[i] isKindOfClass:[UIImage class]]) {
                        UIImage *image = recheckInfoList.imageArr[j];
                        NSData *data = UIImageJPEGRepresentation(image.fixOrientation, 1) ;
                        
                        NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                        NSDate *date=[NSDate date];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
                        NSString *currentDateStr = [formatter stringFromDate:date];
                        jpgPath = [jpgPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%i.jpg",currentDateStr,j]];
                        
                        [data writeToFile:jpgPath atomically:YES];
                        
                        [tempArr addObject:[NSString stringWithFormat:@"%@%i.jpg",currentDateStr,j]];
                        
                    }else{
                        [tempArr addObject:recheckInfoList.imageArr[i]];
                    }
                    
                }
                if (tempArr.count) {
                    [recheckInfoList.imageArr removeAllObjects];
                    [recheckInfoList.imageArr addObjectsFromArray:tempArr];
                }
                
                
            }
            
            //保存到本地
            [self.issureModel.recheckProblemList removeAllObjects];
            [self.issureModel.recheckProblemList addObject:self.recheckProList];
            self.issureModel.saveType = 1;
            NSDictionary *dict=self.issureModel.mj_keyValues;
            NSLog(@"%@",dict);
             NSMutableArray *smArr=[[self getDataFromSandBox] mutableCopy];
            [smArr insertObject:dict atIndex:0];
            [self.userDefaults setObject:smArr forKey:kDraft];
            
            [MBProgressHUD showSuccess:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }

        
    }
    
}

//从沙河获取内容
- (NSArray *)getDataFromSandBox{
    NSArray *draftArr  = [self.userDefaults  arrayForKey:kDraft];
    NSMutableArray *smArr=[[NSMutableArray alloc]  initWithArray:draftArr];
    for (int i=0; i<smArr.count; i++) {
        NSDictionary *dict = smArr[i];
        SMIssureDetailModel *detailModel = [SMIssureDetailModel mj_objectWithKeyValues:dict];
        if (detailModel.saveType==1&&detailModel.checkId==self.recheckProList.reCheckId) {
            Recheckproblemlist *recheckProList = (Recheckproblemlist *)detailModel.recheckProblemList.firstObject;
            
            for (Recheckinfolist *infolist in recheckProList.recheckInfoList ) {
                for (int i=0; i<infolist.imageArr.count; i++) {
                    [self clearCachesWithImgName:infolist.imageArr[i]];
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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.bottomView.hidden=YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.bottomView.hidden=NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.bottomView.hidden=NO;
}


//从服务器获取数据
- (void)requestCheckResultDetailInfoData{
    MBProgressHUD *hud =[MBProgressHUD showMessage:@"加载中..."];
    NSDictionary *parameters =@{@"checkId":[NSString stringWithFormat:@"%li",self.checkId]};
    
    [NetRequestClass NetRequestGETWithRequestURL:kCheckResultDetailInfoInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        hud.hidden=YES;
        NSDictionary *dict= returnValue;
        NSDictionary *itemDict= dict[@"items"];
        
        
        self.issureModel  =[SMIssureDetailModel mj_objectWithKeyValues:itemDict];
     
        
//        for (Recheckproblemlist *info in self.issureModel.recheckProblemList) {
//        
//            for (Recheckinfolist *detail in info.recheckInfoList) {
//                NSLog(@"%@",detail.imagePath);
//            }
//        }
        self.smcheckState = self.issureModel.state;
        
        if (self.issureModel.state!=5&&self.issureModel.state!=1) {
            
           [self configToolBar];
            
            if (!self.recheckProList) {
                self.recheckProList=[[Recheckproblemlist alloc] init];
                self.recheckProList.reCheckUserName=self.issureModel.checkUserName;
                self.recheckProList.reCheckId=self.issureModel.checkId;
                self.recheckProList.recheckInfoList =[[NSMutableArray alloc] init];
                for (int i =0;  i<self.issureModel.checkInfoProblemClassList.count; i++) {
                    Checkinfoproblemclasslist *proclassList=self.issureModel.checkInfoProblemClassList[i];
                    Recheckinfolist *recheckInfolist=[[Recheckinfolist alloc] init];
                    recheckInfolist.classType = proclassList.classType;
                    recheckInfolist.imageArr=[[NSMutableArray alloc] init];
                    [self.recheckProList.recheckInfoList addObject:recheckInfolist];
                }
                NSDate *  senddate=[NSDate date];
                
                NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
                
                [dateformatter setDateFormat:@"YYYY-MM-dd"];
                
                NSString *  locationString=[dateformatter stringFromDate:senddate];
                self.recheckProList.reCheckDate = locationString;
                self.dateString = locationString;

            }else{
                self.dateString = self.recheckProList.reCheckDate;
            }
        }
 
        [self.tableView reloadData];
        
        
    } WithErrorCodeBlock:^(id errorCode) {
         hud.hidden=YES;
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }

    } WithFailureBlock:^{
        hud.hidden=YES;
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

//上传图片
- (void)uploadFileByHttp{
    for (int i=0; i<self.recheckProList.recheckInfoList.count; i++) {
        Recheckinfolist *recheckInfoList =self.recheckProList.recheckInfoList[i];
         NSMutableArray *pathArr=[[NSMutableArray alloc] init];
        for (int j =0; j<recheckInfoList.imageArr.count; j++) {
            
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
                sha1str =  [SMCheckdetailViewController sha1:sha1str];
                [manager.requestSerializer setValue:sha1str forHTTPHeaderField:@"encryptBody"];
                
                [manager.requestSerializer setValue:[NSString stringWithFormat:@"%lld",dateNum] forHTTPHeaderField:@"timestamp"];
                
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                NSMutableArray *tempImgArr=[[NSMutableArray alloc] init];
                [manager POST:kUploadFileByHttpInterface parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                  
                        UIImage *image = recheckInfoList.imageArr[j];
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
                    
                    if ([dic[@"msg"] isEqualToString:@"非法请求!"]) {
                        self.hud.hidden=YES;
                        [self restartLogin];
                    }else{
                          [pathArr addObject: dic[@"items"]];
                        if (j==recheckInfoList.imageArr.count-1) {
                            Recheckinfolist *recheckInfoList =self.recheckProList.recheckInfoList[i];
                              NSString *str=[pathArr componentsJoinedByString:@"|"];
                            recheckInfoList.imagePath =str;
                        }
                   
                        if (i==self.recheckProList.recheckInfoList.count-1&&j==recheckInfoList.imageArr.count-1) {
                            [self addCheckInfoRequest];
                        }
                    }
                    
                    NSLog(@"%@", result);
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

//提交复查
- (void)addCheckInfoRequest{
    
    NSMutableArray *infoArr=[[NSMutableArray alloc] init];
    for (int i =0; i<self.recheckProList.recheckInfoList.count; i++) {
        Recheckinfolist *recheckInfp =self.recheckProList.recheckInfoList[i];
        SMARecheckinfolist *smarecheckInfo =[[SMARecheckinfolist alloc] init];
        smarecheckInfo.classType=recheckInfp.classType;
        smarecheckInfo.imagePath =recheckInfp.imagePath;
        [infoArr addObject:smarecheckInfo];
    }
    NSArray *infoArr2=[SMARecheckinfolist mj_keyValuesArrayWithObjectArray:infoArr];
    NSString *checkId =[NSString stringWithFormat:@"%li",(long)self.recheckProList.reCheckId];
    NSString *stateStr=[NSString stringWithFormat:@"%li",(long)uploadIndex];
    NSDictionary *parameters = @{@"checkId":checkId,
                                 @"reCheckDate":self.recheckProList.reCheckDate,
                                 @"state":stateStr,
                                 @"recheckInfoList":infoArr2
                                 };

    
    [NetRequestClass NetJsonRequestPOSTWithRequestURL:kAddRecheckInfoInterface WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        self.hud.hidden=YES;
        
        [MBProgressHUD showSuccess:@"上传成功"];
        
        NSArray *smarr = [self getDataFromSandBox];
        [self.userDefaults setObject:smarr forKey:kDraft];
        
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

//处理人完成
- (void)solveUserAgreeRequest{
    NSString *checkId = [NSString stringWithFormat:@"%li",self.issureModel.checkId];
    NSDictionary *parameters=@{@"checkId":checkId
                               };
    MBProgressHUD *hud1 =  [MBProgressHUD showMessage:@"正在提交中..."];
    [NetRequestClass NetRequestGETWithRequestURL:kSolveUserAgree WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        hud1.hidden=YES;
        [MBProgressHUD showSuccess:@"处理成功"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kCheckInformationRefresh object:@YES];
        
        [self.navigationController  popViewControllerAnimated:YES];
        
    } WithErrorCodeBlock:^(id errorCode) {
        hud1.hidden=YES;
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        hud1.hidden=YES;
    }];
    

}

//标记已读未读
- (void)readCheckMsgRequset{
    NSString *checkId = [NSString stringWithFormat:@"%li",self.checkId];
    NSDictionary *parameters=@{@"msgId":self.msgId,
                               @"checkId":checkId
                               };
   
    [NetRequestClass NetRequestGETWithRequestURL:kReadCheckMsg WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {

        [self requestCheckResultDetailInfoData];
        
    } WithErrorCodeBlock:^(id errorCode) {
        [self requestCheckResultDetailInfoData];
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
         [self requestCheckResultDetailInfoData];
        
    }];
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
