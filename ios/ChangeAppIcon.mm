#import "ChangeAppIcon.h"
#import <React/RCTLog.h>
#import <React/RCTConvert.h>
#import "ChangeAppIcon-Swift.h"

@implementation ChangeAppIcon {
  ChangeAppIconImpl *moduleImpl;
}

-(instancetype) init {
  self = [super init];
  if (self) {
    moduleImpl = [ChangeAppIconImpl new];
  }
  return self;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getIconApp:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSString *iconName = UIApplication.sharedApplication.alternateIconName ?: @"Default";
  resolve(iconName);
}


- (void)getIcon:(nonnull RCTPromiseResolveBlock)resolve
         reject:(nonnull RCTPromiseRejectBlock)reject {
  NSString *iconName = [moduleImpl getIcon];
  resolve(iconName);
}

- (void)changeIcon:(nullable NSString *)iconName
           resolve:(nonnull RCTPromiseResolveBlock)resolve
            reject:(nonnull RCTPromiseRejectBlock)reject
{
  [moduleImpl changeIconTo:iconName];
  resolve(@"Icon change requested");
}

- (void)changeIconSilently:(nullable NSString *)iconName
           resolve:(nonnull RCTPromiseResolveBlock)resolve
            reject:(nonnull RCTPromiseRejectBlock)reject
{
  @try {
    [moduleImpl changeIconSilentlyTo:iconName];
    resolve(@"Icon change requested");
  } @catch (NSException *exception) {
    reject(@"icon_change_failed", exception.reason, nil);
  }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeChangeAppIconSpecJSI>(params);
}

@end
