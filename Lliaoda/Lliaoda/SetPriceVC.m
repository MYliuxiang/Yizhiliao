//
//  SetPriceVC.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/19.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SetPriceVC.h"

@interface SetPriceVC ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong)UIView *pickerBG;//选择器底
@property (nonatomic, strong)UIPickerView *picker;//选择器

@end

@implementation SetPriceVC

- (void) crpickerBG {
    
    _pickerBG = [[UIView alloc] initWithFrame:CGRectMake(0,kScreenHeight, kScreenWidth, 216 + 50)];
    _pickerBG.backgroundColor = [UIColor whiteColor];
    
    
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    toolView.backgroundColor = [UIColor whiteColor];
    [_pickerBG addSubview:toolView];
    
    
    //確定按钮
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-60, 0,50,50)];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel setTitleColor:Color_nav forState:UIControlStateNormal];
    [cancel setTitle:LXSring(@"確定") forState:UIControlStateNormal];
    [toolView addSubview:cancel];
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //取消按钮
    UIButton *enter = [[UIButton alloc]initWithFrame:CGRectMake(10, 0,50,50)];
    enter.titleLabel.font = [UIFont systemFontOfSize:14];
    [enter setTitleColor:Color_nav forState:UIControlStateNormal];
    [enter setTitle:LXSring(@"取消") forState:UIControlStateNormal];
    [toolView addSubview:enter];
    [enter addTarget:self action:@selector(enterAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 216)];
    self.picker.dataSource = self;
    self.picker.delegate = self;
    [_pickerBG addSubview:self.picker];
    [self.view addSubview:_pickerBG];
}

#pragma mark ----------確定-------------
- (void)cancelAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 256);
    } completion:^(BOOL finished) {
        
        self.priceBtn.selected = NO;
        NSInteger row1=[self.picker selectedRowInComponent:0];
        Charge *charge = self.model.charges[row1];
        self.priceBtn.titleLabel.text = charge.name;
        self.cmodel = charge;
        [self.priceBtn setTitle:charge.name forState:UIControlStateNormal];
    }];
    
    
}

#pragma mark ----------取消-------------
- (void)enterAction:(UIButton *)sender
{
    
    
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, self.view.height, self.view.width, 0);
    } completion:^(BOOL finished) {
        
        self.priceBtn.selected = NO;
        

    }];
    
    
}

//字体大小
- (CGFloat)fontWithString:(NSString *)string {
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    CGFloat font = 0;
    for (int i = 17; i > 0; i--) {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:i]};
        CGSize rect = [string sizeWithAttributes:attributes];
        if (rect.width <= width) {
            font = (CGFloat)i;
            break;
        }
    }
    return font;
}


#pragma mark pickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    return self.model.charges.count;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 3;
    UILabel *myView = nil;
    
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        Charge  *charge = self.model.charges[row];
        myView.text = charge.name;
        myView.font = [UIFont systemFontOfSize:[self fontWithString:myView.text]];         //用label来設定字体大小
        myView.backgroundColor = [UIColor clearColor];
    
    return myView;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
   
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.text = LXSring(@"收費設定");
    
    
    self.priceBtn.layer.borderColor = Color_nav.CGColor;
    self.priceBtn.layer.borderWidth = 1;
    self.priceBtn.layer.cornerRadius = 3;
    self.priceBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.cornerRadius = 22.5;
    self.doneBtn.layer.masksToBounds = YES;
//    if (self.model.charge != -1) {
//       
//        [self.priceBtn setTitle:[NSString stringWithFormat:@"%d鑽/分钟",self.model.charge] forState:UIControlStateNormal];
//    }else{
//        
//    [self.priceBtn setTitle:[NSString stringWithFormat:LXSring(@"未設定")] forState:UIControlStateNormal];
//    }
    
    Charge *charge;
    for (Charge *mo in self.model.charges) {
        if (mo.uid == self.model.charge) {
            charge = mo;
        }
    }
    
    [self.priceBtn setTitle:charge.name forState:UIControlStateNormal];
   
    [self crpickerBG];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)tap
{
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, self.view.height, self.view.width, 0);
    } completion:^(BOOL finished) {
        
        self.priceBtn.selected = NO;
        
      
        
    }];

}

- (void)_loadData
{
    
    NSDictionary *params;
    params = @{@"uid":[NSString stringWithFormat:@"%d",self.cmodel.uid]};
    [WXDataService requestAFWithURL:Url_accountcharge params:params httpMethod:@"POST" isHUD:YES isErrorHud:YES finishBlock:^(id result) {
        if(result){
            if ([[result objectForKey:@"result"] integerValue] == 0) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else{    //请求失败
                [SVProgressHUD showErrorWithStatus:result[@"message"]];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    [SVProgressHUD dismiss];
                });
                
            }
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)rezhengAC:(id)sender {
}

- (IBAction)setPrice:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    for (int i = 0; i < self.model.charges.count; i++) {
        Charge *charge = self.model.charges[i];
        NSLog(@"%@",self.priceBtn.titleLabel.text);
        if ([self.priceBtn.titleLabel.text isEqualToString:charge.name]) {
            [self.picker selectRow:i inComponent:0 animated:NO];
        }
    }
    [UIView animateWithDuration:0.33 animations:^{
        self.pickerBG.frame = CGRectMake(0, kScreenHeight - 266, kScreenWidth, 266);
    } completion:^(BOOL finished) {
        
        
    }];
}
- (IBAction)done:(id)sender {
    
    if (self.cmodel == nil) {
    
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        [self _loadData];
    
    }
    
}


@end
