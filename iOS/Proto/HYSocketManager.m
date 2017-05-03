//
//  HYSocketManager.m
//  Proto
//
//  Created by liuchao on 2017/5/2.
//  Copyright © 2017年 Will. All rights reserved.
//

#import "HYSocketManager.h"
#import "GCDAsyncSocket.h"
#import "ProtocolBuffers.h"
#import "Person.pb.h"

static  NSString * Khost = @"127.0.0.1";
static const uint16_t Kport = 6969;

@interface HYSocketManager()<GCDAsyncSocketDelegate>{

    GCDAsyncSocket *gcdSocket;

}
@end

@implementation HYSocketManager

+ (instancetype) share{
    static dispatch_once_t onceToken;
    static HYSocketManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
        [instance initSocket];
    });
    return instance;
}

- (void) initSocket{
    gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
- (BOOL)connect{
    return [gcdSocket connectToHost:Khost onPort:Kport error:nil];
}
- (void)disConnect{
    [gcdSocket disconnect];
}

- (void)sendMsg:(NSString *)msg{
    
    NSData *data  = [msg dataUsingEncoding:NSUTF8StringEncoding];
    //第二个参数，请求超时时间
    [gcdSocket writeData:data withTimeout:-1 tag:110];
}

- (void)sendData:(NSData *)data{
    
    //第二个参数，请求超时时间
    [gcdSocket writeData:data withTimeout:-1 tag:110];
}

- (void)pullTheMsg{
        [gcdSocket readDataWithTimeout:-1 tag:110];
}
#pragma mark - GCDAsyncSocketDelegate
//连接成功调用
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功,host:%@,port:%d",host,port);
    
    [self pullTheMsg];
    
    //心跳写在这...
}

//断开连接的时候调用
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err
{
    NSLog(@"断开连接,host:%@,port:%d",sock.localHost,sock.localPort);
    //断线重连写在这...
    
}

//写成功的回调
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
{
    //    NSLog(@"写的回调,tag:%ld",tag);
}

//收到消息的回调
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSString *msg = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到消息：%@",msg);
    NSRange range = [msg rangeOfString:@"127.0.0.1"];
    if (range.location ==NSNotFound) {
        Person *person2 = [Person parseFromData:data];

        NSLog(@"%u",(unsigned int)[person2.myfield uint32AtIndex:0]);
    }


    
    [self pullTheMsg];
}
@end
