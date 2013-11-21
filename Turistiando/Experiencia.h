//
//  Experiencia.h
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 29/10/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Experiencia : NSObject{
@private

/*!
 Nombre de la experiecia
 */
NSString *nombre;

/*!
 nombre usuario
 */
NSString *nombreUsu;

/*!
 Representa la latitud de la actividad
 */
double latitud;

/*!
 Representa la longitud del lugar
 */
double longitud;
}

@property (strong,nonatomic) NSString *nombreUsu;
@property (strong,nonatomic) NSString *nombre;
@property (nonatomic) double latitud;
@property (nonatomic) double longitud;


@end
