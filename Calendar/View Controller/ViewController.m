//
//  ViewController.m
//  Calendar
//
//  Created by Arup Saha on 8/16/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "ViewController.h"
#import "CalendarViewController.h"
#import "AgendaViewController.h"
#import "DateManager.h"
#import "EventManager.h"
#import "WeatherManager.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet CalendarViewController *calendarVC;
@property (strong, nonatomic) IBOutlet AgendaViewController *agendaVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EventManager *eventManager = [EventManager sharedInstance];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [eventManager setUpWithCompletion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(weakSelf) {
                    [weakSelf setTodaysDate];
                }
            });
        }];
    });
    
    [weakSelf addChildViewController:self.calendarVC];
    [weakSelf.calendarVC loadViewIfNeeded];
    [weakSelf.calendarVC didMoveToParentViewController:self];
    
    [weakSelf addChildViewController:weakSelf.agendaVC];
    [weakSelf.agendaVC loadViewIfNeeded];
    [weakSelf.agendaVC didMoveToParentViewController:weakSelf];
}

- (void) setTodaysDate {
    DateManager *dateManager = [DateManager sharedInstance];
    [self notifyCalendarForDateIndex:[dateManager indexForToday] fromViewController:self];
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self.calendarVC beginAppearanceTransition: YES animated: animated];
    [self.agendaVC beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated
{
    WeatherManager *wm = [WeatherManager sharedInstance];
    [wm refreshWeatherData];
    [self.calendarVC endAppearanceTransition];
    [self.agendaVC endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self.calendarVC beginAppearanceTransition: NO animated: animated];
    [self.agendaVC beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [self.calendarVC endAppearanceTransition];
    [self.agendaVC endAppearanceTransition];
}


- (void) notifyCalendarForDateIndex: (NSUInteger) dateIndex fromViewController:(UIViewController *)requestingViewController {
    [self setTitle:[[DateManager sharedInstance] monthDisplayForIndex:dateIndex]];
    if(requestingViewController != self.calendarVC)
        [self.calendarVC showDateIndex:dateIndex animated:NO];
    if(requestingViewController != self.agendaVC)
        [self.agendaVC showDateIndex:dateIndex animated:requestingViewController != self];
}

- (void) viewController:(UIViewController *)focussedViewController isMoving:(BOOL) isMoving {
    if(focussedViewController != self.calendarVC)
        [self.calendarVC layoutForAutoScrolling:isMoving];
}

- (void) contractCalendarView:(BOOL) contract {
    [self.calendarVC compressCalendar:contract];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
