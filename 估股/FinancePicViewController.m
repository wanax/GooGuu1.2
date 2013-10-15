//
//  DemoCollectionViewController.m
//  googuu
//
//  Created by Xcode on 13-10-12.
//  Copyright (c) 2013年 Xcode. All rights reserved.
//

#import "FinancePicViewController.h"
#import "FinanPicCollectCell.h"
#import "UIImageView+WebCache.h"
#import "DemoPhoto.h"

@interface FinancePicViewController ()

@end

static NSString *ItemIdentifier = @"ItemIdentifier";
static float imageSize = 90.0f;

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@implementation FinancePicViewController

@synthesize images = _images;

-(void)loadView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(90, 160)];
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[FinanPicCollectCell class] forCellWithReuseIdentifier:ItemIdentifier];
    [self.collectionView setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoDataSource=[[NSMutableArray alloc] init];
    self.browser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
    self.browser.wantsFullScreenLayout = NO;
    [self.view setBackgroundColor:[Utiles colorWithHexString:@"#FDFBE4"]];
    self.images=[[NSArray alloc] init];
    [self getPics];
}

-(void)getPics{
    
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:self.keyWord,@"keyword",@"1",@"offset", nil];
    
    [Utiles getNetInfoWithPath:@"Fchart" andParams:params besidesBlock:^(id obj) {
        
        NSMutableArray *temp=[[[NSMutableArray alloc] init] autorelease];
        for(id t in obj){
            [temp addObject:[t objectForKey:@"url"]];
        }
        
        for (id obj in temp) {
            DemoPhoto *photo = nil;
            photo = [[DemoPhoto alloc] initWithURL:[NSURL URLWithString:obj]];
            [self.photoDataSource addObject:photo];
        }
        self.images=temp;
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - UICollectionView DataSource & Delegate methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.images count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FinanPicCollectCell *cell = (FinanPicCollectCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ItemIdentifier forIndexPath:indexPath];
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:[self.images objectAtIndex:indexPath.row]]
                   placeholderImage:[UIImage imageNamed:@"icon.png"]];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.browser.currentPageIndex=indexPath.row;
    [self presentViewController:self.browser animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark CXPhotoBrowserDelegate

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index{
    [self.imageTitleLabel setText:[NSString stringWithFormat:@"%d/%d",(index+1),[self.images count]]];
}

#pragma mark - CXPhotoBrowserDataSource
- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return [self.photoDataSource count];
}
- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photoDataSource.count)
        return [self.photoDataSource objectAtIndex:index];
    return nil;
}

- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)];
        [bkgView setBackgroundColor:[UIColor blackColor]];
        bkgView.alpha = 0.2;
        bkgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [navBarView addSubview:bkgView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [doneButton setTitle:NSLocalizedString(@"返回",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 60, 10, 50, 30)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        self.imageTitleLabel = [[UILabel alloc] init];
        [self.imageTitleLabel setFrame:CGRectMake((size.width - 60)/2, 10, 60, 40)];
        [self.imageTitleLabel setCenter:navBarView.center];
        [self.imageTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [self.imageTitleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [self.imageTitleLabel setTextColor:[UIColor whiteColor]];
        [self.imageTitleLabel setBackgroundColor:[UIColor clearColor]];
        [self.imageTitleLabel setText:@""];
        self.imageTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.imageTitleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:self.imageTitleLabel];
    }
    
    return navBarView;
}

#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
