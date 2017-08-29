//
//  AgendaTableViewCell.m
//  Calendar
//
//  Created by Arup Saha on 8/18/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "NoEventTableViewCell.h"
#import "Constants.h"

#define kNoEventMsgLblFont [UIFont systemFontOfSize:12.0f]

@interface NoEventTableViewCell()
@property (nonatomic, strong) UILabel *noEventMsgLbl;
@end

@implementation NoEventTableViewCell

- (void) baseInit {
    [self initNoEventMessageLabel];
}

- (void) initNoEventMessageLabel {
    self.noEventMsgLbl = [[UILabel alloc] init];
    [self.noEventMsgLbl setText:@"No events"];
    [self.noEventMsgLbl setTextColor:[UIColor lightGrayColor]];
    [self.noEventMsgLbl setFont:kNoEventMsgLblFont];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self baseInit];
        [self.contentView addSubview:self.noEventMsgLbl];
    }
    return self;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.noEventMsgLbl setFrame:CGRectMake(kCellPadding, kCellPadding, 0, 0)];
    [self.noEventMsgLbl sizeToFit];
    [self.noEventMsgLbl setCenter:CGPointMake(self.noEventMsgLbl.center.x, self.contentView.center.y)];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
