//
//  AuthenticationData.h
//  AirFrag
//
//  Created by Daniel on 27/06/2022.
//

#import <Foundation/Foundation.h>


@interface AuthenticationData : NSObject <NSCopying, NSSecureCoding>

@property(nonatomic, copy) NSString *deviceCA;
@property(nonatomic, copy) NSString *CAhash;
@property(nonatomic, copy) NSString *ECDSAsig;

//@property(nonatomic, copy) NSString *deviceUniqueIdentifier;
//@property(nonatomic, copy) NSString *deviceSerialNumber;
//@property(nonatomic, copy) NSString *deviceDescription;

@property(nonatomic, copy) NSDate *date;
@property(nonatomic, copy) NSTimeZone *timeZone;

@property(nonatomic, copy) NSData *_Nullable searchPartyToken;

- (instancetype)initWithDeviceCA:(NSString *)deviceCA
                  CAhash:(NSString *)CAhash
                      ECDSAsig:(NSString *)ECDAsig
//                      routingInfo:(unsigned long long)routingInfo
//           deviceUniqueIdentifier:(NSString *)deviceUniqueIdentifier
//               deviceSerialNumber:(NSString *)deviceSerialNumber
//                deviceDescription:(NSString *)deviceDescription
                             date:(NSDate *)date
//                           locale:(NSLocale *)locale
                         timeZone:(NSTimeZone *)timeZone;

//- (instancetype)initFromALTAnissetteData:(ALTAnisetteData *)altAnisetteData;

@end

