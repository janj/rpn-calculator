//
//  RPNEvaluator.m
//  RPNCalculator
//
//  Created by Jan Jirout on 6/18/14.
//  Copyright (c) 2014 Jan Jirout. All rights reserved.
//

#import "RPNEvaluator.h"

@implementation RPNEvaluator

// All available operators for RPN
+(NSDictionary*)operatorDict{
    static NSMutableDictionary *operatorDict;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        operatorDict = [NSMutableDictionary dictionary];
        // *
        [operatorDict setObject:[^ double (double firstOperand, double secondOperand){return firstOperand * secondOperand;} copy] forKey:@"*"];
        // /
        [operatorDict setObject:[^ double (double firstOperand, double secondOperand){return firstOperand / secondOperand;} copy] forKey:@"/"];
        // +
        [operatorDict setObject:[^ double (double firstOperand, double secondOperand){return firstOperand + secondOperand;} copy] forKey:@"+"];
        // -
        [operatorDict setObject:[^ double (double firstOperand, double secondOperand){return firstOperand - secondOperand;} copy] forKey:@"-"];
        // ^
        [operatorDict setObject:[^ double (double firstOperand, double secondOperand){return pow(firstOperand, secondOperand);} copy] forKey:@"^"];
    });
    return operatorDict;
}

+(NSDictionary*)stackOperatorDict{
    NSMutableDictionary *stackOperators = [NSMutableDictionary dictionary];
    
    [stackOperators setObject:[^ double (NSArray *operands) {
        double total = 0;
        for(NSNumber *operand in operands){
            total += operand.doubleValue;
        }
        return total;
    } copy] forKey:@"SUM"];
    
    return stackOperators;
}

// Evaluates the rpn string and retuns the result if there is no error, returns nil if there is an error
+(NSNumber*)evaluateString:(NSString *)rpnString error:(NSError**)error{
    NSArray *parts = [rpnString componentsSeparatedByString:@" "];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:parts.count];
    NSDictionary *binaryOperators = [RPNEvaluator operatorDict];
    NSDictionary *stackOperators = [RPNEvaluator stackOperatorDict];
    
    for(NSString* token in parts){
        NSString *uppercaseToken = token.uppercaseString;
        NSNumber *num = [numberFormatter numberFromString:token];
        if(nil != num){
            // found a number
            [stack addObject:num];
        }
        else if(nil != [binaryOperators objectForKey:token]){
            // found an operator
            NSNumber *secondOperand = [stack lastObject];
            [stack removeLastObject];
            NSNumber *firstOperand = [stack lastObject];
            [stack removeLastObject];
            
            if(nil != firstOperand && nil != secondOperand){
                double (^operator)(double, double) = [binaryOperators objectForKey:token];
                
                [stack addObject:[NSNumber numberWithDouble:operator(firstOperand.doubleValue, secondOperand.doubleValue)]];
            }
            else{
                // not enough arguments
                *error = [NSError errorWithDomain:@"rpn" code:MISSING_ARGUMENTS_ERROR userInfo:@{NSLocalizedDescriptionKey:@"not enough arguments"}];
                return nil;
            }
        }
        else if(nil != [stackOperators objectForKey:uppercaseToken]){
            double (^stackOperator)(NSArray *stack) = [stackOperators objectForKey:uppercaseToken];
            double result = stackOperator(stack);
            [stack removeAllObjects];
            [stack addObject:@(result)];
        }
        else{
            // invalid number
            *error = [NSError errorWithDomain:@"rpn" code:INVALID_NUMBER_ERROR userInfo:@{NSLocalizedDescriptionKey:@"invalid number"}];
            return nil;
        }
    }
    if(stack.count == 1){
        // successful eval
        return stack.firstObject;
    }
    else{
        // not enough arguments
        *error = [NSError errorWithDomain:@"rpn" code:MISSING_ARGUMENTS_ERROR userInfo:@{NSLocalizedDescriptionKey:@"not enough arguments"}];
        return nil;
    }
}


@end
