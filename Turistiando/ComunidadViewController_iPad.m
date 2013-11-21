//
//  ComunidadViewController_iPad.m
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "ComunidadViewController_iPad.h"
#import "Turistiando.h"
#import "CiudadCell.h"

@interface ComunidadViewController_iPad ()

@end

@implementation ComunidadViewController_iPad

@synthesize menu = _menu;
@synthesize mapaE =_mapaE;
@synthesize locationManager = _locationManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menu = [NSMutableArray arrayWithArray:@[@"titulo",@"perfil", @"ciudades",@"ciudad",@"agregarCiudad", @"comunidad"]];
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
    
    self.tablaMenu.dataSource = self;
    self.tablaMenu.delegate = self;
    
    self.tablaExperiencias.delegate = self;
    self.tablaExperiencias.dataSource = self;
	// Do any additional setup after loading the view.
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
    NSInteger valor;
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"titulo"];
    if (cell==nil) {
        valor = 1;
    }
    else
    {
        Turistiando * tour = [Turistiando darInstancia];
        int intM =[self.menu count]-1;
         valor = intM+[tour.lugares count];
    }
    return valor;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"titulo"];
    if (cell!=nil) {
        NSString *cellI = [self.menu objectAtIndex:0];
        if ([cellI isEqualToString:@"ciudad"]) {
            CiudadCell *cell1;
            Turistiando * tour = [Turistiando darInstancia];
            NSUInteger da = [[tour lugares] count];
            NSUInteger da1 = da-indexPath.row;
            if (da==0) {
                cell1=(CiudadCell*)[tableView dequeueReusableCellWithIdentifier:cellI forIndexPath:indexPath];
                cell1.lblNOmbre.text = @"Agrega una ciudad";
                cell1.highlighted = NO;
                [self.menu removeObject:cellI];
            }
            else
            {
                if (da1==-2) {
                    cell1=(CiudadCell*)[tableView dequeueReusableCellWithIdentifier:cellI forIndexPath:indexPath];
                    int rowM = indexPath.row -3;
                    cell1.lblNOmbre.text= [[[tour lugares] objectAtIndex:rowM] nombreL];
                    [self.menu removeObject:cellI];
                    
                }
                else
                {
                    cell1 =(CiudadCell*)[tableView dequeueReusableCellWithIdentifier:cellI forIndexPath:indexPath];
                    int rowM = indexPath.row -3;
                    NSString* holi = [[[tour lugares] objectAtIndex:rowM] nombreL];
                    cell1.lblNOmbre.text = holi;
                }
                
                
            }
            return cell1;
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellI forIndexPath:indexPath];
            cell.detailTextLabel.text= cellI;
            [self.menu removeObject:cellI];
            
        }

        
    }

    return cell;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.menu = [NSMutableArray arrayWithArray:@[@"titulo",@"perfil", @"ciudades",@"ciudad",@"agregarCiudad", @"comunidad"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
