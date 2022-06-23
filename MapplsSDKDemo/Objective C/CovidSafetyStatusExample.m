//
//  CovidSafetyStatusExample.m

//
//  Created by apple on 18/06/20.
//  Copyright © 2022 Mappls. All rights reserved.
//

#import "CovidSafetyStatusExample.h"

@interface CovidSafetyStatusExample () <MapplsMapViewDelegate>

@property (nonatomic) IBOutlet MapplsMapView *mapView;

@property (weak, nonatomic) IBOutlet UIButton *getCurrentSafetyButton;

@property (weak, nonatomic) IBOutlet UIButton *hideSafetyStatusButton;


@end

@implementation CovidSafetyStatusExample

BOOL isLocationReady = NO;

- (IBAction)getCurrentSafetyButtonPressed:(UIButton *)sender {
    [_mapView showCurrentLocationSafety];
}

- (IBAction)hideSafetyStatusButtonPressed:(UIButton *)sender {
    [_mapView hideSafetyStrip];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MGLUserTrackingModeFollow;
    _mapView.delegate = self;
}

- (void)mapView:(MGLMapView *)mapView didUpdateUserLocation:(MGLUserLocation *)userLocation {
    if (userLocation && userLocation.location && CLLocationCoordinate2DIsValid(userLocation.location.coordinate)) {
        isLocationReady = YES;
    }
}

@end
