//
//  AgendaTableHeaderView.m
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "AgendaTableHeaderView.h"

@implementation AgendaTableHeaderView


- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.font = [UIFont systemFontOfSize:10];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.textLabel setText:@""];
}


@end
