    //
//  AgendaViewController.m
//  Calendar
//
//  Created by Arup Saha on 8/17/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "AgendaViewController.h"
#import "AgendaTableHeaderView.h"
#import "EventTableViewCell.h"
#import "NoEventTableViewCell.h"
#import "ViewController.h"
#import "DateManager.h"
#import "EventManager.h"
#import "UIView+Coordinates.h"
#import "WeatherInfoHeaderView.h"
#import "WeatherManager.h"
#import "Constants.h"
#import "DateStringHelper.h"


#define kNormalCellId @"NormalCellId"
#define kEmptyCellId @"EmptyCellId"
#define kAgendaHeader @"AgendaHeader"
#define kWeatherHeader @"WeatherHeader"

@interface AgendaViewController ()
@property (weak, nonatomic) IBOutlet UITableView *agendaTableView;
@property (nonatomic, strong) DateManager *dateManager;
@property (nonatomic, strong) EventManager *eventManager;
@property (nonatomic, strong) WeatherManager *weatherManager;
@property (nonatomic, assign) BOOL shouldAlertParentWhileScrolling;
@property (nonatomic, strong) DateStringHelper *dateHelper;
@end

@implementation AgendaViewController

- (void) registerViews {
    [self.agendaTableView registerClass:[NoEventTableViewCell class] forCellReuseIdentifier:kEmptyCellId];
    [self.agendaTableView registerClass:[EventTableViewCell class] forCellReuseIdentifier:kNormalCellId];
    [self.agendaTableView registerClass:[AgendaTableHeaderView class] forHeaderFooterViewReuseIdentifier:kAgendaHeader];
    [self.agendaTableView registerClass:[WeatherInfoHeaderView class] forHeaderFooterViewReuseIdentifier:kWeatherHeader];
}

- (void) baseInit {
    [self initManagers];
    [self initDateHelper];
}

- (void) initDateHelper {
    self.dateHelper = [DateStringHelper helperWithDateManager:self.dateManager];
}

- (void) initManagers {
    self.dateManager = [DateManager sharedInstance];
    self.eventManager = [EventManager sharedInstance];
    self.weatherManager = [WeatherManager sharedInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.agendaTableView.scrollsToTop = NO;
    [self registerViews];
    [self baseInit];
    [self.agendaTableView reloadData];
    
    self.shouldAlertParentWhileScrolling = YES;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeatherInfo:) name:kWeatherUpdateNotification object:nil];
}

// Reload the section showing today's events when new weather information is available if it is visible
- (void) refreshWeatherInfo:(id)sender {
    NSUInteger sectionForToday = [self.dateManager indexForToday];
    for(NSIndexPath * indexPath in [self.agendaTableView indexPathsForVisibleRows]) {
        if(indexPath.section == sectionForToday) {
            [self.agendaTableView reloadSections:[NSIndexSet indexSetWithIndex:sectionForToday] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}


- (void)showDateIndex:(NSUInteger)date animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:date];
    [self.agendaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dateManager totalDays];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *event = [self eventAtIndexPath:indexPath];
    if(event) {
        return [EventTableViewCell heightForEvent:event];
    }
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *events = [self.eventManager eventsForTheDay:[self.dateHelper keyStringForIndex:section]];
    if(events.count == 0)
        return 1;
    return events.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AgendaTableHeaderView *header;
    if(section == [self.dateManager indexForToday] && self.weatherManager.hasWeatherData) {
        WeatherInfoHeaderView *weatherHeader = (WeatherInfoHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kWeatherHeader];
        [weatherHeader.weatherIcon setImage:[UIImage imageNamed:[self.weatherManager iconString]]];
        [weatherHeader.temperatureLbl setText:[self.weatherManager temperature]];
        header = (AgendaTableHeaderView *)weatherHeader;
    } else {
        header = (AgendaTableHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kAgendaHeader];
    }
    [header.textLabel setText:[self.dateHelper sectionTitleStringForIndex:section]];
    return header;
}

- (Event *) eventAtIndexPath:(NSIndexPath *) indexPath {
    NSArray *events = [self.eventManager eventsForTheDay:[self.dateHelper keyStringForIndex:indexPath.section]];
    if(events.count > 0 && indexPath.row < events.count) {
        return [events objectAtIndex:indexPath.row];
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Event *event = [self eventAtIndexPath:indexPath];
    if(event) {
        EventTableViewCell * cell =  [tableView dequeueReusableCellWithIdentifier:kNormalCellId];
        [cell fillCellWithDataOfEvent:event];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:kEmptyCellId];
}

- (void) setRowForScrollOffset: (CGPoint) contentOffset {
    NSIndexPath *indexPath = [self.agendaTableView indexPathForRowAtPoint:contentOffset];
    UITableViewCell *cell = [self.agendaTableView cellForRowAtIndexPath:indexPath];
    NSIndexPath *nextIndexPath = indexPath;
    if((contentOffset.y - cell.topY) >= (cell.bottomY - contentOffset.y) + 3)
        nextIndexPath = [self getNextIndexPathForIndexPath:indexPath];
    
    [self.agendaTableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if(self.shouldAlertParentWhileScrolling)
        [(ViewController *)self.parentViewController viewController:self isMoving:NO];
}

// Next Index Path for a given Index Path. If there are no rows after this index path, the same will be returned
- (NSIndexPath *) getNextIndexPathForIndexPath:(NSIndexPath *)indexPath {
    if([self numberOfSectionsInTableView:self.agendaTableView] == indexPath.section - 1) {
        
    }
    if([self tableView:self.agendaTableView numberOfRowsInSection:indexPath.section] > indexPath.row + 1) {
        return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    }
    
    if([self numberOfSectionsInTableView:self.agendaTableView] > indexPath.section + 1) {
        return [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
    }
    return indexPath;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    if(!decelerate) {
        [self setRowForScrollOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.agendaTableView indexPathForRowAtPoint:scrollView.contentOffset];
    if(self.shouldAlertParentWhileScrolling)
        [(ViewController *)self.parentViewController notifyCalendarForDateIndex:indexPath.section fromViewController:self];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setRowForScrollOffset:scrollView.contentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(self.shouldAlertParentWhileScrolling) {
        [(ViewController *)self.parentViewController contractCalendarView:YES];
        [(ViewController *)self.parentViewController viewController:self isMoving:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if(!self.shouldAlertParentWhileScrolling)
        self.shouldAlertParentWhileScrolling = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.weatherManager refreshWeatherData];
}



@end
