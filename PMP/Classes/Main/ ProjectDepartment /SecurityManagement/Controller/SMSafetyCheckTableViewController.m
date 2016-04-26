//
//  SMSafetyCheckTableViewController.m
//  PMP
//
//  Created by mac on 15/12/2.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckTableViewController.h"
#import <FMDB.h>
#import "SMSafetyContent.h"
#import "SMSafetyCheckShowView.h"
#import "SMAddSafetyCheckCell.h"
@interface SafetyCheckBtn : UIButton

@end

@implementation SafetyCheckBtn

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17.0];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat h = self.height * 0.3;
    CGFloat w = h;
    CGFloat x = self.width-w-15;
    CGFloat y = (self.height-h)/2.0;
    return CGRectMake(x, y, w, h);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(15, self.height * 0.4/2.0, self.width*0.6, self.height * 0.6);
}


@end


@interface SMSafetyCheckTableViewController ()<UITableViewDataSource,UITableViewDelegate,SMSafetyCheckShowViewDelegate>
@property(strong,nonatomic)FMDatabase *db;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *contentForShowArr;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *selectedArr;//所以选中的cell
@property(nonatomic,strong)NSMutableArray *itemArr;//选中的内容

@end

@implementation SMSafetyCheckTableViewController
- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [[NSMutableArray alloc] init];
    }
    return _selectedArr;
}

- (NSMutableArray *)itemArr{
    if (!_itemArr) {
        _itemArr = [[NSMutableArray alloc] init];
    }
    return _itemArr;
}

-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        
        _contentArr=[[NSMutableArray alloc]init];
        
    }
    return _contentArr;
}

-(NSMutableArray *)contentForShowArr{
    if (!_contentForShowArr) {
        _contentForShowArr=[[NSMutableArray alloc]init];
    }
    return _contentForShowArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加安全检查内容";
    [self installFileOfName];
    [self didSearch];
    [self configRightBtn];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    [self.view addSubview:self.tableView];
}

- (void)configRightBtn{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(TransportData)];
    
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)TransportData{
    NSArray *tempArr  =[[NSMutableArray alloc] initWithArray:self.contentArr];
    [tempArr enumerateObjectsUsingBlock:^(SMSafetyContent *obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSMutableArray *tempArr2=[[NSMutableArray alloc] init];
        
        [obj.sections enumerateObjectsUsingBlock:^(SMSafetyContentSecondDetail *obj1, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj1.isOpen) {
                NSMutableArray *tempArr3=[[NSMutableArray alloc] init];
                [obj1.sections enumerateObjectsUsingBlock:^(SMSafetyContentThirdDetail *obj3, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj3.isOpen) {
                        [tempArr3 addObject:obj3];
                    }
                }];
                obj1.sections=tempArr3;
                [tempArr2 addObject:obj1];
            }
        }];
        
        if (tempArr2.count) {
            obj.sections=tempArr2;
            [self.itemArr addObject:obj];
        }
        
    }];
    for (int i=0; i<self.itemArr.count;i++ ) {
        SMSafetyContent *c=self.itemArr[i];
        for (int j=0; j<c.sections.count; j++) {
            SMSafetyContentSecondDetail *t=c.sections[j];
            NSLog(@"%@",t.name);
            for (int h=0; h<t.sections.count; h++) {
                SMSafetyContentThirdDetail *td=t.sections[h];
                NSLog(@"%@",td.name);
            }
        }
    }
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SMSafetyCheckViewPassData: AtIndex:)]) {
        
        [self.delegate SMSafetyCheckViewPassData:self.itemArr AtIndex:self.index];
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.contentArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    SMSafetyContent *smsc=self.contentArr[section];
    
    if (smsc.isOpen) {
       
        return smsc.sections.count;
    }else{
         return 0;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    SMAddSafetyCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMAddSafetyCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
     SMSafetyContent *smsc=self.contentArr[indexPath.section];
    SMSafetyContentSecondDetail *smscsd = smsc.sections[indexPath.row];
    cell.nameLable.text=smscsd.name;
    if (smscsd.isOpen) {
        cell.selectState=1;
    }else{
        cell.selectState=0;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 50)];
    view.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 250, 30)];
    lable.backgroundColor=[UIColor clearColor];
    lable.font=[UIFont systemFontOfSize:17.0];
    SMSafetyContent *smsc=self.contentArr[section];
    lable.text=smsc.name;
    SafetyCheckBtn *btn =[[SafetyCheckBtn alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 49.5)];
    [btn setTitle:smsc.name forState:UIControlStateNormal];
    if (smsc.isOpen) {
        [btn setImage:[UIImage imageNamed:@"arrow_down1"] forState:UIControlStateNormal];
    }else{
        [btn setImage:[UIImage imageNamed:@"arrow_right1"] forState:UIControlStateNormal];
    }
    [btn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = section;
    [btn addTarget:self action:@selector(hideOrShow:) forControlEvents:UIControlEventTouchUpInside];
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 0.5)];
    line.backgroundColor=[UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [view addSubview:line];
    
    [view addSubview:btn];
    
    return view;
}

- (void)hideOrShow:(UIButton *)btn{
    SMSafetyContent *smsc=self.contentArr[btn.tag];
    smsc.isOpen = !smsc.isOpen;
    if (smsc.isOpen) {
        [btn setImage:[UIImage imageNamed:@"arrow_down1"] forState:UIControlStateNormal];
    }else{
         [btn setImage:[UIImage imageNamed:@"arrow_right1"] forState:UIControlStateNormal];
    }
    NSIndexSet *set=[NSIndexSet indexSetWithIndex:btn.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMSafetyCheckShowView *showView=[[SMSafetyCheckShowView alloc] init];
    showView.delegate=self;
    
    SMSafetyContent *smsc=self.contentArr[indexPath.section];
    SMSafetyContentSecondDetail *smscsd = smsc.sections[indexPath.row];
    smscsd.isOpen=YES;
    showView.dataArr = smscsd.sections;
    [self.selectedArr addObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [[UIApplication sharedApplication].delegate.window addSubview:showView];
    
    
}

#pragma mark SMSafetyCheckShowViewDelegate
- (void)SMSafetyCheckShowViewCancelled{
    NSIndexPath *indexPath=self.selectedArr.lastObject;
    SMSafetyContent *smsc=self.contentArr[indexPath.section];
    SMSafetyContentSecondDetail *smscsd = smsc.sections[indexPath.row];

    __block NSInteger num=-1;
    [smscsd.sections enumerateObjectsUsingBlock:^(SMSafetyContentThirdDetail *thridDetail, NSUInteger idx, BOOL * _Nonnull stop) {
        if (thridDetail.isOpen) {
            num++;
        }
    }];
    if (num==-1) {
        smscsd.isOpen=NO;
        [self.selectedArr removeLastObject];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)SMSafetyCheckShowViewFinishedPickkingFilter:(NSArray *)Filter{
    
    NSIndexPath *indexPath=self.selectedArr.lastObject;
    SMSafetyContent *smsc=self.contentArr[indexPath.section];
    SMSafetyContentSecondDetail *smscsd = smsc.sections[indexPath.row];
    if (!Filter.count) {
        smscsd.isOpen=NO;
         [self.selectedArr removeLastObject];
         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
   
}

#pragma mark FMDB
- (void)installFileOfName{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [path stringByAppendingPathComponent:@"safe.db"];
    NSLog(@"%@",fileName);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:fileName];
    //- (BOOL)fileExistsAtPath:(NSString *)path;
    
    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist)
    {
        //拷贝数据库
        
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:@"safe.db"
                                  ofType:nil];
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        NSError *error;
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:fileName error:&error];
        NSLog(@"cp = %d",cp);
        //- (BOOL)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath error:(NSError **)error
        NSLog(@"backupDbPath =%@",backupDbPath);
        
    }
    
    self.db = [FMDatabase databaseWithPath:fileName];
    
    // 2.打开数据库
    if ([self.db open]) {
        NSLog(@"打开成功");
        
    }else
    {
        NSLog(@"打开失败");
    }
    [self.db close];
}

- (void)didSearch{
    if ([self.db open]) {
        
        FMResultSet *set =[self.db executeQuery:@"SELECT * FROM safety_d_checkcontent"];
        
        while ([set next]) {
            NSString *contentName =[set stringForColumn:@"CheckContentName"];
            NSString *contentId = [set stringForColumn:@"CheckContentId"];
            SMSafetyContent *safetyContent =[[SMSafetyContent alloc] init];
            safetyContent.name = contentName;
            safetyContent.isOpen = NO;
            safetyContent.classID = contentId;
            
            [self.contentArr addObject:safetyContent];
      
        }
        
      
        for (SMSafetyContent *safetyContent in self.contentArr) {
            NSString *str=[NSString stringWithFormat:@"SELECT * FROM safety_d_checkitem WHERE CheckContentId='%@'",safetyContent.classID];
            set = [self.db executeQuery:str];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            while ([set next]) {
                NSString *str = [set stringForColumn:@"CheckItemName"];
                 NSString *itemId = [set stringForColumn:@"CheckItemId"];
                SMSafetyContentSecondDetail *smscsd=[[SMSafetyContentSecondDetail alloc] init];
                smscsd.isOpen = NO;
                smscsd.name= str;
                smscsd.classID = itemId;
               
                [arr addObject:smscsd];
            }
            safetyContent.sections = arr;
        }
        
        for (SMSafetyContent *safetyContent in self.contentArr) {
            
            for ( SMSafetyContentSecondDetail *smscsd in safetyContent.sections) {
                NSString *str=[NSString stringWithFormat:@"SELECT * FROM safety_d_checkproblem WHERE CheckItemId='%@'",smscsd.classID];
                set = [self.db executeQuery:str];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
    
                while ([set next]) {
                    NSString *str = [set stringForColumn:@"CheckProblemName"];
                    NSString *itemId = [set stringForColumn:@"CheckProblemId"];
                    SMSafetyContentThirdDetail *smsctd=[[SMSafetyContentThirdDetail alloc] init];
                    smsctd.isOpen = NO;
                    smsctd.name=str;
                    smsctd.classID=itemId;
                    [arr addObject:smsctd];
                   
                }
                NSString *numStr=[NSString stringWithFormat:@"%@00",smscsd.classID];
                SMSafetyContentThirdDetail *smsctd1=[[SMSafetyContentThirdDetail alloc] init];
                smsctd1.isOpen = NO;
                smsctd1.name=@"其他";
                smsctd1.classID=numStr;
                [arr insertObject:smsctd1 atIndex:0];
       
                smscsd.sections =  arr;

            }
            
        }
        
    }
    
    [self.db close];
    [self configTableView];
}




@end
