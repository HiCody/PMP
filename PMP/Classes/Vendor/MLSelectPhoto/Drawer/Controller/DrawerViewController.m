//
//  DrawerViewController.m
//  PMP
//
//  Created by mac on 16/1/6.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "DrawerViewController.h"
#import "HMSegmentedControl.h"
#import "LPHPaintView.h"

#define kBtnWidth 30
#define kBtnHeight 30
#define kPadding 20
@interface DrawerViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    CGFloat scale,perviousScale;
}

@property (strong, nonatomic)  LPHPaintView *paintView;

@property (strong,nonatomic) UIButton *doneBtn;
@property (strong,nonatomic)UIButton *cancleBtn;
@property (strong,nonatomic) UIToolbar *toolBar;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property(nonatomic,strong)UIScrollView *scrollView;


@end

@implementation DrawerViewController
- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 45, 45);
        [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:193/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        cancleBtn.enabled = YES;
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        cancleBtn.frame = CGRectMake(0, 0, 45, 45);
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        self.cancleBtn = cancleBtn;
    }
    return _cancleBtn;
}

- (HMSegmentedControl *)segmentedControl{
    if (!_segmentedControl) {
        HMSegmentedControl *segmentedControl2 = [[HMSegmentedControl alloc] initWithSectionImages:@[[UIImage imageNamed:@"60 画笔 未选中"]] sectionSelectedImages:@[[UIImage imageNamed:@"60 画笔 选中"]]];
        segmentedControl2.frame = CGRectMake(0, 0, 120, 50);
        segmentedControl2.selectionIndicatorHeight = 2.0f;
        segmentedControl2.backgroundColor = [UIColor clearColor];
        segmentedControl2.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        segmentedControl2.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        
        [segmentedControl2 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
        self.segmentedControl = segmentedControl2;
    }
    return _segmentedControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    self.view.backgroundColor=[UIColor blackColor];
    
    [self configPaintView];
    [self setupToorBar];
    [self configScrollView];
    
}

- (void)configPaintView{
    perviousScale=1;    
    self.paintView = [[LPHPaintView alloc] init];
    self.paintView.lineWidth = 8;
    self.paintView.backgroundColor=[UIColor clearColor];
    self.paintView.lineColor=[UIColor redColor];
    
    UIImage *newImg = [self imageCompressForWidth:self.doodleImage targetWidth:WinWidth-10];
    self.paintView.pickedImage = newImg;
    self.paintView.frame = CGRectMake(5, 5, newImg.size.width,  newImg.size.height);
    self.paintView.center =CGPointMake(WinWidth/2, (WinHeight-110)/2);
    [self.view addSubview:self.paintView];
    
    self.paintView.userInteractionEnabled=YES;
    
    //先给imageview一个放大和缩小的手势
    UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(doPinch:)];
    pinchGesture.delegate=self;
    
    [self.paintView addGestureRecognizer:pinchGesture];
    
    
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    pan.minimumNumberOfTouches=2;
    [self.paintView addGestureRecognizer:pan];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btnEnable:) name:@"btnEnable" object:nil];
}



- (void)btnEnable:(NSNotification *)notification{
    NSString *enable = notification.object;
  //  NSLog(@"%@",enable);
    UIButton *btn = [self.view viewWithTag:100];
    btn.enabled=enable.boolValue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)configScrollView{
    UIScrollView *scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-110, WinWidth, 60)];
    scrollView.contentSize= CGSizeMake(450, 60);
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.showsHorizontalScrollIndicator=NO;
    
    scrollView.backgroundColor=[UIColor colorWithRed:33/255.0 green:33/255.0 blue:33/255.0 alpha:1.0];
    
    NSArray *unselectedArr=@[@"60 返回 未选中",@"60 橡皮擦 未选中",@"60红色 未选中",@"60橙色 未选中",@"60黄色 未选中",@"60绿色 未选中",@"60蓝色 未选中",@"60紫色 未选中"];
    NSArray *selectedArr = @[@"60 返回 选中",@"60 橡皮擦 选中",@"60红色 选中",@"60橙色 选中",@"60黄色 选中",@"60绿色 选中",@"60蓝色 选中",@"60紫色 选中"];
    for (int i=0; i<unselectedArr.count; i++) {
        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(5+(kBtnWidth+kPadding)*i, 15, kBtnWidth, kBtnHeight)];
        [scrollView addSubview:btn];
        if (i==0) {
            btn.enabled=NO;
            [btn setImage:[UIImage imageNamed:unselectedArr[i]] forState:UIControlStateDisabled];
            [btn setImage:[UIImage imageNamed:selectedArr[i]] forState:UIControlStateNormal];
            
            
        }else{
            if (i==2) {
                btn.selected=YES;
            }
            [btn setImage:[UIImage imageNamed:unselectedArr[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:selectedArr[i]] forState:UIControlStateSelected];
        }
        
        btn.tag=i+100;
        switch (i) {
            case 0:{
                [btn addTarget:self action:@selector(backToupStep:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case 1:{
                [btn addTarget:self action:@selector(cleanStep:) forControlEvents:UIControlEventTouchUpInside];
            }
                
                break;
                
            default:{
                [btn addTarget:self action:@selector(chooselinecolor:) forControlEvents:UIControlEventTouchUpInside];
            }
                
                break;
        }
    }
    self.scrollView = scrollView;
    [self.view addSubview:self.scrollView];
    
}

//回退
- (void)backToupStep:(UIButton *)btn{
    
    [self.paintView backspace];
}

//擦除
- (void)cleanStep:(UIButton *)btn{
    [self cancleSelected:btn.tag-100];
    //self.isEase=YES;
    btn.selected=YES;
    [self.paintView erasure];
}


//颜色选择改变事件
- (void)chooselinecolor:(UIButton *)btn{
    btn.selected=YES;
    [self cancleSelected:btn.tag-100];
    NSArray *arr=@[[UIColor redColor],
                   [UIColor colorWithRed:253/255.0 green:127/255.0 blue:50/255.0 alpha:1.0],
                   [UIColor yellowColor],
                   [UIColor colorWithRed:133/255.0 green:232/255.0 blue:27/255.0 alpha:1.0],
                   [UIColor colorWithRed:23/255.0 green:146/255.0 blue:249/255.0 alpha:1.0],
                   [UIColor colorWithRed:176/255.0 green:14/255.0 blue:205/255.0 alpha:1.0]];
    
    self.paintView.lineColor=arr[btn.tag-102];
}

- (void)cancleSelected:(NSInteger )index{
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    for (int i=1; i<8; i++) {
        UIButton *btn = [self.view viewWithTag:i+100];
        [arr addObject:btn];
    }
    [arr removeObjectAtIndex:index-1];
    
    for (int i =0; i<arr.count; i++) {
        UIButton *btn = arr[i];
        btn.selected=NO;
    }
}



- (void)setupToorBar{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    // toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    UIImageView *imgView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下"]];
    imgView.frame=CGRectMake(0, 0, WinWidth, 50);
    [toolBar addSubview:imgView];
    
    self.toolBar = toolBar;
    
    self.toolBar.frame=CGRectMake(0, WinHeight-50, WinWidth, 50);
    [self.view addSubview: self.toolBar];
    // 左视图 中间距 右视图
    
    UIBarButtonItem *cancleBtn = [[UIBarButtonItem alloc]  initWithCustomView:self.cancleBtn];
    
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    
    toolBar.items = @[cancleBtn,fiexItem,rightItem];
    
    
    self.segmentedControl.frame=CGRectMake((WinWidth-120)/2, 0, 120, 50);
    
    [toolBar addSubview:self.segmentedControl];
}

//保存编辑好的图片
- (void)done{
    UIGraphicsBeginImageContextWithOptions(self.paintView.bounds.size, NO, 0.0);
    
    CGContextRef ctx =UIGraphicsGetCurrentContext();
    
    //从上下文中获取图片
    
    [self.paintView.layer renderInContext:ctx];
    
    UIImage * image =UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    
    UIGraphicsEndImageContext();
    
    //把图片保存到相册
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    self.passImage(image);
    
}


-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 拖拽

- (void)panAction:(UIPanGestureRecognizer*)recongnizer{
    
    CGPoint offset =[recongnizer translationInView:recongnizer.view];
    
    recongnizer.view.transform=CGAffineTransformTranslate(recongnizer.view.transform, offset.x
                                                          , offset.y);
    
    [recongnizer setTranslation:CGPointZero inView:recongnizer.view];
    
    
}

//放大缩小
-(void)doPinch:(UIPinchGestureRecognizer *)gesture{
    scale=gesture.scale;
    [self transformImageView];
    //当手势触摸结束的时候，保存当前的缩放比例
    if (gesture.state==UIGestureRecognizerStateEnded) {
        
        perviousScale=scale*perviousScale;
        if (perviousScale<0.8) {
            scale=1;
            perviousScale=0.8;
            self.paintView.lineWidth =8;
            [self transformImageView];
        }
        
        if (perviousScale>1.5) {
            scale=1;
            perviousScale=1.5;
            [self transformImageView];
        }
        if (perviousScale<=1) {
            self.paintView.lineWidth =8;
        }else{
            self.paintView.lineWidth =4;
        }
        
    }
}

-(void)transformImageView{
    //缩放比例
    CGAffineTransform t=CGAffineTransformMakeScale(scale*perviousScale, scale*perviousScale);
    self.paintView.transform=t;
}

//取消
- (void)cancle{
    
    if (self.paintView.paints.count==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"你尚未保存" message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
         [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentControl{
    if (segmentControl.selectedSegmentIndex==0) {
        
        
    }else{
        
        
    }
}


-(BOOL)prefersStatusBarHidden{
    return YES;
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
