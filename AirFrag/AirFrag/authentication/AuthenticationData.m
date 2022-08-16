//
//  AuthenticationData.m
//  AirFrag
//
//  Created by Daniel on 27/06/2022.
//

#import <Foundation/Foundation.h>
#import "AuthenticationData.h"


@implementation AuthenticationData

- (instancetype)initWithDeviceCA:(NSString *)deviceCA
                          CAhash:(NSString *)CAhash
//                        ECDSAsig:(NSString *)ECDSAsig
//                      routingInfo:(unsigned long long)routingInfo
//           deviceUniqueIdentifier:(NSString *)deviceUniqueIdentifier
//               deviceSerialNumber:(NSString *)deviceSerialNumber
//                deviceDescription:(NSString *)deviceDescription
                            date:(NSDate *)date
//                           locale:(NSLocale *)locale
                        timeZone:(NSTimeZone *)timeZone {
    
    self = [super init];
    if (self) {
        _deviceCA = [deviceCA copy];
        _CAhash = [CAhash copy];
//        _ECDSAsig = [ECDSAsig copy];
//        _routingInfo = routingInfo;
//
//        _deviceUniqueIdentifier = [deviceUniqueIdentifier copy];
//        _deviceSerialNumber = [deviceSerialNumber copy];
//        _deviceDescription = [deviceDescription copy];
        
        _date = [date copy];
        //_locale = [locale copy];
        _timeZone = [timeZone copy];
    }
    
    return self;
}

//- (instancetype)initFromALTAnissetteData:(ALTAnisetteData *)altAnisetteData {
//    self = [super init];
//
//    if (self) {
//        _machineID = [altAnisetteData.machineID copy];
//        _oneTimePassword = [altAnisetteData.oneTimePassword copy];
//        _localUserID = [altAnisetteData.localUserID copy];
//        _routingInfo = altAnisetteData.routingInfo;
//
//        _deviceUniqueIdentifier = [altAnisetteData.deviceUniqueIdentifier copy];
//        _deviceSerialNumber = [altAnisetteData.deviceSerialNumber copy];
//        _deviceDescription = [altAnisetteData.deviceDescription copy];
//
//        _date = [altAnisetteData.date copy];
//        _locale = [altAnisetteData.locale copy];
//        _timeZone = [altAnisetteData.timeZone copy];
//        _searchPartyToken = nil;
//    }
//
//    return self;
//}
//
#pragma mark - NSObject -

- (NSString *)description {
    return [NSString stringWithFormat:@"Device CA: %@\nCA Hash: %@\nDate: %@\nTime Zone: %@",
            self.deviceCA, self.CAhash,
             self.date, self.timeZone];
}

//- (BOOL)isEqual:(id)object {
//    AppleAccountData *anisetteData = (AppleAccountData *)object;
//    if (![anisetteData isKindOfClass:[AppleAccountData class]]) {
//        return NO;
//    }
//
//    BOOL isEqual = ([self.machineID isEqualToString:anisetteData.machineID] && [self.oneTimePassword isEqualToString:anisetteData.oneTimePassword] &&
//                    [self.localUserID isEqualToString:anisetteData.localUserID] && [@(self.routingInfo) isEqualToNumber:@(anisetteData.routingInfo)] &&
//                    [self.deviceUniqueIdentifier isEqualToString:anisetteData.deviceUniqueIdentifier] &&
//                    [self.deviceSerialNumber isEqualToString:anisetteData.deviceSerialNumber] && [self.deviceDescription isEqualToString:anisetteData.deviceDescription] &&
//                    [self.date isEqualToDate:anisetteData.date] && [self.locale isEqual:anisetteData.locale] && [self.timeZone isEqualToTimeZone:anisetteData.timeZone]);
//    return isEqual;
//}

- (NSUInteger)hash {
    return (self.deviceCA.hash ^ self.CAhash.hash ^ self.date.hash ^ self.timeZone.hash);
    ;
}

#pragma mark - <NSCopying> -

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    AuthenticationData *copy = [[AuthenticationData alloc] initWithDeviceCA:(NSString *)self.deviceCA
                                                                 CAhash:(NSString *)self.CAhash
//                                                               ECDSAsig:(NSString *)self.ECDSAsig
                              //                      routingInfo:(unsigned long long)routingInfo
                              //           deviceUniqueIdentifier:(NSString *)deviceUniqueIdentifier
                              //               deviceSerialNumber:(NSString *)deviceSerialNumber
                              //                deviceDescription:(NSString *)deviceDescription
                                                                   date:(NSDate *)self.date
                              //                           locale:(NSLocale *)locale
                                                               timeZone:(NSTimeZone *)self.timeZone];

    return copy;
}

#pragma mark - <NSSecureCoding> -

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *deviceCA = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(deviceCA))];
    NSString *CAhash = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(CAhash))];
//    NSString *ECDSAsig = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(ECDSAsig))];
//    NSNumber *routingInfo = [decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(routingInfo))];

//    NSString *deviceUniqueIdentifier = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(deviceUniqueIdentifier))];
//    NSString *deviceSerialNumber = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(deviceSerialNumber))];
//    NSString *deviceDescription = [decoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(deviceDescription))];

    NSDate *date = [decoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(date))];
//    NSLocale *locale = [decoder decodeObjectOfClass:[NSLocale class] forKey:NSStringFromSelector(@selector(locale))];
    NSTimeZone *timeZone = [decoder decodeObjectOfClass:[NSTimeZone class] forKey:NSStringFromSelector(@selector(timeZone))];

//    NSData *searchPartyToken = [decoder decodeObjectOfClass:[NSData class] forKey:NSStringFromSelector(@selector(searchPartyToken))];

    self = [self initWithDeviceCA:(NSString *)deviceCA
                           CAhash:(NSString *)CAhash
//                         ECDSAsig:(NSString *)ECDSAsig
            //                      routingInfo:(unsigned long long)routingInfo
            //           deviceUniqueIdentifier:(NSString *)deviceUniqueIdentifier
            //               deviceSerialNumber:(NSString *)deviceSerialNumber
            //                deviceDescription:(NSString *)deviceDescription
                             date:(NSDate *)date
            //                           locale:(NSLocale *)locale
                         timeZone:(NSTimeZone *)timeZone];

//    self.searchPartyToken = searchPartyToken;

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.deviceCA forKey:NSStringFromSelector(@selector(deviceCA))];
    [encoder encodeObject:self.CAhash forKey:NSStringFromSelector(@selector(CAhash))];
//    [encoder encodeObject:self.ECDSAsig forKey:NSStringFromSelector(@selector(ECDSAsig))];
//    [encoder encodeObject:@(self.routingInfo) forKey:NSStringFromSelector(@selector(routingInfo))];
//
//    [encoder encodeObject:self.deviceUniqueIdentifier forKey:NSStringFromSelector(@selector(deviceUniqueIdentifier))];
//    [encoder encodeObject:self.deviceSerialNumber forKey:NSStringFromSelector(@selector(deviceSerialNumber))];
//    [encoder encodeObject:self.deviceDescription forKey:NSStringFromSelector(@selector(deviceDescription))];

    [encoder encodeObject:self.date forKey:NSStringFromSelector(@selector(date))];
//    [encoder encodeObject:self.locale forKey:NSStringFromSelector(@selector(locale))];
    [encoder encodeObject:self.timeZone forKey:NSStringFromSelector(@selector(timeZone))];
//    [encoder encodeObject:self.searchPartyToken forKey:NSStringFromSelector(@selector(searchPartyToken))];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
