//
//  SQLiteData.h
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQLiteData : NSObject
{
    
}

+ (SQLiteData *)sharedSQLiteData;
- (void)clearDatabaseFile;
- (void)checkAndCreateDatabase;


- (NSMutableArray *)searchData;
- (NSMutableArray *)testData;
- (BOOL)deleteSearchText:(NSUInteger)idx;
- (BOOL)deleteAllSearchText;
- (void)addSearchText:(NSString *)search_text;

@end
