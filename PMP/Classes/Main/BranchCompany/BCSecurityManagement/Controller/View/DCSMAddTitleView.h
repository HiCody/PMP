//
//  DCSMAddTitleView.h
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCSMAddTitleView : UIView<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;//项目名称

@property (weak, nonatomic) IBOutlet UILabel *projectManagerLabel;//项目经理

@property (weak, nonatomic) IBOutlet UILabel *technicalDirectorLabel;//技术负责人

@property (weak, nonatomic) IBOutlet UILabel *qualityInspectorLabel;//质检员

@property (weak, nonatomic) IBOutlet UILabel *securityOfficerLabel;//安全员

@property (weak, nonatomic) IBOutlet UIButton *moreContactsButton;//更多联系人

@property (weak, nonatomic) IBOutlet UIButton *collapseButton;//收起

@property (weak, nonatomic) IBOutlet UILabel *costLabel;//造价

@property (weak, nonatomic) IBOutlet UILabel *areaLabel;//建筑面积

@property (weak, nonatomic) IBOutlet UILabel *otherCostLabel;//造价2

@property (weak, nonatomic) IBOutlet UILabel *groundLabel;//结构层数地上

@property (weak, nonatomic) IBOutlet UILabel *undergroundLabel;//地下

@property (weak, nonatomic) IBOutlet UILabel *structureTypeLabel;//结构类型

@property (weak, nonatomic) IBOutlet UILabel *umberPeopleLabel;//参建人数

@property (weak, nonatomic) IBOutlet UIButton *detailedButton;//详细

@property (weak, nonatomic) IBOutlet UIButton *secondCollaoseButton;//第二个收起

@property (weak, nonatomic) IBOutlet UITextField *scheduleText;//形象进度

@property (weak, nonatomic) IBOutlet UIButton *spotCheckButton;
- (IBAction)detailed:(id)sender;

- (IBAction)secondCollaose:(id)sender;

- (IBAction)spotChecks:(id)sender;//抽查情况

- (IBAction)collapse:(id)sender;

- (IBAction)moreContacts:(id)sender;


+ (instancetype)addTitleView;
@end
