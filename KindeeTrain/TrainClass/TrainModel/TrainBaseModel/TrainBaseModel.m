//
//  TrainBaseModel.m
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import "TrainBaseModel.h"
#import <objc/runtime.h>
#import "TrainDBHelper.h"


@implementation TrainBaseModel

#pragma mark - override method
+ (void)initialize
{
    if (self != [TrainBaseModel self]) {
        [self createTable];
    }
}

-(NSString *)dbUser_id{
    if (!_dbUser_id) {
        
        if (TrainUser.user_id && ![TrainUser.user_id isEqualToString:@""]) {
            _dbUser_id = TrainUser.user_id;
        }
    }
    return _dbUser_id;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [self.class getAllProperties];
        _columeNames = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
        _columeTypes = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    }
    
    return self;
}

#pragma mark - base method
/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    
    NSArray *theTransients = [[self class] getDoNotSaveField];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        /*
         各种符号对应类型，部分类型在新版SDK中有所变化，如long 和long long
         c char         C unsigned char
         i int          I unsigned int
         l long         L unsigned long
         s short        S unsigned short
         d double       D unsigned double
         f float        F unsigned float
         q long long    Q unsigned long long
         B BOOL
         @ 对象类型 //指针 对象类型 如NSString 是@“NSString”
         
         
         64位下long 和long long 都是Tq
         SQLite 默认支持五种数据类型TEXT、INTEGER、REAL、BLOB、NULL
         因为在项目中用的类型不多，故只考虑了少数类型
         */
        if ([propertyType hasPrefix:@"T@\"NSString\""]) {
            [proTypes addObject:SQLTEXT];
        } else if ([propertyType hasPrefix:@"T@\"NSData\""]) {
            [proTypes addObject:SQLBLOB];
        } else if ([propertyType hasPrefix:@"Ti"]||[propertyType hasPrefix:@"TI"]||[propertyType hasPrefix:@"Ts"]||[propertyType hasPrefix:@"TS"]||[propertyType hasPrefix:@"TB"]||[propertyType hasPrefix:@"Tq"]||[propertyType hasPrefix:@"TQ"]) {
            [proTypes addObject:SQLINTEGER];
        } else {
            [proTypes addObject:SQLREAL];
        }
        
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 获取所有属性，包含主键 */
+ (NSDictionary *)getAllProperties
{
    NSDictionary *dict = [self.class getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:primaryDBUser];
    [proTypes addObject:[NSString stringWithFormat:@"%@",SQLTEXT]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable
{
    __block BOOL res = NO;
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        res = [db tableExists:tableName];
    }];
    return res;
}

/** 获取列名 */
+ (NSArray *)getColumns
{
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    NSMutableArray *columns = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
    }];
    return [columns copy];
}

/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable
{
    __block BOOL res = YES;
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *columeAndType = [self.class getColumeAndTypeString];
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
        if (![db executeUpdate:sql]) {
            res = NO;
            *rollback = YES;
            return;
        };
        
        NSMutableArray *columns = [NSMutableArray array];
        FMResultSet *resultSet = [db getTableSchema:tableName];
        while ([resultSet next]) {
            NSString *column = [resultSet stringForColumn:@"name"];
            [columns addObject:column];
        }
        NSDictionary *dict = [self.class getAllProperties];
        NSArray *properties = [dict objectForKey:@"name"];
        NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
        //过滤数组
        NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];
        for (NSString *column in resultArray) {
            NSUInteger index = [properties indexOfObject:column];
            NSString *proType = [[dict objectForKey:@"type"] objectAtIndex:index];
            NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
            NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",NSStringFromClass(self.class),fieldSql];
            if (![db executeUpdate:sql]) {
                res = NO;
                *rollback = YES;
                return ;
            }
        }
    }];
    
    return res;
}


//- (BOOL)saveOrUpdate
//{
//    id primaryValue = [self valueForKey:primaryId];
//    if ([primaryValue intValue] <= 0) {
//        return [self save];
//    }
//
//    return [self update];
//}


-(NSString *)getSQLStrByColumnName:(NSArray *)columnNameArr {
    
    NSMutableString   *SQLstr = [NSMutableString string];
    
    [columnNameArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [SQLstr appendFormat:@"%@ = %@",obj ,[self valueForKey:obj]];
        }else{
            [SQLstr appendFormat:@" and %@ = %@",obj ,[self valueForKey:obj]];
            
        }
    }];
    
    return SQLstr;
    
}

- (BOOL)saveOrUpdateByColumnName:(NSArray *)columnNameArr
{
    NSString  *sqlStr = [self getSQLStrByColumnName:columnNameArr];
    id record = [self.class findFirstByCriteria:sqlStr];
    if (record) {
        
        return [self updateObjectsByColumnName:columnNameArr];
        
    }else{
        return [self save];
    }
}

- (BOOL)save
{
    NSString *tableName = NSStringFromClass(self.class);
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    for (int i = 0; i < self.columeNames.count; i++) {
        NSString *proname = [self.columeNames objectAtIndex:i];
        
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        id value = [self valueForKey:proname];
        if (!value) {
            value = @"";
        }
        [insertValues addObject:value];
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        NSLog(res?@"插入成功":@"插入失败");
    }];
    return res;
}

/** 批量保存用户对象 */
+ (void)saveObjectsByColumnName:(NSArray *)columnNameArr andArr:(NSArray *)array
{
    //判断是否是JKBaseModel的子类
    for (TrainBaseModel *model in array) {
        if (![model isKindOfClass:[TrainBaseModel class]]) {
            return ;
        }
    }
    for (TrainBaseModel *model in array) {
        
        [model saveOrUpdateByColumnName:columnNameArr];
        
    }
    
    
    //    __block BOOL res = YES;
    //    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    //    // 如果要支持事务
    //    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
    //        for (TrainBaseModel *model in array) {
    //            NSString *tableName = NSStringFromClass(model.class);
    //            NSMutableString *keyString = [NSMutableString string];
    //            NSMutableString *valueString = [NSMutableString string];
    //            NSMutableArray *insertValues = [NSMutableArray  array];
    //            for (int i = 0; i < model.columeNames.count; i++) {
    //                NSString *proname = [model.columeNames objectAtIndex:i];
    //
    //                [keyString appendFormat:@"%@,", proname];
    //                [valueString appendString:@"?,"];
    //                id value = [model valueForKey:proname];
    //                if (!value) {
    //                    value = @"";
    //                }
    //                [insertValues addObject:value];
    //            }
    //            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    //            [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    //
    //            NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
    //            BOOL flag = [db executeUpdate:sql withArgumentsInArray:insertValues];
    //
    //            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = %@ and %@ = %@;", tableName, keyString,format,[self valueForKey:format], primaryDBUser, TrainUser.user_id];
    //            res = [db executeUpdate:sql withArgumentsInArray:updateValues];
    //            NSLog(res?@"更新成功":@"更新失败");
    //
    //            NSLog(flag?@"插入成功":@"插入失败");
    //            if (!flag) {
    //                res = NO;
    //                *rollback = YES;
    //                return;
    //            }
    //        }
    //    }];
}

/** 更新单个对象 */
//- (BOOL)update
//{
//    return [self updateObjectsWithFormat:@""];
//}

- (BOOL)updateObjectsByColumnName:(NSArray *)columnNameArr{
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < self.columeNames.count; i++) {
            NSString *proname = [self.columeNames objectAtIndex:i];
            
            [keyString appendFormat:@" %@=?,", proname];
            id value = [self valueForKey:proname];
            if (!value) {
                value = @"";
            }
            [updateValues addObject:value];
        }
        NSLog(@"%@",[self class]);
        
        //删除最后那个逗号
        NSString  *sqlStr = [self getSQLStrByColumnName:columnNameArr];
        NSLog(@"%@",sqlStr);
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@  and %@ = %@;", tableName, keyString,sqlStr, primaryDBUser, TrainUser.user_id];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        NSLog(res?@"更新成功":@"更新失败");
    }];
    return res;
}

/** 批量更新用户对象*/
+ (BOOL)updateObjectsByColumnName:(NSArray *)columnNameArr andArr:(NSArray *)array
{
    for (TrainBaseModel *model in array) {
        if (![model isKindOfClass:[TrainBaseModel class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    // 如果要支持事务
    
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (TrainBaseModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            for (int i = 0; i < model.columeNames.count; i++) {
                NSString *proname = [model.columeNames objectAtIndex:i];
                
                [keyString appendFormat:@" %@=?,", proname];
                id value = [model valueForKey:proname];
                if (!value) {
                    value = @"";
                }
                [updateValues addObject:value];
            }
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString  *sqlStr = [model getSQLStrByColumnName:columnNameArr];
            
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ and %@=%@;", tableName, keyString,sqlStr,primaryDBUser,TrainUser.user_id];
            BOOL flag = [db executeUpdate:sql withArgumentsInArray:updateValues];
            NSLog(flag?@"更新成功":@"更新失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    
    return res;
}

/** 删除单个对象 */
- (BOOL)deleteObjectsByColumnName:(NSArray *)columnNameArr{
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString  *sqlStr = [self getSQLStrByColumnName:columnNameArr];
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@  and %@ = %@",tableName,sqlStr,primaryDBUser,TrainUser.user_id];
        res = [db executeUpdate:sql];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    return res;
}


/** 批量删除用户对象 */
+ (BOOL)deleteObjectsByColumnName:(NSArray *)columnNameArr andArr:(NSArray *)array
{
    for (TrainBaseModel *model in array) {
        if (![model isKindOfClass:[TrainBaseModel class]]) {
            return NO;
        }
    }
    
    __block BOOL res = YES;
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    // 如果要支持事务
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (TrainBaseModel *model in array) {
            NSString *tableName = NSStringFromClass(model.class);
            NSString  *sqlStr = [model getSQLStrByColumnName:columnNameArr];
            
            NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@  and %@ = %@",tableName,sqlStr,primaryDBUser,TrainUser.user_id];
            BOOL flag = [db executeUpdate:sql ];
            NSLog(flag?@"删除成功":@"删除失败");
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}


/** 清空表 */
+ (BOOL)clearTable
{
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",tableName];
        res = [db executeUpdate:sql];
        NSLog(res?@"清空成功":@"清空失败");
    }];
    return res;
}

/** 查询全部数据 */
+ (NSArray *)findAll
{
    NSLog(@"jkdb---%s",__func__);
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@",tableName,primaryDBUser, TrainUser.user_id];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            TrainBaseModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else if ([columeType isEqualToString:SQLBLOB]) {
                    [model setValue:[resultSet dataForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

+ (instancetype)findFirstWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self findFirstByCriteria:criteria];
}

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria
{
    NSArray *results = [self.class findByCriteria:criteria];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}



+ (NSArray *)findWithFormat:(NSString *)format, ...
{
    va_list ap;
    va_start(ap, format);
    NSString *criteria = [[NSString alloc] initWithFormat:format locale:[NSLocale currentLocale] arguments:ap];
    va_end(ap);
    
    return [self findByCriteria:criteria];
}

/** 通过条件查找数据 */
+ (NSArray *)findByCriteria:(NSString *)criteria
{
    TrainDBHelper *jkDB = [TrainDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ and %@ = %@",tableName,criteria,primaryDBUser,TrainUser.user_id];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            TrainBaseModel *model = [[self.class alloc] init];
            for (int i=0; i< model.columeNames.count; i++) {
                NSString *columeName = [model.columeNames objectAtIndex:i];
                NSString *columeType = [model.columeTypes objectAtIndex:i];
                if ([columeType isEqualToString:SQLTEXT]) {
                    [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
                } else if ([columeType isEqualToString:SQLBLOB]) {
                    [model setValue:[resultSet dataForColumn:columeName] forKey:columeName];
                } else {
                    [model setValue:[NSNumber numberWithLongLong:[resultSet longLongIntForColumn:columeName]] forKey:columeName];
                }
            }
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    
    return users;
}

#pragma mark - util method
+ (NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class getAllProperties];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[proTypes objectAtIndex:i]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}

- (NSString *)description
{
    NSString *result = @"";
    NSDictionary *dict = [self.class getAllProperties];
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    for (int i = 0; i < proNames.count; i++) {
        NSString *proName = [proNames objectAtIndex:i];
        id  proValue = [self valueForKey:proName];
        result = [result stringByAppendingFormat:@"%@:%@\n",proName,proValue];
    }
    return result;
}

#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)getDoNotSaveField
{
    return [NSArray array];
}


@end

