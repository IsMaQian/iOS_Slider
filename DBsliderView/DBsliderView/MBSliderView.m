//
//  SliderView.m
//  Slider
//
//  Created by Mathieu Bolard on 02/02/12.
//  Copyright (c) 2012 Streettours. All rights reserved.
//

#import "MBSliderView.h"
#import <QuartzCore/QuartzCore.h>
#define UIColorFromRGB(rgbValue , A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]
#define MAS_SHORTHAND_GLOBALS
#define equalTo(...)                     mas_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        mas_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           mas_lessThanOrEqualTo(__VA_ARGS__)
#define offset(...)                      mas_offset(__VA_ARGS__)


#define FRAMES_PER_SEC 10
#import "Masonry.h"

static const CGFloat gradientWidth = 0.2;
static const CGFloat gradientDimAlpha = 0.5;


@interface MBSliderView()
- (void) loadContent;
- (UIImage *) thumbWithColor:(UIColor*)color;
- (UIImage *) clearPixel;
@end

@implementation MBSliderView
//@synthesize delegate = _delegate;

-(instancetype)init{
    if(self = [super init]){
        [self loadContent];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (frame.size.width < 136.0) {
        frame.size.width = 136.0;
    }
    if (frame.size.height < 44.0) {
        frame.size.height = 34.0;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer setCornerRadius:20];
        [self.layer setMasksToBounds:YES];
        [self.layer setBounds:frame];
        [self.layer setBorderColor:[UIColor redColor].CGColor];
        [self loadContent];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadContent];
    }
    return self;
}
-(void) awakeFromNib
{
    [super awakeFromNib];
    [self loadContent];
}


- (void) loadContent {
    
//    self.backgroundColor = UIColorFromRGB(0x1c251e, 0.8);
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"bg_di" ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
//    self.backgroundColor = [UIColor colorWithPatternImage:image];
    self.layer.contents = (__bridge id _Nullable)(image.CGImage);
    self.userInteractionEnabled = YES;
    [self backGroundImage];
    [self mySlider];
    [self slideLab];

}

-(UISlider *)mySlider{
    if (_mySlider == nil) {
        _mySlider = [[UISlider alloc]init];
        [self addSubview:_mySlider];
        [_mySlider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [self setSliderImage:@"bg_di" :_mySlider ];
        [_mySlider setThumbImage:[UIImage imageNamed:@"lines-1"] forState:UIControlStateNormal];
        _mySlider.minimumValue = 0.0;
        _mySlider.maximumValue = 1.0;
        _mySlider.continuous = YES;
        _mySlider.value = 0.0;
        
        [_mySlider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpInside];
        [_mySlider addTarget:self
                    action:@selector(sliderUp:)
          forControlEvents:UIControlEventTouchUpOutside];
        [_mySlider addTarget:self
                    action:@selector(sliderDown:)
          forControlEvents:UIControlEventTouchDown];
        [_mySlider addTarget:self
                    action:@selector(sliderChanged:)
          forControlEvents:UIControlEventValueChanged];
        
    }
    return _mySlider;
}

-(UIImageView *)backGroundImage{
    if (_backGroundImage == nil) {
        _backGroundImage = [[UIImageView alloc]init];
        [self addSubview:_backGroundImage];
        [_backGroundImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _backGroundImage.backgroundColor = UIColorFromRGB(0x1c251e, 0.8);
    }
    return _backGroundImage;
}

-(UILabel *)slideLab{
    if (_slideLab == nil) {
        _slideLab = [[UILabel alloc]init];
        [self addSubview:_slideLab];
        [_slideLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.right.equalTo(-40);
        }];
        _slideLab.text = @"测试";
        _slideLab.textColor = UIColorFromRGB(0x6ceba4, 0.3);
        
    }
    return _slideLab;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat sliderWidth = [_slider thumbImageForState:_slider.state].size.width;
    CGSize labelSize = [_label sizeThatFits:self.bounds.size];
    
    _label.frame = CGRectMake(sliderWidth + 20.0,
                              CGRectGetMidY(self.bounds) - (labelSize.height / 2.0),
                              CGRectGetWidth(self.bounds) - sliderWidth - 30.0,
                              labelSize.height
                              );
    _slider.frame = self.bounds;
}

// Implement the "enabled" property
- (BOOL) enabled {
	return _slider.enabled;
}

- (void) setEnabled:(BOOL)enabled{
	_slider.enabled = enabled;
	_label.enabled = enabled;
	if (enabled) {
		_slider.value = 0.0;
		_label.alpha = 1.0;
		_sliding = NO;
	}
    [_label setAnimated:enabled];
}

- (NSString *) slideLabText {
    return [self.slideLab text];
}

- (void) setSlideLabText:(NSString *)text {
    [self.slideLab setText:text];
}
// Implement the "text" property
- (NSString *) text {
    return [_label text];
}

- (void) setText:(NSString *)text {
    [_label setText:text];
}

// Implement the "labelColor" property
- (UIColor *) labelColor {
    return [_label textColor];
}

- (void) setLabelColor:(UIColor *)labelColor {
    [_label setTextColor:labelColor];
}

// UISlider actions
- (void) sliderUp:(UISlider *)sender {
    
	if (_sliding) {
		_sliding = NO;
        
        if (sender.value == 1.0) {
            [_delegate sliderDidSlide:self];
            [sender setValue:1.0 animated: YES];
        }else{
            [sender setValue:0.0 animated: YES];
            _label.alpha = 1.0;
//            self.alpha = 1.0;
            self.slideLab.alpha = 1;
            self.backGroundImage.alpha = 1;
        }
		 
        [_label setAnimated:YES];
	}
}

- (void) sliderDown:(UISlider *)sender {

	if (!_sliding) {
		[_label setAnimated:NO];
	}
	_sliding = YES;
}

- (void) setSliderImage : (NSString *)imageName :(UISlider *)sender{
    UIImage *stetchTrack = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [sender setMaximumTrackImage:stetchTrack forState:UIControlStateNormal];
    [sender setMinimumTrackImage:stetchTrack forState:UIControlStateNormal];
    
}

- (void) setSliderColor : (UIColor *)colorName :(UISlider *)sender{

    [sender setMaximumTrackTintColor:colorName];
    [sender setMinimumTrackTintColor:colorName];
    
}

- (void) sliderChanged:(UISlider *)sender {

	_label.alpha = MAX(0.0, 1.0 - (_slider.value * 3.5));
    self.slideLab.alpha = MAX(0.0, 1.0 - (sender.value * 1.5));
    self.backGroundImage.alpha = MAX(0.0, 1.0 - (sender.value * 1));

    
}


- (void) setThumbColor:(UIColor *)color {
    [_slider setThumbImage:[self thumbWithColor:color] forState:UIControlStateNormal];
}

- (void) setThumbImage:(UIImage *)image{
    [_slider setThumbImage:image forState:UIControlStateNormal];
}

- (void)setTrackMinImage:(UIImage *)image{
    [_slider setMinimumTrackImage:image forState:UIControlStateNormal];
}

-(void)setTrackMaxImage:(UIImage *)image{
    [_slider setMaximumTrackImage:image forState:UIControlStateNormal];
}



- (UIImage *) thumbWithColor:(UIColor*)color {
    CGFloat scale = [UIScreen mainScreen].scale;
    if (scale<1.0) {scale = 1.0;}
    
    CGSize size = CGSizeMake(68.0*scale, 34.0*scale);
    CGFloat radius = self.layer.cornerRadius*scale;
    // create a new bitmap image context
    UIGraphicsBeginImageContext(size);     
    
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();       
    
    // push context to make it current 
    // (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);    
    
    [color setFill];
    [[[UIColor blackColor] colorWithAlphaComponent:0.8] setStroke];
    
    CGFloat radiusp = radius+0.5;
    CGFloat wid1 = size.width-0.5;
    CGFloat hei1 = size.height-0.5;
    CGFloat wid2 = size.width-radiusp;
    CGFloat hei2 = size.height-radiusp;
    
	// Path
    CGContextMoveToPoint(context, 0.5, radiusp);
    CGContextAddArcToPoint(context, 0.5, 0.5, radiusp, 0.5, radius);
    CGContextAddLineToPoint(context, wid2, 0.5);
    CGContextAddArcToPoint(context, wid1, 0.5, wid1, radiusp, radius);
    CGContextAddLineToPoint(context, wid1, hei2);
    CGContextAddArcToPoint(context, wid1, hei1, wid2, hei1, radius);
    CGContextAddLineToPoint(context, radius, hei1);
    CGContextAddArcToPoint(context, 0.5, hei1, 0.5, hei2, radius);
    CGContextClosePath(context); 
    CGContextDrawPath(context, kCGPathFillStroke);
    
    
    // Arrow
    [[[UIColor whiteColor] colorWithAlphaComponent:0.6] setFill];
    [[[UIColor blackColor] colorWithAlphaComponent:0.3] setStroke];
    
    CGFloat points[8]= {    (15.0*scale)+0.5,//左边距(10)
                            (12.0*scale)+0.5,//上边距(16)
                            (36.0*scale)+0.5,
                            (5.0*scale)+0.5,//箭头上(10)
                            (52.0*scale)+0.5,
                            (17.0*scale)+0.5,//箭头点(22)
                            (30.0*scale)+0.5,//箭头下
                            (24.0*scale)+0.5 };//下边距(28)
    
    CGContextMoveToPoint(context, points[0], points[1]);
    CGContextAddLineToPoint(context, points[2], points[1]);
    CGContextAddLineToPoint(context, points[2], points[3]);
    CGContextAddLineToPoint(context, points[4], points[5]);
    CGContextAddLineToPoint(context, points[2], points[6]);
    CGContextAddLineToPoint(context, points[2], points[7]);
    CGContextAddLineToPoint(context, points[0], points[7]);
    CGContextClosePath(context); 
    CGContextDrawPath(context, kCGPathFillStroke); 
    
    
    // Light
    [[[UIColor whiteColor] colorWithAlphaComponent:0.2] setFill];
    
    CGFloat mid = lround(size.height/2.0)+0.5;
    CGContextMoveToPoint(context, 0.5, radiusp);
    CGContextAddArcToPoint(context, 0.5, 0.5, radiusp, 0.5, radius);
    CGContextAddLineToPoint(context, wid2, 0.5);
    CGContextAddArcToPoint(context, wid1, 0.5, wid1, radiusp, radius);
    CGContextAddLineToPoint(context, wid1, mid);
    CGContextAddLineToPoint(context, 0.5, mid);
    CGContextClosePath(context); 
    CGContextDrawPath(context, kCGPathFill);
    
    // pop context 
    UIGraphicsPopContext();                             
    
    // get a UIImage from the image context
    UIImage *outputImage = [[UIImage alloc] initWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    //write (debug)
    //[UIImagePNGRepresentation(outputImage) writeToFile:@"/Users/mathieu/Desktop/test.png" atomically:YES];
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return outputImage;
}

- (UIImage *) clearPixel {
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end












@interface MBSliderLabel()

- (void) setGradientLocations:(CGFloat)leftEdge;
- (void) startTimer;
- (void) stopTimer;

@end

@implementation MBSliderLabel
@synthesize animated = _animated;

- (BOOL) isAnimated {
    return _animated;
}

- (void) setAnimated:(BOOL)animated {
    if (_animated != animated) {
        _animated = animated;
        if (_animated) {
            [self startTimer];
        } else {
            [self stopTimer];
        }
    }
}

// animationTimer methods
- (void)animationTimerFired:(NSTimer*)theTimer {
	// Let the timer run for 2 * FPS rate before resetting.
	// This gives one second of sliding the highlight off to the right, plus one
	// additional second of uniform dimness
	if (++animationTimerCount == (2 * FRAMES_PER_SEC)) {
		animationTimerCount = 0;
	}
	
	// Update the gradient for the next frame
	[self setGradientLocations:((CGFloat)animationTimerCount/(CGFloat)FRAMES_PER_SEC)];
}

- (void) startTimer {
	if (!animationTimer) {
		animationTimerCount = 0;
		[self setGradientLocations:0];
		animationTimer = [NSTimer 
						   scheduledTimerWithTimeInterval:1.0/FRAMES_PER_SEC 
						   target:self 
						   selector:@selector(animationTimerFired:) 
						   userInfo:nil 
						   repeats:YES];
	}
}

- (void) stopTimer {
	if (animationTimer) {
		[animationTimer invalidate];
		animationTimer = nil;
	}
}

- (void)drawLayer:(CALayer *)theLayer inContext:(CGContextRef)theContext
{	
	// Note: due to use of kCGEncodingMacRoman, this code only works with Roman alphabets! 
	// In order to support non-Roman alphabets, you need to add code generate glyphs,
	// and use CGContextShowGlyphsAtPoint
	//CGContextSelectFont(theContext, [self.font.fontName UTF8String], self.font.pointSize, kCGEncodingMacRoman);
    
	// Set Text Matrix
	CGContextSetTextMatrix(theContext, CGAffineTransformMake(1.0,  0.0,
                                                             0.0, -1.0,
                                                             0.0,  0.0));
	
	// Set Drawing Mode to clipping path, to clip the gradient created below
	CGContextSetTextDrawingMode (theContext, kCGTextClip);
	
	// Draw the label's text
    // 不支持中文
//	const char *text = [self.text cStringUsingEncoding:NSMacOSRomanStringEncoding];
//	CGContextShowTextAtPoint(theContext,
//                             0,
//                             (size_t)self.font.ascender,
//                             text,
//                             strlen(text));

    UIGraphicsPushContext(theContext);
    if ([[UIScreen mainScreen] bounds].size.height > 480.0f && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        [self.text drawAtPoint:CGPointMake(0, (size_t)self.font.leading) withAttributes:attrsDictionary];
        
    }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad || [[UIScreen mainScreen] bounds].size.height <= 480.0f){
        NSDictionary *attrsDictionary =[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,[NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
        [self.text drawAtPoint:CGPointMake(0, (size_t)self.font.leading-18) withAttributes:attrsDictionary];
    }
    
    //NSFont *font = [NSFont fontWithName:@"Palatino-Roman" size:14.0];
    
    UIGraphicsPopContext();
    
	// Calculate text width
	CGPoint textEnd = CGContextGetTextPosition(theContext);
	
	// Get the foreground text color from the UILabel.
	// Note: UIColor color space may be either monochrome or RGB.
	// If monochrome, there are 2 components, including alpha.
	// If RGB, there are 4 components, including alpha.
	CGColorRef textColor = self.textColor.CGColor;
	const CGFloat *components = CGColorGetComponents(textColor);
	size_t numberOfComponents = CGColorGetNumberOfComponents(textColor);
	BOOL isRGB = (numberOfComponents == 4);
	CGFloat red = components[0];
	CGFloat green = isRGB ? components[1] : components[0];
	CGFloat blue = isRGB ? components[2] : components[0];
	CGFloat alpha = isRGB ? components[3] : components[1];
    
	// The gradient has 4 sections, whose relative positions are defined by
	// the "gradientLocations" array:
	// 1) from 0.0 to gradientLocations[0] (dim)
	// 2) from gradientLocations[0] to gradientLocations[1] (increasing brightness)
	// 3) from gradientLocations[1] to gradientLocations[2] (decreasing brightness)
	// 4) from gradientLocations[3] to 1.0 (dim)
	size_t num_locations = 3;
	
	// The gradientComponents array is a 4 x 3 matrix. Each row of the matrix
	// defines the R, G, B, and alpha values to be used by the corresponding
	// element of the gradientLocations array
	CGFloat gradientComponents[12];
	for (int row = 0; row < num_locations; row++) {
		int index = 4 * row;
		gradientComponents[index++] = red;
		gradientComponents[index++] = green;
		gradientComponents[index++] = blue;
		gradientComponents[index] = alpha * gradientDimAlpha;
	}
    
	// If animating, set the center of the gradient to be bright (maximum alpha)
	// Otherwise it stays dim (as set above) leaving the text at uniform
	// dim brightness
	if (animationTimer) {
		gradientComponents[7] = alpha;
	}
    
	// Load RGB Colorspace
	CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
	
	// Create Gradient
	CGGradientRef gradient = CGGradientCreateWithColorComponents (colorspace, gradientComponents,
																  gradientLocations, num_locations);
	// Draw the gradient (using label text as the clipping path)
	CGContextDrawLinearGradient (theContext, gradient, self.bounds.origin, textEnd, 0);
	
	// Cleanup
	CGGradientRelease(gradient);
	CGColorSpaceRelease(colorspace);
    
    
}

- (void) setGradientLocations:(CGFloat) leftEdge {
	// Subtract the gradient width to start the animation with the brightest 
	// part (center) of the gradient at left edge of the label text
	leftEdge -= gradientWidth;
	
	//position the bright segment of the gradient, keeping all segments within the range 0..1
	gradientLocations[0] = leftEdge < 0.0 ? 0.0 : (leftEdge > 1.0 ? 1.0 : leftEdge);
	gradientLocations[1] = MIN(leftEdge + gradientWidth, 1.0);
	gradientLocations[2] = MIN(gradientLocations[1] + gradientWidth, 1.0);
	
	// Re-render the label text
	[self.layer setNeedsDisplay];
}

@end
