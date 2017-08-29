//
//  EventTableViewCell.m
//  Calendar
//
//  Created by Arup Saha on 8/19/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "EventTableViewCell.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Coordinates.h"
#import "ParticipantsView.h"


#define kInterElementVerticalPadding 10.0f


#define kTimeLblWidth 55.0f
#define kTimeLblHeight 14.0f
#define kDurationLblHeight 10.0f

#define kConfirmationIndicatorTop (kCellPadding + 2.0f)
#define kConfirmationIndicatorSide 8.0f
#define kConfirmationIndicatorMargin 15.0f

#define kParticipantsViewHeight 20.0f

#define kTimeLblFont [UIFont systemFontOfSize:12]
#define kDurationLblFont [UIFont systemFontOfSize:10]
#define kAgendaLblFont [UIFont boldSystemFontOfSize:12]
#define kLocationLblFont [UIFont systemFontOfSize:12]

@interface EventTableViewCell()
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *durationLbl;
@property (nonatomic, strong) UIView *confirmationIndicator;
@property (nonatomic, strong) UILabel *agendaLbl;
@property (nonatomic, strong) ParticipantsView *participantsView;
@property (nonatomic, strong) UILabel *locationLbl;

@property (nonatomic, weak) Event *event;
@end

@implementation EventTableViewCell

- (void) baseInit {
    [self initTimeLabel];
    [self initDurationLabel];
    [self initConfirmationIndicator];
    [self initAgendaLabel];
    [self initParticipantsView];
    [self initLocationLabel];
}

- (void) initTimeLabel {
    self.timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLbl.font = kTimeLblFont;
}

- (void) initDurationLabel {
    self.durationLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.durationLbl.font = kDurationLblFont;
}

- (void) initConfirmationIndicator {
    self.confirmationIndicator = [[UIView alloc] initWithFrame:[self frameForConfirmationIndicator]];
    [self.confirmationIndicator.layer setCornerRadius:kConfirmationIndicatorSide/2];
    [self.confirmationIndicator.layer setMasksToBounds:YES];
    [self.confirmationIndicator setBackgroundColor:[UIColor greenColor]];
}

- (void) initAgendaLabel {
    self.agendaLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.agendaLbl.font = kAgendaLblFont;
    self.agendaLbl.lineBreakMode = NSLineBreakByWordWrapping;
    self.agendaLbl.numberOfLines = 0;
}

- (void) initParticipantsView {
    self.participantsView = [[ParticipantsView alloc] initWithFrame:CGRectZero maxParticipantCount:5];
}

- (void) initLocationLabel {
    self.locationLbl = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLbl.font = kLocationLblFont;
    self.locationLbl.lineBreakMode = NSLineBreakByWordWrapping;
    self.locationLbl.numberOfLines = 0;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self baseInit];
        
        [self.contentView addSubview:_timeLbl];
        [self.contentView addSubview:_durationLbl];
        [self.contentView addSubview:_confirmationIndicator];
        [self.contentView addSubview:_agendaLbl];
        [self.contentView addSubview:_participantsView];
        [self.contentView addSubview:_locationLbl];
    }
    return self;
}

- (void)fillCellWithDataOfEvent:(Event *)event {
    self.event = event;
    [self.timeLbl setText:self.event.displayTime];
    [self.durationLbl setText:self.event.displayDuration];
    [self.agendaLbl setText:self.event.agenda];
    [self.participantsView setParticipants:self.event.participants];
    [self.locationLbl setText:self.event.address];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.timeLbl setText:@""];
    [self.durationLbl setText:@""];
    [self.agendaLbl setText:@""];
    [self.locationLbl setText:@""];
    self.event = nil;
}

- (CGRect) frameForTimeLabel {
    return CGRectMake(kCellPadding, kCellPadding, kTimeLblWidth, kTimeLblHeight);
}

- (CGRect) frameForDurationLabel {
    if(self.event.allDay)
        return CGRectZero;
    return CGRectMake(kCellPadding, self.timeLbl.bottomY + kInterElementVerticalPadding, kTimeLblWidth, kTimeLblHeight);
    
}

- (CGRect) frameForConfirmationIndicator {
    return CGRectMake(self.timeLbl.rightX + kConfirmationIndicatorMargin, kConfirmationIndicatorTop, kConfirmationIndicatorSide, kConfirmationIndicatorSide);
}


- (CGRect) frameForAgendaLabel {
    CGFloat startX = self.confirmationIndicator.rightX + kConfirmationIndicatorMargin;
    CGFloat startY = kCellPadding;
    
    CGFloat width = [[self class] rightElementsWidth];
    CGFloat height = [[self class] heightForLabelWithString:self.event.agenda labelWidth:width labelFont:kAgendaLblFont];
    return CGRectMake(startX, startY, width, height);
}

+ (CGFloat) rightElementsWidth {
    return [UIScreen mainScreen].bounds.size.width - (kCellPadding + kTimeLblWidth + kConfirmationIndicatorMargin + kConfirmationIndicatorSide + kConfirmationIndicatorMargin + kCellPadding);
}

+ (CGFloat) heightForLabelWithString:(NSString *)string labelWidth:(CGFloat)width labelFont:(UIFont *) font {
    CGFloat height = 0;
    if(string.length > 0)
        height = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    return ceilf(height);
}

- (CGRect) frameForParticipantsView {
    if(self.event.participants.count == 0)
        return CGRectZero;
    CGFloat startX = self.agendaLbl.leftX;
    CGFloat startY = self.agendaLbl.bottomY + kInterElementVerticalPadding;
    CGFloat width = [[self class] rightElementsWidth];
    return CGRectMake(startX, startY, width, kParticipantsViewHeight);
}

- (CGRect) frameForLocationLabel {
    if(self.event.address.length == 0)
        return CGRectZero;
    CGFloat startX = self.agendaLbl.leftX;
    CGFloat startY = 0;
    if(self.event.hasParticipants) {
        startY = self.participantsView.bottomY + kInterElementVerticalPadding;
    } else {
        startY = self.agendaLbl.bottomY + kInterElementVerticalPadding;
    }
    CGFloat width = [[self class] rightElementsWidth];
    CGFloat height = [[self class] heightForLabelWithString:self.event.address labelWidth:width labelFont:kLocationLblFont];
    return CGRectMake(startX, startY, width, height);
}

+ (CGFloat) heightForEvent:(Event *) event {
    CGFloat leftElementsHeight = 0;
    CGFloat rightElementsHeight = 0;
    leftElementsHeight += kCellPadding;
    leftElementsHeight += kTimeLblHeight;
    if(!event.allDay)
        leftElementsHeight += (kInterElementVerticalPadding + kDurationLblHeight);
    leftElementsHeight += kCellPadding;
    
    
    rightElementsHeight += kCellPadding;
    rightElementsHeight += [self heightForLabelWithString:event.agenda labelWidth:[self rightElementsWidth] labelFont:kAgendaLblFont];
    if(event.participants.count > 0) {
        rightElementsHeight += kInterElementVerticalPadding;
        rightElementsHeight += kParticipantsViewHeight;
    }
    
    if(event.address.length > 0) {
        rightElementsHeight += kInterElementVerticalPadding;
        rightElementsHeight += [self heightForLabelWithString:event.address labelWidth:[self rightElementsWidth] labelFont:kLocationLblFont];
    }
    rightElementsHeight += kCellPadding;
    
    return MAX(leftElementsHeight, rightElementsHeight);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.timeLbl setFrame:[self frameForTimeLabel]];
    [self.durationLbl setFrame:[self frameForDurationLabel]];
    [self.confirmationIndicator setFrame:[self frameForConfirmationIndicator]];
    [self.agendaLbl setFrame:[self frameForAgendaLabel]];
    [self.participantsView setFrame:[self frameForParticipantsView]];
    [self.locationLbl setFrame:[self frameForLocationLabel]];
}

@end
