//
//  Turistiando.m
//  Turistiando
//
//  Created by Lina Maria Duarte Salinas on 14/09/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "Turistiando.h"
#import "Lugar.h"

@implementation Turistiando

@synthesize lugares= _lugares;
@synthesize nombre = _nombre;
@synthesize nacio = _nacio;
@synthesize experiencias = _experiencias;

static Turistiando * instancia = nil;

+(Turistiando *)darInstancia
{
    if (instancia == nil) {
        instancia = [[Turistiando alloc] init];
        [instancia inicializar];
    }
    return instancia;
}

-(void)inicializar
{
    lugares = [[NSMutableArray alloc] init];
//    //Prepare to establish the connection
//    NSURL *url = [NSURL URLWithString:@"http://157.253.238.144:8090/tur/webresources/webservice.usuario/find1"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    
//    [request setHTTPMethod:@"GET"];
//    [request setValue:@"1" forHTTPHeaderField:@"id"];
//    
//    NSLog(@"Url de envio %@",request.URL.fragment);
//    NSHTTPURLResponse *response = nil;
//    NSError *error = nil;
//    //Make the request
//    NSData* responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    if(error ==nil)
//    {
//        //Parse the data as a series of Note objects
//        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
//    }
}

-(NSMutableArray *)lugares
{
    if(lugares==nil) lugares = [[NSMutableArray alloc]init];
    return lugares;
}

-(void) setLugares:(NSMutableArray *)lugaresP
{
    self.lugares =lugaresP;
}

-(NSString*) nombre
{
    if (nombre==nil||[nombre isEqualToString:@""]) {
        nombre = @"Turista";
    }
    return nombre;
}


-(void) setNombre:(NSString *)nombreP
{
    self.nombre = nombreP;
}

-(NSString*) nacio
{
    if (nacio==nil||[nacio isEqualToString:@""]) {
        nacio = @"Mundial";
    }
    return nacio;
}

-(void) setNacio:(NSString *)nacioP
{
    self.nacio = nacioP;
}

-(void) agregarLugar: (Lugar *) lugar
{
    [self.lugares addObject:lugar];
}

-(void) agregarActividadADiccionarioLugar: (Actividad*) actividadA aLugar: (NSString*) lugarA
{
    for(Lugar* lug in self.lugares)
    {
        if ([lug.nombreL isEqualToString:lugarA] ) {
            [lug agregarActividadAdiccionario:actividadA];
        }
    }
}

-(NSArray*) actividadesEnLugar:(NSString*) nlugar
{
    BOOL ya =NO;
    NSMutableArray* result;
    for( int i=0; i<[self.lugares count]||ya==YES;i++)
    {
        Lugar*lug = [self.lugares objectAtIndex:i];
        if ([lug.nombreL isEqualToString:nlugar]) {
            NSArray *resultA =lug.actividades;
            result = [NSMutableArray arrayWithCapacity:[resultA count]];
            for (Actividad* act in resultA) {
                [result addObject:act.nombre];
            }
        }
    }
    return result;
}

-(NSArray*) experienciasCercanasLugar: (NSString*) lugarA aRango: (int) rango
{
    NSMutableArray* result;
    for( int i=0; i<[self.lugares count];i++)
    {
        Lugar*lug = [self.lugares objectAtIndex:i];
        if ([lug.nombreL isEqualToString:lugarA]) {
            NSArray *resultA =lug.actividades;
            result = [NSMutableArray arrayWithCapacity:[resultA count]];
            for (Actividad* act in resultA) {
                [result addObject:act.nombre];
            }
        }
    }
    return result;
}

@end
