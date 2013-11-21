//
//  ComunidadViewController_iPad.h
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ComunidadViewController_iPad : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate>


@property (strong, nonatomic) NSMutableArray * menu;
@property (strong, nonatomic) IBOutlet MKMapView *mapaE;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITableView *tablaExperiencias;
@property (strong, nonatomic) IBOutlet UITableView *tablaMenu;
@property (strong, nonatomic) IBOutlet UIButton *buscarAmigos;

@end
