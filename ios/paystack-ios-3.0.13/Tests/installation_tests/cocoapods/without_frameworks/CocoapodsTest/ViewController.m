//
//  ViewController.m
//  CocoapodsTest
//

#import "ViewController.h"
#import <Paystack/Paystack.h>
#import <Paystack/UIImage+Paystack.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Paystack setDefaultPublishableKey:@"test"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
