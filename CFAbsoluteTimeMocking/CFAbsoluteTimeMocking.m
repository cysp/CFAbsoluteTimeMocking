#import "CFAbsoluteTimeMocking.h"
#import "private/dyld-interposing.h"

static NSMutableArray<NSNumber *> *CFAbsoluteTimeGetCurrentStack = nil;

static CFTimeInterval XXXCFAbsoluteTimeGetCurrent(void) {
    NSNumber * const foo = CFAbsoluteTimeGetCurrentStack.lastObject;
    if (foo) {
        NSLog(@"CFAbsoluteTimeGetCurrent interposed with value");
        return foo.doubleValue;
    }
    NSLog(@"CFAbsoluteTimeGetCurrent interposed without value");
    return CFAbsoluteTimeGetCurrent();
}
DYLD_INTERPOSE(XXXCFAbsoluteTimeGetCurrent, CFAbsoluteTimeGetCurrent)


@implementation CFAbsoluteTimeMocking

+ (void)initialize {
    CFAbsoluteTimeGetCurrentStack = [[NSMutableArray alloc] initWithCapacity:8];
}

+ (void)withNow:(CFTimeInterval)now block:(dispatch_block_t NS_NOESCAPE)block {
    [CFAbsoluteTimeGetCurrentStack addObject:@(now)];
    block();
    [CFAbsoluteTimeGetCurrentStack removeLastObject];
}

@end
