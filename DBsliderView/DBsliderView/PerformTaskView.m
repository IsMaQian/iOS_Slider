//
//  PerformTaskView.m
//  DBsliderView
//
//  Created by EdwardSelf on 2018/4/28.
//  Copyright © 2018年 uimbank. All rights reserved.
//
#define UIColorFromRGB(rgbValue , A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]
#define MAS_SHORTHAND_GLOBALS
#define equalTo(...)                     mas_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        mas_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           mas_lessThanOrEqualTo(__VA_ARGS__)
#define offset(...)                      mas_offset(__VA_ARGS__)

#import "PerformTaskView.h"
#import "Masonry.h"

@implementation PerformTaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    if (self == [super init]) {
        [self mySlideView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self mySlideView];
    }
    return self;
}

-(MBSliderView *)mySlideView{
    [self backgroudView];
    if (_mySlideView == nil) {
        //添加滑块
        _mySlideView = [[MBSliderView alloc]init];
        [self.backgroudView addSubview:_mySlideView];
        [_mySlideView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(238, 38));
        }];
        [_mySlideView setSlideLabText:@"滑动发送方案"];
        _mySlideView.tag = 0;
        //        [_MBSlider setThumbImage:[UIImage imageNamed:@"lines-1"]];
        //
        ////        _MBSlider.backgroundColor = [UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        //        [_MBSlider setText:@"滑动发送方案"];
        //        [_MBSlider setLabelColor:[UIColor whiteColor]];
        //        //设置代理
        [_mySlideView setDelegate:self];
        
        [self sendLable];
        [self cancalSendBtn];
    }
    return _mySlideView;
}

- (UIView *)backgroudView {
    if(_backgroudView == nil) {
        _backgroudView = [[UIView alloc] init];
        [self addSubview:_backgroudView];
        [_backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _backgroudView.backgroundColor = UIColorFromRGB(0x343434, 0.6);
    }
    return _backgroudView;
}

-(UILabel *)sendLable{
    if (_sendLable == nil) {
        _sendLable = [[UILabel alloc]init];
        [self.backgroudView addSubview:_sendLable];
        [_sendLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_mySlideView.mas_top).equalTo(-20);
            make.centerX.equalTo(_mySlideView.mas_centerX);
        }];
        _sendLable.text = @"确定上传作业方案？";
        _sendLable.textColor = [UIColor whiteColor];
    }
    return _sendLable;
}

-(UIButton *)cancalSendBtn{
    if (_cancalSendBtn == nil) {
        _cancalSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backgroudView addSubview:_cancalSendBtn];
        [_cancalSendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_mySlideView.mas_bottom).equalTo(70);
            make.centerX.equalTo(_mySlideView.mas_centerX);
        }];
        [_cancalSendBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [_cancalSendBtn addTarget:self action:@selector(cancelSendAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancalSendBtn;
}
- (void)cancelSendAction{
    [_delegate cancelClickAction];
}

-(void)cancelAction{
    
}

-(NSString *)pfLabText{
    return [_sendLable text];
}

-(NSString *)pfSliderLabText{
    return [_mySlideView slideLabText];
}

-(void)setPfLabText:(NSString *)pfLabText{
    [_sendLable setText:pfLabText];
}

-(void)setPfSliderLabText:(NSString *)pfSliderLabText{
    return [_mySlideView setSlideLabText:pfSliderLabText];
}

- (void) sliderDidSlide:(MBSliderView *)slideView {
    [_delegate sliderMoveFinish];

}

@end
