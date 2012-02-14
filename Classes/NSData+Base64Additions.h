//
//  base64.h
//  ViewTransitions
//
//  Created by Neo on 5/11/08.
//  Copyright 2008 Kaliware, LLC. All rights reserved.
//


@interface NSData (Base64Additions)
+ (NSData *) dataWithBase64EncodedString:(NSString *) string;
- (id) initWithBase64EncodedString:(NSString *) string;

- (NSString *) base64Encoding;
- (NSString *) base64EncodingWithLineLength:(NSUInteger) lineLength;
@end
