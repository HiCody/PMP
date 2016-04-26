//
//  BCSMSafetyCheckDetailViewController.m
//  PMP
//
//  Created by mac on 16/1/13.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "BCSMSafetyCheckDetailViewController.h"
#import "BCSMSafetyCheckDetailCell.h"
#import "BCSMImproveCell.h"
#import "BCSMSpotCheckListViewController.h"
#import <MWCommon.h>
#import <MWPhotoBrowser.h>

@interface BCSMSafetyCheckDetailViewController ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *photos;
@end

@implementation BCSMSafetyCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"安全检查详细";
    
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)projectNameView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    
    UILabel *projectLable =[[UILabel alloc] initWithFrame:CGRectMake(12, 0, WinWidth-12*2, 40)];
    projectLable.font = [UIFont boldSystemFontOfSize:17.0];
    projectLable.text =self.detailModel.deptName;
    [view addSubview:projectLable];
    view.backgroundColor=[UIColor whiteColor];
    
    return view;
}

- (void)configTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight-CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:UITableViewStyleGrouped];
    self.tableView.delegate  = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [self projectNameView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

#pragma mark UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        
        return 4;
        
    }else if (section==1) {
        
        return 3;
        
    }else if(section==2){
        return 3;
    }else if(section==3){
        return 2;
    }else if(section==4){
        return 1;
    }else if(section==5){
        
        return self.detailModel.companyCheckImages.count;
        
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    if (indexPath.section==0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
        if (indexPath.row==0) {
            cell.textLabel.text = [NSString stringWithFormat:@"项目经理：%@",self.detailModel.manageManName];
            cell.detailTextLabel.text = self.detailModel.manageManTel;
        }else if(indexPath.row==1){
            cell.textLabel.text = [NSString stringWithFormat:@"技术负责人：%@",self.detailModel.technologyManName];
            cell.detailTextLabel.text = self.detailModel.technologyManTel;
        }else if(indexPath.row==2){
            cell.textLabel.text = [NSString stringWithFormat:@"质检员：%@",self.detailModel.qualityManName];
            cell.detailTextLabel.text = self.detailModel.qualityManTel;
        }else if(indexPath.row==3){
            cell.textLabel.text = [NSString stringWithFormat:@"安全员：%@",self.detailModel.safetyManName];
            cell.detailTextLabel.text = self.detailModel.safetyManTel;
        }
    }else if(indexPath.section==1){
        
        if (indexPath.row==0) {
            cell.textLabel.text = [NSString stringWithFormat:@"建筑面积：%@㎡",self.detailModel.buildAreaSize];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"造价：%@万元",self.detailModel.costOfConstruction];
        }else if(indexPath.row==1){
            cell.textLabel.text = [NSString stringWithFormat:@"结构层数：地上%@层",self.detailModel.landUp];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"地下：%@层",self.detailModel.landDown];
        }else if(indexPath.row==2){
            cell.textLabel.text = [NSString stringWithFormat:@"结构类型：%@",self.detailModel.strutClassName];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"参建人数：%@人",self.detailModel.buildPersons];
        }
    }else if(indexPath.section==2){
        if (indexPath.row==0) {
            cell.textLabel.text = @"实际开工日期";
            cell.detailTextLabel.text = self.detailModel.beginDate;
        }else  if (indexPath.row==1) {
            cell.textLabel.text = @"计划完工日期";
            cell.detailTextLabel.text = self.detailModel.endDate;
        }else  if (indexPath.row==2) {
            cell.textLabel.text = @"形象进度：";
            cell.detailTextLabel.text = self.detailModel.progress;
        }
    }else if(indexPath.section ==3){
        if (indexPath.row==0) {
            cell.textLabel.text = @"检查日期";
            cell.detailTextLabel.text = self.detailModel.checkDate;
        }else  if (indexPath.row==1) {
            static NSString *identifier = @"cell2";
            UITableViewCell *cell2  = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell2) {
                cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            cell2.textLabel.font = [UIFont systemFontOfSize:14.0];
            cell2.detailTextLabel.font = [UIFont systemFontOfSize:14.0];
            cell2.selectionStyle  = UITableViewCellSelectionStyleNone;
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell2.textLabel.text = @"抽查情况";
            NSInteger num =0;
            for (BCSMSpotinfos *spotInfos in self.detailModel.spotInfos) {
                if (spotInfos.spotId==2||spotInfos.spotId==4) {
                    num++;
                }
            }
            NSString *spotStr;
            if (num) {
                spotStr = [NSString stringWithFormat:@"%li项存在问题",num];
            }else{
                spotStr = @"不存在问题";
            }
            cell2.detailTextLabel.text = spotStr;
            return cell2;
        }
    }else if(indexPath.section==4){
        
        BCSMImproveCell *improveCell = (BCSMImproveCell *)[self getCellWithTableView:tableView andIndexPath:indexPath];
        
        improveCell.improveContent = self.detailModel.improve;

        return improveCell;
        
    }else if(indexPath.section==5){
        
        BCSMSafetyCheckDetailCell   *cell2 = (BCSMSafetyCheckDetailCell   *)[self getCellWithTableView:tableView andIndexPath:indexPath];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (BCSMCompanycheckdetails *checkDetails in self.detailModel.companyCheckDetails) {
            if (checkDetails.classType == indexPath.row) {
                [tempArr addObject:checkDetails];
            }
        }
        cell2.prolist = [tempArr copy];
        
        for (BCSMCompanycheckimages *checkImages in self.detailModel.companyCheckImages) {
            if (checkImages.classType== indexPath.row) {
                cell2.checkImages = checkImages;
            }
        }
        
        __weak typeof(self)weakself = self;
        cell2.showImageView=^(NSArray *imgArr,NSInteger tag){
            [weakself scanPhotoWithImgArr:imgArr andTag:tag];
        };
        
        return cell2;
        
       
    }
    
    
    return cell;
}

-(UITableViewCell *)getCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==5) {
        static NSString *identifier=@"detailCell";
        BCSMSafetyCheckDetailCell   *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[BCSMSafetyCheckDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
    }else{
        
        static NSString *identifier=@"dimproveCell";
        BCSMImproveCell   *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[BCSMImproveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        return cell;
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==5) {
        BCSMSafetyCheckDetailCell   *cell2 = (BCSMSafetyCheckDetailCell   *)[self getCellWithTableView:tableView andIndexPath:indexPath];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (BCSMCompanycheckdetails *checkDetails in self.detailModel.companyCheckDetails) {
            
            if (checkDetails.classType == indexPath.row) {
              //  NSLog(@"%li----%li",checkDetails.classTpye,indexPath.row);
                [tempArr addObject:checkDetails];
            }
        }
        cell2.prolist = [tempArr copy];
        
        for (BCSMCompanycheckimages *checkImages in self.detailModel.companyCheckImages) {
            if (checkImages.classType== indexPath.row) {
                cell2.checkImages = checkImages;
            }
        }
        
        return cell2.cellHeight;
        
    }else if(indexPath.section==4){
      
        BCSMImproveCell *improveCell = (BCSMImproveCell *)[self getCellWithTableView:tableView andIndexPath:indexPath];
        improveCell.improveContent = self.detailModel.improve;
        
        return improveCell.cellHeight;
        
    }else {
        
        return 44;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3&&indexPath.row==1) {
        BCSMSpotCheckListViewController *spotVC = [[BCSMSpotCheckListViewController alloc] init];
        
        spotVC.spotInfos = [self.detailModel.spotInfos mutableCopy];
        spotVC.isEdit =NO;
        [self.navigationController pushViewController:spotVC animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *arr = @[@"项目人员信息",@"项目概况",@"项目时间与进展",@"检查情况",@"改进要求",@"相关问题"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WinWidth, 40)];
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10,20 , 20)];
    imageView.image = [UIImage imageNamed:@"checkHeadImage-1"];
    [view addSubview:imageView];
   
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 10, WinWidth-50, 20)];
    lable.text = arr[section];
    lable.font = [UIFont boldSystemFontOfSize:15.0];
    lable.textColor = NAVI_SECOND_COLOR;
    
    [view addSubview:lable];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)scanPhotoWithImgArr:(NSArray *)imgArr andTag:(NSInteger)tag{
    NSMutableArray *photosArr = [[NSMutableArray alloc] init];
    for (int i = 0; i<imgArr.count; i++) {
        if ([imgArr[i] isMemberOfClass:[UIImage class]]) {
            MWPhoto *photo = [MWPhoto photoWithImage:imgArr[i]];
            [photosArr  addObject:photo];
            
        }else{
            NSString *jpgpath=imgArr[i];
            MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:jpgpath]];
            [photosArr  addObject:photo];
        }
        
    }
    self.photos  = photosArr;
    
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = NO;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    browser.enableSwipeToDismiss = NO;
    [browser setCurrentPhotoIndex:tag];
    
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index1 {
    if (index1 < self.photos.count)
        return [self.photos objectAtIndex:index1];
    return nil;
}

@end
