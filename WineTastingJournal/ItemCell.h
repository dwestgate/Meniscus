//
//  ItemCell.h
//  WineTastingJournal
//
//  Created by David Westgate on 6/19/15.
//  Copyright (c) 2015 David Westgate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;
@property (copy, nonatomic) void (^actionBlock)(void);

@end
