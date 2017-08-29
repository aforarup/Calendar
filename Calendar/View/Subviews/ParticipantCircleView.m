//
//  ParticipantCircleView.m
//  Calendar
//
//  Created by Arup Saha on 8/25/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "ParticipantCircleView.h"
#import <QuartzCore/QuartzCore.h>

@interface ParticipantCircleView ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation ParticipantCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:self.label];
        [self setBackgroundColor:[UIColor blackColor]];
        
        
    }
    return self;
}


- (void)setParticipantName:(NSString *)name {
    
    // Instead of taking initials, just using first 2 characters of the name.
    [self.label setText:[[name substringToIndex:2] uppercaseString]];
    
    
    [self setBackgroundColor:[UIColor colorWithRed:(arc4random()%255)/255.0f green:(arc4random()%255)/255.0f blue:(arc4random()%255)/255.0f alpha:1.0f]];
    
}

- (void) showHasMore {
    [self.label setText:@"..."];
    [self setBackgroundColor:[UIColor colorWithWhite:0.75f alpha:1.0f]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.label setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.label setFont:[UIFont systemFontOfSize:ceilf((self.frame.size.height)/2)]];
    self.layer.cornerRadius = MAX(self.frame.size.width, self.frame.size.width)/2;
    self.layer.masksToBounds = YES;
}



@end
