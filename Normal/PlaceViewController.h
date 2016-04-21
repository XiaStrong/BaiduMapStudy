//
//  PlaceViewController.h
//  Normal
//
//  Created by Xia_Q on 16/4/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fromTf;
@property (weak, nonatomic) IBOutlet UITextField *toTf;
- (IBAction)sureClick:(id)sender;


@property (nonatomic ,copy) void (^getDic)(NSDictionary *dic);

@property(nonatomic,strong)NSDictionary *placeDic;

@end
