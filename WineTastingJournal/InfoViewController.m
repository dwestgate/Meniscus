//
//  InfoViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 10/18/15.
//  Copyright © 2015 Refabricants. All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@end

@implementation InfoViewController

- (instancetype)init {
  self = [super init];
  
  if (self) {
    self.restorationIdentifier = NSStringFromClass([self class]);
    self.restorationClass = [self class];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelItem;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSURL *htmlString = [[NSBundle mainBundle]
                       URLForResource: @"info" withExtension:@"html"];
  
  self.infoTextView.attributedText = [[NSAttributedString alloc] initWithURL:htmlString options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
  // Load text
  // [self.infoTextView.textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"info" withExtension:@"html"] usedEncoding:NULL error:NULL]];
  
  // Enable hyphenation
  self.infoTextView.layoutManager.hyphenationFactor = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
