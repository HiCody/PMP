
//
//  SMFilterTableView.m
//  PMP
//
//  Created by 顾佳洪 on 16/1/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "SMFilterTableView.h"
#import "PopMenuTableView.h"
#import "KLCPopup.h"
#import "WHUCalendarPopView.h"

@interface SMFilterTableView()<PopMenuDelegate>{
    NSInteger index;
     WHUCalendarPopView* _pop;
}

@property(nonatomic,strong)NSArray *datalist;
@property (nonatomic,strong)UITextField *nameText;
@property (nonatomic,strong)UITextField *treatmentText;
@property(nonatomic,strong)KLCPopup* popup;

@end

@implementation SMFilterTableView

//延迟实例化
- (NSArray *)datalist{
    if (!_datalist) {
        _datalist = [[NSMutableArray alloc] init];
    }
    return  _datalist;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        self.datalist =@[@"检查人员",
                         @"处理人员",
                         @"检查类型",
                         @"是否存在问题",
                         @"开始时间",
                         @"结束时间",
                         ];
        self.filterRequest =[[SMFilterRequset alloc] init];
        [self resetData];

        [self configTableView];
        [self configCalendar];
       
    }
    
    return self;
}

- (void)configTableView{
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(WinWidth-210, 0, 200, 55)];
    [self.nameText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameText.textAlignment =NSTextAlignmentRight;
    
    self.treatmentText =[[UITextField alloc]initWithFrame:CGRectMake(WinWidth-210, 0, 200, 55)];
    self.treatmentText.textAlignment =NSTextAlignmentRight;
        [self.treatmentText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"恢复默认" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    button.frame =  CGRectMake((WinWidth-80)/2,WinHeight-W(240), 80, 30);
    button.tag =100;
    button.backgroundColor = [UIColor clearColor];
    [ button.layer setMasksToBounds:YES];
    [ button.layer setBorderWidth:1.0];//边框宽度
    button.layer.borderColor =[[UIColor colorWithRed:34/255.0 green:172/255.0  blue:57/255.0  alpha:1.0]CGColor];
    [button addTarget:self action:@selector(resetting:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:button];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //btn.layer.cornerRadius = 10.0;
    btn.frame =  CGRectMake(20,self.height-50, self.frame.size.width-40, 40);
    btn.backgroundColor =  [UIColor colorWithRed:255/255.0 green:154/255.0  blue:20/255.0  alpha:1.0];//淡橙色
    [ btn.layer setMasksToBounds:YES];
    [btn.layer setBorderWidth:1.0];//边框宽度
     btn.layer.cornerRadius = 8.0;
    btn.layer.borderColor =[[UIColor colorWithRed:255/255.0 green:154/255.0  blue:20/255.0  alpha:1.0]CGColor];
    [btn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
        if (textField.text.length >8) {
            textField.text = [textField.text substringToIndex:8];
        }
   
}

- (void)resetData{
    self.nameText.text  =@"";
    self.treatmentText.text  =@"";
    self.typeStr  =@"全部";
    self.dateString  =@"";
    self.endDateString  =@"";
    self.hasPro  =@"全部";

    self.filterRequest.checkUserName =self.nameText.text;
    self.filterRequest.solveUserName =self.treatmentText.text;
    self.filterRequest.checkTypeId   = @"-1";
    self.filterRequest.hasProblem    =@"-1";
    self.filterRequest.beginDate     =self.dateString;
    self.filterRequest.endDate       =self.endDateString;
}

//重置
- (void)resetting:(UIButton *)btn{
 
    [self resetData];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FilterShowBadge" object:@"0"];
}

//筛选
-(void)search:(UIButton *)btn{
    self.filterRequest.checkUserName =self.nameText.text;
    self.filterRequest.solveUserName =self.treatmentText.text;
    
    NSString *type;
    if ([self.typeStr isEqualToString:@"全部"]) {
        type   = @"-1";
    }else if([self.typeStr isEqualToString:@"日常检查"]){
         type   = @"1";
    }else{
        type   = @"2";
    }
    self.filterRequest.checkTypeId   = type;
    
    NSString *hasProStr;
    if ([self.hasPro isEqualToString:@"全部"]) {
        hasProStr   = @"-1";
    }else if([self.hasPro isEqualToString:@"未发现问题"]){
        hasProStr   = @"0";
        
    }else{
        hasProStr   = @"1";
    }
    self.filterRequest.hasProblem    =hasProStr;
    self.filterRequest.beginDate     =self.dateString;
    self.filterRequest.endDate       =self.endDateString;
    
    
    if (self.filterDelegate&&[self.filterDelegate respondsToSelector:@selector(requestWithFilterData:)]) {
        [self.filterDelegate requestWithFilterData:self.filterRequest];
    }
    
}


//一共几组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

//一组有几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datalist.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1,定义一个共同的标识
    static NSString *ID = @"cell";
    //2,从缓存中取出可循环利用的cell
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:ID];
    //3,如果缓存中没有可利用的cell，新建一个。
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.datalist[indexPath.row];
    //cell后面的箭头
    
    if (indexPath.row ==0) {
        self.nameText.textColor =[UIColor grayColor];
        self.nameText.delegate = self;
        self.nameText.placeholder = @"请输入检查人员";
        [cell addSubview:self.nameText];
        
    }
    if (indexPath.row ==1){
        self.treatmentText.textColor =[UIColor grayColor];
        self.treatmentText.delegate = self;
        self.treatmentText.placeholder = @"请输入处理人员";
        [cell.contentView addSubview:self.treatmentText];
        
    }
    if (indexPath.row ==2) {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text =self.typeStr;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 55)];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
        
    }
    if (indexPath.row ==3) {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text =self.hasPro;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 55)];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    
    if (indexPath.row ==4) {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text =self.dateString;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 55)];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    if (indexPath.row ==5) {
        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text =self.endDateString;
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 55)];
        btn.tag = indexPath.row;
        [btn addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
    
    
    return cell;
    
}
//返回每行cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return H(55.0);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"111");
}

- (void)chooseType:(UIButton *)btn{
     [self endEditing:YES];
    [self popMenuViewWithIndex:btn.tag];
}


//弹出视图
-(void)popMenuViewWithIndex:(NSInteger)index1{
    index = index1;
    NSArray *arr;
    if (index1==2) {
        arr= @[@"全部",@"日常检查",@"专项检查"];
    }else if(index1==3){
        arr= @[@"全部",@"未发现问题",@"存在问题"];
    }
    PopMenuTableView *view = [[PopMenuTableView alloc] initWithFrame:CGRectMake(0, 0,W(300), arr.count*55)];

    view.arr = arr;

    view.menuDelegate=self;
    
    self.popup = [KLCPopup popupWithContentView:view
                                       showType:KLCPopupShowTypeNone
                                    dismissType:KLCPopupDismissTypeNone
                                       maskType:KLCPopupMaskTypeNone
                       dismissOnBackgroundTouch:YES
                          dismissOnContentTouch:NO];
    
    self.popup.backgroundColor =[UIColor colorWithRed:123/255.0 green:123/255.0 blue:123/255.0 alpha:0.5f];
    [self.popup show];
}


#pragma mark PopMenuDelegate
- (void)openWithTitle:(NSString *)title{
    [self.popup dismiss:YES];
    if (index ==2) {
         self.typeStr=title;
    }else if(index ==3){
        self.hasPro = title;
    }
   
    [self reloadData];
}

- (void)chooseDate:(UIButton *)btn{
     [self endEditing:YES];
    index=btn.tag;
    [_pop show];
}

- (void)configCalendar{
    _pop=[[WHUCalendarPopView alloc] init];
    __weak typeof(self)weakself = self;
    _pop.onDateSelectBlk=^(NSDate* date){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];

        if (index==4) {
            NSDate *lastdate  =  [format dateFromString:weakself.endDateString];
            NSComparisonResult result3 = [date compare:lastdate];
            if (result3==NSOrderedDescending) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"开始时间晚于结束时间，请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            }else{
                
                weakself.dateString = [format stringFromDate:date];
            }

           
        }else if(index==5){
            NSDate *lastdate  =  [format dateFromString:weakself.dateString];
            NSComparisonResult result3 = [date compare:lastdate];
            if (result3==NSOrderedAscending) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间早于开始时间，请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                 weakself.endDateString =[format stringFromDate:date];
            }
           
        }
        
        
        [weakself reloadData];
    };
}

////点击屏幕空白处去掉键盘
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//   
////    [self endEditing:YES];
//    [self.nameText resignFirstResponder];
//    [self.treatmentText resignFirstResponder];
//}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



@end
