//
//  Experiencia.m
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 29/10/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "Experiencia.h"

@implementation Experiencia

@synthesize nombre = _nombre;
@synthesize nombreUsu = _nombreUsu;
@synthesize latitud;
@synthesize longitud;

-(id)init
{
    self=[super init];
    if (self) {
        latitud=101;
        longitud = 101;
    }

    return self;
}


@end
