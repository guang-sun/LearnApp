//
//  TrainBaseModel.h
//   KingnoTrain
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年  Kingno. All rights reserved.
//

#import <Foundation/Foundation.h>

/** SQLite五种数据类型 */
#define SQLTEXT     @"TEXT"
#define SQLINTEGER  @"INTEGER"
#define SQLREAL     @"REAL"
#define SQLBLOB     @"BLOB"
#define SQLNULL     @"NULL"
#define PrimaryKey  @"primary key"

#define primaryDBUser   @"dbUser_id"
//#define valueDBUser   @"dbUser_id"

@interface TrainBaseModel : NSObject


//* 主键 id
//@property (nonatomic, assign)   int        pk_id;
/** 用户 id */
@property (nonatomic, strong)   NSString   *dbUser_id;
/** 列名 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeNames;
/** 列类型 */
@property (retain, readonly, nonatomic) NSMutableArray         *columeTypes;
/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys;

/** 获取所有属性，包括主键 */
+ (NSDictionary *)getAllProperties;

/** 数据库中是否存在表 */
+ (BOOL)isExistInTable;

/** 表中的字段*/
+ (NSArray *)getColumns;


/** 保存或更新
 * 如果根据特定的列数据可以获取记录，则更新，
 * 没有记录，则保存
 */
- (BOOL)saveOrUpdateByColumnName:(NSArray *)columnNameArr;
/** 保存单个数据 */
- (BOOL)save;
/** 批量保存数据 */
+ (void)saveObjectsByColumnName:(NSArray *)columnNameArr andArr:(NSArray *)array;


/** 条件更新单个数据 */
- (BOOL)updateObjectsByColumnName:(NSArray *)columnNameArr;
/** 批量更新数据*/
+ (BOOL)updateObjectsByColumnName:(NSArray *)columnNameArr andArr:(NSArray *)array;



/** 条件删除单个数据 */
- (BOOL)deleteObjectsByColumnName:(NSArray *)columnNameArr;
/** 批量删除数据 */
+ (BOOL)deleteObjectsByColumnName:(NSArray *)columnNameArr andArr:(NSArray *)array;

/** 清空表 */
+ (BOOL)clearTable;

/** 查询全部数据 */
+ (NSArray *)findAll;


+ (instancetype)findFirstWithFormat:(NSString *)format, ...;

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria;

+ (NSArray *)findWithFormat:(NSString *)format, ...;

/** 通过条件查找数据
 * 这样可以进行分页查询 @" WHERE pk > 5 limit 10"
 */
+ (NSArray *)findByCriteria:(NSString *)criteria;
/**
 * 创建表
 * 如果已经创建，返回YES
 */
+ (BOOL)createTable;

#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)getDoNotSaveField;


@end
