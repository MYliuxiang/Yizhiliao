//
//  SelectedCell.m
//  Lliaoda
//
//  Created by 刘翔 on 2017/4/17.
//  Copyright © 2017年 刘翔. All rights reserved.
//

#import "SelectedCell.h"

@implementation SelectedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
    //不在线
    //忙碌
    
}

- (void)setModel:(SelectedModel *)model
{
    _model = model;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:_model.portrait] placeholderImage:[UIImage imageNamed:@"Image"]];
    self.nameLabel.text = _model.nickname;
    _placeLabel.text = [[CityTool sharedCityTool] getAdressWithCountrieId:_model.country WithprovinceId:_model.province WithcityId:_model.city];
    //主播状态，0 表示离线，1 表示在线，2 表示忙碌。app根据当前语言显示状态
    if(_placeLabel.text.length == 0){
        
        _palceImageV.hidden = YES;
        
    }else{
        
        _palceImageV.hidden = NO;
        
    }
    if(_model.state == 0){
    
        self.stateView.layer.borderColor = Color_green.CGColor;
        self.stateView.layer.cornerRadius = 10;
        self.stateView.layer.masksToBounds = YES;
        self.stateView.layer.borderWidth = .5;
        self.stateLabel.text = LXSring(@"空闲");
        self.stateLabel1.backgroundColor = Color_green;
        self.stateLabel1.layer.cornerRadius = 8;
        self.stateLabel1.layer.masksToBounds = YES;
        
        self.stateView.hidden = YES;
        self.stateLabel.hidden = YES;
        
    }else if (_model.state == 1){
        
        self.stateView.hidden = YES;
        self.stateLabel.hidden = YES;
        self.stateView.layer.borderColor = Color_green.CGColor;
        self.stateView.layer.cornerRadius = 10;
        self.stateView.layer.masksToBounds = YES;
        self.stateView.layer.borderWidth = .5;
        self.stateLabel.text = LXSring(@"空闲");
        self.stateLabel1.backgroundColor = Color_green;
        self.stateLabel1.layer.cornerRadius = 8;
        self.stateLabel1.layer.masksToBounds = YES;
    
    }else{
        
        self.stateView.hidden = NO;
        self.stateLabel.hidden = NO;
        self.stateView.layer.borderColor = Color_nav.CGColor;
        self.stateView.layer.cornerRadius = 10;
        self.stateView.layer.masksToBounds = YES;
        self.stateView.layer.borderWidth = .5;
        self.stateLabel.text = LXSring(@"忙碌");
        self.stateLabel1.backgroundColor = Color_nav;
        self.stateLabel1.layer.cornerRadius = 8;
        self.stateLabel1.layer.masksToBounds = YES;
    
    }
    

}

@end
