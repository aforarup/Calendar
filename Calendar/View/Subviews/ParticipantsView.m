//
//  ParticipantsView.m
//  Calendar
//
//  Created by Arup Saha on 8/22/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "ParticipantsView.h"
#import "ParticipantCircleView.h"
#import <QuartzCore/QuartzCore.h>


#define kParticipantCircleSpacing 6.0f

@interface ParticipantsView()
@property (nonatomic, assign) NSUInteger participantCount;
@property (nonatomic, assign) CGFloat participantCircleRadius;
@property (nonatomic, strong) NSMutableArray<ParticipantCircleView *>* participantCircles;
@end

@implementation ParticipantsView

- (instancetype)initWithFrame:(CGRect)frame maxParticipantCount:(NSUInteger) participantCount {
    if(self = [super initWithFrame:frame]) {
        self.participantCount = participantCount;
        self.participantCircles = [NSMutableArray arrayWithCapacity:participantCount];
        for(int i = 0; i < participantCount; i++) {
            ParticipantCircleView *participantView = [[ParticipantCircleView alloc] initWithFrame:CGRectZero];
            [_participantCircles addObject:participantView];
            [self addSubview:participantView];
            
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat maxCircleSpace = self.frame.size.width - (self.participantCount -1) * kParticipantCircleSpacing;
    CGFloat circleDiamter = MIN(self.frame.size.height, maxCircleSpace/self.participantCount);
    
    CGFloat x = 0;
    CGFloat y = (self.frame.size.height - circleDiamter)/2;
    
    for(int i = 0; i < self.participantCount; i++) {
        ParticipantCircleView *participantView = [self.participantCircles objectAtIndex:i];
        [participantView setFrame:CGRectMake(x, y, circleDiamter, circleDiamter)];
        x += circleDiamter;
        x += kParticipantCircleSpacing;
    }
}

- (void)setParticipants:(NSArray<Participant *> *)participants {
    for(int i = 0; i < self.participantCount; i++) {
        ParticipantCircleView *participantCircle = [self.participantCircles objectAtIndex:i];
        [participantCircle setHidden:NO];
        if(i >= participants.count) {
            [participantCircle setHidden:YES];
        } else if(i == self.participantCount - 1 && participants.count > self.participantCount) {
            [participantCircle showHasMore];
        } else {
            NSString *name = [participants objectAtIndex:i].name;
            [participantCircle setParticipantName:name];
        }
    }
}


@end
