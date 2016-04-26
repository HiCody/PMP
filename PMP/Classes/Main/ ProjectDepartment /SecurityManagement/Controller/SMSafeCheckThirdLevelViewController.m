//
//  SMSafeCheckThirdLevelViewController.m
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafeCheckThirdLevelViewController.h"
#import "SMSafetyCheckEditProViewController.h"
#import "SMCheckIssureCell.h"
@interface AddButton : UIButton

@end

@implementation AddButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:4/255.0 green:169/255.0 blue:244/255.0 alpha:1.0]  forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.height * 0.3;
    CGFloat w = h;
    CGFloat x = self.width * 0.3;
    CGFloat y = (self.height-w)/2.0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.height*0.7/2, self.width, self.height * 0.3);
}


@end

@interface SMSafeCheckThirdLevelViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL isselected;
    NSArray *selectedArr;
}


@property(nonatomic,strong)NSMutableArray *contentArr;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UIView *bottomView;
@end

@implementation SMSafeCheckThirdLevelViewController
- (NSMutableArray *)contentArr{
    if (!_contentArr) {
        _contentArr = [[NSMutableArray alloc] init];
    }
    return _contentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=self.secondDetail.name;
    self.contentArr = [self.secondDetail.sections mutableCopy];
    NSMutableArray *tempArr=[[NSMutableArray alloc] init];
    for (SMSafetyContentThirdDetail *thirdDetail in self.contentArr) {
        if (thirdDetail.isOpen) {
            [tempArr addObject:thirdDetail];
        }
    }
    selectedArr =[tempArr copy];
    
       isselected =NO;

    [self confingRightBtn];
    [self configTableView];
     [self configBottomView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configBottomView{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    CGFloat  topHeight=rectStatus.size.height+rectNav.size.height;
    self.bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, WinHeight-topHeight-50, WinWidth, 50)];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:self.bottomView.bounds];
    imgView.image=[UIImage imageNamed:@"toolbar_bg"];
    [self.bottomView addSubview:imgView];
    [self.view addSubview:self.bottomView];
    
    AddButton *btn = [[AddButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 50.0)];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"新增检查问题" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"2-2"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(editNewPro:)forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn];
    
}

//编辑新增问题
-(void)editNewPro:(AddButton *)btn{
        SMSafetyCheckEditProViewController *editVC=[[SMSafetyCheckEditProViewController alloc] init];
    __weak typeof(self)weakself = self;
    editVC.passNewPro=^(SMSafetyContentThirdDetail *thirdDetail){
        [weakself.contentArr insertObject:thirdDetail atIndex:0];
        self.secondDetail.sections=weakself.contentArr;
        [weakself.tableView reloadData];
    };
    
    [self.navigationController  pushViewController:editVC animated:YES];
}

- (void)confingRightBtn{
    

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStyleDone target:self action:@selector(popBack)];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(addNewProblem)];
    self.navigationItem.rightBarButtonItem  =rightBarBtn;
}

- (void)popBack{
    if (!isselected) {
        
        for (SMSafetyContentThirdDetail *thirdDetail in self.secondDetail.sections) {
            NSInteger num=0;
            for (SMSafetyContentThirdDetail *thirdDetail2 in selectedArr) {
                if (thirdDetail==thirdDetail2) {
                    thirdDetail.isOpen=YES;
                    break;
                }else{
                    num++;
                }
            }
            if (num==selectedArr.count) {
                thirdDetail.isOpen=NO;
            }
            
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)addNewProblem{
    isselected  =YES;
    self.passThirdPro(self.secondDetail.sections);
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-50)];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMCheckIssureCell *cell=(SMCheckIssureCell *)[self getCellWithTableView:tableView];
    SMSafetyContentThirdDetail *thirdDetail = self.contentArr[indexPath.row];
    cell.title=thirdDetail.name;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    if (thirdDetail.isOpen) {
        
        cell.selectState=1;
        
    }else{
        
        cell.selectState=0;
        
    }
    return cell;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView{
    static NSString *identifier=@"cell";
    SMCheckIssureCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMCheckIssureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMCheckIssureCell *cell=(SMCheckIssureCell *)[self getCellWithTableView:tableView];
    SMSafetyContentThirdDetail *thirdDetail = self.contentArr[indexPath.row];
    cell.title=thirdDetail.name;
    return cell.cellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSafetyContentThirdDetail *smsc=self.contentArr[indexPath.row];
    
    smsc.isOpen=!smsc.isOpen;

    
    [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
    
   
    
}


@end
