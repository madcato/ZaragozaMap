//
//  BusAnnotationView.m
//  ZaragozaMap
//
//  Created by Daniel Vela on 5/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BusAnnotationView.h"
#import "BiZiItem.h"

static inline double radians(double degrees) { return degrees * M_PI / 180; }

@implementation BusAnnotationView

@synthesize num_huecos, num_bizis;
@synthesize imageName;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier  withDelegate:(id<MapManagementProtocol>) dele
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
	    delegate = dele;
		
        CGRect frame = self.frame;
        frame.size = CGSizeMake(38.0, 38.0);
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0.0, -19.0);//CGPointMake(30.0, 42.0);
		
		
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

-(void) dealloc {
	[imageName release];
	[super dealloc];
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
		

		
	 CGContextRef context = UIGraphicsGetCurrentContext();
	 CGContextSetLineWidth(context, 1);
        

		
		[[UIImage imageNamed:self.imageName] drawInRect:CGRectMake(0.0, 0.0, 38.0, 38.0)];
		

		
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
		
		self.layer.shadowOffset = CGSizeMake(0.0,0.0);
       
		CGPathRef shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 0, 10, 38) cornerRadius:5].CGPath;
		self.layer.shadowPath = shadowPath;
				
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
