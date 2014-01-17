//
//  JMMViewController.m
//  BarDice
//
//  Created by Justin Martin on 1/16/14.
//  Copyright (c) 2014 JMM. All rights reserved.
//

#import "JMMViewController.h"
#import "JMMLocationEngine.h"

@interface JMMViewController ()

@property (nonatomic, strong) FSVenue *thisVenue;
@property (nonatomic, strong) FSLocation *thisLocation;
@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation JMMViewController {
    UILabel *_shakeLabel;
    UILabel *_addressLabel;
    UILabel *_distanceLabel;
    
    
    UIGravityBehavior *_gravity;
    UIDynamicAnimator *_animator;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getLocation];

    
    _shakeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 50)];
    _shakeLabel.text = @"Shake up the phone for a place to go!";
    //[label sizeToFit];
    _shakeLabel.textAlignment = NSTextAlignmentCenter;
    _shakeLabel.numberOfLines = 0;
 	_shakeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 50)];
    _addressLabel.textAlignment = NSTextAlignmentCenter;
    _addressLabel.numberOfLines = 0;
    _addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 250, 320, 50)];
    _distanceLabel.textAlignment = NSTextAlignmentCenter;
    _distanceLabel.numberOfLines = 0;
    _distanceLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 300, 320, self.view.height - 250)];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.thisVenue.location.coordinate, 500, 500);
    [self.mapView setRegion:region];
    
    
    
    [self.view addSubview:self.mapView];
    

    
    
    
    
    
    [self.view addSubview:_shakeLabel];
    [self.view addSubview:_addressLabel];
    [self.view addSubview:_distanceLabel];
    
    
    [self addBehaviors];
    

}

-(void) addBehaviors {
    [_animator removeAllBehaviors];
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_shakeLabel, _distanceLabel, _addressLabel]];
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[_shakeLabel, _addressLabel, _distanceLabel]];
    itemBehavior.elasticity = 0.3;
    [_animator addBehavior:itemBehavior];
    [_animator addBehavior:_gravity];
    _gravity.magnitude = 1.3;
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[_shakeLabel, _addressLabel, _distanceLabel]];
    collision.collisionMode = UICollisionBehaviorModeEverything;
    collision.collisionDelegate = self;
    collision.translatesReferenceBoundsIntoBoundary = NO;
    [_animator addBehavior:collision];
    
    
    CGPoint start = CGPointMake(0, 250);
    CGPoint end = CGPointMake(self.view.width, 250);
    [collision addBoundaryWithIdentifier:@"ident" fromPoint:start toPoint:end];
}

-(void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [_animator removeAllBehaviors];
		[self.mapView removeAnnotations:[self.mapView annotations]];
        
        /*
        [UIView animateWithDuration:0.2 animations:^{

            [_shakeLabel withY:150];
            [_addressLabel withY:200];
            [_distanceLabel withY:250];
        }];
         */
        
        NSLog(@"%@   %@   %@", self.thisVenue.name, self.thisVenue.location.address, self.thisVenue.location.distance);
        _shakeLabel.text = self.thisVenue.name ? self.thisVenue.name : @" ";
        _addressLabel.text = self.thisVenue.location.address ? self.thisVenue.location.address : @" ";
        NSNumber *distance = self.thisVenue.location.distance ? self.thisVenue.location.distance : @0;
        
        _distanceLabel.text = [NSString stringWithFormat:@"%@ Meters", distance];
        [_shakeLabel sizeToFit];
        [_addressLabel sizeToFit];
        [_distanceLabel sizeToFit];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.thisVenue.location.coordinate, 1000, 1000);
        [self.mapView setRegion:region];
        [self.mapView addAnnotation:self.thisVenue];
        [self.mapView setShowsUserLocation:YES];
        
        _shakeLabel.center = self.view.center;
        _addressLabel.center = self.view.center;
        _distanceLabel.center = self.view.center;
        [_shakeLabel withY:-55];
        [_addressLabel withY:-40];
        [_distanceLabel withY:-25];
        [_shakeLabel setTransform:CGAffineTransformMakeRotation(0)];
        [_addressLabel setTransform:CGAffineTransformMakeRotation(0)];
        [_distanceLabel setTransform:CGAffineTransformMakeRotation(0)];
        [self addBehaviors];
//
//        UIPushBehavior *pusher = [[UIPushBehavior alloc] initWithItems:@[_shakeLabel, _addressLabel, _distanceLabel] mode:UIPushBehaviorModeInstantaneous];
//        pusher.pushDirection = CGVectorMake(0, 1);
//        pusher.active = YES;
//        [_animator addBehavior:pusher];
        
        
        [self getLocation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)getLocation {
	[JMMLocationEngine getFoursquareVenuesNearbyOnSuccess:^(NSArray *venues) {
        int rand = arc4random() % venues.count;
        FSVenue *venue = (FSVenue *)venues[rand];
        self.thisVenue = venue;
        
        NSLog(@"%@", venue.name);
    } onFailure:^(NSInteger failCode) {
        NSLog(@"%d", failCode);
    }];
}




















@end

