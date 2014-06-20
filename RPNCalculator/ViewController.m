//
//  ViewController.m
//  RPNCalculator
//
//  Created by Jan Jirout on 6/18/14.
//  Copyright (c) 2014 Jan Jirout. All rights reserved.
//

#import "ViewController.h"
#import "RPNTextField.h"
#import "RPNEvaluator.h"

@interface ViewController ()

// history of rpn expressions and results
@property NSMutableString *resultHistory;

// view for displaying the result history
@property UITextView *resultsView;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    
    self.resultHistory = [[NSMutableString alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width-40, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"RPN Calc";
    [self.view addSubview:titleLabel];
    
    UITextField *inputField = [[RPNTextField alloc] initWithFrame:CGRectMake(15, titleLabel.frame.origin.y+titleLabel.frame.size.height, self.view.frame.size.width-30, 40)];
    inputField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    inputField.delegate = self;
    inputField.clearButtonMode = UITextFieldViewModeAlways;
    inputField.placeholder = @"Enter RPN expression here";
    inputField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [inputField becomeFirstResponder];
    [self.view addSubview:inputField];
    
    self.resultsView = [[UITextView alloc] initWithFrame:CGRectMake(inputField.frame.origin.x, inputField.frame.origin.y+inputField.frame.size.height + 15, inputField.frame.size.width, 220)];
    self.resultsView.layer.cornerRadius = 5;
    self.resultsView.bounces = NO;
    self.resultsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.resultsView.editable = NO;
    [self.view addSubview:self.resultsView];
}

// appends the eval string and result to the result history
-(void)addResult:(NSString*)result forEvalString:(NSString*)evalString{
    [self.resultHistory appendString:[NSString stringWithFormat:@"%@\n%@\n\n",evalString, result]];
    self.resultsView.text = self.resultHistory;
    [self.resultsView scrollRangeToVisible:NSMakeRange(self.resultHistory.length, 0)];
    // workaround for scroll bug, without this scrolling isn't smoothe
    self.resultsView.scrollEnabled = NO;
    self.resultsView.scrollEnabled = YES;
}

// evaluates the string and appends the result
-(void)evaluateString:(NSString *)evalString{
    NSError *error;
    NSNumber *result = [RPNEvaluator evaluateString:evalString error:&error];
    if(result){
        [self addResult:[NSString stringWithFormat:@"= %@", result] forEvalString:evalString];
    }
    else if(error){
        [self addResult:error.localizedDescription forEvalString:evalString];
    }
    else{
        // should never get here
    }
}

// return initiates the eval
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.text.length > 0){
        [self evaluateString:textField.text];
    }
    return NO;
}

@end
