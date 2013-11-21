//
//  CrearRecordatorioViewController_iPad.m
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import "CrearRecordatorioViewController_iPad.h"
#import <EventKit/EKReminder.h>
#import <EventKit/EKAlarm.h>

@interface CrearRecordatorioViewController_iPad ()

@end

@implementation CrearRecordatorioViewController_iPad

/*!
 Se sintetizan todos los atributos que se encinetran en la onterfaz de la clase
 !*/

@synthesize eventStore = _eventStore;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_eventStore==nil) {
        _eventStore = [[EKEventStore alloc]init];
        [_eventStore requestAccessToEntityType:EKEntityTypeReminder
                                    completion:^(BOOL granted, NSError *error) {
                                        if (!granted)
                                            NSLog(@"Access to store not granted");
                                    }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cerrarteclado:(UITextField *)sender {
    
    [self.txtNOmbre becomeFirstResponder];
    [self.txtNOmbre resignFirstResponder];
}

/*!
 ______________________________________________________________________________________________
 Metodos de Auxiliares.
 !*/

- (IBAction)crear:(id)sender {
    
    EKReminder *recordatorio = [EKReminder reminderWithEventStore:self.eventStore];
    
    recordatorio.title = [NSString stringWithFormat:@"No olvidar: %@", self.txtNOmbre.text];
    
    recordatorio.calendar = [_eventStore defaultCalendarForNewReminders];
    
    NSDate *date = [_datePicker date];
    
    EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
    
    [recordatorio addAlarm:alarm];
    
    
    NSError *error = nil;
    
    [_eventStore saveReminder:recordatorio commit:YES error:&error];
    
    if (error) {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Hubo un error creando el recordatorio" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    else
    {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"Exito" message:@"Se agrego corectamente el recordatorio" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
    }
    self.txtNOmbre.text =@"";
}

@end
