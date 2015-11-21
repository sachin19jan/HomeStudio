//
//  HSProductDetailsViewController.m
//  HomeStudio
//
//  Created by Sachin Bhardwaj on 01/11/15.
//  Copyright © 2015 Sachin Bhardwaj. All rights reserved.
//

#import "HSProductDetailsViewController.h"
#import "Cell.h"
#import "SlideNavigationController.h"
#import "HSSearchbarView.h"
#import "Constants.h"
#import "PageContentViewController.h"

#define kROW_HEIGHT  44
@interface HSProductDetailsViewController ()
@property (nonatomic, strong) HSSearchbarView *searchView;
@property (nonatomic, strong) NSArray *animationImageArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) IBOutlet UIButton *btnCart;
@property (nonatomic,strong) UIPageViewController *PageViewController;
@property (nonatomic,strong) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblHeightConstraint;
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index;
- (IBAction)searchAction:(id)sender;
- (IBAction)cartAction:(id)sender;
@end

@implementation HSProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    self.animationImageArray = [[NSArray alloc]initWithObjects:@"image1.jpg",@"image2.jpg",@"image3.jpg",@"image4.jpg", nil];
    
    self.categoryArray = [[NSMutableArray alloc]initWithObjects:@"Reviews",@"Warranty", nil];

    // Create page view controller
    self.PageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.PageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.PageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    int x = self.mainView.frame.origin.x;
    int y = self.mainView.frame.origin.y;
    int width = self.mainView.frame.size.width;
    int height = self.mainView.frame.size.height;
    self.PageViewController.view.frame = CGRectMake(x, y-64, width, height);
    
    [self addChildViewController:self.PageViewController];
    [self.mainView addSubview:self.PageViewController.view];
    [self.PageViewController didMoveToParentViewController:self];
    _tblHeightConstraint.constant = (self.categoryArray.count*kROW_HEIGHT);
}

#pragma mark  - UITableView Delegate Methods -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex {
    
    return [self.categoryArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
        
        cell.textLabel.text = [self.categoryArray objectAtIndex:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    //
    //    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
        [cell setPreservesSuperviewLayoutMargins:NO];
    
    
    //    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
        [cell setLayoutMargins:UIEdgeInsetsZero];
}



#pragma mark - Page View Datasource Methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound))
    {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound)
    {
        return nil;
    }
    
    index++;
    if (index == [self.animationImageArray count])
    {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - Other Methods
- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.animationImageArray count] == 0) || (index >= [self.animationImageArray count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imgFile = self.animationImageArray[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

#pragma mark - No of Pages Methods
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.animationImageArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


#pragma mark - Custom Method Actions

-(void)moveToProductSubCategory
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProductSubcategoryViewController"];
    
    [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];
    
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
