//
//  ItemCell.m
//  WineTastingJournal
//
//  Created by David Westgate on 6/19/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import "ItemCell.h"

@interface ItemCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation ItemCell

- (void)updateInterfaceForDynamicTypeSize
{
  UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  self.noteTitleLabel.font = font;
  
  static NSDictionary *imageSizeDictionary;
  
  if (!imageSizeDictionary) {
    imageSizeDictionary = @{ UIContentSizeCategoryExtraSmall : @40,
                             UIContentSizeCategorySmall : @40,
                             UIContentSizeCategoryMedium : @40,
                             UIContentSizeCategoryLarge : @40,
                             UIContentSizeCategoryExtraLarge : @45,
                             UIContentSizeCategoryExtraExtraLarge : @55,
                             UIContentSizeCategoryExtraExtraExtraLarge : @65 };
  }
  NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
  
  NSNumber *imageSize = imageSizeDictionary[userSize];
  self.imageViewHeightConstraint.constant = imageSize.floatValue;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self updateInterfaceForDynamicTypeSize];
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
  
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.thumbnailView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
  [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc
{
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}

- (IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
