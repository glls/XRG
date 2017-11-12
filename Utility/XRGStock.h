/* 
 * XRG (X Resource Graph):  A system resource grapher for Mac OS X.
 * Copyright (C) 2002-2016 Gaucho Software, LLC.
 * You can view the complete license in the LICENSE file in the root
 * of the source tree.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 */

//
//  XRGStock.h
//

#import <Foundation/Foundation.h>
#import "XRGURL.h"

@interface XRGStock : NSObject

@property NSString *label;
@property (nonatomic) NSString *symbol;

@property XRGURL *surl;
@property XRGURL *immediateURL;

@property CGFloat currentPrice;
@property CGFloat lastChange;
/// 52 week high
@property CGFloat highWeekPrice;
/// 52 week low
@property CGFloat lowWeekPrice;

@property BOOL gettingData;
@property BOOL haveGoodURL;
@property BOOL haveGoodStockArray;
@property BOOL haveGoodDisplayData;

@property NSMutableArray *closingPrices;
@property NSMutableArray *volumes;

- (NSString *)symbol;
- (NSString *)label;
- (void)setURL;
- (void)resetData;
- (void)loadData;
- (void)checkForData;
- (void)parseWebData:(NSString *)webData;

- (NSArray *)get1MonthValues:(int)max;
- (NSArray *)get3MonthValues:(int)max;
- (NSArray *)get6MonthValues:(int)max;
- (NSArray *)get12MonthValues:(int)max;
- (NSArray *)getCurrentPriceAndChange;

- (NSString *)priceString;
- (NSString *)changeString;

- (BOOL)errorOccurred;

@end
