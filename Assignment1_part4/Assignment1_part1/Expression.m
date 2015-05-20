//
//  Expression.m
//  Assignment1_part1
//
//  Matthew Brooker, 541670
//
//  Created by mccane on 7/11/14.
//  Copyright (c) 2014 mccane. All rights reserved.
//

#import "Expression.h"
#import "Tokens.h"

@implementation Prog

// for rules that only have choices as their production, can default to using the GrammarRule parse. But to do that, must add rules to the subrule array.


// Adds print and epsilon rules to prog.
-(id)init
{
    self = [super init];
    Print *print = [[Print alloc] init];
    [self addRule:print];
    [self addRule:[Epsilon theEpsilon]];
    return self;
}
@end

@implementation Print

-(NSString *) parse:(NSString *)input
{
    // So file needs print command to print out the value
    // of an expression.
    Literal *print = [[Literal alloc]init: @"print"];
    NSString *s1 = [print parse: input];
    
    // if there is no print message, return epsilon.
    if (s1==nil)
        return input;
    
    // For calculating expression after print statement.
    Expr *expr = [[Expr alloc] init];
    NSString *s2 = [expr parse: s1];
    
    // After value is calculated, the result(s) are printed.
    printf(">>> %d\n", [expr value]);
    
    // If there is no more input (no new line), return
    // epsilon.
    if ([s2 isEqual:@""])
        return input;
       
    // Otherwise go through the parse process again with
    // the next line.
    Prog *prog = [[Prog alloc] init];
    NSString *s3 = [prog parse: s2];
   
    return s3;

}

@end


@implementation Expr

// This parse method begins possible multiplication term with
// By parsing the input through the MulTerm class. If it fails
// or not, execution returns to pass the multerm result s1 through
// Exprtail class, for additions.
-(NSString *) parse:(NSString *)input
{
    MulTerm *multerm = [[MulTerm alloc] init];
    NSString *s1 = [multerm parse:input];
  
  
    // if we can't parse a number, then the production doesn't match. Return nil.
    if (s1==nil)
        return input;
    
    // Creates Exprtail object to its parsing method can
    // be used on s1.
    Exprtail *exprtail = [[Exprtail alloc] init];
    NSString *s2 = [exprtail parse:s1];
    
    
    // set the value of the expression
    if (s2!=nil)
        [self setValue: [multerm value]+[exprtail value]];
    return s2;

}

@end


// This class is used for +x (additions). Its parse
// method recursively calls itself is there are more
// additions. The multerm parse method is called to
// parse the tail number and possible parse another
// multiplication.
@implementation Exprtail

-(NSString *)parse:input
{
    // Literal object allocated. Its parse method
    // called with input as parameter.
    Literal *plus = [[Literal alloc]init: @"+"];
    NSString *s1 = [plus parse: input];
    
    // If there is no '+', leave this method and
    // continue execution where it was called.
    if (s1==nil)
        return input;
    
    // For trailing number
    MulTerm *multerm = [[MulTerm alloc] init];
    NSString *s2 = [multerm parse: s1];
    
    // For extra additions (beyond x+x).
    // This is a recursive parse call.
    Exprtail *exprtail = [[Exprtail alloc] init];
    NSString *s3 = [exprtail parse:s2];
  
    
    // Return epsilon if there is no more tails.
    if (s3==nil){
        [self setValue: 0];
        return input;
    }
    // Sets the object values multerm (a number) and the object
    // value
    [self setValue: [multerm value]+[exprtail value]];

    return s3;
}

@end

// This class allows us to parse numbers and call
// Multail for possible trailing multiplication term(s).
@implementation MulTerm

-(NSString *) parse:(NSString *)input
{
   
    // First token...
    Number *num = [[Number alloc] init];
    NSString *s1 = [num parse: input];
    
    // If we have no more input left, the last
    // token will be a number and we can return
    // the epsilon.
    if (s1==nil)
        return input;
    
    // For * number
    Multail *multail = [[Multail alloc] init];
    NSString *s2 = [multail parse: s1];
    
    // Set appropriate values for Number and Multail
    // objects.
    if (s2!=nil)
        [self setValue: [num value]*[multail value]];
    return s2;
}
@end

// For multiplications (*x). Creates Literal '*' and parses
// it using the parse method is tokens.m. This is followed by
// instantiation of Number and Multail for the trailing int
// followed by further multiplications.
@implementation Multail

-(NSString *) parse:(NSString *)input
{
  
    // tail * token (could be in middle of expression).
    Literal *times = [[Literal alloc]init: @"*"];
    NSString *s1 = [times parse: input];
    
    // Return epsilon if there is no more input.
    if (s1==nil){
        [self setValue: 1];
        return input;
    }
    // tail number
    Number *num = [[Number alloc] init];
    NSString *s2 = [num parse: s1];
    
    // For extra multiplications given multterm.
    // - A recursive call.
    Multail *multail = [[Multail alloc] init];
    NSString *s3 = [multail parse:s2];
    
    //Return epsilon if multail object is nil.
    if (s3==nil){
        [self setValue: 0];
        return input;
    }
    
    // Otherwise set appropriate values.
    if (s3!=nil)
        [self setValue: [num value]*[multail value]];
    return s3;
}
@end

