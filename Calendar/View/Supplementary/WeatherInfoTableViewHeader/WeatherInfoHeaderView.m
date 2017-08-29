//
//  WeatherInfoHeaderView.m
//  Calendar
//
//  Created by Arup Saha on 8/28/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "WeatherInfoHeaderView.h"
#import "Constants.h"

@implementation WeatherInfoHeaderView

- (void) baseInit {
    [self initTemperatureLabel];
    [self initWeatherIcon];
}

- (void) initTemperatureLabel {
    self.temperatureLbl = [[UILabel alloc] init];
    [self.contentView addSubview:self.temperatureLbl];
}

- (void) initWeatherIcon {
    self.weatherIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.weatherIcon];
}

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier {
    if(self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self baseInit];
        
    }
    return self;
}

- (CGRect) frameForTemperatureLabel {
    
    CGRect frame = self.temperatureLbl.frame;
    frame.origin.x = self.contentView.frame.size.width - kCellPadding - frame.size.width;
    return frame;
}

- (CGRect) frameForWeatherIcon {
    CGFloat kWidth = 10;
    CGRect frameForTemperatureLabel = [self frameForTemperatureLabel];
    CGRect frame = CGRectMake(0, 0, kWidth, kWidth);
    frame.origin.x = frameForTemperatureLabel.origin.x - kWidth - 2;
    frame.origin.y = (frameForTemperatureLabel.origin.y + frameForTemperatureLabel.size.height / 2) - kWidth/2;
    return frame;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.temperatureLbl.font = super.textLabel.font;
    [self.temperatureLbl sizeToFit];
    self.temperatureLbl.center = CGPointMake(0, self.contentView.center.y);
    [self.temperatureLbl setFrame:[self frameForTemperatureLabel]];
    
    [self.weatherIcon setFrame:[self frameForWeatherIcon]];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.textLabel setText:@""];
}
@end
