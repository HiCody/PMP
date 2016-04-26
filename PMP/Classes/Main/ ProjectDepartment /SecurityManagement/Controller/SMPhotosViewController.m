//
//  SMPhotosViewController.m
//  PMP
//
//  Created by mac on 15/12/1.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMPhotosViewController.h"
#import "SMPhotoItem.h"
#import "SMPhotoTableViewDetailCell.h"
#import "SMPhotoTableViewItemCell.h"
#import <MWCommon.h>
#import <MWPhotoBrowser.h>
#import "NetRequestClass.h"
#import "NotfindView.h"
#import "AccountModel.h"
#import <CommonCrypto/CommonDigest.h>
static NSString *itemCellIdentifier=@"cell1";//item的cell
static NSString *detailCellIdentifier=@"cell2";//detail的cell

@interface SMPhotosViewController ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate,UIDocumentInteractionControllerDelegate>{

    NSInteger page ;//tableview的加载数
    
    NSInteger total;//tableview对应的总的页数

    Resultlist *filelist;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *contentForShowArr;
@property(nonatomic,strong)NSMutableArray *photos;
@property(nonatomic,strong)UIDocumentInteractionController *docController;
@property(nonatomic,strong)NotfindView *notfindView;
@end

@implementation SMPhotosViewController
-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr=[[NSMutableArray alloc]init];
    }
    return _contentArr;
}

-(NSMutableArray *)photos{
    if (!_photos) {
        _photos=[[NSMutableArray alloc]init];
    }
    return _photos;
}

-(NSMutableArray *)contentForShowArr{
    if (!_contentForShowArr) {
        _contentForShowArr=[[NSMutableArray alloc]init];
    }
    return _contentForShowArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.notfindView=[[NotfindView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    
    [self reloadShowIngData];
    [self configTableView];
    
    page  = 1;
    
    [self beginRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanPhoto:) name:@"kSMPhoto" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)beginRefresh{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(void)reloadShowIngData{
    [self.contentForShowArr removeAllObjects];
    [self reloadVisiableDataFrom:self.contentArr toTagertArr:self.contentForShowArr];
}

-(void)reloadVisiableDataFrom:(NSMutableArray *)initialArr toTagertArr:(NSMutableArray *)tagertArr{
    for (SMPhotoItem *item in initialArr) {
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
        [tempArr addObject:item];
        if ([item isOpen]) {
            [tempArr addObject:item.resultList];
        }
        [tagertArr addObject:tempArr];
    }
}


- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];

    
}

//刷新
- (void)loadNewData{
       page=1;
      [self queryUploadFileListByMenuIdAndFileTypeRequest];
   }


//加载更多
- (void)loadMoreDate{
        if (page<total) {
            
            page++;
            
            [self queryUploadFileListByMenuIdAndFileTypeRequest];
            
        }else {
            
            page =total;
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
        }
    }



#pragma  mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.contentForShowArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr =self.contentForShowArr[indexPath.section];
    id value=tempArr[indexPath.row];
    UITableViewCell *cell=[self getCellWithTableView:tableView andIndexpath:indexPath];
    if ([cell isKindOfClass:[SMPhotoTableViewItemCell class]]) {
        [(SMPhotoTableViewItemCell *)cell setCellItem:value];
    }
    else{
        [(SMPhotoTableViewDetailCell *)cell setDetailList:value];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath{
    //NSLog(@"%li---%li",indexPath.row,indexPath.section);
    NSArray *tempArr =self.contentForShowArr[indexPath.section];
    
    id value=tempArr[indexPath.row];
    UITableViewCell *cell;
    //如果value是BouceTableViewItem类型，复用itemCellIdentifier
    if ([value isKindOfClass:[SMPhotoItem class]]) {
        cell=[tableView dequeueReusableCellWithIdentifier:itemCellIdentifier];
        if (cell==nil) {
            cell=[[SMPhotoTableViewItemCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:itemCellIdentifier];
        }
    }
    //否则复用detailCellIdentifier
    else{
        cell=[tableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
        if (cell==nil) {
            cell=[[SMPhotoTableViewDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCellIdentifier];
        }
        
    }
    return cell;
}

//tableView行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr =self.contentForShowArr[indexPath.section];
    id value=tempArr[indexPath.row];
    CGFloat height=0;
    if ([value isKindOfClass:[SMPhotoItem class]]) {
        height=44;
    }
    else{
        UITableViewCell *cell=[self getCellWithTableView:tableView andIndexpath:indexPath];
        [(SMPhotoTableViewDetailCell *)cell setDetailList:value];
        height=[(SMPhotoTableViewDetailCell *)cell cellHeight];
    }
    return height;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

//选中单元格后(如果选中的是BouceTableViewItem，则该cell需要展开或者关闭)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *tempArr =self.contentForShowArr[indexPath.section];
    id value=tempArr[indexPath.row];

    if ([value isKindOfClass:[SMPhotoItem class]]) {
        SMPhotoItem *item=value;
        item.isOpen=!item.isOpen;//改变item的是否打开的属性
        [self reloadShowIngData];
        [tableView reloadData];
    }
}

- (void)scanPhoto:(NSNotification *)notification{
    UIImageView *imgView = notification.object;
   // NSLog(@"%@----%@",imgView.superview,imgView.superview.superview);
    SMPhotoTableViewDetailCell *cell = (SMPhotoTableViewDetailCell *)imgView.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:cell.center];
    //注意判断是否为 nil 
    if (indexPath!=nil) {
        
        NSArray *tempArr1 =self.contentForShowArr[indexPath.section];
        NSArray *value=tempArr1[indexPath.row];
      
        NSArray *tempArr = value;
        
        Resultlist *photoList=tempArr[imgView.tag];
        
        if (photoList.fileType==1) {
            
            NSMutableArray *photos = [[NSMutableArray alloc] init];
    
            NSString *str = [NSString stringWithFormat:@"%@%@",kPort,photoList.filePath ];
            str=[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *url =[NSURL URLWithString:str];
            
            MWPhoto *photo = [MWPhoto photoWithURL:url];
            [photos  addObject:photo];
            
            self.photos  = [[NSMutableArray alloc]initWithArray:photos];
            
            
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
            [browser setCurrentPhotoIndex:imgView.tag];
            
            [self.navigationController pushViewController:browser animated:YES];

        }else{
            filelist = photoList;
            CGFloat size  =photoList.fileSize/1024;
            NSString *str=[NSString stringWithFormat:@"文件大小为%.2fM,确定要下载吗？",size];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 1000;
            [alertView show];
            
            
        }
        
       }
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}


#pragma mark UIDocumentInteractionController
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    
    return self;
    
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    
    return self.tableView;
    
}



- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    
    return  self.tableView.frame;
    
}



- (void)downloadFile{
      NSString *str  =[NSString stringWithFormat:@"%@%@",kPort,filelist.filePath];

    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFURLConnectionOperation *operation=[[AFURLConnectionOperation alloc]initWithRequest:request];
    //设置下载文件的保存路径
    NSString *filePath=[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",filelist.fileName]];
    NSLog(@"%@",filePath);
    
    MBProgressHUD *hud =  [MBProgressHUD showMessage:@"正在加载中..."];
    hud.dimBackground=NO;
    //创建一个输出流
    operation.outputStream=[NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"下载进度:%f",(double)totalBytesRead/totalBytesExpectedToRead);
    }];
    [operation setCompletionBlock:^{
        NSLog(@"下载完成");
                //[MBProgressHUD hideHUD];
        hud.hidden = YES;
        _docController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        _docController.delegate =self;
        
        CGRect navRect =self.navigationController.navigationBar.frame;
        
        navRect.size =CGSizeMake(1500.0f,40.0f);
        
        [_docController presentOptionsMenuFromRect:navRect inView:self.tableView animated:YES];
        

    }];
    [operation start];


}


- (void)queryUploadFileListByMenuIdAndFileTypeRequest{
    NSString *menuId  = self.securityMemuid;

    NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%ld",(long)page],
                                 @"rows":@"7",
                                 @"menuId":menuId,
                                 @"fileType":@"all"
                                 };

    [NetRequestClass NetRequestPOSTWithRequestURL:kQueryUploadFileListByMenuIdAndFileType WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dict= returnValue;
      
        NSDictionary *itemsDict= dict[@"items"];
        if (itemsDict) {
            NSString *totalStr = itemsDict[@"total"];
            total = totalStr.integerValue;
            
            if ([self.tableView.mj_header isRefreshing]) {
                [self.contentArr removeAllObjects];
            }
            
            NSArray *tempphotoArr = [SMPhotoItem mj_objectArrayWithKeyValuesArray:itemsDict[@"rows"]];
            
            
            for (SMPhotoItem *photoItem in tempphotoArr) {
                photoItem.isOpen = YES;
                [self.contentArr addObject:photoItem];
            }
            
            
            [self reloadShowIngData];
            [self.tableView reloadData];
            
           
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        //判断有无数据的时候的视图
        if (self.contentArr.count ==0) {
            
            [self.tableView addSubview: self.notfindView];
            self.tableView.mj_footer.hidden =YES;
            
        }else{
            [self.notfindView removeFromSuperview];
        }

       
       
    } WithErrorCodeBlock:^(id errorCode) {
        NSLog(@"%@",errorCode);
        
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    } WithFailureBlock:^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag =10001;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==10001) {
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    }else if(alertView.tag==1000){
        
        if (buttonIndex==1) {
             [self downloadFile];
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
