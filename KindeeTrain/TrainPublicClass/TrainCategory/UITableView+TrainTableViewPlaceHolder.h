//
//  UITableView+TrainTableViewPlaceHolder.h
//  SOHUEhr
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年  . All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol TrainTableViewPlaceHolderDelegate <NSObject>

@required
/*!
 @brief  make an empty overlay view when the tableView is empty
 @return an empty overlay view
 */
- (UIView *)makePlaceHolderView;

@optional
/*!
 @brief enable tableView scroll when place holder view is showing, it is disabled by default.
 @attention There is no need to return  NO, it will be NO by default
 @return enable tableView scroll, you can only return YES
 */

- (BOOL)enableScrollWhenPlaceHolderViewShowing;
@end


@interface UITableView (TrainTableViewPlaceHolder)
/*!
 @brief just use this method to replace `reloadData` ,and it can help you to add or remove place holder view automatically
 @attention this method has already reload the tableView,so do not reload tableView any more.
 */
- (void)train_reloadData;

@end
