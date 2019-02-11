//
//  NSDictionary+Object.m
//  CyberClassKJG
//
//  Created by GMedia on 12. 7. 9..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+Object.h"

@implementation NSDictionary(Object)
-(NSString *)StringForKey:(NSString *)key
{   
    if (self == nil) return @"";
    NSString *result = [NSString stringWithFormat:@"%@", [self objectForKey:key]];
    
    if (result == nil || [result isKindOfClass:[NSString class]]==NO || [result isEqualToString:@"<null>"]) {
        return @"";
    }
    
    return result;
}


-(int)intForKey:(NSString *)key
{   
    if (self == nil) return 0;
    id obj = [self objectForKey:key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]])return 0;    
    return [[self objectForKey:key] intValue];    
}

-(double)DoubleForKey:(NSString *)key
{    
    if (self == nil) return 0;
    id obj = [self objectForKey:key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]])return 0;   
    return [[self objectForKey:key] doubleValue];
}

-(float)FloatForKey:(NSString *)key
{   
    if (self == nil) return 0;
    id obj = [self objectForKey:key];
    if (obj == nil || [obj isKindOfClass:[NSNull class]])return 0;    
    return [[self objectForKey:key] floatValue];
}
@end
