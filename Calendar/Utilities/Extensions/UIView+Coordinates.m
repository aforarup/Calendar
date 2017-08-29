//
//  UIView+Coordinates.m
//  Calendar
//
//  Created by Arup Saha on 8/22/17.
//  Copyright © 2017 arupsaha.tech. All rights reserved.
//

#import "UIView+Coordinates.h"

@implementation UIView (Coordinates)
- (CGFloat) topY {
    return self.frame.origin.y;
}
- (CGFloat) bottomY {
    return self.topY + self.frame.size.height;
}
- (CGFloat) leftX {
    return self.frame.origin.x;
}
- (CGFloat) rightX {
    return self.leftX + self.frame.size.width;
}
@end
