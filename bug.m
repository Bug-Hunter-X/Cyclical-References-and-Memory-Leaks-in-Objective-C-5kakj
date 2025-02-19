In Objective-C, a common yet subtle issue arises when dealing with memory management, specifically with regards to object ownership and the `retain`/`release` cycle (or, more modernly, using Automatic Reference Counting (ARC)).  A classic example involves creating a cyclical reference. Consider two objects, `ObjectA` and `ObjectB`.  `ObjectA` holds a strong reference to `ObjectB`, and `ObjectB` holds a strong reference to `ObjectA`.  Neither object will ever be deallocated, leading to a memory leak. This is harder to spot than a simple memory leak because the code might appear correct at first glance.

```objectivec
@interface ObjectA : NSObject
@property (strong, nonatomic) ObjectB *objectB;
@end

@interface ObjectB : NSObject
@property (strong, nonatomic) ObjectA *objectA;
@end

@implementation ObjectA
- (void)dealloc {
    NSLog(@"ObjectA deallocated");
}
@end

@implementation ObjectB
- (void)dealloc {
    NSLog(@"ObjectB deallocated");
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ObjectA *objectA = [[ObjectA alloc] init];
        ObjectB *objectB = [[ObjectB alloc] init];
        objectA.objectB = objectB;
        objectB.objectA = objectA;
    }
    return 0;
}
```

Neither `objectA` nor `objectB` will ever be deallocated because of the mutual strong references. This will not trigger a compiler warning or runtime exception but leads to a memory leak.