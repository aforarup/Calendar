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
        
        // Draw Cicle Views and keep them in memory
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
    
    // Max Area circles can have
    CGFloat maxCircleSpace = self.frame.size.width - (self.participantCount -1) * kParticipantCircleSpacing;
    
    // Diameter of the circles
    CGFloat circleDiamter = MIN(self.frame.size.height, maxCircleSpace/self.participantCount);
    
    // Initial X of the circles
    CGFloat x = 0;
    
    // Initial Y of the circles. In case the height of the circles are less that the frame of the view, center align the circles
    CGFloat y = (self.frame.size.height - circleDiamter)/2;
    
    // Set frames for the circles.
    for(int i = 0; i < self.participantCount; i++) {
        ParticipantCircleView *participantView = [self.participantCircles objectAtIndex:i];
        [participantView setFrame:CGRectMake(x, y, circleDiamter, circleDiamter)];
        x += circleDiamter;
        x += kParticipantCircleSpacing;
    }
}

- (void)setParticipants:(NSArray<Participant *> *)participants {
    
    // Set the value for each of the circle
    for(int i = 0; i < self.participantCount; i++) {
        
        ParticipantCircleView *participantCircle = [self.participantCircles objectAtIndex:i];
        
        [participantCircle setHidden:NO];
        
        if(i >= participants.count) {
            
            // Hide the remaining circle if total number of participants is less than max number of circles
            [participantCircle setHidden:YES];
            
        } else if(i == self.participantCount - 1 && participants.count > self.participantCount) {
            
            // If Particpants are more and this is the last circle, put "..."
            [participantCircle showHasMore];
            
        } else {
            
            // Put the participant name
            NSString *name = [participants objectAtIndex:i].name;
            [participantCircle setParticipantName:name];
            
        }
    }
}


@end
