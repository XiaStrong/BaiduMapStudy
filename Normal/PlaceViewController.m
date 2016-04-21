//
//  PlaceViewController.m
//  Normal
//
//  Created by Xia_Q on 16/4/20.
//  Copyright © 2016年 X. All rights reserved.
//

#import "PlaceViewController.h"

@interface PlaceViewController ()

@end

@implementation PlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sureClick:(id)sender {
    
    NSString *from= _fromTf.text;
    NSString *to=_toTf.text;
    if (from.length>0&&to.length>0) {
        _placeDic =[[NSMutableDictionary alloc]init];
        [_placeDic setValue:from forKey:@"from"];
        [_placeDic setValue:to forKey:@"to"];
    
        if(self.getDic)
        {
            self.getDic(_placeDic);
        }

        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"数据不完整" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
    
    
}
@end
