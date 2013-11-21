//
//  PerfilViewController_iPad.m
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "PerfilViewController_iPad.h"
#import "Turistiando.h"
#import "CiudadCell.h"

@interface PerfilViewController_iPad ()

@end

@implementation PerfilViewController_iPad

@synthesize menu = _menu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Turistiando *tour = [Turistiando darInstancia];
    self.nombre.text = tour.nombre;
    self.nacio.text = tour.nacio;
    
    self.menu = [NSMutableArray arrayWithArray:@[@"titulo",@"perfil", @"ciudades",@"ciudad",@"agregarCiudad", @"comunidad"]];
    self.tabla.dataSource = self;
    self.tabla.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.menu = [NSMutableArray arrayWithArray:@[@"titulo",@"perfil", @"ciudades",@"ciudad",@"agregarCiudad", @"comunidad"]];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Turistiando * tour = [Turistiando darInstancia];
    int intM =[self.menu count]-1;
    int intT = intM+[tour.lugares count];
    return intT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
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
    
    
    return cell;
}


@end
