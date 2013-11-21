//
//  VerElementoViewController_iPad.h
//  Turistiando
//
//  Created by Juan Sebastian Macias Quintero on 20/11/13.
//  Copyright (c) 2013 Turistiando Colombia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerElementoViewController_iPad : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tablaExperiencias;
@property (strong, nonatomic) IBOutlet UITextField *txtDescripcion;
@property (strong,nonatomic) UIImageView *fotoprevia;

@end
