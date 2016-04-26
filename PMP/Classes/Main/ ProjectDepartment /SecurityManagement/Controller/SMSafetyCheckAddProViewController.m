//
//  SMSafetyCheckAddProViewController.m
//  PMP
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SMSafetyCheckAddProViewController.h"
#import "SMSafetyCheckSecondLevelViewController.h"
#import "SMSafeCheckThirdLevelViewController.h"
#import "SMSafetyCheckFirstLevelViewController.h"
#import "SMSafetyCheckEditProViewController.h"
#import "NSString+NumRevretToChinese.h"
@interface DCButton : UIButton

@end

@implementation DCButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor]  forState:UIControlStateHighlighted];
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

@interface SMSafetyCheckAddProViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    SMSafetyContent *lastSafetyContent;
    NSInteger contentIndex;
}
@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *secondProArr;

@property(nonatomic,strong)NSMutableArray *thirdProArr;

@property(nonatomic,strong)UIView *changedbottomView;

@end

@implementation SMSafetyCheckAddProViewController
- (NSMutableArray *)secondProArr{
    if (!_secondProArr) {
        _secondProArr  =[[NSMutableArray alloc] init];
    }
    return _secondProArr;
}

- (NSMutableArray *)thirdProArr{
    if (!_thirdProArr) {
        _thirdProArr   = [[NSMutableArray alloc] init];
    }
    return _thirdProArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = @"新增检查";
    contentIndex = 0;
    
    [self configTableView];
    
    if (self.safetyContent) {
        lastSafetyContent = [[SMSafetyContent alloc] init];
        NSDictionary *stuDict = self.safetyContent.mj_keyValues;
        NSString *str =stuDict.mj_JSONObject;
        lastSafetyContent = [SMSafetyContent mj_objectWithKeyValues:str];
        self.safetyContent = lastSafetyContent;
        [self confingChangedBottomViewWithText:self.safetyContent.name];

        for (SMSafetyContentSecondDetail *secondDetail in self.safetyContent.sections) {
            NSMutableArray *tempArr=[[NSMutableArray alloc] init];
            if (secondDetail.isOpen) {
                [self.secondProArr addObject:secondDetail];
                for (SMSafetyContentThirdDetail *thirdDetail in secondDetail.sections) {
                    if (thirdDetail.isOpen) {
                         [tempArr addObject:thirdDetail];
                    }
                   
                }
                [self.thirdProArr addObject:tempArr];
            }
            
        }
        
    }else{
        [self configBottomView];
    }
    

    
    [self configRightBtn];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)configRightBtn{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_btn"] style:UIBarButtonItemStyleDone target:self action:@selector(popBack)];
    
    
     self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *rightBtn =[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(ensureProblem)];
    self.navigationItem.rightBarButtonItem  =rightBtn;
}

- (void)popBack{
 
    [self.navigationController popViewControllerAnimated:YES];
}


//确定提交问题
- (void)ensureProblem{
    if (self.safetyContent) {
        NSInteger num =0;
        for (SMSafetyContentSecondDetail *secondDetail in self.safetyContent.sections) {
            
            if (secondDetail.isOpen) {
                num++;
                NSInteger count=0;
                for (SMSafetyContentThirdDetail *thirdDetail in secondDetail.sections) {
                    if (thirdDetail.isOpen) {
                        count++;
                    }
                }
                if (!count) {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择检查问题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil];
                    [alert show];
                    return ;
                }
            }
        }
        if (num) {
            
            self.passCheckPro(self.safetyContent);
            [self.navigationController popViewControllerAnimated:YES];
           
        }
        
    }
  
}

- (void)configTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-50) style:UITableViewStyleGrouped];
    self.tableView.dataSource =self;
    self.tableView.delegate=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}


- (void)configBottomView{
    
    self.bottomView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WinWidth, 50)];
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:self.bottomView.bounds];
    imgView.image=[UIImage imageNamed:@"toolbar_bg"];
    [self.bottomView addSubview:imgView];
    [self.view addSubview:self.bottomView];

    DCButton *btn = [[DCButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 50.0)];
    
    [btn setTitleColor:NAVI_SECOND_COLOR forState:UIControlStateNormal];
    [btn setTitle:@"添加检查内容" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"2-2"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addSafetyCheck:)forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:btn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btn.frame), WinWidth, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.bottomView addSubview:lineView];


}

- (void)confingChangedBottomViewWithText:(NSString *)str{
    self.changedbottomView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, WinWidth, 100)];
    
    UIView *lineView1=[[UIView alloc] initWithFrame:CGRectMake(0, 49.5, WinWidth, 0.5)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    [self.changedbottomView addSubview:lineView1];
    
    UILabel *lable =[[UILabel alloc] initWithFrame:CGRectMake(15, 0, WinWidth-30, 49.5)];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.text=[NSString stringWithFormat:@"%@",str];
    lable.font =[UIFont boldSystemFontOfSize:18.0];
     [self.changedbottomView addSubview:lable];
    
    UIImageView *img =[[UIImageView alloc]initWithFrame:CGRectMake(WinWidth-25, 20, 15, 15)];
    img.image = [UIImage imageNamed:@"40 前往.png"];
     img.contentMode = UIViewContentModeScaleAspectFit;
    [self.changedbottomView addSubview:img];
    
    
    UIButton *btn2=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 50)];
    btn2.backgroundColor=[UIColor clearColor];
    [btn2 addTarget:self action:@selector(addSafetyCheck:)forControlEvents:UIControlEventTouchUpInside];
    [self.changedbottomView addSubview:btn2];
    btn2.enabled = !self.isEditing;

    DCButton *btn1 = [[DCButton alloc] initWithFrame:CGRectMake(0, 50, WinWidth, 49.5)];
    
    [btn1 setTitleColor:NAVI_SECOND_COLOR forState:UIControlStateNormal];
    [btn1 setTitle:@"添加检查项目" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"2-2"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(addSafetySecondCheck:)forControlEvents:UIControlEventTouchUpInside];
    [self.changedbottomView addSubview:btn1];
    
    UIView *lineView2=[[UIView alloc] initWithFrame:CGRectMake(0, 99.5, WinWidth, 0.5)];
    lineView2.backgroundColor=[UIColor lightGrayColor];
    [self.changedbottomView addSubview:lineView2];

    
    [self.view addSubview:self.changedbottomView];
    
    self.tableView.frame = CGRectMake(0, 100, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)-100);
}

//此处添加问题分组！！！！！！
- (void)addSafetyCheck:(DCButton *)btn{
    if (contentIndex) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"提示" message:@"确认变更检查内容 ?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        [self chooseCheckContent];
    }
    
    contentIndex++;
}

- (void)chooseCheckContent{
    SMSafetyCheckFirstLevelViewController *safecheckFLVC=[[SMSafetyCheckFirstLevelViewController alloc] init];
    __weak typeof(self)weakself = self;
    safecheckFLVC.passFirstPro=^(SMSafetyContent *safetycontent){
        weakself.safetyContent=safetycontent;
        [weakself.bottomView removeFromSuperview];
        [weakself.changedbottomView removeFromSuperview];
        [weakself confingChangedBottomViewWithText:safetycontent.name];
        
        [weakself.secondProArr removeAllObjects];
        [weakself.thirdProArr removeAllObjects];
        [weakself.tableView reloadData];
    };
    // safecheckFLVC.safetycontent = self.safetyContent;
    NSMutableArray *arr;
    if (self.compareArr.count) {
        arr=[[NSMutableArray alloc] initWithArray:self.compareArr];
    }else{
        arr = [[NSMutableArray alloc] init];
    }
    if (self.safetyContent) {
        [arr addObject:self.safetyContent];
    }
    
    safecheckFLVC.compareArr=arr;
    [self.navigationController pushViewController:safecheckFLVC animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
        [self chooseCheckContent];
        
    }
}

- (void)addSafetySecondCheck:(UIButton *)btn{
        SMSafetyCheckSecondLevelViewController *safetycheckVC=[[SMSafetyCheckSecondLevelViewController alloc] init];
        safetycheckVC.safetycontent = self.safetyContent;
    
        __weak typeof(self)weakself = self;
        safetycheckVC.passSecondPro=^(SMSafetyContentSecondDetail *secondDetail){
            NSArray *arr=[[NSArray alloc] init];
            [weakself.thirdProArr addObject:arr];
            [weakself.secondProArr addObject:secondDetail];
            [weakself.tableView reloadData];
        };
    
        [self.navigationController pushViewController:safetycheckVC animated:YES];
}


#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.secondProArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (self.thirdProArr.count) {
         NSArray *arr= self.thirdProArr[section];
        return 3+arr.count;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }else{
        while ([cell.contentView.subviews lastObject] != nil) {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    cell.accessoryType   = UITableViewCellAccessoryNone;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        
        NSString *numStr=[NSString stringWithFormat:@"%li",indexPath.section+1];
        NSString *numChinsese = [NSString translation:numStr];
        cell.textLabel.text=[NSString  stringWithFormat:@"%@.检查项目:",numChinsese];
        cell.textLabel.font =[UIFont boldSystemFontOfSize:18.0];
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(WinWidth-50, 7.5, 50, 40)];
        [btn setImage:[UIImage imageNamed:@"40 删除"] forState:UIControlStateNormal];
     //   [btn setTitle:@"删除" forState:UIControlStateNormal];
        btn.tag=indexPath.section+50;
        [btn addTarget:self action:@selector(deleteCheckProject:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [cell.contentView addSubview:btn];
        
    }else if(indexPath.row==1){
        
        SMSafetyContentSecondDetail *scsd = self.secondProArr[indexPath.section];

        cell.textLabel.text = scsd.name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font =[UIFont systemFontOfSize:15.0];
        
    }else if(indexPath.row==2){
        
        cell.textLabel.text = @"检查问题:";
        cell.textLabel.font =[UIFont boldSystemFontOfSize:18.0];
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(WinWidth-50, 7.5, 50, 40)];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.tag=indexPath.section+100;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn addTarget:self action:@selector(addCheckProblem:) forControlEvents:UIControlEventTouchUpInside];
     //   [btn setTitle:@"添加" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"40 添加"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btn];
        
    }else{
        
        cell.textLabel.font =[UIFont systemFontOfSize:15.0];
         NSArray *tempArr = self.thirdProArr[indexPath.section];
        SMSafetyContentThirdDetail *thirdDetail=tempArr[indexPath.row-3];
        cell.textLabel.numberOfLines=3;
        
        NSString *numStr=[NSString stringWithFormat:@"%i",indexPath.row-2];
        
        cell.textLabel.text=[NSString stringWithFormat:@"%@.%@",numStr,thirdDetail.name];
        
    }
    
    return cell;
    
}

- (void)deleteCheckProject:(UIButton *)btn{
    SMSafetyContentSecondDetail *scsd = self.secondProArr[btn.tag-50];
    scsd.isOpen=NO;
    
    for (SMSafetyContentThirdDetail *thirdDetail in scsd.sections) {
        thirdDetail.isOpen=NO;
    }
    
    [self.secondProArr removeObjectAtIndex:btn.tag-50];
    [self.thirdProArr removeObjectAtIndex:btn.tag-50];
    [self.tableView reloadData];

}

- (void)addCheckProblem:(UIButton *)btn{
    SMSafetyContentSecondDetail *scsd = self.secondProArr[btn.tag-100];
    SMSafeCheckThirdLevelViewController *safecheckTLVC=[[SMSafeCheckThirdLevelViewController alloc] init];
    safecheckTLVC.secondDetail =scsd;
     __weak typeof(self)weakself = self;
  
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    safecheckTLVC.passThirdPro=^(NSArray *thirdArr){
        
        for (SMSafetyContentThirdDetail *thirdDetail in thirdArr) {
            if (thirdDetail.isOpen) {
                [arr addObject:thirdDetail];
            }
        }
        [weakself.thirdProArr replaceObjectAtIndex:(btn.tag-100) withObject:arr];
        [weakself.tableView reloadData];
        
    };
    
    [self.navigationController pushViewController:safecheckTLVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1.0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *likeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 实现相关的逻辑代码
        SMSafetyCheckEditProViewController *editProVC=[[SMSafetyCheckEditProViewController alloc] init];
        NSArray *arr= self.thirdProArr[indexPath.section];
        NSMutableArray *tempArr=[[NSMutableArray alloc] initWithArray:arr];
        SMSafetyContentThirdDetail *thirdDetail =tempArr[indexPath.row-3];
        editProVC.proStr = thirdDetail.name;
        __weak typeof(self)weakself  =self;
        editProVC.passNewPro = ^(SMSafetyContentThirdDetail *tempThirdDetail){
            if (![tempThirdDetail.name isEqualToString:thirdDetail.name]) {
    
                thirdDetail.isOpen=NO;
                
                SMSafetyContentSecondDetail *secondDetail = weakself.secondProArr[indexPath.section];
            
                NSMutableArray *tempArr2=[[NSMutableArray alloc] initWithArray:secondDetail.sections];
                [secondDetail.sections enumerateObjectsUsingBlock:^(SMSafetyContentThirdDetail *obj, NSUInteger idx, BOOL *stop) {
                    
                    if ([obj.name isEqualToString:thirdDetail.name]) {
                        
                        [tempArr2 insertObject:tempThirdDetail atIndex:idx];
                        
                        *stop = YES;
                    }
                    
                }];
                secondDetail.sections  =[tempArr2 copy];
                
                [tempArr insertObject:tempThirdDetail atIndex:indexPath.row-3];
                [tempArr removeObject:thirdDetail];
                weakself.thirdProArr[indexPath.section]=tempArr;
    
                [self.tableView reloadData];
            }
        };
        
        [self.navigationController pushViewController:editProVC animated:YES];
        // 在最后希望cell可以自动回到默认状态，所以需要退出编辑模式
        tableView.editing = NO;
    }];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        NSArray *arr= self.thirdProArr[indexPath.section];
        NSMutableArray *tempArr=[[NSMutableArray alloc] initWithArray:arr];
        SMSafetyContentThirdDetail *thirdDetail =tempArr[indexPath.row-3];
        thirdDetail.isOpen=NO;
        [tempArr removeObject:thirdDetail];
        [self.thirdProArr replaceObjectAtIndex:indexPath.section withObject:tempArr];
        [tableView reloadData];
    
    }];
    
    return @[deleteAction, likeAction];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>2) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.row>2){
            
            NSArray *arr= self.thirdProArr[indexPath.section];
            NSMutableArray *tempArr=[[NSMutableArray alloc] initWithArray:arr];
            SMSafetyContentThirdDetail *thirdDetail =tempArr[indexPath.row-3];
            thirdDetail.isOpen=NO;
            [tempArr removeObject:thirdDetail];
            [self.thirdProArr replaceObjectAtIndex:indexPath.section withObject:tempArr];
            [tableView reloadData];

        }
 
    }


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        SMSafetyCheckSecondLevelViewController *safetycheckSLVC=[[SMSafetyCheckSecondLevelViewController alloc] init];
        safetycheckSLVC.safetycontent = self.safetyContent;
         __weak typeof(self)weakself = self;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        safetycheckSLVC.passSecondPro=^(SMSafetyContentSecondDetail *secondDetail){
            
            cell.textLabel.text  =secondDetail.name;
            SMSafetyContentSecondDetail *tempSecond =weakself.secondProArr[indexPath.section];
            tempSecond.isOpen=NO;
            for (SMSafetyContentThirdDetail *thirdDetail in tempSecond.sections) {
                thirdDetail.isOpen=NO;
            }
            [weakself.thirdProArr replaceObjectAtIndex:indexPath.section withObject:[[NSArray alloc] init]];
            [weakself.secondProArr replaceObjectAtIndex:indexPath.section withObject:secondDetail];
            [weakself.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:safetycheckSLVC animated:YES];
    }
}
@end
