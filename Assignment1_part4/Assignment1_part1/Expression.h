//
//  Expression.h
//  Assignment1_part4
//
//  Matthew Brooker, 541670
//
//  Created by mccane on 7/11/14.
//  Copyright (c) 2014 mccane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GrammarRule.h"

// The full part 4 grammar. Including the Prog where
// the rules are added, the print class where we can
// print Expr expression results, Expr where the
// expressions are parsed and calculated, Exprtail where additions
// are parsed, Multerm where numbers are parsed, and
// Multail where multiplications are parsed

@interface Prog: GrammarRule

-(id) init;

@end

@interface Print: GrammarRule

-(NSString *) parse:(NSString *)input;

@end

@interface Expr : GrammarRule

-(NSString *) parse:(NSString *)input;

@end

@interface Exprtail: GrammarRule

-(NSString *) parse:(NSString *)input;

@end

@interface MulTerm : GrammarRule

-(NSString *) parse:(NSString *)input;

@end

@interface Multail : GrammarRule

-(NSString *) parse:(NSString *)input;

@end
