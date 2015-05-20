//
//  main.m
//  Assignment1_part1
//
//  Matthew Brooker, 541670
//
//  Created by mccane on 7/11/14.
//  Copyright (c) 2014 mccane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GrammarRule.h"
#import "Expression.h"

// Prog allocated and called with string contents of test file.
int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        Prog *expr = [[Prog alloc] init];
        NSString *res = [NSString stringWithContentsOfFile:@"/home/cshome/m/mbrooker/346/Assignment1/Assignment1_part3/test4.ex"  encoding:NSUTF8StringEncoding error:nil];
        res = [expr parse:res];
    }
    return 0;
}
