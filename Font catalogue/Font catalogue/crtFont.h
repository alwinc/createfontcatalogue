//
//  crtFont.h
//  Font catalogue
//
//  Created by Alwin Chin on 14/08/13.
//  Copyright (c) 2013 creategroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface crtFont : NSObject {
  NSString *fontName;
  NSNumber *rating;
  NSNumber *fontSizeForCell;
}

@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, retain) NSNumber *rating;
@property (nonatomic, retain) NSNumber *fontSizeForCell;


+ (id)fontWithNameRating:(NSString *)fontName rating:(NSNumber *)rating;
@end
