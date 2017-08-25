//
//  JXRadarPointView.m
//  咻一咻
//
//  Created by mac on 17/4/14.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXRadarPointView.h"

@interface JXRadarPointView()

@property(nonatomic, strong) UIImageView *imageView;

@property(nonatomic, strong) UILabel *nickName;

@property(nonatomic, strong) UILabel *placeLabel;


@end

@implementation JXRadarPointView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self _initView];
    
        
    }
    return self;
}

- (void)_initView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 60) / 2.0, 0, 60, 60)];
    _imageView.layer.cornerRadius = 30;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _imageView.layer.borderWidth = 2;
    _imageView.center = self.center;
    [self addSubview:_imageView];
    
    
    
    
//    _nickName = [[UILabel alloc] initWithFrame:CGRectMake(18, _imageView.bottom + 5, 64, 12)];
//    _nickName.font = [UIFont systemFontOfSize:12];
//    _nickName.textColor = [MyColor colorWithHexString:@"#333333"];
//    _nickName.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_nickName];
//    
//    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, _nickName.bottom + 5, 64, 10)];
//    _placeLabel.font = [UIFont systemFontOfSize:10];
//    _placeLabel.textColor = [MyColor colorWithHexString:@"#999999"];
//    _placeLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:_placeLabel];


}

- (void)setSendBordColor:(UIColor *)sendBordColor
{
    _sendBordColor = sendBordColor;
    self.layer.cornerRadius = 35;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = self.sendBordColor.CGColor;
    self.layer.borderWidth = 1;


}

- (void)setModel:(SelectedModel *)model
{
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.portrait]];
    _nickName.text = model.nickname;
    
    _placeLabel.text = [[CityTool sharedCityTool] getAdressWithCountrieId:_model.country WithprovinceId:_model.province WithcityId:_model.city];

}

@end
