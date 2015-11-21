//
//  HSAboutViewController.m
//  HomeStudio
//
//  Created by Sachin Bhardwaj on 02/11/15.
//  Copyright © 2015 Sachin Bhardwaj. All rights reserved.
//

#import "HSAboutViewController.h"
#import "HSSearchbarView.h"
#import "Constants.h"

@interface HSAboutViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) HSSearchbarView *searchView;
@property (nonatomic, strong) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) IBOutlet UIButton *btnCart;
@end

@implementation HSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Add code to load web content in UIWebView
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"about.html" ofType:nil]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark  - Outlet Actions

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchAction:(UIButton*)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.btnSearch setBackgroundColor:[UIColor blackColor]];
        self.searchView = [[HSSearchbarView alloc] initWithFrame:CGRectMake(0, 62, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
        [self.view addSubview:self.searchView];
    }
    else
    {
        [self.btnSearch setBackgroundColor:[UIColor clearColor]];
        [self.searchView removeFromSuperview];
    }
}

- (IBAction)cartAction:(id)sender {
    
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

@end
