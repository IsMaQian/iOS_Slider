//
//  SliderView.h
//  Slider
//  //滑块动画
//  Created by Mathieu Bolard on 02/02/12.
//  Copyright (c) 2012 Streettours. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBSliderLabel;
@protocol MBSliderViewDelegate;

@interface MBSliderView : UIView {
    UISlider *_slider;
    MBSliderLabel *_label;
 //   id<MBSliderViewDelegate> delegate;
    BOOL _sliding;
}

@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) UIColor *labelColor;
//留给xib
//@property (nonatomic,assign) IBOutlet id<MBSliderViewDelegate> delegate;
@property (nonatomic) id<MBSliderViewDelegate> delegate;
@property (nonatomic) BOOL enabled;

@property (nonatomic) UISlider *mySlider;
@property (nonatomic) UILabel *slideLab;
@property (nonatomic) UIImageView *backGroundImage;
@property (nonatomic) NSString *slideLabText;

- (void) setThumbColor:(UIColor *)color;
- (void) setThumbImage:(UIImage *)image;
- (void)setTrackMinImage:(UIImage *)image;
-(void)setTrackMaxImage:(UIImage *)image;

@end

@protocol MBSliderViewDelegate <NSObject>

- (void) sliderDidSlide:(MBSliderView *)slideView;
@end




@interface MBSliderLabel : UILabel {
    NSTimer *animationTimer;
    CGFloat gradientLocations[3];
    int animationTimerCount;
    BOOL _animated;
}

@property (nonatomic, assign, getter = isAnimated) BOOL animated;

@end
