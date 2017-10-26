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
  
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.nianView.layer.cornerRadius = 11;
    self.nianView.layer.masksToBounds = YES;
    //不在线
    //忙碌
    
}

- (void)setModel:(SelectedModel *)model
{
    _model = model;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:_model.portrait] placeholderImage:[UIImage imageNamed:@"Image"]];
    self.nameLabel.text = _model.nickname;
    _placeLabel.text = [[CityTool sharedCityTool] getAdressWithCountrieId:_model.country WithprovinceId:_model.province WithcityId:_model.city];
//    self.nianLabel.text =  [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:[_model.birthday longLongValue] / 1000]];
    self.nianLabel.text = [InputCheck dateToOld:[NSDate dateWithTimeIntervalSince1970:_model.birthday/1000]];
    //主播状态，0 表示离线，1 表示在线，2 表示忙碌。app根据当前语言显示状态
    if(_placeLabel.text.length == 0){
        
        _palceImageV.hidden = YES;
        
    }else{
        
        _palceImageV.hidden = NO;
        
    }
    
    if (_model.intro.length != 0) {
        self.introLabel.text = _model.intro;
    }
  

}

@end
