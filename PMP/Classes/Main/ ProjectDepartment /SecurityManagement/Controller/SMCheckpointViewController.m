//
//  SMCheckpointViewController.m
//  PMP
//
//  Created by mac on 15/12/22.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMCheckpointViewController.h"
#import "NetRequestClass.h"

@interface SMCheckpointViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSInteger page;
    NSInteger total;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *saveDatalist;//自定义数据的数组
@property(nonatomic,strong)NSMutableArray *dataSourcelist;//网上获取数据的数组
@property(nonatomic,strong)NSUserDefaults *userdefaults;
@end

@implementation SMCheckpointViewController
- (NSMutableArray *)saveDatalist{
    if (!_saveDatalist) {
        _saveDatalist = [[NSMutableArray alloc] init];
    }
    return _saveDatalist;
}

- (NSMutableArray *)dataSourcelist{
    if (!_dataSourcelist) {
        _dataSourcelist = [[NSMutableArray alloc] init];
    }
    return _dataSourcelist;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.userdefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr=[self.userdefaults objectForKey:kPosition];
    for (int i =0; i<arr.count; i++) {
        SMCheckpointModel *checkpoint =[[SMCheckpointModel alloc] init];
        checkpoint.checkPosId=@"0";
        checkpoint.positionName=arr[i];
        [self.saveDatalist addObject:checkpoint];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    page=1;
    self.title = @"检查位置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configRightButton];
    [self configTableView];

    [self beginRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)beginRefresh{
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, self.view.height)];
    self.tableView.delegate =self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadLastData方法）
    
    // 设置了底部inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDate)];
    
}

//刷新
- (void)loadNewData{
    
    page=1;
    
    [self queryCheckPositionRequset];
}


//加载更多
- (void)loadMoreDate{
    if (page<total) {
        
        page++;
        
        [self queryCheckPositionRequset];
        
    }else {
        
        page =total;
        // 拿到当前的上拉刷新控件，变为没有更多数据的状态
       // [self.tableView.mj_footer endRefreshingWithNoMoreData];
        
        
        
    }
}


- (void)configRightButton{
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStyleDone target:self action:@selector(customcheckpoint)];
    self.navigationItem.rightBarButtonItem  = rightBarBtn;
    
}

- (void)customcheckpoint{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新增检查位置" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    alert.tag=100;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            UITextField *field = [alertView textFieldAtIndex:0];
            if (!field.text.length||[field.text isEqualToString:@""]) {
                
                
            }else{
                
                //先判断网上获取数据中是否已包含自定义的
                __block  NSInteger num = -1;
                [self.dataSourcelist enumerateObjectsUsingBlock:^(SMCheckpointModel *obj, NSUInteger idx, BOOL * stop) {
                    if ([obj.positionName isEqualToString:field.text]) {
                        num = idx;
                        *stop=YES;
                    }
                    
                }];
                if (num==-1) {
                    NSInteger count=-1;
                    NSArray *tempArr=[self.userdefaults objectForKey:kPosition];
                    for (NSString *str in tempArr) {
                        if ([str isEqualToString:field.text]) {
                            NSString *str=[NSString stringWithFormat:@"%@ 已经存在",field.text];
                            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                            count++;
                        }
                    }
                    
                    if (count==-1) {
                        SMCheckpointModel *checkpoint =[[SMCheckpointModel alloc] init];
                        checkpoint.checkPosId=@"0";
                        checkpoint.positionName  =field.text;
                        [self.saveDatalist insertObject:checkpoint atIndex:0];
                        
                        NSMutableArray *arr =[[NSMutableArray alloc] initWithArray:tempArr];
                        [arr insertObject:field.text atIndex:0];
                        
                        [self.userdefaults setObject:arr forKey:kPosition];
                        
                        [self.tableView reloadData];
                    }
                    
                    
                }else{
                    NSString *str=[NSString stringWithFormat:@"%@ 已经存在",field.text];
                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                    SMCheckpointModel *checkpoint =self.dataSourcelist[num];
                    self.checkpoint = checkpoint;
                    
                    UITableViewCell *cell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:num inSection:1]];
                    cell.accessoryType=UITableViewCellAccessoryCheckmark;
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:num inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    [self.tableView reloadData];
                    
                }
                
            }
            
        }

    }else if(alertView.tag==102){
        if (buttonIndex==1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView{
    if (alertView.tag==100) {
        UITextField *field = [alertView textFieldAtIndex:0];
        if (!field.text.length) {
            return NO;
        }else{
            return YES;
        }
    }else{
        return YES;
    }
    
 
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        if (self.saveDatalist.count) {
             return self.saveDatalist.count;
        }else{
            return 1;
        }
       
    }else{
        if (self.dataSourcelist.count) {
            return self.dataSourcelist.count;
        }else{
            return 1;
        }
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier =@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        if (self.saveDatalist.count==0) {
            
            cell.textLabel.text=@"暂无内容";
            cell.textLabel.textColor = [UIColor lightGrayColor];
            
        }else{
         
            SMCheckpointModel *checkpoint = self.saveDatalist[indexPath.row];
            cell.textLabel.text=checkpoint.positionName;
            if ([self.checkpoint.positionName isEqualToString:checkpoint.positionName]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.font =[UIFont  systemFontOfSize:15.0];
            cell.textLabel.textColor =[UIColor blackColor];
            
        }
        
        
    }else{
        if (self.dataSourcelist.count ==0) {
            
            cell.textLabel.text=@"暂无内容";
            cell.textLabel.textColor =[UIColor lightGrayColor];
            }
        else{
            SMCheckpointModel *checkpoint = self.dataSourcelist[indexPath.row];
            cell.textLabel.text=checkpoint.positionName;
            cell.textLabel.font =[UIFont  systemFontOfSize:15.0];
            cell.textLabel.textColor =[UIColor blackColor];

            if ([self.checkpoint.positionName isEqualToString:checkpoint.positionName]) {
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }
        }

        
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"新增检查位置";
    }else{
        return @"检查位置";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&self.saveDatalist.count) {
        SMCheckpointModel *checkpoint =self.saveDatalist[indexPath.row];
        self.passValue(checkpoint);
         self.checkpoint =checkpoint;
        [self.navigationController popViewControllerAnimated:YES];
       
    }else if(indexPath.section==1&&self.dataSourcelist.count){
        SMCheckpointModel *checkpoint =self.dataSourcelist[indexPath.row];
        self.passValue(checkpoint);
         self.checkpoint =checkpoint;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
 
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&self.saveDatalist.count) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
           if (editingStyle == UITableViewCellEditingStyleDelete) {
               if (indexPath.section==0&&self.saveDatalist.count){
                   
                   //1、从数据源中删除数据
                   [self.saveDatalist removeObjectAtIndex:indexPath.row];
                   
                   NSMutableArray *arr=[[self.userdefaults objectForKey:kPosition] mutableCopy];
                   [arr removeObjectAtIndex:indexPath.row];
                   
                   [self.userdefaults setObject:arr forKey:kPosition];
                   
                   //2、从tableview中删除cell
                   [self.tableView reloadData];
                   
                   
                   
               }
 
            
        }
    
}

- (void)queryCheckPositionRequset{
    NSString *pageStr=[NSString stringWithFormat:@"%li",page];
    NSDictionary *parameters = @{@"page":pageStr,
                                 @"rows":@"100"
                                 };
    [NetRequestClass NetRequestPOSTWithRequestURL:kQueryCheckPosition WithParameter:parameters WithReturnValeuBlock:^(id returnValue) {
        NSDictionary *dic =returnValue;
        NSDictionary *dict = dic[@"items"];
        NSArray *tempArr=[SMCheckpointModel mj_objectArrayWithKeyValuesArray:dict[@"rows"]];
        NSString *numStr=dict[@"total"];
        total =numStr.integerValue;
        
        if ([self.tableView.mj_header isRefreshing]) {
            [self.dataSourcelist removeAllObjects];
        }
        
        [self.dataSourcelist addObjectsFromArray:tempArr];
        
        NSMutableArray *arr=[[self.userdefaults objectForKey:kPosition] mutableCopy];
       [self.dataSourcelist enumerateObjectsUsingBlock:^(SMCheckpointModel *obj, NSUInteger idx, BOOL *stop) {
  
               [arr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * stop) {
                   if ([str isEqualToString:obj.positionName] ) {
                       [arr removeObject:str];
                       [self.saveDatalist removeObjectAtIndex:idx];
                       *stop=YES;
                   }
                   
               }];
       
           
       }];
        

        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        
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
    alert.tag=102;
    [alert show];
    
}

@end
