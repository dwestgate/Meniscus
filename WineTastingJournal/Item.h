//
//  Item.h
//  WineTastingJournal
//
//  Created by David Westgate on 6/22/15.
//  Copyright (c) 2015 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Item : NSManagedObject

@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, strong) NSString * itemNotes;
@property (nonatomic, strong) NSString * itemClarity;
@property (nonatomic) int itemClarityValue;
@property (nonatomic, strong) NSString * itemColor;
@property (nonatomic) int itemColorValue;
@property (nonatomic, strong) NSString * itemColorIntensity;
@property (nonatomic) int itemColorIntensityValue;
@property (nonatomic, strong) NSString * itemColorShade;
@property (nonatomic) int itemColorShadeValue;
@property (nonatomic, strong) NSString * itemPetillance;
@property (nonatomic) int itemPetillanceValue;
@property (nonatomic, strong) NSString * itemViscosity;
@property (nonatomic) int itemViscosityValue;
@property (nonatomic, strong) NSString * itemSediment;
@property (nonatomic) int itemSedimentValue;
@property (nonatomic, strong) NSString * itemCondition;
@property (nonatomic) int itemConditionSliderValue;
@property (nonatomic, strong) NSString * itemAromaIntensity;
@property (nonatomic) int itemAromaIntensityValue;
@property (nonatomic, strong) NSString * itemAromas;
@property (nonatomic, strong) NSString * itemDevelopment;
@property (nonatomic) int itemDevelopmentValue;
@property (nonatomic, strong) NSString * itemSweetness;
@property (nonatomic) int itemSweetnessValue;
@property (nonatomic, strong) NSString * itemAcidity;
@property (nonatomic) int itemAcidityValue;
@property (nonatomic, strong) NSString * itemTannin;
@property (nonatomic) int itemTanninValue;
@property (nonatomic, strong) NSString * itemAlchohol;
@property (nonatomic) int itemAlchoholValue;
@property (nonatomic, strong) NSString * itemBody;
@property (nonatomic) int itemBodyValue;
@property (nonatomic, strong) NSString * itemFlavorIntensity;
@property (nonatomic) int itemFlavorIntensityValue;
@property (nonatomic, strong) NSString * itemFlavors;
@property (nonatomic, strong) NSString * itemBalance;
@property (nonatomic, strong) NSString * itemMousse;
@property (nonatomic) int itemMousseValue;
@property (nonatomic, strong) NSString * itemFinish;
@property (nonatomic) int itemFinishValue;
@property (nonatomic, strong) NSString * itemQuality;
@property (nonatomic) int itemQualityValue;
@property (nonatomic, strong) NSString * itemReadiness;
@property (nonatomic, strong) NSString * itemWinemaker;
@property (nonatomic, strong) NSString * itemVintage;
@property (nonatomic, strong) NSString * itemAppellation;
@property (nonatomic) int itemPrice;
@property (nonatomic, strong) NSDate * itemTastedOn;

/*
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic, strong) NSString * vintage;
*/

@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSString * itemKey;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
