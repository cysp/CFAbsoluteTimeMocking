#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

__attribute__((weak_import))
@interface CFAbsoluteTimeMocking : NSObject

+ (void)withNow:(CFTimeInterval)now block:(dispatch_block_t NS_NOESCAPE)block;

@end

NS_ASSUME_NONNULL_END
