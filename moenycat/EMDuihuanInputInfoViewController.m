//
//  EMDuihuanInputInfoViewController.m
//  moenycat
//
//  Created by haicuan139 on 14-11-12.
//  Copyright (c) 2014年 haicuan139. All rights reserved.
//

#import "EMDuihuanInputInfoViewController.h"

@interface EMDuihuanInputInfoViewController ()

@end

@implementation EMDuihuanInputInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"兑换申请"];
    //加载上次的地址
    self.ud = [NSUserDefaults standardUserDefaults];
    NSString *addr  =   [_ud stringForKey:CONFIG_KEY_DUIHUAN_ADDR];
    NSString *name  =   [_ud stringForKey:CONFIG_KEY_DUIHUAN_NAME];
    NSString *phone =   [_ud stringForKey:CONFIG_KEY_DUIHUAN_PHONE];
    NSString *duihuanQQ = [_ud stringForKey:CONFIG_KEY_DUIHUAN_QQ];
    [_duihuanName setText:name];
    [_duihuanQQ setText:duihuanQQ];
    [_duihuanPhone setText:phone];
    [_duihanAddress setText:addr];
    [_duihuanCommit setBackgroundColor:[UIColor colorWithHexString:@"#ad1524"]];
    [_duihuanCommit.layer setMasksToBounds:YES];
    [_duihuanCommit.layer setCornerRadius:4.0];
    [_duihuanName becomeFirstResponder];
    _duihuanCountControllerButton.minimumValue = 1;
    EMAppDelegate *app = (EMAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *dic = app.duihuanDic;
        NSInteger maxValue = [[dic objectForKey:@"p_max_dh_num"] integerValue];

    _duihuanCountControllerButton.tag = [[dic objectForKey:@"pprice"] integerValue] ;
    _duihuanCountControllerButton.maximumValue = maxValue;
    _duihuanCountControllerButton.value = 1;
    [_duihuanCountControllerButton addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    _delegateClass = [[EMDelegateClass alloc]init];
    _delegateClass.rootView = self.view;
    _delegateClass.delegate = self;
}
- (void)valueChanged:(UIStepper *)Stepper{
    NSInteger balance = [_ud integerForKey:CONFIG_KEY_LOCAL_BALANCE];
    NSInteger price = Stepper.tag;
    NSLog(@"点击了!%f",Stepper.value);
    if ((Stepper.value * price) < balance) {
        NSString *value = [[NSString alloc]initWithFormat:@"%d",(int)Stepper.value];
        [_duihuanCount setText:value];
    } else {
        if (Stepper.value > 1) {
            
            _duihuanCountControllerButton.maximumValue = Stepper.value - 1;
        }
    }
}
-(void)initBaseLeftItem{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [_duihuanName release];
    [_duihuanPhone release];
    [_ud release];
    [_duihanAddress release];
    [_duihuanCount release];
    [_duihuanCountControllerButton release];
    [_duihuanCommit release];
    [_duihuanQQ release];
    [super dealloc];
}
- (IBAction)postDuihuan:(id)sender {
    [_duihanAddress resignFirstResponder];
    [_duihuanName resignFirstResponder];
    [_duihuanPhone resignFirstResponder];
    NSString *addr = _duihanAddress.text;
    NSString *phone = _duihuanPhone.text;
    NSString *name = _duihuanName.text;
    NSString *qq = _duihuanQQ.text;
    if (name.length == 0 || phone.length == 0 || name.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"信息不完整" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showAlertViewWithCompleteBlock:^(NSInteger buttonIndex) {
            if (buttonIndex == 1) {

                
            }
        }];
        return;
    }
    [_ud setObject:addr forKey:CONFIG_KEY_DUIHUAN_ADDR];
    [_ud setObject:phone forKey:CONFIG_KEY_DUIHUAN_PHONE];
    [_ud setObject:name forKey:CONFIG_KEY_DUIHUAN_NAME];
    [_ud setObject:_duihuanCount.text forKey:CONFIG_KEY_DUIHUAN_COUNT];
    [_ud setObject:qq forKey:CONFIG_KEY_DUIHUAN_QQ];
    //申请兑换
    [_delegateClass EMDelegatePostDuiHuanInfo];
}
@end
