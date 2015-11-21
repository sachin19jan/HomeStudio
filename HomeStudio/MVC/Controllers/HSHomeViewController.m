//
//  HSHomeViewController.m
//  HomeStudio
//
//  Created by Sachin Bhardwaj on 25/10/15.
//  Copyright (c) 2015 Sachin Bhardwaj. All rights reserved.
//

#import "HSHomeViewController.h"
#import "Cell.h"
#import "HSSearchbarView.h"
#import "HSProductCategoryViewController.h"
#import "Constants.h"
#import "Utils.h"
@interface HSHomeViewController ()
{
    NSInteger _currentImageIndex;
}
@property (nonatomic, strong) IBOutlet UIImageView *frontView;
@property (nonatomic, strong) IBOutlet UIButton *btnSearch;
@property (nonatomic, strong) IBOutlet UIButton *btnCart;
@property (nonatomic, strong) HSSearchbarView *searchView;
@property (nonatomic, strong) NSArray *sellerImageArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tblHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
- (IBAction)searchAction:(id)sender;
- (IBAction)cartAction:(id)sender;

@end
#define kROW_HEIGHT  44
#define kHEADER_HEIGHT  32
#define kCell_HEIGHT  50
@implementation HSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.categoryArray = [[NSMutableArray alloc]initWithObjects:@"KITCHEN",@"DINING",@"BEDROOM",@"KIDS",@"STUDY",@"STORAGE", nil];
  
    self.sellerImageArray = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"image1.jpg"],[UIImage imageNamed:@"image2.jpg"],[UIImage imageNamed:@"image3.jpg"],[UIImage imageNamed:@"image4.jpg"], nil];
//    NSArray *animationArray=[NSArray arrayWithObjects:
//                             [UIImage imageNamed:@"image1.jpg"],
//                             [UIImage imageNamed:@"image2.jpg"],
//                             [UIImage imageNamed:@"image3.jpg"],
//                             [UIImage imageNamed:@"image4.jpg"],
//                             nil];
//    self.frontView.animationImages=animationArray;
//    self.frontView.animationDuration=10.0;
//    self.frontView.animationRepeatCount=600;
//    [self.frontView startAnimating];
    
    
    self.frontView.image = [self.sellerImageArray objectAtIndex:0];
    
//    [self.view addSubview:self.frontView];
    
    _currentImageIndex = 0;
    
    self.frontView.userInteractionEnabled = YES;
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.frontView addGestureRecognizer:swipeLeftGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.frontView addGestureRecognizer:swipeRightGesture];
    
     _tblHeightConstraint.constant = (self.categoryArray.count*kROW_HEIGHT);
    _collectionViewHeightConstraint.constant = (self.sellerImageArray.count*kCell_HEIGHT);
}

#pragma mark - Custom Method Actions

- (void)changeImage:(UISwipeGestureRecognizer *)swipe{
    
    NSArray *images =[NSArray arrayWithArray:self.sellerImageArray];
    NSInteger nextImageInteger = _currentImageIndex;
    
    
    if(swipe.direction == UISwipeGestureRecognizerDirectionLeft)
        nextImageInteger++;
    else
        nextImageInteger--;
    
    
    if(nextImageInteger < 0)
        nextImageInteger = images.count -1;
    else if(nextImageInteger > images.count - 1)
        nextImageInteger = 0;
    
    _currentImageIndex = nextImageInteger;
    
    UIImage *target = [images objectAtIndex:_currentImageIndex];
    
    CABasicAnimation *crossFade = [CABasicAnimation animationWithKeyPath:@"contents"];
    crossFade.duration      = 0.5;
    crossFade.fromValue     = self.frontView.image;
    crossFade.toValue       = target;
    [self.frontView.layer addAnimation:crossFade forKey:@"animateContents"];
    self.frontView.image = target;
}

-(void)moveToProductCategory
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    HSProductCategoryViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"HSProductCategoryViewController"];
    vc.isBackEnable = YES;
    [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];

}

#pragma mark  - Outlet Actions

-(IBAction)toggle:(id)sender
{
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self moveToProductCategory];
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

#pragma mark
#pragma mark Collection view layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGSize cellSize = CGSizeZero;
    if([Utils isIPAD])
    {
        cellSize = CGSizeMake(219, 190);
    }
    else
    {
        cellSize = CGSizeMake(138, 117);
    }
    return cellSize;
}


#pragma mark  - UICollectionView Delegate Methods -

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.sellerImageArray count];
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

    // load the image for this cell
    cell.image.image = [self.sellerImageArray objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
}

@end
