//
//  NSString+XPKit.h
//  XPKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 - 2015 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

/**
 *  This class add some useful methods to NSString
 */
@interface NSString (XPKit)

/**
 *  Convert String to an NSObject instance
 *
 *  @return Return NSObject instance
 */
- (instancetype)stringToObject;

/**
 *  Encode self to an encoded HMAC string
 *
 *  @param type   type
 *  @param secret secret
 *
 *  @return Return the encoed NSString
 */
- (NSString *)hmacAlgorithm:(CCHmacAlgorithm)type secret:(NSString *)secret;

/**
 *  Encode self to an encoded base64 string
 *
 *  @return Return the encoded NSString
 */
- (NSString *)base64Encode;

/**
 *  Decode self to an decoded base64 string
 *
 *  @return Return the decoded NSString
 */
- (NSString *)base64Decode;

/**
 *  Encode self to an encoded url string
 *
 *  @return Return the encoded NSString
 */
- (NSString *)urlEncode;

/**
 *  Decode self to an decoded url string
 *
 *  @return Return the decoded NSString
 */
- (NSString *)urlDecode;

/**
 *  Convert self to a hex value
 *
 *  @return Return the hex value
 */
- (NSInteger)hexValue;

/**
 *  Convert self to a unsigned int value
 *
 *  @return Return the unsigned int value
 */
- (unsigned int)unsignedIntValue;

/**
 *  Convert self to a unsigned long long value
 *
 *  @return Return the unsigned long long value
 */
- (unsigned long long)unsignedLongLongValue;

/**
 *  Remove white space and new line
 *
 *  @return Return removed NSString
 */
- (NSString *)removeWhitespaceAndNewline;

/**
 *  Search in a given string a substring from the start char to the end char.
 *  Example: "This is a test" with start char 'h' and end char 't' will return "his is a "
 *
 *  @param string The string to search in
 *  @param start  The start char
 *  @param end    The end char
 *
 *  @return
 */
+ (NSString *)searchInString:(NSString *)string
                   charStart:(char)start
                     charEnd:(char)end;

/**
 *  Search in self for a substring from the start char to the end char.
 *  Example: "This is a test" with start char 'h' and end char 't' will return "his is a "
 *
 *  @param start  The start char
 *  @param end    The end char
 *
 *  @return
 */
- (NSString *)searchCharStart:(char)start
                      charEnd:(char)end;

/**
 *  Create a MD5 string from self
 *
 *  @return Return the MD5 NSString from self
 */
- (NSString *)MD5;

/**
 *  Create a SHA1 string from self
 *
 *  @return Return the SHA1 NSString from self
 */
- (NSString *)SHA1;

/**
 *  Create a SHA256 string from self
 *
 *  @return Return the SHA256 NSString from self
 */
- (NSString *)SHA256;

/**
 *  Create a SHA512 string from self
 *
 *  @return Return the SHA512 NSString from self
 */
- (NSString *)SHA512;

/**
 *  Check if self has the given substring
 *
 *  @param substring The substring to be searched
 *
 *  @return Return YES if founded, NO if not
 */
- (BOOL)hasString:(NSString *)substring;

/**
 *  Check if self is an email
 *
 *  @return Return YES if it's an email, NO if not
 */
- (BOOL)isEmail;

/**
 *  Check if the given string is an email
 *
 *  @param email The string to be checked
 *
 *  @return Return YES if it's an email, NO if not
 */
+ (BOOL)isEmail:(NSString *)email;

/**
 *  Convert a string to UTF8
 *
 *  @param string String to be converted
 *
 *  @return Return the converted string
 */
+ (NSString *)convertToUTF8Entities:(NSString *)string;

/**
 *  Conver self to a capitalized string.
 *  Example: "This is a Test" will return "This is a test" and "this is a test" will return "This is a test"
 *
 *  @return Return the capitalized sentence string
 */
- (NSString *)sentenceCapitalizedString;

/**
 *  Return a human legible string from a timestamp
 *
 *  @return Return a human legible string from a timestamp
 */
- (NSString *)dateFromTimestamp;

@end
