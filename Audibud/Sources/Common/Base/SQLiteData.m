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


- (void)dropAndcreateTable
{
    NSString *a = @"PRAGMA foreign_keys = false;DROP TABLE IF EXISTS 'tbl_file_data'; CREATE TABLE 'tbl_file_data' ( 'f_idx' integer NOT NULL, 'f_a' TEXT, 'download_yn' TEXT, 'download_date' DATE, PRIMARY KEY ('f_idx'));PRAGMA foreign_keys = true;";
    
    NSString *b = @"PRAGMA foreign_keys = false; DROP TABLE IF EXISTS 'tbl_practice'; CREATE TABLE 'tbl_practice' ( 'p_idx' integer NOT NULL, 'f_idx' integer, 'seq' integer, 'start_time' real, 'end_time' real, 'txt_kor' TEXT, 'txt_eng' TEXT, PRIMARY KEY ('p_idx')); PRAGMA foreign_keys = true;";
    
    NSString *c = @"PRAGMA foreign_keys = false; DROP TABLE IF EXISTS 'tbl_user_log'; CREATE TABLE 'tbl_user_log' ( 'p_idx' integer, 'view_date' DATE); PRAGMA foreign_keys = true;";
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    
    BOOL isOK;
    
    isOK = [db executeUpdate:a];
    NSLog(@"create table %@ => %d", @"tbl_file_data", isOK);
    isOK = NO;
    
    isOK = [db executeUpdate:b];
    NSLog(@"create table %@ => %d", @"tbl_practice", isOK);
    isOK = NO;
    
    isOK = [db executeUpdate:c];
    NSLog(@"create table %@ => %d", @"tbl_user_log", isOK);
    isOK = NO;
    
    [db close];
}

- (BOOL)addFileData:(NSDictionary *)dic
{
    if(dic)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
        [db open];
        
        NSMutableArray *data1 = [[db executeQuery:@"SELECT f_idx FROM tbl_file_data WHERE f_idx = ?", dic[@"f_idx"] ] data];
        
        if ([data1 count] > 0)
        {
            [db close];
            return NO;
        }
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        
        BOOL isOK = [db executeUpdate:@"INSERT INTO tbl_file_data (f_idx, f_type_idx, f_a, download_yn, download_date) VALUES (?,?,?,?,?)", dic[@"f_idx"], dic[@"f_type_idx"], dic[@"f_a"], @"N", dateString];
        
        [db close];
        return isOK;
    }
    
    return NO;
}

- (BOOL)updateFileDataAtDownloadYN:(NSUInteger)f_idx
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
    
    BOOL isOK = [db executeUpdate:@"UPDATE tbl_file_data SET download_yn = ?, download_date = ? WHERE f_idx = ?", @"Y", dateString, @(f_idx).stringValue ];
    
    [db close];
    return isOK;
}

- (BOOL)addPractice:(NSDictionary *)dic
{
    if(dic)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
        [db open];
        
        BOOL isOK = [db executeUpdate:@"INSERT INTO tbl_practice (p_idx,f_idx,seq,start_time,end_time,txt_kor,txt_eng) VALUES (?,?,?,?,?,?,?)", dic[@"p_idx"], dic[@"f_idx"], dic[@"seq"], dic[@"start_time"], dic[@"end_time"], dic[@"txt_kor"], dic[@"txt_eng"] ];
        
        [db close];
        return isOK;
    }
    
    return NO;
}

- (BOOL)removePracticeByFileIdx:(NSUInteger)f_idx
{
    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
    [db open];
    
    BOOL isOK = [db executeUpdate:@"DELETE FROM tbl_practice WHERE f_idx = ?", @(f_idx).stringValue];
    
    [db close];
    return isOK;
}

- (BOOL)addUesrLog:(NSDictionary *)dic
{
    if(dic)
    {
        FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
        [db open];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *dateString=[dateFormat stringFromDate:[NSDate date]];
        
        BOOL isOK = [db executeUpdate:@"INSERT INTO tbl_user_log (p_idx,view_date) VALUES (?,?)", dic[@"p_idx"], dateString ];
        
        [db close];
        return isOK;
    }
    
    return NO;
}

- (NSMutableArray *)fileData
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_file_data"] data];
    [db close];
    
    return data;
}

- (NSDictionary *)fileDataByFileIdx:(NSUInteger)f_idx
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_file_data WHERE f_idx = ?", @(f_idx).stringValue ] data];
    [db close];
    
    if(data.count > 0)
    {
        return data[0];
    }
    
    return nil;
}

- (NSMutableArray *)practiceFileIdx:(NSUInteger)f_idx
{
    return [self practiceFileIdx:f_idx withRandomYN:@"N"];
}

- (NSMutableArray *)practiceFileIdx:(NSUInteger)f_idx withRandomYN:(NSString *)random_yn
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    
    NSString *q = @"";
    
    if([random_yn isEqualToString:@"Y"])
    {
        q = [NSString stringWithFormat:@"SELECT * FROM tbl_practice WHERE f_idx = %@ ORDER BY RANDOM()", @(f_idx).stringValue];
    }
    else
    {
        q = [NSString stringWithFormat:@"SELECT * FROM tbl_practice WHERE f_idx = %@", @(f_idx).stringValue];
    }
    
    NSMutableArray *data = [[db executeQuery:q] data];
    [db close];
    
    return data;
}

- (NSMutableArray *)userLog
{
    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
    [db open];
    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_user_log"] data];
    [db close];
    
    return data;
}

//- (NSMutableArray *)testData
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
//    [db open];
//    
//    NSMutableArray *data1 = [[db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name= ?", @"tbl_test"] data];
//    
//    BOOL isOK = NO;
//    
//    if ([data1 count] == 0)
//    {
//        isOK = [db executeUpdate:@"CREATE TABLE 'tbl_test' ('idx' INTEGER PRIMARY KEY  NOT NULL, 'search_text' TEXT, 'date' DATETIME)"];
//        
//        if (!isOK)
//        {
//            NSLog(@"create table");
//            [db close];
//            return nil;
//        }
//    }
//    
//    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_test"] data];
//    
//    [db close];
//    
//    return data;
//}

//- (NSMutableArray *)searchData
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:[self databasePath]];
//    [db open];
//
//    NSMutableArray *data1 = [[db executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name= ?", @"tbl_search"] data];
//
//    BOOL isOK = NO;
//
//    if ([data1 count] == 0)
//    {
//        isOK = [db executeUpdate:@"CREATE TABLE 'tbl_search' ('idx' INTEGER PRIMARY KEY  NOT NULL, 'search_text' TEXT, 'date' DATETIME)"];
//
//        if (!isOK)
//        {
//            [db close];
//            return nil;
//        }
//    }
//
//    NSMutableArray *data = [[db executeQuery:@"SELECT * FROM tbl_search ORDER BY date DESC"] data];
//
//    [db close];
//
//    return data;
//}

//- (BOOL)deleteSearchText:(NSUInteger)idx
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
//    [db open];
//
//    BOOL isOK = [db executeUpdate:@"DELETE FROM tbl_search where idx = ?", [NSString stringWithFormat:@"%d", (int)idx]];
//
//    [db close];
//
//    return isOK;
//}
//
//- (BOOL)deleteAllSearchText
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
//    [db open];
//
//    BOOL isOK = [db executeUpdate:@"DELETE FROM tbl_search"];
//
//    [db close];
//
//    return isOK;
//}
//
//- (void)addSearchText:(NSString *)search_text
//{
//    FMDatabase *db = [FMDatabase databaseWithPath:self.databasePath];
//    [db open];
//
//    [db beginTransaction];
//
//    [db executeUpdate:@"DELETE FROM tbl_search where search_text = ?", search_text];
//    [db executeUpdate:@"INSERT into tbl_search (search_text,date) values (?,?)" ,
//                         search_text,
//                         [NSDate date]
//                         ];
//    [db commit];
//    [db close];
//}

@end


