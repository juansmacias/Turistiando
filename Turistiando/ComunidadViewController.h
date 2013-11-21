//
//  ComunidadViewController.h
//  Turistiando
//
//  Created by Macias on 15/09/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

# import <MapKit/MapKit.h>
# import "Experiencia.h"

@interface ComunidadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,CLLocationManagerDelegate,NSXMLParserDelegate>
@property (strong,nonatomic) NSMutableString *contentsOfElement;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *buttonBarMenu;
@property (strong, nonatomic) IBOutlet MKMapView *mapaE;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITableView *tablaExperiencias;
@property (strong, nonatomic) IBOutlet UIButton *buscarAmigos;
@property (strong,nonatomic) Experiencia *expN;
@property (strong,nonatomic) NSMutableArray *experenciasT;
@property (nonatomic) BOOL yaN;

@end
