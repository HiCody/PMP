//
//  SMDraftViewController.m
//  PMP
//
//  Created by mac on 15/12/8.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMDraftViewController.h"
#import "SMImage.h"
#import "SMIssureDetailModel.h"
#import "SMAddSafetyCheckViewController.h"
#import "SMCheckdetailViewController.h"
#import "SMSafetyContent.h"
#import "NotfindView.h"

@interface SMDraftViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *datalist;

@property(nonatomic,strong)NotfindView *notfindView;

@property(nonatomic,strong)UIButton *deletebutton;
@end

@implementation SMDraftViewController
- (NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist = [[NSMutableArray alloc] init];
    }
    return _datalist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"草稿箱";
    
    [self configTableView];
    [self setUpBackBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.datalist removeAllObjects];
    [self getDataFromSandBox];
    [self.tableView reloadData];
    [self configRightBtn];
    //添加没有数据时候的视图
    self.notfindView=[[NotfindView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    
    if (self.datalist.count ==0) {
        [self.tableView addSubview:self.notfindView];
        self.deletebutton.hidden=YES;
    }
    else{
        [self.notfindView removeFromSuperview];
        self.deletebutton.hidden=NO;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpBackBtn{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}


- (void)configRightBtn{
    self.navigationItem.backBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -20;
    
   self.deletebutton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [ self.deletebutton addTarget:self action:@selector(toggleDelete:) forControlEvents:UIControlEventTouchUpInside];
    [ self.deletebutton setTitle:@"删除" forState:UIControlStateNormal];
    UIBarButtonItem *moveBtn=[[UIBarButtonItem alloc] initWithCustomView: self.deletebutton];
    self.navigationItem.rightBarButtonItems=@[negativeSeperator,moveBtn];
}

-(void)toggleDelete:(UIButton *)item{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    [item setTitle:self.tableView.editing?@"完成":@"删除" forState:UIControlStateNormal];
}

//得到保存在沙盒的数据
- (void)getDataFromSandBox{
   
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *arr= [userDefaults arrayForKey:kDraft];
    for (NSDictionary *dict in arr) {
        
        SMIssureDetailModel *detailModel = [SMIssureDetailModel mj_objectWithKeyValues:dict];
        [self.datalist addObject:detailModel];
        
    }
}

- (void)configTableView{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-60) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self.view addSubview:self.tableView];
    
    }

//将lable转换为image
-(UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


#pragma mark  UITableViewDataSource,UITableViewDelegate

//section的个数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每个section的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datalist.count;
}

//选中事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     SMIssureDetailModel *detailModel = self.datalist[indexPath.row];
    
    if (detailModel.saveType==1) {
        SMCheckdetailViewController *detailVC=[[SMCheckdetailViewController alloc] init];
        detailVC.checkId =detailModel.checkId;
        if (detailModel.recheckProblemList.count) {
             Recheckproblemlist *recheckProList = (Recheckproblemlist *)detailModel.recheckProblemList.firstObject;
            for (Recheckinfolist *infolist in recheckProList.recheckInfoList ) {
                NSMutableArray *tempArr=[[NSMutableArray alloc] init];
                for (int i=0; i<infolist.imageArr.count; i++) {
                    NSString  *jpgPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    jpgPath = [jpgPath stringByAppendingPathComponent:infolist.imageArr[i]];
                    
                    UIImage *image=[UIImage imageWithContentsOfFile:jpgPath];
                    [tempArr addObject:image];
                }
                [infolist.imageArr removeAllObjects];
                [infolist.imageArr addObjectsFromArray:tempArr];
            }
             detailVC.recheckProList = recheckProList;
           
        }
        
        [self.navigationController pushViewController:detailVC animated:YES];
      
    }else{
        SMAddSafetyCheckViewController *addVC=[[SMAddSafetyCheckViewController alloc] init];
        addVC.issureDetailModel = detailModel;
  
        [self.navigationController pushViewController:addVC animated:YES];
    }
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
      UIView *imgView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, 50,50)];
    UILabel *imgLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, 50,25)];
    UILabel *imgLab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 50,25)];
    [imgView addSubview:imgLab];
    [imgView addSubview:imgLab2];
    imgLab.text =@"待";
    imgLab2.text=@"上传";
    imgLab.backgroundColor=[UIColor clearColor];
    imgLab2.backgroundColor=[UIColor clearColor];
    imgView.backgroundColor=[UIColor orangeColor];

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
    
    SMIssureDetailModel *detailModel = self.datalist[indexPath.row];
    switch (detailModel.checkTypeId) {
        case 1:
            cell.textLabel.text = @"日常检查";
            break;
        case 2:
            cell.textLabel.text = @"专项检查";
            break;
        default:
            break;
    }
   // cell.detailTextLabel.lineBreakMode=NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines=3;
    if (detailModel.saveType==1) {
      
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
          for (Checkinfoproblemclasslist *proClasslist in detailModel.checkInfoProblemClassList) {
              for (Checkinfodetaillist *detailList in proClasslist.checkInfoDetailList) {
                  
                  if (detailList.checkProblemName) {
                      [tempArr addObject:detailList.checkProblemName];
                  }
                  if (detailList.problemDesc) {
                      [tempArr addObject:detailList.problemDesc];
                  }
              }
          }
        
        cell.detailTextLabel.text = [tempArr componentsJoinedByString:@","];
 
    }else{
        NSMutableArray *tempArr=[[NSMutableArray alloc] init];
        for (Checkinfoproblemclasslist *proClasslist in detailModel.checkInfoProblemClassList) {
            for (SMSafetyContent *content in proClasslist.safetyContentArr) {
                for (SMSafetyContentSecondDetail *second in content.sections) {
                    for (SMSafetyContentThirdDetail *third in second.sections) {
                        if (third.isOpen) {
                            [tempArr addObject:third.name];
                        }
                        
                    }
                }
            }
        }
        NSString *str =[tempArr componentsJoinedByString:@","];
        cell.detailTextLabel.text= str;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //1、从数据源中删除数据
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *arr= [userDefaults arrayForKey:kDraft];
        NSMutableArray *tempArr=[[NSMutableArray alloc] initWithArray:arr];
        [tempArr removeObjectAtIndex:indexPath.row];
        [self.datalist removeObjectAtIndex:indexPath.row];
        
        [userDefaults setObject:tempArr forKey:kDraft];
        //2、从tableview中删除cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (!self.datalist.count) {
             self.deletebutton.hidden=YES;
            [self.tableView addSubview:self.notfindView];
        }else{
            [self.notfindView removeFromSuperview];
             self.deletebutton.hidden=NO;
        }
    }
}


//使cell的下划线顶头，沾满整个屏幕宽
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

//获取文字处理后的尺寸
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs=@{NSFontAttributeName:font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
 }




@end