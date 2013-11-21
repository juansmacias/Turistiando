//
//  CrearRecordatorioViewController_iPad.h
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EKEventStore.h>

@interface CrearRecordatorioViewController_iPad : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txtNOmbre;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong,nonatomic)  EKEventStore * eventStore;

@end
