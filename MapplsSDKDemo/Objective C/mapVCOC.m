//
//  mapVCOC.m

//
//  Created by CE Info on 30/07/18.
//  Copyright © 2022 Mappls. All rights reserved.
//

#import "mapVCOC.h"
#import "MapplsSDKDemo-Swift.h"
#import "MultipleShapesExample.h"
#import "CustomAnnotationModels.h"
#import "CustomInfoWindowView.h"

@import MapplsFeedbackUIKit;


#define CASE(str)                       if ([__s__ isEqualToString:(str)])
#define SWITCH(s)                       for (NSString *__s__ = (s); ; )
#define DEFAULT
@interface mapVCOC ()
@property (weak, nonatomic) IBOutlet MapplsMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintSearchBarHeight;
@property (weak, nonatomic) IBOutlet UIView *vwFooter;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAutoSuggest;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;
    
@property(nonatomic, strong) NSMutableArray *searchSuggestions;
@property(nonatomic, strong) NSMutableArray *tempAnnotations;
@property(nonatomic, strong) MapplsPlacemark *placemark;
@property(nonatomic, strong) MapplsPlaceDetail *placeDetail;
@end

@implementation mapVCOC

BOOL isForCustomAnnotationView = false;

CLLocation *referenceLocation = nil;
NSString *refLocation = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mapView.delegate = self;
    self.tableViewAutoSuggest.hidden = YES;
    self.tableViewAutoSuggest.delegate = self;
    self.tableViewAutoSuggest.dataSource = self;
    [self.tableViewAutoSuggest reloadData];
    self.mapView.minimumZoomLevel = 4;
    
    referenceLocation = [[CLLocation alloc] initWithLatitude:28.550667 longitude:77.268959];
    refLocation = @"28.550667, 77.268959";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)feedbackButtonPressed:(UIButton *)sender {
    [self feedbackButtonHandler];
}
    
- (void)setData {
    SWITCH (_strType) {
        CASE (@"Zoom Level") {
            [_mapView setCenterCoordinate:referenceLocation.coordinate];
            _mapView.zoomLevel = 15;
            
        }
        CASE (@"Zoom Level With Animation") {
            [_mapView setCenterCoordinate:referenceLocation.coordinate];
            _mapView.zoomLevel = 15;
            [_feedbackButton setTitle:@"Start Zoom" forState:UIControlStateNormal];
            [_feedbackButton setHidden:false];
            [_feedbackButton addTarget:self action:@selector(zoomWithAnimation) forControlEvents:UIControlEventTouchUpInside];
        }
        CASE (@"Center With Animation") {
            [_mapView setCenterCoordinate:referenceLocation.coordinate];
            _mapView.zoomLevel = 15;
            [_feedbackButton setTitle:@"Start Center" forState:UIControlStateNormal];
            [_feedbackButton setHidden:false];
            [_feedbackButton addTarget:self action:@selector(centerWithAnimation) forControlEvents:UIControlEventTouchUpInside];
        }
        CASE (@"Current Location") {
            _mapView.showsUserLocation = YES;
        }
        CASE (@"Tracking Mode") {
            _mapView.userTrackingMode = MGLUserTrackingModeFollow;
        }
        CASE (@"Add Marker") {
            MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
            point.coordinate = referenceLocation.coordinate;
            point.title = @"Annotation";
            [self.mapView addAnnotation:point];
            [self.mapView setCenterCoordinate:referenceLocation.coordinate];
        }
        CASE (@"Add Multiple Markers With Bounds") {
            CLLocationCoordinate2D coordinates[] = {
                CLLocationCoordinate2DMake(28.550834, 77.268918),
                CLLocationCoordinate2DMake(28.551059, 77.268890),
                CLLocationCoordinate2DMake(28.550938, 77.267641),
                CLLocationCoordinate2DMake(28.551764, 77.267575),
                CLLocationCoordinate2DMake(28.552068, 77.267599),
                CLLocationCoordinate2DMake(28.553836, 77.267450),
            };
            
            NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
            
            NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:numberOfCoordinates];
            
            for (NSUInteger i = 0; i < numberOfCoordinates; i++) {
                MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
                point.coordinate = coordinates[i];
                point.title = [NSString stringWithFormat:@"Custom Point Annotation %lu", (unsigned long)i+1];
                [annotations addObject:point];
            }
            [self.mapView addAnnotations:annotations];
            [self.mapView showAnnotations:annotations animated:true];
        }
        CASE (@"Remove Marker") {
            MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
            point.coordinate = referenceLocation.coordinate;
            point.title = @"Annotation";
            [self.mapView addAnnotation:point];
            
            [self.mapView removeAnnotation:point];
//            [self.mapView removeAnnotations:point];
        }
        CASE (@"Polyline") {
            CLLocationCoordinate2D coordinates[] = {
            CLLocationCoordinate2DMake(28.550834, 77.268918),
            CLLocationCoordinate2DMake(28.551059, 77.268890),
            CLLocationCoordinate2DMake(28.550938, 77.267641),
            CLLocationCoordinate2DMake(28.551764, 77.267575),
            CLLocationCoordinate2DMake(28.552068, 77.267599),
            CLLocationCoordinate2DMake(28.553836, 77.267450),
        };
        NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
        MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coordinates
                                                               count:numberOfCoordinates];//
        [self.mapView addAnnotation:polyline];
            MGLMapCamera *shapeCam = [self.mapView cameraThatFitsShape:polyline direction:(0) edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)];
            [self.mapView setCamera:shapeCam];
            
        }
        CASE (@"Polygons") {
            CLLocationCoordinate2D coordinates[] = {
                CLLocationCoordinate2DMake(28.550834, 77.268918),
                CLLocationCoordinate2DMake(28.551059, 77.268890),
                CLLocationCoordinate2DMake(28.550938, 77.267641),
                CLLocationCoordinate2DMake(28.551764, 77.267575),
                CLLocationCoordinate2DMake(28.552068, 77.267599),
                CLLocationCoordinate2DMake(28.553836, 77.267450),
            };
            NSUInteger numberOfCoordinates = sizeof(coordinates) /
            sizeof(CLLocationCoordinate2D);
            MGLPolygon *polygon = [MGLPolygon polygonWithCoordinates:coordinates
                                                               count:numberOfCoordinates];//
            [self.mapView addAnnotation:polygon];
            MGLMapCamera *shapeCam = [self.mapView cameraThatFitsShape:polygon direction:(0) edgePadding:UIEdgeInsetsMake(20, 20, 20, 20)];
            [self.mapView setCamera:shapeCam];
        }
        CASE (@"Autosuggest") {
            [self.searchBar setHidden:NO];
            self.constraintSearchBarHeight.constant = 56;
            self.searchBar.delegate = self;
            _searchSuggestions = [[NSMutableArray alloc]init];
            
            [self.mapView setCenterCoordinate:referenceLocation.coordinate];
            [self.mapView setZoomLevel:16];
            MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
            [annotation setCoordinate:referenceLocation.coordinate];
            [self.mapView addAnnotation:annotation];
        }
        CASE (@"Geocode") {
            [self.searchBar setHidden:NO];
            self.constraintSearchBarHeight.constant = 56;
            self.searchBar.delegate = self;
            self.searchBar.text = @"Mappls, Okhla";
            [self callGeocode: self.searchBar.text];
        }
        CASE (@"Reverse Geocoding") {
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMap:)];
            [self.mapView addGestureRecognizer:tapRecognizer];
        }
        CASE (@"Nearby Search") {
            [self.searchBar setHidden:NO];
            self.constraintSearchBarHeight.constant = 56;
            self.searchBar.delegate = self;
            self.searchBar.text = @"Hotel";
            _searchSuggestions = [[NSMutableArray alloc]init];
            
            [self.mapView setCenterCoordinate:referenceLocation.coordinate];
            [self.mapView setZoomLevel:16];
            MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc] init];
            [annotation setCoordinate:referenceLocation.coordinate];
            [self.mapView addAnnotation:annotation];
            
            MapplsNearByManager * nearByManager = [MapplsNearByManager
                                                       sharedManager];
            MapplsNearbyAtlasOptions *nearByOptions = [[MapplsNearbyAtlasOptions alloc] initWithQuery:self.searchBar.text location:refLocation withRegion:MapplsRegionTypeIndia];
            nearByOptions.bounds = [[MapplsRectangularRegion alloc] initWithTopLeft:CLLocationCoordinate2DMake(28.563838, 77.244345) bottomRight:CLLocationCoordinate2DMake(28.541898, 77.294514)];

            [nearByManager getNearBySuggestionsWithOptions:nearByOptions
                                         completionHandler:^(MapplsNearbyResult * _Nullable
                                                             result, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error);
                } else if (result.suggestions.count > 0) {
                    NSLog(@"Nearby %@%@",
                          result.suggestions[0].latitude,result.suggestions[0].longitude);
                    [self.searchSuggestions removeAllObjects];
                    self.searchSuggestions = [NSMutableArray arrayWithArray:result.suggestions];
                    self.tableViewAutoSuggest.hidden = NO;
                    [self.tableViewAutoSuggest reloadData];
                } else {
                    
                }
            }];
        }
        CASE (@"Place Detail") {
            [self.searchBar setHidden:NO];
            self.constraintSearchBarHeight.constant = 56;
            self.searchBar.delegate = self;
            self.searchBar.text = @"mmi000";
            [self callPlaceDetail: self.searchBar.text];
        }
        CASE (@"Distance Matrix") {
            [self callDistanceMatrixWithIsETA: NO];
        }
        CASE (@"Distance Matrix ETA") {
            [self callDistanceMatrixWithIsETA: YES];
        }
        CASE (@"Route Advance") {
            [self callRouteUsingDirectionsFramework:NO];
        }
        CASE (@"Route Advance ETA") {
            [self callRouteUsingDirectionsFramework:YES];
        }
        CASE (@"Feedback") {
            [_mapView setCenterCoordinate:referenceLocation.coordinate];
            _mapView.zoomLevel = 15;
            [_feedbackButton setTitle:@"Send Feedback" forState:UIControlStateNormal];
            [_feedbackButton setHidden:false];
            [_feedbackButton addTarget:self action:@selector(feedbackButtonHandler) forControlEvents:UIControlEventTouchUpInside];
        }
        CASE (@"Animate Marker") {
            isForCustomAnnotationView = true;
            [self.mapView setCenterCoordinate:referenceLocation.coordinate];
            [self.mapView setZoomLevel:12];
            
            MGLPointAnnotation *annot = [[MGLPointAnnotation alloc] init];
            annot.coordinate = referenceLocation.coordinate;
            [self.mapView addAnnotation:annot];
            
            // Move the annotation to a point that is offscreen.
            CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(28.570288, 77.116392);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:10 animations:^{
                    annot.coordinate = coord;
                }];
            });
        }
        CASE (@"Custom Marker") {
            CLLocationCoordinate2D coordinates[] = {
                CLLocationCoordinate2DMake(28.551438, 77.265119),
                CLLocationCoordinate2DMake(28.521438, 77.265179),
                CLLocationCoordinate2DMake(28.571438, 77.26509),
                CLLocationCoordinate2DMake(28.551438, 77.26319),
                CLLocationCoordinate2DMake(28.511438, 77.261119),
                CLLocationCoordinate2DMake(28.552438, 77.262119),
            };
            NSUInteger numberOfCoordinates = sizeof(coordinates) / sizeof(CLLocationCoordinate2D);
            
            NSMutableArray *pointAnnotations = [NSMutableArray arrayWithCapacity:numberOfCoordinates];
            for (NSUInteger i = 0; i < numberOfCoordinates; i++) {
                NSUInteger count = pointAnnotations.count + 1;
                CustomAnnotation *point = [[CustomAnnotation alloc] init];
                
                point.coordinate = coordinates[i];
                point.title = [NSString stringWithFormat:@"Custom Point Annotation %lu", (unsigned long)count];
                
                point.reuseIdentifier = [NSString stringWithFormat:@"customAnnotation%lu", (unsigned long)count];
                point.image = [UIImage imageNamed:@"Vehicle"];
                
                [pointAnnotations addObject:point];
            }            
            [self.mapView addAnnotations:pointAnnotations];
            [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        }
        DEFAULT {
            break;
        }
    }
}

// TODO: Reference location for Nearby from MapplsAutocompleteViewController.
//-(void) presentDefaultConroller {
//    MapplsAutocompleteViewController * autocompleteViewController = [[MapplsAutocompleteViewController alloc] init];
//    [self.navigationController presentViewController:autocompleteViewController animated:YES completion:nil];
//}


-(void)callPlaceDetail:(NSString *)searchQuery {
    self.placeDetail = nil;
    MapplsPlaceDetailManager * placeDetailManager = [MapplsPlaceDetailManager sharedManager];
    MapplsPlaceDetailOptions *placeOptions = [[MapplsPlaceDetailOptions alloc] initWithMapplsPin:searchQuery
                                                      withRegion:MapplsAccountManager.defaultRegion];
    [placeDetailManager getResultsWithOptions:placeOptions completionHandler:^(MapplsPlaceDetail * _Nullable placeDetail, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (placeDetail) {
            self.placeDetail = placeDetail;
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Detail" style:UIBarButtonItemStylePlain target:self action:@selector(showPlaceDetail)];
            
            NSLog(@"Place Detail %@%@",
                  placeDetail.latitude,placeDetail.longitude);
            
            if (placeDetail.latitude && placeDetail.longitude) {
                MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
                point.coordinate = CLLocationCoordinate2DMake( [placeDetail.latitude doubleValue],  [placeDetail.longitude doubleValue]);
                point.title =  placeDetail.address;
                
                [self.mapView addAnnotation:point];
                [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([placeDetail.latitude doubleValue], [placeDetail.longitude doubleValue])
                                        zoomLevel:11
                                         animated:NO];
            }
        } else {
            
        }
    }];
}

-(void)callGeocode:(NSString *)searchQuery {
    MapplsAtlasGeocodeManager * atlasGeocodeManager = [MapplsAtlasGeocodeManager
                                                 sharedManager];
    MapplsAtlasGeocodeOptions *atlasGeocodeOptions =
    [[MapplsAtlasGeocodeOptions alloc] initWithQuery: searchQuery
                                                withRegion:MapplsRegionTypeIndia];
    
    [atlasGeocodeManager getGeocodeResultsWithOptions:atlasGeocodeOptions completionHandler:^(MapplsAtlasGeocodeAPIResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (response!= nil && response.placemarks.count > 0) {
            NSLog(@"Atlas Geocode %@%@", response.placemarks[0].latitude, response.placemarks[0].longitude);
            
            [self.mapView removeAnnotations:self.mapView.annotations];
            
            MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
            point.coordinate = CLLocationCoordinate2DMake( [response.placemarks[0].latitude doubleValue],  [response.placemarks[0].longitude doubleValue]);
            point.title =  response.placemarks[0].formattedAddress;
            [self.mapView addAnnotation:point];
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([response.placemarks[0].latitude doubleValue], [response.placemarks[0].longitude doubleValue])
                                    zoomLevel:17
                                     animated:NO];
        } else {
            NSLog(@"No results");
        }
    }];
}

-(void)callDistanceMatrixWithIsETA:(BOOL) isETA {
    MapplsDrivingDistanceMatrixManager * distanceMatrixManager = [MapplsDrivingDistanceMatrixManager sharedManager];
    
    MapplsDrivingDistanceMatrixOptions *distanceMatrixOptions = [[MapplsDrivingDistanceMatrixOptions alloc] initWithCenter:[[CLLocation
                                                               alloc] initWithLatitude:28.543014 longitude:77.242342] points:[NSArray arrayWithObjects: [[CLLocation alloc] initWithLatitude:28.520638 longitude: 77.201959], nil]
                                                                    withRegion: MapplsRegionTypeIndia ];
    
    if (isETA) {
        distanceMatrixOptions.resourceIdentifier = MapplsDistanceMatrixResourceIdentifierDefault;
    }
    
    _tempAnnotations = [[NSMutableArray alloc] init];
    
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake( 28.543014,  77.242342);
    [self.mapView addAnnotation:point];
    [_tempAnnotations addObject:point];
    
    point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake( 28.520638,  77.201959);
    [self.mapView addAnnotation:point];
    [_tempAnnotations addObject:point];
    
    [self.mapView showAnnotations:_tempAnnotations animated:NO];
    
    [distanceMatrixManager getResultWithOptions:distanceMatrixOptions completionHandler:^(MapplsDrivingDistanceMatrixResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error);
        } else if (response != nil  && response.results != nil) {
            NSArray<NSNumber *> *durations = response.results.durations.firstObject;
            NSArray<NSNumber *> *distances = response.results.distances.firstObject;
            
            NSUInteger pointCount = [distanceMatrixOptions points].count;
            for (int i = 0; i <= pointCount; i++) {
                if (i < durations.count && i < distances.count) {
                    NSLog(@"Driving Distance Matrix %d duration: %@, distance: %@", i, durations[i], distances[i]);
                }
                NSLog(@"Driving Distance %@,%@", durations[0],
                      distances[0]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.vwFooter setHidden:NO];
                    self.lblInfo.text = [NSString stringWithFormat: @"Driving Distance: %ld m, Duration: %ld sec", [distances[0] integerValue], [durations[0] integerValue]];
                });
                
                if (i == 0) {
                    break;
                }
            }
        } else {
            NSLog(@"No results");
        }
    }];
}

-(void)callRouteUsingDirectionsFramework:(BOOL) isETA {
    NSArray<MapplsWaypoint *> *waypoints = @[
                                         [[MapplsWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(28.551052, 77.268918) coordinateAccuracy:-1 name:@"Mappls"],
                                         [[MapplsWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(28.630195, 77.218119) coordinateAccuracy:-1 name:@""],
                                         ];
        
    MapplsRouteOptions *options = [[MapplsRouteOptions alloc] initWithWaypoints:waypoints resourceIdentifier: NULL profileIdentifier:NULL];
    options.includesSteps = YES;
    
    if (isETA) {
        options.resourceIdentifier = MapplsDirectionsResourceIdentifierRouteETA;
    }
    MapplsDirections *directionManager = [[MapplsDirections alloc] initWithRestKey:MapplsAccountManager.restAPIKey clientId:MapplsAccountManager.clientId clientSecret:MapplsAccountManager.clientSecret grantType:MapplsAccountManager.grantType host:nil scheme:nil path:nil];
    [directionManager calculateDirectionsWithOptions:options completionHandler:^(NSArray<MapplsWaypoint *> * _Nullable waypoints, NSArray<MapplsRoute *> * _Nullable routes, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error calculating directions: %@", error);
            return;
        }
        
        MapplsRoute *route = routes.firstObject;
        MapplsRouteLeg *leg = route.legs.firstObject;
        
        if (leg) {
            NSLog(@"Route via %@:", leg);
            
            if (route.coordinateCount) {
                // Convert the route’s coordinates into a polyline.
                CLLocationCoordinate2D *routeCoordinates = malloc(route.coordinateCount * sizeof(CLLocationCoordinate2D));
                [route getCoordinates:routeCoordinates];
                MGLPolyline *routeLine = [MGLPolyline polylineWithCoordinates:routeCoordinates count:route.coordinateCount];
                
                // Add the polyline to the map and fit the viewport to the polyline.
                [self.mapView addAnnotation:routeLine];
                [self.mapView setVisibleCoordinates:routeCoordinates count:route.coordinateCount edgePadding:UIEdgeInsetsMake(20, 20, 20, 20) animated:YES];
                
                // Make sure to free this array to avoid leaking memory.
                free(routeCoordinates);
                
                
                //self.routeAdvices = [NSMutableArray arrayWithArray:result.trips[0].advices];
                //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Advices" style:UIBarButtonItemStylePlain target:self action:@selector(showAdvices)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.vwFooter setHidden:NO];
                    self.lblInfo.text = [NSString stringWithFormat: @"Driving Distance: %d m, Duration: %d sec", (int)route.distance, (int)route.expectedTravelTime];
                });
            }
        }
    }];
}

-(void)zoomWithAnimation {
    MGLMapCamera *mapCamera = self.mapView.camera;
    mapCamera.altitude = 50000;
    
    [_mapView flyToCamera:mapCamera withDuration:3.0 completionHandler:^{
        
    }];
}

-(void)centerWithAnimation {
    MGLMapCamera *mapCamera = self.mapView.camera;
    mapCamera.centerCoordinate = CLLocationCoordinate2DMake(28.612733, 77.231129);
    
    [_mapView flyToCamera:mapCamera withDuration:5.0 completionHandler:^{
        
    }];
}

-(void)feedbackButtonHandler {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_mapView.centerCoordinate.latitude longitude:_mapView.centerCoordinate.longitude];
//    UINavigationController *navVC = [[MapplsFeedbackUIKitManager sharedManager] getViewControllerWithLocation:location moduleId:@""];
//    [self presentViewController:navVC animated:YES completion:nil];
}
    
-(void)showPlaceDetail {
    if (self.placeDetail) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ListVC *listVC = (ListVC *)[storyboard instantiateViewControllerWithIdentifier:@"ListVC"];
        listVC.placeDetail = self.placeDetail;
        [self.navigationController pushViewController:listVC animated:YES];
    }
}

//MARK: MGLMapViewDelegate Methods
#pragma mark - MGLMapViewDelegate methods

- (void)mapView:(MGLMapView *)mapView didFinishLoadingStyle:(MGLStyle *)style {
//    _mapView.userTrackingMode = MGLUserTrackingModeFollow;
    [self.searchBar setHidden:YES];
    self.constraintSearchBarHeight.constant = 0;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.550845, 77.268955)
                       zoomLevel:4
                        animated:NO];
    _mapView.showsUserLocation = NO;
    [self setData];
}
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation {
    // Always allow callouts to popup when annotations are tapped.
    return YES;
}

- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id<MGLAnnotation>)annotation {
    if (isForCustomAnnotationView) {
        MGLAnnotationView *annotationView = [[MGLAnnotationView alloc] init];
        annotationView.bounds = CGRectMake(0, 0, 20, 20);
        annotationView.backgroundColor = [UIColor blueColor];
        return annotationView;
    }
    return nil;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return [UIColor redColor];
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation {
    return [UIColor redColor];
}
- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *point = (CustomAnnotation *)annotation;
        MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:point.reuseIdentifier];
        
        if (annotationImage) {
            // The annotatation image has already been cached, just reuse it.
            return annotationImage;
        } else if (point.image && point.reuseIdentifier) {
            // Create a new annotation image.
            UIImage *newImage = [self imageRotatedByDegrees:point.image byDegree:0];
            return [MGLAnnotationImage annotationImageWithImage:newImage reuseIdentifier:point.reuseIdentifier];
        }
    }
    
    // Fallback to the default marker image.
    return nil;
}

- (UIView<MGLCalloutView> *)mapView:(__unused MGLMapView *)mapView calloutViewForAnnotation:(id<MGLAnnotation>)annotation
{
    // Instantiate and return our custom callout view.
    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomInfoWindowView *calloutView = [[CustomInfoWindowView alloc] init];
        calloutView.representedObject = annotation;
        return calloutView;
    }
    return nil;
}

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation
{
    return 10.0;
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation
{
    return 0.5;
}

//MARK: Gesture Method
-(void)didTapMap:(UITapGestureRecognizer*)sender {
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    SWITCH (_strType) {
        CASE (@"Reverse Geocoding") {
            MapplsReverseGeocodeManager * reverseGeocodeManager =
            [MapplsReverseGeocodeManager sharedManager];
            MapplsReverseGeocodeOptions *revOptions  =[[MapplsReverseGeocodeOptions alloc] initWithCoordinate:location
              withRegion:MapplsRegionTypeIndia];
            [reverseGeocodeManager reverseGeocodeWithOptions:revOptions
                                           completionHandler:^(NSArray<MapplsGeocodedPlacemark *> * _Nullable
                                                               placemarks, NSString * _Nullable attribution, NSError * _Nullable error) {
                                               if (error) {
                                                   NSLog(@"%@", error);
                                               } else if (placemarks.count > 0) {
                                                   NSLog(@"Reverse Geocode %@,%@", placemarks[0].latitude,placemarks[0].longitude);
                                                   
                                                   [self.mapView removeAnnotations:self.mapView.annotations];
                                                   
                                                   MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
                                                   point.coordinate = CLLocationCoordinate2DMake( [placemarks[0].latitude doubleValue],  [placemarks[0].longitude doubleValue]);
                                                   point.title =  placemarks[0].formattedAddress;
                                                   [self.mapView addAnnotation:point];
                                                   [self.mapView setCenterCoordinate:point.coordinate];
                                                   [self.vwFooter setHidden:NO];
                                                   //self.lblInfo.text = [NSString stringWithFormat: @"latitude: %f , longitude: %f" ,[placemarks[0].latitude doubleValue], [placemarks[0].longitude doubleValue]];
                                                   self.lblInfo.text = [NSString stringWithFormat:@"Address: %@", placemarks[0].formattedAddress];
                                               } else {
                                                   
                                               }
                                           }];
        }
        DEFAULT {
            break;
        }
    }
}


//MARK: Searchbar Method
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ( [searchText length] > 2  )
    {
    }
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if ( [searchBar.text length] > 2  )
    {
        [searchBar resignFirstResponder];
        [self updateListResults:searchBar.text isTextSearch:YES];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.tableViewAutoSuggest.hidden = YES;
}
- (void)updateListResults:(NSString *)searchQuery isTextSearch: (BOOL)isTextSearch {
    
    SWITCH (_strType) {
        CASE (@"Autosuggest") {
            MapplsAutoSuggestManager * autoSuggestManager = [MapplsAutoSuggestManager sharedManager];
            MapplsAutoSearchAtlasOptions * autoSuggestOptions =
            [[MapplsAutoSearchAtlasOptions alloc] initWithQuery:searchQuery
                                                         withRegion:MapplsRegionTypeIndia];
            autoSuggestOptions.location = referenceLocation;
            autoSuggestOptions.includeTokenizeAddress = YES;
            autoSuggestOptions.filter = [[MapplsMapplsPinFilter alloc] initWithMapplsPin:@"TAVI5S"];
            autoSuggestOptions.filter = [[MapplsBoundsFilter alloc] initWithBounds:[[MapplsRectangularRegion alloc] initWithTopLeft:CLLocationCoordinate2DMake(28.563838, 77.244345) bottomRight:CLLocationCoordinate2DMake(28.541898, 77.294514)]];
            [autoSuggestManager getAutoSuggestionResultsWithOptions:autoSuggestOptions completionHandler:^(MapplsLocationResults * _Nullable result, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"%@", error);
                } else if (result.suggestions.count > 0) {
                    NSLog(@"Auto Suggest %@%@", result.suggestions[0].latitude, result.suggestions[0].longitude);
                    [self.searchSuggestions removeAllObjects];
                    self.searchSuggestions = [NSMutableArray arrayWithArray:result.suggestions];
                    self.tableViewAutoSuggest.hidden = NO;
                    [self.tableViewAutoSuggest reloadData];
                    
                } else {
                    
                }
            }];
        }
        CASE (@"Place Detail") {
            [self callPlaceDetail: searchQuery];
        }
        CASE (@"Geocode") {
            [self callGeocode: searchQuery];
        }
        DEFAULT {
            break;
        }
    }
}
//MARK: Tableview  Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchSuggestions count];    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier] ;
    }
    MapplsAtlasSuggestion *tempObj = (MapplsAtlasSuggestion *)self.searchSuggestions[indexPath.row];
    cell.textLabel.text = tempObj.placeName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    [self.tableViewAutoSuggest setHidden: YES];
    MapplsAtlasSuggestion *tempObj = (MapplsAtlasSuggestion *)self.searchSuggestions[indexPath.row];
  
    MGLPointAnnotation *point = [[MGLPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([tempObj.latitude doubleValue], [tempObj.longitude doubleValue]);
    point.title = @"Annotation";
    [self.mapView addAnnotation:point];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([tempObj.latitude doubleValue], [tempObj.longitude doubleValue])
                       zoomLevel:11
                        animated:NO];
}

+ (MGLPolyline *)polylineWithEncodedString:(NSString *)encodedString {
    const char *bytes = [encodedString UTF8String];
    NSUInteger length = [encodedString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    NSUInteger idx = 0;
    
    NSUInteger count = length / 4;
    CLLocationCoordinate2D *coords = calloc(count, sizeof(CLLocationCoordinate2D));
    NSUInteger coordIdx = 0;
    
    float latitude = 0;
    float longitude = 0;
    while (idx < length) {
        char byte = 0;
        int res = 0;
        char shift = 0;
        
        do {
            byte = bytes[idx++] - 63;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLat = ((res & 1) ? ~(res >> 1) : (res >> 1));
        latitude += deltaLat;
        
        shift = 0;
        res = 0;
        
        do {
            byte = bytes[idx++] - 0x3F;
            res |= (byte & 0x1F) << shift;
            shift += 5;
        } while (byte >= 0x20);
        
        float deltaLon = ((res & 1) ? ~(res >> 1) : (res >> 1));
        longitude += deltaLon;
        
        float finalLat = latitude * 1E-6;
        float finalLon = longitude * 1E-6;
        
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(finalLat, finalLon);
        coords[coordIdx++] = coord;
        
        if (coordIdx == count) {
            NSUInteger newCount = count + 10;
            coords = realloc(coords, newCount * sizeof(CLLocationCoordinate2D));
            count = newCount;
        }
    }
    
    MGLPolyline *polyline = [MGLPolyline polylineWithCoordinates:coords
                                                           count:coordIdx];
    free(coords);
    return polyline;
}

/*
-(UIImage *) imageRotatedByDegrees:(UIImage *)oldImage deg:(CGFloat)degrees {
    CGSize size = oldImage.size;
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, size.width/2, size.height/2);
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    // Now, draw the rotated/scaled image into the context
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-size.width/2, -size.width/2, size.width, size.height), oldImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}*/

- (UIImage *)imageRotatedByDegrees:(UIImage*)image byDegree:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

@end
