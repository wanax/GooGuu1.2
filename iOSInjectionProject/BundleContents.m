/*
    Generated for Injection of class implementations
*/

#define INJECTION_NOIMPL
#define INJECTION_BUNDLE InjectionBundle12

#import "/Applications/Injection Plugin.app/Contents/Resources/BundleInjection.h"

#undef _instatic
#define _instatic extern

#undef _inglobal
#define _inglobal extern

#undef _inval
#define _inval( _val... ) /* = _val */

#import "BundleContents.h"

#import "/Users/xcode/wanax/oc/GooGuu-f5fb0263a822938a0d6a4aa39e2d5d738805387c/估股/UserRegisterViewController.m"


@interface InjectionBundle12 : NSObject
@end
@implementation InjectionBundle12

+ (void)load {
    Class bundleInjection = NSClassFromString(@"BundleInjection");
    extern Class OBJC_CLASS_$_UserRegisterViewController;
	[bundleInjection loadedClass:INJECTION_BRIDGE(Class)(void *)&OBJC_CLASS_$_UserRegisterViewController notify:4];
    [bundleInjection loadedNotify:4];
}

@end

