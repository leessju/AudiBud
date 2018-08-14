//
//  FMResultSet+data.m
//  hsm_ios
//
//  Created by James Lee on 2015. 3. 27..
//  Copyright (c) 2015년 James Lee. All rights reserved.
//

#import "FMResultSet+data.h"

@implementation FMResultSet (data)


- (NSMutableArray *)data
{
	NSMutableArray *dataT = [[NSMutableArray alloc] init];
	
	while ([self next])
	{
		NSMutableDictionary *dic = [NSMutableDictionary dictionary];
		
		for (int i = 0; i < [self columnCount]; i++)
		{
            if ([self stringForColumnIndex:i])
                [dic setObject:[self stringForColumnIndex:i] forKey:[self columnNameForIndex:i]];
            else
                [dic setObject:[NSNull null] forKey:[self columnNameForIndex:i]];
		}
		
		[dataT addObject:dic];
    }
	
	[self close];
	
	return dataT;
}

@end
