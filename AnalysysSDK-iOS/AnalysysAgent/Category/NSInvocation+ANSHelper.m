//
//  NSInvocation+ANSHelper.m
//  AnalysysAgent
//
//  Created by analysys on 2019/2/21.
//  Copyright © 2019年 analysys. All rights reserved.
//

#import "NSInvocation+ANSHelper.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>

typedef union {
    char                    _chr;
    unsigned char           _uchr;
    short                   _sht;
    unsigned short          _usht;
    int                     _int;
    unsigned int            _uint;
    long                    _lng;
    unsigned long           _ulng;
    long long               _lng_lng;
    unsigned long long      _ulng_lng;
    float                   _flt;
    double                  _dbl;
    _Bool                   _bool;
} AnsObjCNumericTypes;

static void AnsFree(void *p) {
    if (p) {
        free(p);
    }
}

static void *AnsAllocBufferForObjCType(const char *objCType) {
    void *buffer = NULL;
    
    NSUInteger size, alignment;
    NSGetSizeAndAlignment(objCType, &size, &alignment);
    
    int result = posix_memalign(&buffer, MAX(sizeof(void *), alignment), size);
    if (result != 0) {
        NSLog(@"Error allocating aligned memory: %s", strerror(result));
    }
    
    if (buffer) {
        memset(buffer, 0, size);
    }
    
    return buffer;
}

@implementation NSInvocation (ANSHelper)

- (void)AnsSetArgument:(id)argumentValue atIndex:(NSUInteger)index {
    const char *argumentType = [self.methodSignature getArgumentTypeAtIndex:index];
    @try {
        if ([argumentValue isKindOfClass:[NSNumber class]] && strlen(argumentType) == 1) {
            // Deal with NSNumber instances (converting to primitive numbers)
            NSNumber *numberArgument = argumentValue;
            
            AnsObjCNumericTypes arg;
            switch (argumentType[0]) {
                case _C_CHR:      arg._chr      = numberArgument.charValue;                break;
                case _C_UCHR:     arg._uchr     = numberArgument.unsignedCharValue;        break;
                case _C_SHT:      arg._sht      = numberArgument.shortValue;               break;
                case _C_USHT:     arg._usht     = numberArgument.unsignedShortValue;       break;
                case _C_INT:      arg._int      = numberArgument.intValue;                 break;
                case _C_UINT:     arg._uint     = numberArgument.unsignedIntValue;         break;
                case _C_LNG:      arg._lng      = numberArgument.longValue;                break;
                case _C_ULNG:     arg._ulng     = numberArgument.unsignedLongValue;        break;
                case _C_LNG_LNG:  arg._lng_lng  = numberArgument.longLongValue;            break;
                case _C_ULNG_LNG: arg._ulng_lng = numberArgument.unsignedLongLongValue;    break;
                case _C_FLT:      arg._flt      = numberArgument.floatValue;               break;
                case _C_DBL:      arg._dbl      = numberArgument.doubleValue;              break;
                case _C_BOOL:     arg._bool     = numberArgument.boolValue;                break;
                default:
                    //                NSAssert(NO, @"Currently unsupported argument type!");
                    [self setArgument:&argumentValue atIndex:(NSInteger)index];
                    return;
                    break;
            }
            
            [self setArgument:&arg atIndex:(NSInteger)index];
        } else if ([argumentValue isKindOfClass:[NSValue class]]) {
            NSValue *valueArgument = argumentValue;
            
            NSAssert2(strcmp(valueArgument.objCType, argumentType) == 0, @"Objective-C type mismatch (%s != %s)!", valueArgument.objCType, argumentType);
            
            void *buffer = AnsAllocBufferForObjCType(valueArgument.objCType);
            
            [valueArgument getValue:buffer];
            
            [self setArgument:&buffer atIndex:(NSInteger)index];
            
            AnsFree(buffer);
        } else {
            switch (argumentType[0]) {
                case _C_ID:
                {
                    [self setArgument:&argumentValue atIndex:(NSInteger)index];
                    break;
                }
                case _C_SEL:
                {
                    SEL sel = NSSelectorFromString(argumentValue);
                    [self setArgument:&sel atIndex:(NSInteger)index];
                    break;
                }
                default:
                    //NSAssert(NO, @"Currently unsupported argument type!");
                    break;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"NSInvocation exception: %@", exception);
    }
}

- (void)AnsSetArgumentsFromArray:(NSArray *)argumentArray {
    NSParameterAssert(argumentArray.count == (self.methodSignature.numberOfArguments - 2));
    
    NSUInteger i = 0;
    for (id argument in argumentArray) {
        NSUInteger argumentIndex = 2 + i;
        [self AnsSetArgument:argument atIndex:argumentIndex];
        ++i;
    }
}

- (id)AnsReturnValue {
    __strong id returnValue = nil;
    
    NSMethodSignature *methodSignature = self.methodSignature;
    
    const char *objCType = methodSignature.methodReturnType;
    void *buffer = AnsAllocBufferForObjCType(objCType);
    
    [self getReturnValue:buffer];
    
    if (strlen(objCType) == 1) {
        switch (objCType[0]) {
            case _C_CHR:      returnValue = @(*((char *)buffer));                   break;
            case _C_UCHR:     returnValue = @(*((unsigned char *)buffer));          break;
            case _C_SHT:      returnValue = @(*((short *)buffer));                  break;
            case _C_USHT:     returnValue = @(*((unsigned short *)buffer));         break;
            case _C_INT:      returnValue = @(*((int *)buffer));                    break;
            case _C_UINT:     returnValue = @(*((unsigned int *)buffer));           break;
            case _C_LNG:      returnValue = @(*((long *)buffer));                   break;
            case _C_ULNG:     returnValue = @(*((unsigned long*)buffer));           break;
            case _C_LNG_LNG:  returnValue = @(*((long long *)buffer));              break;
            case _C_ULNG_LNG: returnValue = @(*((unsigned long long*)buffer));      break;
            case _C_FLT:      returnValue = @(*((float *)buffer));                  break;
            case _C_DBL:      returnValue = @(*((double *)buffer));                 break;
            case _C_BOOL:     returnValue = @(*((_Bool *)buffer));                  break;
            case _C_ID:       returnValue = *((__unsafe_unretained id *)buffer);    break;
            case _C_SEL:      returnValue = NSStringFromSelector(*((SEL *)buffer)); break;
            default:
                //NSAssert1(NO, @"Unhandled return type: %s", objCType);
                break;
        }
    } else {
        switch (objCType[0]) {
            case _C_STRUCT_B: returnValue = [NSValue valueWithBytes:buffer objCType:objCType]; break;
            case _C_PTR:
            {
                CFTypeRef cfTypeRef = *(CFTypeRef *)buffer;
                if ((strcmp(objCType, @encode(CGImageRef)) == 0 && CFGetTypeID(cfTypeRef) == CGImageGetTypeID()) ||
                    (strcmp(objCType, @encode(CGColorRef)) == 0 && CFGetTypeID(cfTypeRef) == CGColorGetTypeID()))
                {
                    returnValue = (__bridge id)cfTypeRef;
                } else {
                    //NSAssert(NO, @"Currently unsupported return type!");
                    break;
                }
                break;
            }
            default:
                //NSAssert1(NO, @"Unhandled return type: %s", objCType);
                break;
        }
    }
    
    AnsFree(buffer);
    
    return returnValue;
}

@end
