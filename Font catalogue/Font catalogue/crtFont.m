//
//  crtFont.m
//  Font catalogue
//
//  Created by Alwin Chin on 14/08/13.
//  Copyright (c) 2013 creategroup. All rights reserved.
//

#import "crtFont.h"

@implementation crtFont

@synthesize fontName;
@synthesize rating;
@synthesize fontSizeForCell;

+ (id)fontWithNameRating:(NSString *)fontName rating:(NSNumber *)rating
{
  crtFont *newFont = [[self alloc] init];
  [newFont setFontName:fontName];
  [newFont setRating:rating];
  return newFont;
}

@end
