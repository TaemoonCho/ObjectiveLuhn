//
//  Luhn.m
//  Luhn Algorithm (Mod 10)
//
//  Created by Max Kramer on 30/12/2012.
//  Copyright (c) 2012 Max Kramer. All rights reserved.
//

#import "Luhn.h"

@implementation NSString (Luhn)

- (BOOL) isValidCreditCardNumber {
    return [Luhn validateString:self];
}

- (OLCreditCardType) creditCardType {
    return [Luhn typeFromString:self];
}

@end

@interface NSString (Luhn_Private)

- (NSString *) formattedStringForProcessing;

@end

@implementation NSString (Luhn_Private)

- (NSString *) formattedStringForProcessing {
    NSCharacterSet *illegalCharacters = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray *components = [self componentsSeparatedByCharactersInSet:illegalCharacters];
    return [components componentsJoinedByString:@""];
}

@end

@implementation Luhn

+ (OLCreditCardType) typeFromString:(NSString *) string {
    BOOL valid = [string isValidCreditCardNumber];
    if (!valid) {
        return OLCreditCardTypeInvalid;
    }
    
    NSString *formattedString = [string formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return OLCreditCardTypeInvalid;
    }
    
    NSArray *enums = @[@(OLCreditCardTypeCarte), @(OLCreditCardTypeLaser), @(OLCreditCardTypeSolo), @(OLCreditCardTypeSwitch), @(OLCreditCardTypeUnionPay), @(OLCreditCardTypeMaestro), @(OLCreditCardTypeAmex), @(OLCreditCardTypeDinersClub), @(OLCreditCardTypeDiscover), @(OLCreditCardTypeJCB), @(OLCreditCardTypeMastercard), @(OLCreditCardTypeVisa)];
    
    __block OLCreditCardType type = OLCreditCardTypeInvalid;
    [enums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        OLCreditCardType _type = [obj integerValue];
        NSPredicate *predicate = [Luhn predicateForType:_type];
        BOOL isCurrentType = [predicate evaluateWithObject:formattedString];
        if (isCurrentType) {
            type = _type;
            *stop = YES;
        }
    }];
    return type;
}

+ (NSPredicate *) predicateForType:(OLCreditCardType) type {
    if (type == OLCreditCardTypeInvalid || type == OLCreditCardTypeUnsupported) {
        return nil;
    }
    NSString *regex = nil;
    switch (type) {
        case OLCreditCardTypeAmex:
            regex = @"^3[47][0-9]{5,}$";
            break;
        case OLCreditCardTypeDinersClub:
            regex = @"^3(?:0[0-5]|[68][0-9])[0-9]{4,}$";
            break;
        case OLCreditCardTypeDiscover:
            regex = @"^6(?:011|5[0-9]{2})[0-9]{3,}$";
            break;
        case OLCreditCardTypeJCB:
            regex = @"^(?:2131|1800|35[0-9]{3})[0-9]{3,}$";
            break;
        case OLCreditCardTypeMastercard:
            regex = @"^5[1-5][0-9]{5,}$";
            break;
        case OLCreditCardTypeVisa:
            regex = @"^4[0-9]{6,}$";
            break;
        case OLCreditCardTypeUnionPay:
            regex = @"^(62|88)\\d+$";
            break;
        case OLCreditCardTypeMaestro:
            regex = @"^(5018|5020|5038|5612|5893|6304|6759|6761|6762|6763|0604|6390)\\d+$";
            break;
        case OLCreditCardTypeCarte:
            regex = @"^389[0-9]{11}$";
            break;
        case OLCreditCardTypeLaser:
            regex = @"^(6304|6706|6709|6771)[0-9]{12,15}$";
            break;
        case OLCreditCardTypeSolo:
            regex = @"^(6334|6767)[0-9]{12}|(6334|6767)[0-9]{14}|(6334|6767)[0-9]{15}$";
            break;
        case OLCreditCardTypeSwitch:
            regex = @"^(4903|4905|4911|4936|6333|6759)[0-9]{12}|(4903|4905|4911|4936|6333|6759)[0-9]{14}|(4903|4905|4911|4936|6333|6759)[0-9]{15}|564182[0-9]{10}|564182[0-9]{12}|564182[0-9]{13}|633110[0-9]{10}|633110[0-9]{12}|633110[0-9]{13}$";
            break;
        /**** Icon not exist ****
        case OLCreditCardTypeBCGlobal:
            regex = @"^(6541|6556)[0-9]{12}$"; break;
        case OLCreditCardTypeVisaMaster:
            regex = @"^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14})$"; break;
        case OLCreditCardTypeInstaPayment:
            regex = @"^63[7-9][0-9]{13}$"; break;
        *** Icon not exist *****/
        default:
            break;
    }
    return [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
}

+ (BOOL) validateString:(NSString *)string forType:(OLCreditCardType)type {
    return [Luhn typeFromString:string] == type;
}

+ (BOOL)validateString:(NSString *)string {
    NSString *formattedString = [string formattedStringForProcessing];
    if (formattedString == nil || formattedString.length < 9) {
        return NO;
    }
    
    NSMutableString *reversedString = [NSMutableString stringWithCapacity:[formattedString length]];
    
    [formattedString enumerateSubstringsInRange:NSMakeRange(0, [formattedString length]) options:(NSStringEnumerationReverse |NSStringEnumerationByComposedCharacterSequences) usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [reversedString appendString:substring];
    }];
    
    NSUInteger oddSum = 0, evenSum = 0;
    
    for (NSUInteger i = 0; i < [reversedString length]; i++) {
        NSInteger digit = [[NSString stringWithFormat:@"%C", [reversedString characterAtIndex:i]] integerValue];
        
        if (i % 2 == 0) {
            evenSum += digit;
        }
        else {
            oddSum += digit / 5 + (2 * digit) % 10;
        }
    }
    return (oddSum + evenSum) % 10 == 0;
}

@end