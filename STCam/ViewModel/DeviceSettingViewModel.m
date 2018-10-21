//
//  DeviceSettingViewModel.m
//  STCam
//
//  Created by guyunlong on 10/20/18.
//  Copyright © 2018 South. All rights reserved.
//

#import "DeviceSettingViewModel.h"
#import "PrefixHeader.h"
#import "RetModel.h"
#import "CoreDataManager.h"
@implementation DeviceSettingViewModel
-(RACSignal*)racChangeDeviceName:(NSString*)deviceName{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
           
            NSString * url = [NSString stringWithFormat:@"%@&DevName=%@",[self.model getDevURL:Msg_SetDevInfo],deviceName];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1) {
                    [self.model setDevName:deviceName];
                    [subscriber sendNext:@1];
                }
                else{
                     [subscriber sendNext:@(model.ret)];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racChangeDevicePassword:(NSString*)devicePassword{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&&UserName0=admin&Password0=%@",[self.model getDevURL:Msg_SetUserLst],devicePassword];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1 || model.ret == 2) {
                    [self.model setPwd:devicePassword];
                    [[CoreDataManager sharedManager] saveDevice:self.model];
                    [subscriber sendNext:@(model.ret)];
                }
                else{
                    [subscriber sendNext:@(model.ret)];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racRebootDevice{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_SetDevReboot]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret == 1) {
                    
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@(model.ret)];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racGetPushSetting{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@",[self.model getDevURL:Msg_GetPushCfg]];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                PushSettingModel * model = [PushSettingModel PushSettingModelWithDict:data];
                if (model) {
                    self.mPushSettingModel = model;
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
-(RACSignal*)racSetPushConfig{
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber){
        @strongify(self)
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(quene, ^{
            
            NSString * url = [NSString stringWithFormat:@"%@&PushActive=%d&PushInterval=%ld&PIRSensitive=%ld",[self.model getDevURL:Msg_SetPushCfg],self.mPushSettingModel.PushActive,self.mPushSettingModel.PushInterval,self.mPushSettingModel.PIRSensitive];
            
            id data = [self.model thNetHttpGet:url];
            if([data isKindOfClass:[NSDictionary class]]){
                RetModel * model = [RetModel RetModelWithDict:data];
                if (model.ret) {
                    [subscriber sendNext:@1];
                }
                else{
                    [subscriber sendNext:@0];
                }
            }
            
        });
        
        return nil;
    }];
}
@end
