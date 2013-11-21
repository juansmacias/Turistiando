//
//  ComunidadViewController.m
//  Turistiando
//
//  Created by Macias on 15/09/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "ComunidadViewController.h"
#import "SWRevealViewController.h"
#import "Turistiando.h"

@interface ComunidadViewController ()

@end

@implementation ComunidadViewController

@synthesize mapaE =_mapaE;
@synthesize locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.buttonBarMenu.target = self.revealViewController;
    self.buttonBarMenu.action = @selector(revealToggle:);
    self.locationManager = [[CLLocationManager alloc] init];

    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    self.mapaE.delegate = self;
    MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];
    point2.coordinate =CLLocationCoordinate2DMake(4.598889, -74.080833);
    point2.title = @"Bogota";
    
    [self.mapaE addAnnotation:point2];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate =CLLocationCoordinate2DMake(6.244747, -75.574828);
    point.title = @"Medellin";
    
    [self.mapaE addAnnotation:point];
    
    MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
    point3.coordinate =CLLocationCoordinate2DMake(10.423611, -75.525278);
    point3.title = @"Cartagena";
    
    [self.mapaE addAnnotation:point3];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //Turistiando* tur = [Turistiando darInstancia];
//	if (tur.) {
//        <#statements#>
//    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 1800, 1800);
    [self.mapaE setRegion:[self.mapaE regionThatFits:region] animated:YES];
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Aca estoy";
    
    [self.mapaE addAnnotation:point];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
