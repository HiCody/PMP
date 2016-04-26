//
//  SMSafetyCheckFirstLevelViewController.m
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckFirstLevelViewController.h"
#import <FMDB.h>
#import "SMAddSafetyCheckCell.h"
#import "SMSafetyCheckAddProViewController.h"
@interface SMSafetyCheckFirstLevelViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)FMDatabase *db;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *contentForShowArr;
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation SMSafetyCheckFirstLevelViewController
-(NSMutableArray *)contentArr{
    if (!_contentArr) {
        
        _contentArr=[[NSMutableArray alloc]init];
        
    }
    return _contentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加安全检查内容";
    [self installFileOfName];
    [self didSearch];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
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

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    SMAddSafetyCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[SMAddSafetyCheckCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    
    SMSafetyContent *smsc=self.contentArr[indexPath.row];

    cell.nameLable.text=smsc.name;
    cell.nameLable.textColor =[UIColor blackColor];
    
    if (self.compareArr.count) {
        for (SMSafetyContent *safetycontent in self.compareArr) {
            if ([smsc.classID isEqualToString:safetycontent.classID]) {
                smsc.isOpen=YES;
                cell.nameLable.textColor =[UIColor lightGrayColor];
                break;
            }
        }
    }

    
//    if ([smsc.classID isEqualToString:self.safetycontent.classID]) {
//        smsc.isOpen=YES;
//        cell.nameLable.textColor =[UIColor lightGrayColor];
//    }
    
    if (smsc.isOpen) {
        cell.selectState=1;
    }else{
        cell.selectState=0;
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SMSafetyContent *smsc=self.contentArr[indexPath.row];
    NSInteger num=0;
    if (self.compareArr.count) {
        for (SMSafetyContent *safetycontent in self.compareArr) {
            if ([smsc.classID isEqualToString:safetycontent.classID]) {
                num++;
            }
            
        }
        if (!num) {
            smsc.isOpen=YES;
            
            self.passFirstPro(smsc);
            
            [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    }else{
        smsc.isOpen=YES;
        
        self.passFirstPro(smsc);
        
        [tableView reloadRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationNone];
        [self.navigationController popViewControllerAnimated:YES];
    }

    
//    if (![smsc.classID isEqualToString:self.safetycontent.classID]) {
//        
//    }
    
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
