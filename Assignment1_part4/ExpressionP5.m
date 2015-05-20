//
//  Expression.m
//  Assignment1_part1
//
//  Created by mccane on 7/11/14.
//  Copyright (c) 2014 mccane. All rights reserved.
//

#import "Expression.h"
#import "Tokens.h"

@implementation Prog

// for rules that only have choices as their production, can default to using the GrammarRule parse. But to do that, must add rules to the subrule array.
-(id)init
{
    self = [super init];
    Print *print = [[Print alloc] init];
    Assign *assign = [[Assign alloc] init];
    [self addRule:print];
    [self addRule:assign];
    [self addRule:[Epsilon theEpsilon]];
    return self;
}
@end

@implementation Print

-(NSString *) parse:(NSString *)input
{
    // File needs print command to print out the value
    // of an expression.
    Literal *print = [[Literal alloc]init: @"print"];
    NSString *s1 = [print parse: input];
    
    if (s1==nil)
        return input;
    
    Expr *expr = [[Expr alloc] init];
    NSString *s2 = [expr parse: s1];
    
    printf(">>> %d\n", [expr value]);
    
    if ([s2 isEqual:@""])
        return input;
       
    
    Prog *prog = [[Prog alloc] init];
    NSString *s3 = [prog parse: s2];
   
    return s3;

}

@end

@implementation Assign

-(NSString *) parse:(NSString *)input
{
    Literal *id = [[Literal alloc]init: @""];
    NSString *s1 = [id parse: input];
    
    if (s1==nil)
        return input;
    
    Literal *equals = [[Literal alloc]init: @"="];
    NSString *s2 = [equals parse: s1];
    
    if (s2==nil)
        return input;
    
    Expr *expr = [[Expr alloc] init];
    NSString *s3 = [expr parse: s2];
    
    if (s3==nil)
        return input;
    
    Prog *prog = [[Prog alloc] init];
    NSString *s4 = [prog parse: s3];
    
    return s4;
    
}

@end


// Expression -> Number TailExpr
// In this case, we need to redefine parse
@implementation Expr

-(NSString *) parse:(NSString *)input
{
    MulTerm *multerm = [[MulTerm alloc] init];
    NSString *s1 = [multerm parse:input];
  
  
    // if we can't parse a number, then the production doesn't match. Return nil.
    if (s1==nil)
        return input;
    
    Exprtail *exprtail = [[Exprtail alloc] init];
    NSString *s2 = [exprtail parse:s1];
    
    
    // set the value of the expression
    if (s2!=nil)
        [self setValue: [multerm value]+[exprtail value]];
    return s2;

}



@end


@implementation Exprtail

-(NSString *)parse:input
{
  
    // tail + token (could be in middle of expression).
    Literal *plus = [[Literal alloc]init: @"+"];
    NSString *s1 = [plus parse: input];
    
    
    if (s1==nil)
        return input;
    
    MulTerm *multerm = [[MulTerm alloc] init];
    NSString *s2 = [multerm parse: s1];
    
    // For extra additions (beyond x+x).
    // This is a recursive parse call.
    Exprtail *exprtail = [[Exprtail alloc] init];
    NSString *s3 = [exprtail parse:s2];
  
    
    
    if (s3==nil){
        [self setValue: 0];
        return input;
    }
    
    [self setValue: [multerm value]+[exprtail value]];

    return s3;
}

@end

@implementation MulTerm

-(NSString *) parse:(NSString *)input
{
   
    // First token...
    Value *val = [[Value alloc] init];
    NSString *s1 = [val parse: input];
 
    if (s1==nil)
        return s1;
    
    // For * number
    Multail *multail = [[Multail alloc] init];
    NSString *s2 = [multail parse: s1];
    
    if (s2!=nil)
        [self setValue: [val value]*[multail value]];
    return s2;
}
@end

@implementation Multail

-(NSString *) parse:(NSString *)input
{
  
    // tail * token (could be in middle of expression).
    Literal *times = [[Literal alloc]init: @"*"];
    NSString *s1 = [times parse: input];

    if (s1==nil){
        [self setValue: 1];
        return input;
    }
    
    // tail number
    Value *val = [[Value alloc] init];
    NSString *s2 = [val parse: s1];
    
    // For extra multiplications given multterm.
    // - A recursive call.
    Multail *multail = [[Multail alloc] init];
    NSString *s3 = [multail parse:s2];
    
    if (s3==nil){
        [self setValue: 0];
        return input;
    }
    
    if (s3!=nil)
        [self setValue: [val value]*[multail value]];
    return s3;
}
@end

@implementation Value

-(NSString *) parse:(NSString *)input
{
    Literal *id = [[Literal alloc]init: @"Id"];
    NSString *s1 = [id parse: input];
    
    
    if (s1==nil){
        Number *num = [[Number alloc] init];
        NSString *s2 = [num parse: s1];
        return s2;
    }
    return s1;
}

@end

