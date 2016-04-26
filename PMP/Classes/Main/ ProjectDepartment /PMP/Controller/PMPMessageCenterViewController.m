//
//  PMPMessageCenterViewController.m
//  PMP
//
//  Created by mac on 15/12/31.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "PMPMessageCenterViewController.h"
#import "NetRequestClass.h"
#import "NotfindView.h"
#import "SMMessageCenterModel.h"
#import "SMImage.h"
#import "SMCheckdetailViewController.h"
@interface PMPMessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    NSInteger page;//各个tableview的加载数
    
    NSInteger total;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)NotfindView  *notfindView;
@end

@implementation PMPMessageCenterViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"消息中心";
    [self setUpTableView];
    [self setUpBackBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshInfo) name:@"MessageCenter" object:nil];
}

- (void)refreshInfo{
    
    if (self.tableView) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setUpNavBar];
    if (self.tableView) {
         [self.tableView.mj_header beginRefreshing];
    }
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.tableView.dataSource   =self;
    self.tableView.delegate     =self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    [self.tableView.mj_header beginRefreshing];
    
    self.notfindView = [[NotfindView alloc] initWithFrame:  CGRectMake(0,0,self.view.width, self.view.frame.size.height)] ;
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

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

#pragma  mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier  = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            //删除并进行重新分配
        }
    }
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    SMMessageCenterModel *message =self.dataSource[indexPath.row];
    UIView *imgView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 50,50)];
    UILabel *imgLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50,25)];
    UILabel *imgLab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 50,25)];
    [imgView addSubview:imgLab];
    [imgView addSubview:imgLab2];
    switch (message.state) {
        case 1:
            imgLab.text =@"无";
            imgLab2.text=@"问题";
            imgLab.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor colorWithRed:146/255.0 green:189/255.0 blue:59/255.0 alpha:1.0];
            break;
        case 2:
            imgLab.text =@"待";
            imgLab2.text=@"处理";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor purpleColor];
            break;
        case 3:
            imgLab.text =@"待";
            imgLab2.text=@"复查";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor colorWithRed:242/255.0 green:209/255.0 blue:8/255.0 alpha:1.0];
            break;
        case 4:
            imgLab.text =@"未";
            imgLab2.text=@"通过";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor colorWithRed:253/255.0 green:132/255.0 blue:139/255.0 alpha:1.0];
            break;
        case 5:
            imgLab.text =@"已";
            imgLab2.text=@"通过";
            imgLab.backgroundColor=[UIColor clearColor];
            imgLab2.backgroundColor=[UIColor clearColor];
            imgView.backgroundColor=[UIColor colorWithRed:116/255.0 green:204/255.0 blue:242/255.0 alpha:1.0];
            break;
            
        default:
            break;
    }
    imgLab.lineBreakMode =NSLineBreakByTruncatingTail;
    imgLab.numberOfLines=0;
    imgLab.font=[UIFont systemFontOfSize:14];
    imgLab.textAlignment=NSTextAlignmentCenter;
    imgLab.textColor=[UIColor whiteColor];
    imgLab.layer.cornerRadius=25.0f;
    
    imgLab2.lineBreakMode =NSLineBreakByTruncatingTail;
    imgLab2.numberOfLines=0;
    imgLab2.font=[UIFont systemFontOfSize:14];
    imgLab2.textAlignment=NSTextAlignmentCenter;
    imgLab2.textColor=[UIColor whiteColor];
    imgLab2.layer.cornerRadius=25.0f;
    
    UIImage *image=[SMImage imageWithView:imgView];
    cell.imageView.image=image;
    cell.imageView.layer.cornerRadius=25.0f;
    cell.imageView.layer.masksToBounds=YES;
    cell.imageView.backgroundColor =[UIColor clearColor];
    
    cell.textLabel.text = message.title;
    
    cell.detailTextLabel.numberOfLines=3;
    cell.detailTextLabel.text = message.content;
    cell.detailTextLabel.textColor =[UIColor grayColor];
    
    //日期时间
    UILabel *fourthLabel = [[UILabel alloc] init];
    NSString *dateStr  = message.pushDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    fourthLabel.text = dateStr;
    fourthLabel.textAlignment = NSTextAlignmentRight;
    fourthLabel.font = [UIFont systemFontOfSize:10];
    fourthLabel.textColor = [UIColor grayColor];
    CGSize fourthSize = [self sizeWithText:fourthLabel.text font: fourthLabel.font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    fourthLabel.frame  =  CGRectMake(WinWidth-fourthSize.width-5, 5, fourthSize.width, fourthSize.height);
    [cell.contentView addSubview:fourthLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMMessageCenterModel *message =self.dataSource[indexPath.row];
    
    SMCheckdetailViewController *detailVC=[[SMCheckdetailViewController alloc] init];
    detailVC.checkId =message.checkId;
    detailVC.msgId   =[NSString stringWithFormat:@"%li",message.id];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

//刷新
- (void)loadNewData{
    [self.notfindView removeFromSuperview];
    page=1;
    
    [self queryCheckMsgRequset];

}

//加载
- (void)loadMoreDate{
    
    if (page<total) {
        
        page++;
        [self queryCheckMsgRequset];
        
    }else{
        page =total;
        
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
    }

}

- (void)queryCheckMsgRequset{
    NSString *pageStr = [NSString stringWithFormat:@"%li",page];
    NSDictionary *parameters=@{@"page":pageStr,
                               @"rows":@"10",
                               };
    [NetRequestClass NetRequestGETWithRequestURL:kQueryCheckMsg WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        
        NSDictionary *dict= returnValue;
        
        NSDictionary *contentDict=dict[@"items"];
        
        NSString *totalStr = contentDict[@"total"];
        total = totalStr.integerValue;
        
        NSArray *tempArr=[SMMessageCenterModel mj_objectArrayWithKeyValuesArray:contentDict[@"rows"]];
        
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataSource removeAllObjects];
        }
        
        [self.dataSource addObjectsFromArray:tempArr];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        //判断有无数据的时候的视图
        if (self.dataSource.count ==0) {
            
            [self.view addSubview: self.notfindView];
            self.tableView.mj_footer.hidden =YES;
        }
        else{
            [self.notfindView removeFromSuperview];
        }
        
    } WithErrorCodeBlock:^(id errorCode) {
        NSDictionary *dict=errorCode;
        if ([dict[@"msg"] isEqualToString:@"非法请求!"]) {
            [self restartLogin];
        }
        
    } WithFailureBlock:^{
        
    }];

}

- (void)restartLogin{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非法请求,请重新登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
