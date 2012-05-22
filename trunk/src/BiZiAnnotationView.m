//
//  BiZiAnnotationView.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BiZiAnnotationView.h"
#import "BiZiItem.h"

static inline double radians(double degrees) { return degrees * M_PI / 180; }

@implementation BiZiAnnotationView

@synthesize num_huecos, num_bizis;


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier  withDelegate:(id<MapManagementProtocol>) dele
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        delegate = dele;
		
        CGRect frame = self.frame;
        frame.size = CGSizeMake(38.0, 50.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, -22.0);//CGPointMake(30.0, 42.0);
		
		
		// Tap management
		
		UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
		[tapGesture setNumberOfTouchesRequired:1];
		[tapGesture setNumberOfTapsRequired:1];
		[tapGesture setDelegate:self];
		[self addGestureRecognizer:tapGesture];
		[tapGesture release];
    }
    return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    // this annotation view has custom drawing code.  So when we reuse an annotation view
    // (through MapView's delegate "dequeueReusableAnnoationViewWithIdentifier" which returns non-nil)
    // we need to have it redraw the new annotation data.
    //
    // for any other custom annotation view which has just contains a simple image, this won't be needed
    //
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    BiZiItem *biziItem = (BiZiItem *)self.annotation;
    if (biziItem != nil)
    {
		
		UIColor* color = [UIColor whiteColor];
        
		
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        
		CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 16.0, 30.0);
        CGPathAddLineToPoint(path, NULL, 20.0, 47.0); 
        CGPathAddLineToPoint(path, NULL, 24.0, 30.0); 
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        CGPathRelease(path);
        
		
		[[UIImage imageNamed:@"bizi2.png"] drawInRect:CGRectMake(3.0, 3.0, 35.0, 35.0)];
		
        
		
        /*		[[UIImage imageNamed:@"red_cycle.png"] drawInRect:CGRectMake(24, 10.0, 30.0, 26.0)];
         
         [[UIImage imageNamed:@"black_cycle.png"] drawInRect:CGRectMake(24, 40.0, 30.0, 26.0)];
         
         
         NSString *label_bizi = [NSString stringWithFormat:@"%d", self.num_bizis];
         [[UIColor blackColor] set];
         [label_bizi drawInRect:CGRectMake(64.0, 10.0, 50.0, 40.0) withFont:[UIFont systemFontOfSize:24.0]];
         
         NSString *label_hueco = [NSString stringWithFormat:@"%d", self.num_huecos];
         [[UIColor blackColor] set];
         [label_hueco drawInRect:CGRectMake(64.0, 40.0, 50.0, 40.0) withFont:[UIFont systemFontOfSize:24.0]];
         */	
		
		
		self.layer.shadowOpacity = 0.50f;
		self.layer.shadowRadius = 3.0f;
		
		CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
		CGFloat components[4] = {0, 0, 0, 1};
		CGColorRef almostBlack = CGColorCreate(space,components);
		self.layer.shadowColor = almostBlack;
		
		self.layer.shadowOffset = CGSizeMake(0.0,3.0);
        
		CGPathRef shadowPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(20, 20) radius:19 startAngle:0 endAngle:radians(360) clockwise:NO].CGPath;
		self.layer.shadowPath = shadowPath;
        self.layer.shouldRasterize = YES;
        
        CFRelease(almostBlack);
    }
}

#pragma mark -
#pragma mark Tap Gesture

- (void)handleTap:(UITapGestureRecognizer *)sender {     
	

	if (sender.state == UIGestureRecognizerStateEnded) {         

		CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"];

		animation.duration=0.2;
		animation.repeatCount=2;
		animation.autoreverses=YES;
		animation.fromValue=[NSNumber numberWithFloat:1.0];
		animation.toValue=[NSNumber numberWithFloat:0.0];
		[self.layer addAnimation:animation forKey:@"animateOpacity"];

		
		if(delegate != nil) {
			[delegate biziStationTouched:self.annotation];
		}
	} 
	

}
	
@end
