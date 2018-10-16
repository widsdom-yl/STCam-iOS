//
//  DevShareModel.m
//  STCam
//
//  Created by coverme on 10/16/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DevShareModel.h"

@implementation DevShareModel
-(NSString*)localDescription{
    NSDictionary *details =@{@"SN":_SN,@"From":_From,@"Pwd":_Pwd,@"IsVideo":@(_IsVideo),@"IsHistory":@(_IsHistory), @"IsPush":@(_IsPush),@"IsControl":@(_IsControl)};
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

+(instancetype)DevShareModelWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];//kvc
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"%s---%@",__func__,key);
}
@end