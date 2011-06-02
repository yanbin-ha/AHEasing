//
//  PlaygroundViewController.m
//  AHEasing
//
//  Created by Warren Moore on 5/27/11.
//  Copyright 2011 Auerhaus Development, LLC. All rights reserved.
//

#import "PlaygroundViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CAKeyframeAnimation+AHEasing.h"

@implementation PlaygroundViewController
@synthesize boid, tapView, curveSegmentedControl, easingSegmentedControl;

- (void)dealloc
{
	[boid release];
	[tapView release];
	[curveSegmentedControl release];
	[easingSegmentedControl release];

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	currentFunction = LinearInterpolation;
	
	UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
	[self.tapView addGestureRecognizer:tapRecognizer];
	[tapRecognizer release];
}

- (void)viewDidUnload
{
	[self setBoid:nil];
	[self setCurveSegmentedControl:nil];
	[self setEasingSegmentedControl:nil];

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Actions

- (void)viewWasTapped:(UIGestureRecognizer *)recognizer
{
	if([recognizer state] == UIGestureRecognizerStateEnded && !animating)
	{
		CGPoint targetCenter = [recognizer locationInView:self.view];
		
		CALayer *layer= [self.boid layer];
		[CATransaction begin];
		[CATransaction setValue:[NSNumber numberWithFloat:0.750] forKey:kCATransactionAnimationDuration];
		
		CAAnimation *chase = [CAKeyframeAnimation animationWithKeyPath:@"position" 
															 function:currentFunction 
															fromPoint:[self.boid center]
															  toPoint:targetCenter];
		[chase setDelegate:self];
		[layer addAnimation:chase forKey:@"position"];
		
		[CATransaction commit];
		
		[self.boid setCenter:targetCenter];
		
		animating = YES;
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	animating = NO;
}

- (void)configureEasingFunction
{
	switch(currentCurve)
	{
		case CurveTypeLinear:
			currentFunction = LinearInterpolation;
			break;
		case CurveTypeQuadratic:
			currentFunction = (currentEasing == EaseIn) ? QuadraticEaseIn : (currentEasing == EaseOut) ? QuadraticEaseOut : QuadraticEaseInOut;
			break;
		case CurveTypeCubic:
			currentFunction = (currentEasing == EaseIn) ? CubicEaseIn : (currentEasing == EaseOut) ? CubicEaseOut : CubicEaseInOut;
			break;
		case CurveTypeQuartic:
			currentFunction = (currentEasing == EaseIn) ? QuarticEaseIn : (currentEasing == EaseOut) ? QuarticEaseOut : QuarticEaseInOut;
			break;
		case CurveTypeQuintic:
			currentFunction = (currentEasing == EaseIn) ? QuinticEaseIn : (currentEasing == EaseOut) ? QuinticEaseOut : QuinticEaseInOut;
			break;
		case CurveTypeSine:
			currentFunction = (currentEasing == EaseIn) ? SineEaseIn : (currentEasing == EaseOut) ? SineEaseOut : SineEaseInOut;
			break;
		case CurveTypeCircular:
			currentFunction = (currentEasing == EaseIn) ? CircleEaseIn : (currentEasing == EaseOut) ? CircleEaseOut : CircleEaseInOut;
			break;
		case CurveTypeExpo:
			currentFunction = (currentEasing == EaseIn) ? ExponentialEaseIn : (currentEasing == EaseOut) ? ExponentialEaseOut : ExponentialEaseInOut;
			break;
		case CurveTypeElastic:
			currentFunction = (currentEasing == EaseIn) ? ElasticEaseIn : (currentEasing == EaseOut) ? ElasticEaseOut : ElasticEaseOut;
			break;
	}
}

- (IBAction)curveSelectionChanged:(id)sender
{
	currentCurve = [sender selectedSegmentIndex];
	[self configureEasingFunction];
}

- (IBAction)easingSelectionChanged:(id)sender
{
	currentEasing = [sender selectedSegmentIndex];
	[self configureEasingFunction];
}


@end
