//
//  NSDictionary+Object.h
//  CyberClassKJG
//
//  Created by GMedia on 12. 7. 9..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(Object)
-(NSString *)StringForKey:(NSString *)key;
-(int)intForKey:(NSString *)key;
-(double)DoubleForKey:(NSString *)key;
-(float)FloatForKey:(NSString *)key;
@end
