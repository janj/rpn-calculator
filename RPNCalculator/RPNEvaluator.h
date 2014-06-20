//
//  RPNEvaluator.h
//  RPNCalculator
//
//  Created by Jan Jirout on 6/18/14.
//  Copyright (c) 2014 Jan Jirout. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MISSING_ARGUMENTS_ERROR 100
#define INVALID_NUMBER_ERROR 101

@interface RPNEvaluator : NSObject

+(NSNumber*)evaluateString:(NSString *)evalString error:(NSError**)error;

@end
