//
//  CalendarViewController.m
//  Calendar
//
//  Created by Arup Saha on 8/16/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "CalendarViewController.h"
#import "FirstDayCell.h"
#import "DateManager.h"
#import "ViewController.h"
#import "DateStringHelper.h"

#define kNormalCellId @"NormalCellId"
#define kFirstDayCellId @"FirstDayCellId"
#define kCellHeight 45.0f

@interface CalendarViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarHeight;
@property (nonatomic, strong) DateManager *dateManager;
@property (nonatomic, strong) DateStringHelper *dateHelper;

@property (nonatomic, assign) BOOL shouldBlurCells;
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCells];
    self.dateManager = [DateManager sharedInstance];
    self.dateHelper = [DateStringHelper helperWithDateManager:self.dateManager];
    self.shouldBlurCells = NO;
    self.calendarCollectionView.scrollsToTop = NO;
    [self updateLayoutSizes];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.calendarCollectionView reloadData];
    
    @try {
        // Show today's date
        [self showDateIndex:[self.dateManager indexForToday] animated:NO];
    }
    @catch (NSException *exception) {
        // If today's date is out of range, show the first date available
        [self showDateIndex:0 animated:NO];
    }
}


- (void) registerCells {
    [self.calendarCollectionView registerNib:[UINib nibWithNibName:@"NormalCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kNormalCellId];
    [self.calendarCollectionView registerNib:[UINib nibWithNibName:@"FirstDayCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:kFirstDayCellId];
}

- (void) updateLayoutSizes {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.calendarCollectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake([UIScreen mainScreen].bounds.size.width/7, kCellHeight)];
    [layout setMinimumInteritemSpacing:0];
    [layout setMinimumLineSpacing:0];
}

- (void) blurCells: (BOOL) blur {
    self.shouldBlurCells = blur;
    for(UICollectionViewCell *cell in [_calendarCollectionView visibleCells]) {
        cell.alpha = blur ? 0.3 : 1;
    }
}

- (void) compressCalendar : (BOOL) compress {
    self.calendarHeight.constant = compress ? (kCellHeight * 2) : (kCellHeight * 4);
    [UIView animateWithDuration:0.3 animations:^{
        [self.calendarCollectionView.superview layoutIfNeeded];
    }];
}

- (void)showDateIndex:(NSUInteger)dateIndex animated:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:dateIndex inSection:0];
    [self.calendarCollectionView scrollToItemAtIndexPath: indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    [self.calendarCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:animated];
}

- (void)layoutForAutoScrolling:(BOOL)shouldScroll {
    [self blurCells:shouldScroll];
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dateManager totalDays];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NormalCell *cell;
    NSInteger dayOfMonth = [self.dateHelper dayOfMonthForIndex:indexPath.item];
    
    if(dayOfMonth == 1) {
        // If it is the first day of the month, show the short month in the cell as well
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFirstDayCellId forIndexPath:indexPath];
        [((FirstDayCell *)cell).monthLbl setText: [self.dateHelper shortMonthStringForIndex:indexPath.item]];
       
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNormalCellId forIndexPath:indexPath];
        
    }
    if(dayOfMonth > 0) {
        // If the day is 0 (error case, dont do anything)
        [cell.dateLbl setText:[@(dayOfMonth) stringValue]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.alpha = self.shouldBlurCells ? 0.3 : 1.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self compressCalendar:NO];
    [(ViewController *)self.parentViewController notifyCalendarForDateIndex:indexPath.item fromViewController:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // Expand the calendar height if required
    [self compressCalendar:NO];
    
    // Blur cells while scrolling
    [self blurCells:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // If the scrolling is stopped by force, unblur the cells
    if(!decelerate)
        [self blurCells:NO];
    
    // In case the scrolling is
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    // Always snap it to the beginning of a row
    
    CGPoint proposedContentOffset = *targetContentOffset;
    CGFloat offset = kCellHeight;
    
    // Get the content offset of the previous row
    CGFloat newOffset = lrintf(floorf(proposedContentOffset.y / offset)) * offset;
    
    // If the scroll will stop at half past the present row, set the offset of the next row
    if(proposedContentOffset.y - newOffset >= offset/2)
        newOffset += offset;
    
    // Set the new offset
    *targetContentOffset = CGPointMake(proposedContentOffset.x, newOffset);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // Unblur cells after the scrollview stops decelerating
    [self blurCells:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
