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
    
    // Whenever scrolling happens, alert the parent
    self.shouldAlertParentWhileScrolling = YES;
    
    
    // Subscribe to wether update notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshWeatherInfo:) name:kWeatherUpdateNotification object:nil];
}


- (void) refreshWeatherInfo:(id)sender {
    @try {
        
        // Reload the section showing today's events when new weather information is available if it is visible
        NSUInteger sectionForToday = [self.dateManager indexForToday];
        for(NSIndexPath * indexPath in [self.agendaTableView indexPathsForVisibleRows]) {
            if(indexPath.section == sectionForToday) {
                
                // If any cell is found of the current section in the visible window,
                // reload the section
                [self.agendaTableView reloadSections:[NSIndexSet indexSetWithIndex:sectionForToday] withRowAnimation:UITableViewRowAnimationNone];
                
                // Just reload it once
                break;
            }
        }
    }
    @catch(NSException *exception) {
        // if there's an exception, do nothing for now
    }
}

// Scroll to specific date
- (void)showDateIndex:(NSUInteger)date animated:(BOOL)animated {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:date];
    
    // Don't inform parent if scrolling is being done automatically
    self.shouldAlertParentWhileScrolling = NO;
    
    //
    [self.agendaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.dateManager totalDays];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Event *event = [self eventAtIndexPath:indexPath];
    
    // If there's an event on the date, return the height required by the cell to render the event
    if(event)
        return [EventTableViewCell heightForEvent:event];
    
    // Otherwise return default height
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Fetch events on the day
    NSArray *events = [self.eventManager eventsForTheDay:[self.dateHelper keyStringForIndex:section]];
    
    // If there are no events, show only No Events cell
    if(events.count == 0)
        return 1;
    
    // Return Number of cells as many as there are events in the day
    return events.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    AgendaTableHeaderView *header = (AgendaTableHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kAgendaHeader];
    
    @try {
    
        // If it is today's date and WeatherManager has valid weather data, show weather data
        if(section == [self.dateManager indexForToday] && self.weatherManager.hasWeatherData) {
            
            WeatherInfoHeaderView *weatherHeader = (WeatherInfoHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:kWeatherHeader];
            
            // Set the icon
            [weatherHeader.weatherIcon setImage:[UIImage imageNamed:[self.weatherManager iconString]]];
            
            // Set the temperature label
            [weatherHeader.temperatureLbl setText:[self.weatherManager temperature]];
            
            // Assign it to return value
            header = (AgendaTableHeaderView *)weatherHeader;
            
        }
    }
    @catch (NSException *exception) {
        // cases like today is out of range of date manager.
        // do nothing for now
    }
    
    // Set Today's date
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
    
    // Index path at present offset
    NSIndexPath *indexPath = [self.agendaTableView indexPathForRowAtPoint:contentOffset];
    
    // Cell at present offset
    UITableViewCell *cell = [self.agendaTableView cellForRowAtIndexPath:indexPath];
    
    NSIndexPath *nextIndexPath = indexPath;
    
    // If the cell is displayed in near half height, present index path will be retained
    // else next index index path will be chosen
    if((contentOffset.y - cell.topY) >= (cell.bottomY - contentOffset.y) + 3)
        nextIndexPath = [self getNextIndexPathForIndexPath:indexPath];
    
    // Scroll the table to a cell such that the top should always begin with a cell
    [self.agendaTableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    // Alert parent it stopped moving if required
    if(self.shouldAlertParentWhileScrolling)
        [(ViewController *)self.parentViewController viewController:self isMoving:NO];
}

// Next Index Path for a given Index Path. If there are no rows after this index path, the same will be returned
- (NSIndexPath *) getNextIndexPathForIndexPath:(NSIndexPath *)indexPath {
    
    if([self tableView:self.agendaTableView numberOfRowsInSection:indexPath.section] > indexPath.row + 1) {
        // If there are more rows in the section, return next row
        return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    }
    
    if([self numberOfSectionsInTableView:self.agendaTableView] > indexPath.section + 1) {
        
        // If there is next section, return the first row of the next section
        return [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
    }
    
    // return present index path (as it is the last in the table)
    return indexPath;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // if the scroll is forcefully stopped, move to cell whose top aligns with table's top
    if(!decelerate) {
        [self setRowForScrollOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // find the top cell in the table view
    NSIndexPath *indexPath = [self.agendaTableView indexPathForRowAtPoint:scrollView.contentOffset];
    
    // Alert the parent to show this date, if required
    if(self.shouldAlertParentWhileScrolling)
        [(ViewController *)self.parentViewController notifyCalendarForDateIndex:indexPath.section fromViewController:self];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // After the scrollview comes to stop, move to cell whose top aligns with table's top
    [self setRowForScrollOffset:scrollView.contentOffset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    // If the parent should be known about the scroll state of the agenda table
    if(self.shouldAlertParentWhileScrolling) {
        
        // Ask the parent to contract the calendar view
        [(ViewController *)self.parentViewController contractCalendarView:YES];
        
        // Alert the parent of that it is scrolling
        [(ViewController *)self.parentViewController viewController:self isMoving:YES];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // Toggle the state such that it will alert the parent of the scroll state
    // for next time
    if(!self.shouldAlertParentWhileScrolling)
        self.shouldAlertParentWhileScrolling = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // Refresh weather dataa on click of any cell.
    [self.weatherManager refreshWeatherData];
}



@end
