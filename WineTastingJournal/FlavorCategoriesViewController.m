//
//  FlavorCategoriesViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 9/7/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
//

#import "FlavorCategoriesViewController.h"
#import "FlavorsViewController.h"
#import "ItemStore.h"
#import "Item.h"

@interface FlavorCategoriesViewController ()

@property (strong, nonatomic) NSArray *allTastes;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *characteristicsArray;
@property (strong, nonatomic) NSMutableArray *tastesArray;
@property (strong, nonatomic) NSMutableDictionary *characteristicToCategory;
@property (strong, nonatomic) NSMutableSet *selectedCategories;
@property (strong, nonatomic) NSMutableDictionary *selectedFlavors;
@property (strong, nonatomic) NSMutableOrderedSet *selectedCharacteristics;

@end

@implementation FlavorCategoriesViewController

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.navigationItem.title = NSLocalizedString(@"Flavors", @"FlavorCategoriesViewController title");
  }
  return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
  return [super initWithStyle:UITableViewStylePlain];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  
  _allTastes = [[NSArray alloc] init];
  _categoriesArray = [[NSMutableArray alloc] init];
  _characteristicsArray = [[NSMutableArray alloc] init];
  _tastesArray = [[NSMutableArray alloc] init];
  _characteristicToCategory = [[NSMutableDictionary alloc] init];
  
  // test - can I just sort flavor?
  
  NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryOrder" ascending:YES];
  NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
  _allTastes = [[[ItemStore sharedStore] allTastes] sortedArrayUsingDescriptors:descriptors];
  
  for (NSManagedObject *flavor in _allTastes) {
    
    if ([_characteristicToCategory objectForKey:[self flavorsNotAromas:[flavor valueForKey:@"characteristic"]]] == nil) {
      NSLog(@"characteristic = %@", [flavor valueForKey:@"categoryOrder"]);
      NSLog(@"characteristic = %@", [flavor valueForKey:@"category"]);
      NSLog(@"characteristic = %@", [flavor valueForKey:@"characteristic"]);
      NSLog(@"characteristic = %@", [flavor valueForKey:@"taste"]);
      [_characteristicToCategory setObject:[flavor valueForKey:@"category"] forKey:[self flavorsNotAromas:[flavor valueForKey:@"characteristic"]]];
    }
    
    // if the category isn't in our list already, add it - otherwise skip
    if (([_categoriesArray count] < 1) || (([_categoriesArray count] > 0) && (![[_categoriesArray lastObject] isEqualToString:[flavor valueForKey:@"category"]]))) {
      
      [_categoriesArray addObject:[flavor valueForKey:@"category"]];
      
      NSMutableArray *tastes = [NSMutableArray arrayWithArray:[_allTastes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category MATCHES %@", [flavor valueForKey:@"category"]]]];
      [_tastesArray addObject:[NSMutableArray arrayWithArray:[[tastes valueForKey:@"taste"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]]];
      
      NSMutableArray *characteristics = [[NSMutableArray alloc] init];
      
      for (NSString *member in [_tastesArray lastObject]) {
        NSArray *characteristic = [NSArray arrayWithArray:[tastes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taste MATCHES %@", member]]];
        if ([characteristic count] > 0) {
          [characteristics addObject:[self flavorsNotAromas:[[characteristic lastObject] valueForKey:@"characteristic"]]];
        }
      }
      [_characteristicsArray addObject:[NSArray arrayWithArray:characteristics]];
      
    }
  }
  
  [self readUserSelections];
  
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"UITableViewCell"];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return  [_tastesArray count];
  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
  
  Boolean found = NO;
  
  // floral (lavendar, rose); nutty (almonds, chocolate)
  
  if ([_selectedCategories containsObject:[_categoriesArray objectAtIndex:[indexPath row]]]) {
    found = YES;
  }
  
  // Set font to bold and itallic
  UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
  UIFontDescriptor *changedFontDescriptor;
  NSDictionary *attributes;
  uint32_t existingTraitsWithNewTrait;
  
  if (found) {
    existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] | UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic;
  } else {
    existingTraitsWithNewTrait = [fontDescriptor symbolicTraits] & ~UIFontDescriptorTraitBold & ~UIFontDescriptorTraitItalic;
  }
  
  changedFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:existingTraitsWithNewTrait];
  
  UIFont *updatedFont = [UIFont fontWithDescriptor:changedFontDescriptor size:0.0];
  
  attributes = @{ NSFontAttributeName : updatedFont };
  // end setting to bold and itallic
  
  NSMutableAttributedString *category = [[NSMutableAttributedString alloc] initWithString:[_categoriesArray objectAtIndex:[indexPath row]] attributes:attributes];
  
  cell.textLabel.attributedText = category;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  FlavorsViewController *avc = [[FlavorsViewController alloc] init];
  avc.item = self.item;
  avc.category = [_categoriesArray objectAtIndex:[indexPath row]];
  avc.tastes = [_tastesArray objectAtIndex:[indexPath row]];
  avc.selectedCategories = _selectedCategories;
  avc.selectedFlavors = _selectedFlavors;
  avc.selectedCharacteristics = _selectedCharacteristics;
  
  avc.characteristics = [_characteristicsArray objectAtIndex:[indexPath row]];
  
  [self.navigationController pushViewController:avc
                                       animated:YES];
}


- (void)readUserSelections {
  _selectedCategories = [[NSMutableSet alloc] init];
  _selectedFlavors = [[NSMutableDictionary alloc] init];
  _selectedCharacteristics = [[NSMutableOrderedSet alloc] init];
  
  NSString *string = self.item.itemFlavors;
  
  // First make any "common descriptors" look like regular flavors
  if ((string.length > 0) && (![string containsString:@"of"] || [string rangeOfString:@";"].location < [string rangeOfString:@"of"].location)) {
    
    string = [string stringByReplacingCharactersInRange:[string rangeOfString:@" flavors"] withString:@""];
    string = [NSString stringWithFormat:@"General flavors of %@", [string lowercaseString]];
    
  }
  
  string = [string stringByReplacingOccurrencesOfString:@"of " withString:@"("];
  string = [string stringByReplacingOccurrencesOfString:@", and " withString:@", "];
  string = [string stringByReplacingOccurrencesOfString:@" and " withString:@", "];
  
  NSArray *groupings = [string componentsSeparatedByString: @";"];
  // groupings = "tropical fruit (banana, pear" , "red fruit (red apple, red cherry)"
  
  if ([[groupings objectAtIndex:0] length] > 0) {
    for (NSString *grouping in groupings) {
      NSMutableOrderedSet *components = [NSMutableOrderedSet orderedSetWithArray:[grouping componentsSeparatedByString:@"("]];
      // components[0] = "tropical fruit" , "banana, pear"
      // components[1] = "red fruit" , "red apple, red cherry)"
      
      components[0] = [self uncapitalize:[components[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
      components[1] = [components[1] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
      
      [_selectedFlavors setObject:[NSMutableArray arrayWithArray:[[components objectAtIndex:1] componentsSeparatedByString:@", "]] forKey:[components objectAtIndex:0]];
      // selecedFlavors = (key: "tropical fruit" , value: "banana, pear") , (key: "red fruit" , value: "red apple, cherry)")
      [_selectedCharacteristics addObject:[components objectAtIndex:0]];
      // selectedCategoreis = "tropical fruit", "red fruit"
      
      [_selectedCategories addObject:[_characteristicToCategory objectForKey:[components objectAtIndex:0]]];
    }
  }
}


- (Boolean)isFlavorSelected:(NSString *)flavor withCharacteristic:(NSString *)characteristic {
  
  Boolean found = NO;
  
  if (!([_selectedFlavors objectForKey:characteristic] == nil) && ([[_selectedFlavors objectForKey:characteristic] containsObject:flavor])) {
    found = YES;
  }
  return found;
}


-(NSString *)uncapitalize:(NSString *)string {
  return [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] lowercaseString]];
}


-(NSString *)flavorsNotAromas:(NSString *)string {
  string = [string stringByReplacingOccurrencesOfString:@"aromas or " withString:@""];
  return string;
}

@end
