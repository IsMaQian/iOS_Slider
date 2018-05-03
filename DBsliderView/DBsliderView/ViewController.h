//
//  ViewController.h
//  DBsliderView
//
//  Created by Jdb on 16/1/21.
//  Copyright © 2016年 uimbank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBSliderView.h"
#import "PerformTaskView.h"

@interface ViewController : UIViewController<MBSliderViewDelegate,PerformTaskViewDelegate>
{
    
}
@property (strong, nonatomic) MBSliderView *MBSlider;//滑块带边框
@property (nonatomic) PerformTaskView *performTaskView;
@end

