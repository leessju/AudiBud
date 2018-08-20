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
- (void)dropAndcreateTable;

- (BOOL)addFileData:(NSDictionary *)dic;
- (BOOL)updateFileDataAtDownloadYN:(NSUInteger)f_idx;
- (BOOL)addPractice:(NSDictionary *)dic;
- (BOOL)removePracticeByFileIdx:(NSUInteger)f_idx;
- (BOOL)addUesrLog:(NSDictionary *)dic;
- (NSMutableArray *)fileData;
- (NSDictionary *)fileDataByFileIdx:(NSUInteger)f_idx;
- (NSMutableArray *)fileDataByFileTypeIdx:(NSUInteger)f_type_idx;
- (NSMutableArray *)practiceFileIdx:(NSUInteger)f_idx;
- (NSMutableArray *)practiceFileIdx:(NSUInteger)f_idx withRandomYN:(NSString *)random_yn;
- (NSMutableArray *)userLog;
- (NSDictionary *)latestInfo;

//- (NSMutableArray *)searchData;
//- (NSMutableArray *)testData;
//- (BOOL)deleteSearchText:(NSUInteger)idx;
//- (BOOL)deleteAllSearchText;
//- (void)addSearchText:(NSString *)search_text;

@end
