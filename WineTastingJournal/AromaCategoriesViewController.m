//
//  AromaCategoriesViewController.m
//  WineTastingJournal
//
//  Created by David Westgate on 9/7/15.
//  Copyright (c) 2015 Refabricants. All rights reserved.
//

#import "AromaCategoriesViewController.h"
#import "AromasViewController.h"
#import "ItemStore.h"
#import "Item.h"

@interface AromaCategoriesViewController ()

@property (strong, nonatomic) NSArray *allTastes;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) NSMutableArray *characteristicsArray;
@property (strong, nonatomic) NSMutableArray *tastesArray;
@property (strong, nonatomic) NSMutableDictionary *characteristicToCategory;
@property (strong, nonatomic) NSMutableSet *selectedCategories;
@property (strong, nonatomic) NSMutableDictionary *selectedAromas;
@property (strong, nonatomic) NSMutableOrderedSet *selectedCharacteristics;

@end

@implementation AromaCategoriesViewController

- (instancetype)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    self.navigationItem.title = NSLocalizedString(@"Aromas", @"AromaCategoriesViewController title");
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

  // test - can I just sort aroma?
  
  NSSortDescriptor *valueDescriptor = [[NSSortDescriptor alloc] initWithKey:@"categoryOrder" ascending:YES];
  NSArray *descriptors = [NSArray arrayWithObject:valueDescriptor];
  _allTastes = [[[ItemStore sharedStore] allTastes] sortedArrayUsingDescriptors:descriptors];

  for (NSManagedObject *aroma in _allTastes) {
    
    if ([_characteristicToCategory objectForKey:[aroma valueForKey:@"characteristic"]] == nil) {
      [_characteristicToCategory setObject:[aroma valueForKey:@"category"] forKey:[aroma valueForKey:@"characteristic"]];
    }
    
    // if the category isn't in our list already, add it - otherwise skip
    if (([_categoriesArray count] < 1) || (([_categoriesArray count] > 0) && (![[_categoriesArray lastObject] isEqualToString:[aroma valueForKey:@"category"]]))) {
      
      [_categoriesArray addObject:[aroma valueForKey:@"category"]];

      NSMutableArray *tastes = [NSMutableArray arrayWithArray:[_allTastes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"category MATCHES %@", [aroma valueForKey:@"category"]]]];
      [_tastesArray addObject:[NSMutableArray arrayWithArray:[[tastes valueForKey:@"taste"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]]];
      
      NSMutableArray *characteristics = [[NSMutableArray alloc] init];
      
      for (NSString *member in [_tastesArray lastObject]) {
        NSArray *characteristic = [NSArray arrayWithArray:[tastes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taste MATCHES %@", member]]];
        if ([characteristic count] > 0) {
          [characteristics addObject:[[characteristic lastObject] valueForKey:@"characteristic"]];
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
  
  AromasViewController *avc = [[AromasViewController alloc] init];
  avc.item = self.item;
  avc.category = [_categoriesArray objectAtIndex:[indexPath row]];
  avc.tastes = [_tastesArray objectAtIndex:[indexPath row]];
  avc.selectedCategories = _selectedCategories;
  avc.selectedAromas = _selectedAromas;
  avc.selectedCharacteristics = _selectedCharacteristics;
  
  avc.characteristics = [_characteristicsArray objectAtIndex:[indexPath row]];
 
  [self.navigationController pushViewController:avc
                                       animated:YES];
}


- (void)readUserSelections {
  _selectedCategories = [[NSMutableSet alloc] init];
  _selectedAromas = [[NSMutableDictionary alloc] init];
  _selectedCharacteristics = [[NSMutableOrderedSet alloc] init];
  
  NSString *string = [self.item.itemAromas stringByReplacingOccurrencesOfString:@"aromas of " withString:@"("];
  string = [string stringByReplacingOccurrencesOfString:@"sells of " withString:@"("];
  string = [string stringByReplacingOccurrencesOfString:@"notes of " withString:@"("];
  string = [string stringByReplacingOccurrencesOfString:@", and " withString:@", "];
  string = [string stringByReplacingOccurrencesOfString:@" and " withString:@", "];
  string = [string stringByReplacingOccurrencesOfString:@";" withString:@");"]; // Can simplify this when finished
  
  NSArray *groupings = [string componentsSeparatedByString: @";"];
  // NSArray *groupings = [self.item.itemAromas componentsSeparatedByString: @");"];
  // groupings = "tropical fruit (banana, pear" , "red fruit (red apple, red cherry)"
  
  if ([[groupings objectAtIndex:0] length] > 0) {
    for (NSString *grouping in groupings) {
      NSMutableOrderedSet *components = [NSMutableOrderedSet orderedSetWithArray:[grouping componentsSeparatedByString:@"("]];
      // components[0] = "tropical fruit" , "banana, pear"
      // components[1] = "red fruit" , "red apple, red cherry)"
      
      components[0] = [components[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
      components[1] = [components[1] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
      
      [_selectedAromas setObject:[NSMutableArray arrayWithArray:[[components objectAtIndex:1] componentsSeparatedByString:@", "]] forKey:[components objectAtIndex:0]];
      // selecedAromas = (key: "tropical fruit" , value: "banana, pear") , (key: "red fruit" , value: "red apple, cherry)")
      [_selectedCharacteristics addObject:[components objectAtIndex:0]];
      // selectedCategoreis = "tropical fruit", "red fruit"
      
      [_selectedCategories addObject:[_characteristicToCategory objectForKey:[components objectAtIndex:0]]];
    }
  }
}


- (Boolean)isAromaSelected:(NSString *)aroma withCharacteristic:(NSString *)characteristic {
  
  Boolean found = NO;
  
  if (!([_selectedAromas objectForKey:characteristic] == nil) && ([[_selectedAromas objectForKey:characteristic] containsObject:aroma])) {
    found = YES;
  }
  return found;
}

@end
