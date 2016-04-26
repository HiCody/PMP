//
//  DCSMDataCheckCell.m
//  PMP
//
//  Created by mac on 16/1/12.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DCSMDataCheckCell.h"

@implementation DCSMDataCheckCell
+ (instancetype)cell{
    return [[NSBundle mainBundle] loadNibNamed:@"DCSMDataCheckCell" owner:nil options:nil].lastObject;
}

- (IBAction)telPhone:(id)sender {
    UIButton *btn  = sender;
    if(btn.tag ==100){
        self.titleStr = self.safetyCheck.companyCheckBaseInfoHistory.manageManName;
        self.telPhone =self.safetyCheck.companyCheckBaseInfoHistory.manageManTel;
    }
    else if (btn.tag ==101){
        self.titleStr = self.safetyCheck.companyCheckBaseInfoHistory.technologyManName;
        self.telPhone =self.safetyCheck.companyCheckBaseInfoHistory.technologyManTel;
   
    }
    else if (btn.tag ==102){
        self.titleStr = self.safetyCheck.companyCheckBaseInfoHistory.qualityManName;
        self.telPhone =self.safetyCheck.companyCheckBaseInfoHistory.qualityManTel;
       
    }
    else if (btn.tag ==103){
        self.titleStr = self.safetyCheck.companyCheckBaseInfoHistory.safetyManName;
        self.telPhone =self.safetyCheck.companyCheckBaseInfoHistory.safetyManTel;
   }
    
    if (self.telPhone.length) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: self.titleStr message:self.telPhone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"呼叫",nil];
        
        [alertView show];
    }
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
      
        [self dialPhoneNumber:self.telPhone];

    }
}

//调出电话功能
- (void)dialPhoneNumber:(NSString *)aPhoneNumber
{
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
   
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneURL]){
  
        [[UIApplication sharedApplication] openURL:phoneURL];

    }
}



- (void)setSafetyCheck:(BCSMSafetyCheckModel *)safetyCheck{
    _safetyCheck = safetyCheck;

    BCSMCompanycheckbaseinfohistory *infohistory =safetyCheck.companyCheckBaseInfoHistory;
    
    if (infohistory.deptName) {
         _projectNameLable.text    = infohistory.deptName;
    }
    
    if (infohistory.manageManName) {
        _projectManagerLable.text =infohistory.manageManName;
    }
    if (infohistory.checkDate) {
        _checkTimeLable.text      = infohistory.checkDate;
    }else if (!infohistory.checkDate){
      
        _checkerLable.text =@"";
    }
    
    
    if (infohistory.technologyManName) {
        _directorLable.text       = infohistory.technologyManName;
    }
    
    if (infohistory.safetyManName) {
        _safetyCheckLable.text    = infohistory.safetyManName;
    }
    
    if (infohistory.checkManName) {
        _checkerLable.text        = infohistory.checkManName;
    }
    
    if (infohistory.qualityManName) {
         _quantityCheckLable.text  =infohistory.qualityManName;
    }
    
    if (!infohistory.manageManTel) {
        
        _projectManagerImage.hidden =YES;
    }
    if (!infohistory.technologyManTel) {
        
        _directorImage.hidden =YES;
    }
    if (!infohistory.qualityManTel) {
        
        _quantityImage.hidden =YES;
    }
    if (!infohistory.safetyManTel) {
        _safetyImage.hidden =YES;
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
