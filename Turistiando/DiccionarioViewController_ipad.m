//
//  DiccionarioViewController_ipad.m
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "DiccionarioViewController_ipad.h"
#import "VerElementoViewController_iPad.h"
#import "Turistiando.h"

@interface DiccionarioViewController_ipad ()

@end

@implementation DiccionarioViewController_ipad

@synthesize ciudad=_ciudad;
@synthesize elementos = _elementos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    Turistiando * tour = [Turistiando darInstancia];
    NSArray* holii = [tour actividadesEnLugar:_ciudad];
    [self setElementos:holii];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)ciudad
{
    return _ciudad;
}

-(void) setCiudad:(NSString *)ciudad
{
    _ciudad = ciudad;
}

-(NSArray*)elementos
{
    return _elementos;
}

-(void)setElementos:(NSArray *)elementos
{
    _elementos=elementos;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return ([_elementos count]+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"info" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"elementoD" forIndexPath:indexPath];
        cell.textLabel.text = [_elementos objectAtIndex:(indexPath.row-1)];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
    if ([[segue identifier] isEqualToString:@"verElemento"]) {
        VerElementoViewController_iPad * verEl=[segue destinationViewController];
        verEl.title = cell.textLabel.text;
    }
}


@end
