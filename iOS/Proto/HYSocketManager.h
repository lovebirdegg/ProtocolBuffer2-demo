//
//  HYSocketManager.h
//  Proto
//
//  Created by liuchao on 2017/5/2.
//  Copyright © 2017年 Will. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYSocketManager : NSObject

+(instancetype) share;
- (BOOL)connect;
- (void)disConnect;

- (void)sendMsg:(NSString *)msg;
- (void)sendData:(NSData *)data;

- (void)pullTheMsg;

@end
