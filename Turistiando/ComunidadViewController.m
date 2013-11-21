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
@synthesize expN = _expN;
@synthesize experenciasT =_experenciasT;
@synthesize contentsOfElement = _contentsOfElement;
@synthesize yaN=_yaN;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.experenciasT = [NSMutableArray arrayWithCapacity:30];
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
    point2.subtitle =@"";
    
    [self.mapaE addAnnotation:point2];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate =CLLocationCoordinate2DMake(6.244747, -75.574828);
    point.title = @"Medellin";
    point.subtitle =@"";
    
    [self.mapaE addAnnotation:point];
    
    MKPointAnnotation *point3 = [[MKPointAnnotation alloc] init];
    point3.coordinate =CLLocationCoordinate2DMake(10.423611, -75.525278);
    point3.title = @"Cartagena";
    point3.subtitle =@"";
    
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


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [ self clearContentsOfElement];
    if ([elementName isEqualToString:@"experiencia"] ) {
        self.expN = [[Experiencia alloc]init];
    }
    else if ([elementName isEqualToString:@"lugarfk"]) {
        self.yaN=NO;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"experiencia"] ) {
        [self.experenciasT addObject:self.expN];
        self.expN = nil;
    }
    else if (self.expN.latitud==101&&[elementName isEqualToString:@"latitud"]) {
        self.expN.latitud = [self.contentsOfElement doubleValue];
    }
    else if (self.expN.longitud==101&&[elementName isEqualToString:@"longitud"]) {
        self.expN.longitud = [self.contentsOfElement doubleValue];
    }
    else if (self.yaN==YES&&[elementName isEqualToString:@"nombre"]) {
        self.expN.nombre = self.contentsOfElement;
        self.yaN = NO;
    }
    else if (self.yaN==NO&&[elementName isEqualToString:@"nombre"])
    {
        self.expN.nombreUsu = self.contentsOfElement;
    }
    else if ([elementName isEqualToString:@"lugarfk"]) {
        self.yaN=YES;
    }
    
    
    [self clearContentsOfElement];

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	[self.contentsOfElement appendString:string];
}

- (void) clearContentsOfElement {
	self.contentsOfElement = [[NSMutableString alloc] init];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[self.mapaE dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    if (!pinView)
    {
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                               reuseIdentifier:SFAnnotationIdentifier];
        if (![annotation.subtitle isEqualToString:@""]) {
            annotationView.pinColor=MKPinAnnotationColorGreen;

        }
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
        pinView.canShowCallout = YES;
        pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    return pinView;
}

@end
