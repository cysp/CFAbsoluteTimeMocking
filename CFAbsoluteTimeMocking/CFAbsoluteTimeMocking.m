#import "CFAbsoluteTimeMocking.h"

static CFTimeInterval XXXCFAbsoluteTimeGetCurrent(void);

typedef struct interpose_s {
    void *new_func;
    void *orig_func;
} interpose_t;

__attribute__((used)) static const interpose_t interposing_functions[] \
__attribute__ ((section("__DATA,__interpose"))) = {
    { (void *)XXXCFAbsoluteTimeGetCurrent,  (void *)CFAbsoluteTimeGetCurrent  }
};

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
