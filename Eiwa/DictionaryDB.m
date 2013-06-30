//
//  DictionaryDB.m
//  EIWA
//  SQLiteから意味を検索
//  Created by 菅澤 英司 on 2012/12/25.
//  Copyright (c) 2012年 菅澤 英司. All rights reserved.
//

#import "DictionaryDB.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Word.h"

#define DB_FILE_NAME @"ejdict.sqlite3"


@interface DictionaryDB()
@property (nonatomic, copy) NSString* dbPath; //データベース　ファイルへのパス

- (FMDatabase*)getConnection;
+ (NSString*)getDbFilePath;
@end


@implementation DictionaryDB

@synthesize dbPath;

//指定された文字列に一致する単語リストを返す
- (NSMutableArray *)searchWords:(NSString *)searchWord
{
	FMDatabase* db = [self getConnection];
    
	if(![db open]){NSLog(@"DB open failed..");}; //DBへ接続
   
    [db setShouldCacheStatements:YES];
    NSLog(@"DB OPEN..%@",db);

	
    NSString *sql =
        [NSString stringWithFormat:
         @"select item_id,word,mean,level from items where word COLLATE NOCASE like '%@%@' order by level desc limit 50;"
           ,searchWord,@"%"];
    
    NSLog(@"sql..%@",sql);
   	
    FMResultSet*  results = [db executeQuery:sql];
    
    NSMutableArray* words = [[NSMutableArray alloc] initWithCapacity:0];
	
	while( [results next] )
	{
		Word* word = [[Word alloc] init];
		word.itemId   = [results intForColumnIndex:0];
		word.word     = [results stringForColumnIndex:1];
		word.mean     = [results stringForColumnIndex:2];
		word.level    = [results intForColumnIndex:3];

        //NSLog(@"HIT WORD..%@,%@",word.word,word.mean);

		[words addObject:word];
	}
	
	[db close];
	
	return words;
}



//データベース接続を取得
- (FMDatabase *)getConnection
{
    BOOL success;
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
	if( dbPath == nil )
	{
		dbPath =  [DictionaryDB getDbFilePath];
	}
    NSLog(@"dbpath:%@",dbPath);
    
    success = [fm fileExistsAtPath:dbPath];
    
    if(!success){
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DB_FILE_NAME];
        success = [fm copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if(!success){
            NSLog(@"DB ERROR:%@",[error localizedDescription]);
        }
    }
        
	return [FMDatabase databaseWithPath:dbPath];
}

//データベース ファイルのパスを取得します。
+ (NSString*)getDbFilePath
{
	NSArray*  paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
	NSString* dir   = [paths objectAtIndex:0];
	
	return [dir stringByAppendingPathComponent:DB_FILE_NAME];
}

@end
