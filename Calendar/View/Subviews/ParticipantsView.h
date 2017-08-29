//
//  ParticipantsView.h
//  Calendar
//
//  Created by Arup Saha on 8/22/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Participant.h"

@interface ParticipantsView : UIView

- (instancetype)initWithFrame:(CGRect)frame maxParticipantCount:(NSUInteger) participantCount;
- (void) setParticipants:(NSArray<Participant *> *)participants;
@end
