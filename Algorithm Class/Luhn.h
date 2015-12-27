//
//  Luhn.h
//  Luhn Algorithm (Mod 10)
//
//  Created by Max Kramer on 30/12/2012.
//  Copyright (c) 2012 Max Kramer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OLCreditCardType) {
    OLCreditCardTypeAmex,
    OLCreditCardTypeVisa,
    OLCreditCardTypeMastercard,
    OLCreditCardTypeDiscover,
    OLCreditCardTypeDinersClub,
    OLCreditCardTypeJCB,
    OLCreditCardTypeUnionPay,
    OLCreditCardTypeMaestro,
    OLCreditCardTypeCarte,
    OLCreditCardTypeLaser,
    OLCreditCardTypeSolo,
    OLCreditCardTypeSwitch,
    /**** Icon not exist ****
    OLCreditCardTypeBCGlobal,
    OLCreditCardTypeVisaMaster,
    OLCreditCardTypeInstaPayment,
    *** Icon not exist *****/
    OLCreditCardTypeUnsupported,
    OLCreditCardTypeInvalid
};

@interface Luhn : NSObject

+ (OLCreditCardType) typeFromString:(NSString *) string;
+ (BOOL) validateString:(NSString *) string forType:(OLCreditCardType) type;
+ (BOOL) validateString:(NSString *) string;

@end

@interface NSString (Luhn)

- (BOOL) isValidCreditCardNumber;
- (OLCreditCardType) creditCardType;

@end