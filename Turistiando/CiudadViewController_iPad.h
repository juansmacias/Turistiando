//
//  CiudadViewController_iPad.h
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CiudadViewController_iPad : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * menu;

@property (strong, nonatomic) IBOutlet UITableView *tablaMenu;

@end
