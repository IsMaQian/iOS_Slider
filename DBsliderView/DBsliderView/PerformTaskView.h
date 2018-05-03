//
//  PerformTaskView.h
//  DBsliderView
//
//  Created by EdwardSelf on 2018/4/28.
//  Copyright © 2018年 uimbank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSliderView.h"

@protocol PerformTaskViewDelegate;
@protocol PerformTaskViewDelegate <NSObject>

-(void)sliderMoveFinish;
-(void)cancelClickAction;

@end

@interface PerformTaskView : UIView <MBSliderViewDelegate>
@property (nonatomic) MBSliderView *mySlideView;
@property (nonatomic) UILabel *sendLable;
@property (nonatomic) UIView *backgroudView;
@property (nonatomic) UIButton *cancalSendBtn;
@property (nonatomic) id<PerformTaskViewDelegate> delegate;

@property (nonatomic) NSString *pfSliderLabText;
@property (nonatomic) NSString *pfLabText;

-(void)cancelAction;

@end
