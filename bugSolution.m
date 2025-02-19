The solution involves using `weak` references to break the cycle. One of the objects should hold a weak reference to the other.  This prevents the cycle from preventing deallocation.

```objectivec
@interface ObjectA : NSObject
@property (strong, nonatomic) ObjectB *objectB;
@end

@interface ObjectB : NSObject
@property (weak, nonatomic) ObjectA *objectA; // Changed to weak
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

Now, when the `autoreleasepool` ends, the objects will be deallocated correctly because the weak reference will not prevent deallocation.