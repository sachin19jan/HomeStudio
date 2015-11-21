//
//  HSProductCategoryViewController.m
//  HomeStudio
//
//  Created by Sachin Bhardwaj on 31/10/15.
//  Copyright © 2015 Sachin Bhardwaj. All rights reserved.
//

#import "HSProductCategoryViewController.h"
#import "Cell.h"
#import "SlideNavigationController.h"
#import "HSSearchbarView.h"
#import "Constants.h"
@interface HSProductCategoryViewController ()
@property (nonatomic, strong) HSSearchbarView *searchView;
@property (nonatomic, strong) NSArray *animationImageArray;
@property (nonatomic, strong) IBOutlet UIImageView *frontView;
@property (nonatomic, strong) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) IBOutlet UIButton *btnCart;
@property (nonatomic, strong) IBOutlet UIButton *btnMenu;
- (IBAction)searchAction:(id)sender;
- (IBAction)cartAction:(id)sender;
@end

@implementation HSProductCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.isBackEnable)
    {
        [self.btnMenu setImage:[UIImage imageNamed:@"arrow-right.png"] forState:UIControlStateNormal];
    }
    
    
    self.animationImageArray = [[NSArray alloc]initWithObjects:@"image1.jpg",@"image1.jpg",@"image2.jpg",@"image2.jpg",@"image3.jpg",@"image3.jpg",@"image4.jpg",@"image4.jpg", nil];
    NSArray *animationArray=[NSArray arrayWithObjects:
                             [UIImage imageNamed:@"image1.jpg"],
                             [UIImage imageNamed:@"image2.jpg"],
                             [UIImage imageNamed:@"image3.jpg"],
                             [UIImage imageNamed:@"image4.jpg"],
                             nil];
    self.frontView.animationImages=animationArray;
    self.frontView.animationDuration=5.0;
    self.frontView.animationRepeatCount=600;
    [self.frontView startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark  - UICollectionView Delegate Methods -

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.animationImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    cell.labelTile.text = @"COLOUR ART TV UNIT";
    cell.labelDetail.text = @"(SANREMO LIGHT & WHITE)";
    cell.labelPrice.text = @"$ 115,680.00";
    
    // load the image for this cell
    NSString *imageToLoad = [self.animationImageArray objectAtIndex:indexPath.row];
    // load the image for this cell
    cell.image.image = [UIImage imageNamed:imageToLoad];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self moveToProductSubCategory];
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

-(IBAction)toggle:(id)sender
{
    if (self.isBackEnable) //  back Action
      [self.navigationController popViewControllerAnimated:YES];
    else  //  menu Action
      [[SlideNavigationController sharedInstance] toggleLeftMenu];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
