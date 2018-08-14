//
//  SQLiteData.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import "SQLiteData.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet+data.h"

#define kDataBaseFile	@"db.sqlite"

@interface SQLiteData()
- (NSString *)databasePath;
@end

@implementation SQLiteData

static SQLiteData *obj = nil;

+ (SQLiteData *)sharedSQLiteData
{
    @synchronized(self)
    {
        if (!obj)
        {
            obj = [[SQLiteData alloc] init];
        }
    }
    
    return obj;
}

- (void)clearDatabaseFile
{
    NSString *databasePath = [self databasePath];
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(success) {
        [fileManager removeItemAtPath:databasePath error:nil];
        return;
    }
}

- (void)checkAndCreateDatabase
{
    NSString *databasePath = [self databasePath];
    
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    success = [fileManager fileExistsAtPath:databasePath];
    
    NSLog(@"checkAndCreateDatabase : %d", success);
    
    if(success)
        return;
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDataBaseFile];
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    NSLog(@"copyItemAtPath : %@", databasePathFromApp);
}

- (NSString *)databasePath
{
    NSArray *documentPaths	= NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDir	= [documentPaths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:kDataBaseFile];
}


- (NSMutableArray *)testData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    
    NSMutableArray *data1 = [[db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name= ?", @"tbl_test"] data];
    
    BOOL isOK = NO;
    
    if ([data1 count] == 0)
    {
        isOK = [db executeUpdate:@"CREATE TABLE 'tbl_test' ('idx' INTEGER PRIMARY KEY  NOT NULL, 'search_text' TEXT, 'date' DATETIME)"];
        
        if (!isOK)
        {
            NSLog(@"create table");
            [db close];
            return nil;
        }
    }
    
    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_test"] data];
    
    [db close];
    
    return data;
}

- (NSMutableArray *)searchData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    
    NSMutableArray *data1 = [[db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name= ?", @"tbl_search"] data];
    
    BOOL isOK = NO;
    
    if ([data1 count] == 0)
    {
        isOK = [db executeUpdate:@"CREATE TABLE 'tbl_search' ('idx' INTEGER PRIMARY KEY  NOT NULL, 'search_text' TEXT, 'date' DATETIME)"];
        
        if (!isOK)
        {
            [db close];
            return nil;
        }
    }
    
    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_search ORDER BY date DESC"] data];
    
    [db close];
    
    return data;
}

- (BOOL)deleteSearchText:(NSUInteger)idx
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    BOOL isOK = [db executeUpdate:@"DELETE FROM tbl_search where idx = ?", [NSString stringWithFormat:@"%d", (int)idx]];
    
    [db close];
    
    return isOK;
}

- (BOOL)deleteAllSearchText
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    BOOL isOK = [db executeUpdate:@"DELETE FROM tbl_search"];
    
    [db close];
    
    return isOK;
}

- (void)addSearchText:(NSString *)search_text
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    [db beginTransaction];
    
    [db executeUpdate:@"DELETE FROM tbl_search where search_text = ?", search_text];
    [db executeUpdate:@"INSERT into tbl_search (search_text,date) values (?,?)" ,
                         search_text,
                         [NSDate date]
                         ];
    [db commit];
    [db close];
}

@end


