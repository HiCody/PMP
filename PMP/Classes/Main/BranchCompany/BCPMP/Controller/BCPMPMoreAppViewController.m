//
//  BCPMPMoreAppViewController.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCPMPMoreAppViewController.h"
#import "GridItemModel.h"
#import "AddGridView.h"
#import "NotfindView.h"
@interface BCPMPMoreAppViewController ()<AddGridViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)AddGridView *addGridView;
@property (nonatomic,strong)NSMutableArray *deletateArr;
@property (nonatomic,strong)NotfindView *notfindView;

@end

@implementation BCPMPMoreAppViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray=[[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSMutableArray *)deletateArr{
    if (!_deletateArr) {
        
        _deletateArr=[[NSMutableArray alloc] init];
    }
    return _deletateArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.showBackBtn=YES;
    [self configGridView];
    [self setUpNavBar];
    
    self.notfindView =[[NotfindView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, self.view.height)];
    [self.view addSubview:self.notfindView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    [self setUpNavBar];
//    
//}

- (void)setUpNavBar{
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithHexString:Navi_hexcolor];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    NSMutableDictionary *attrs=[[NSMutableDictionary alloc]init];
    attrs[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attrs[NSFontAttributeName]=[UIFont boldSystemFontOfSize:19];
    [self.navigationController.navigationBar setTitleTextAttributes:attrs];
}


//添加GridView
- (void)configGridView{
    self.addGridView=[[AddGridView alloc] init];
    self.addGridView.frame=self.view.frame;
    self.addGridView.addItemDelegate =self;
    self.addGridView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:self.addGridView];
    
    [self getDataListFromSand];
    
    self.addGridView.gridModelsArray =self.deletateArr;
}

//获取沙盒内的GridView
-(void)getDataListFromSand{
    NSString *path = [self gridfilePath];
    self.dataArray = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSString *path2 = [self addGridfilePath];
    self.deletateArr = [NSKeyedUnarchiver unarchiveObjectWithFile:path2];
    
}

//保存现有的GriView
-(void)saveDataListToSand{
    NSString *path = [self gridfilePath];
    [NSKeyedArchiver archiveRootObject:self.dataArray toFile:path];
    
    NSString *path2 = [self addGridfilePath];
    [NSKeyedArchiver archiveRootObject:self.deletateArr toFile:path2];
}

//归档路径
- (NSString *)addGridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"AddGrid2.plist"];
}

- (NSString *)gridfilePath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Grid2.plist"];
}

#pragma mark AddGridViewDelegate
- (void)addItemGridViewPassAddValue:(GridItemModel *)model{
    [self.deletateArr removeObject:model];
    [self.dataArray addObject:model];
    [self saveDataListToSand];
}

@end
