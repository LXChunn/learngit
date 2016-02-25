//
//  XPAutoNIBi18n.h
//  Huaban
//
//  Created by huangxinping on 4/23/15.
//  Copyright (c) 2015 iiseeuu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! Shorthand for NSLocalizedString */
#ifndef _T
#define _T(key) NSLocalizedString((key), @"")
#endif

/*! Use NSLocalizedString representing a format string */
#ifndef _Tf
#define _Tf(key, ...) [NSString stringWithFormat: _T(key), __VA_ARGS__]
#endif

/*! Easily define singular and plural forms.
 *  - The key with "(0)" appended is used if n == 0
 *  - The key with "(1)" appended is used if n == 1 (singular form)
 *  - The key is used unchanged in any other case (like when n>1, plural form)
 *
 * Example of a Localized.strings file content:
 *   "apple(0)" = "%2$@ n'a aucune pomme";
 *   "apple(1)" = "%2$@ n'a qu'une seule pomme";
 *   "apple"    = "%2$@ a %1$d pommes";
 * Usage: _Tf_n(@"apple", nbApples, firstName);
 */
#ifndef _Tfn
#define _Tfn(key, n, ...) _Tf((n == 1) ? (key "(1)") : ((n == 0) ? (key "(0)") : (key)), n, ## __VA_ARGS__)
#endif

@interface NSBundle (Language)

/**
 *  设置使用语种（如：en、zh-Hans、de等）
 *
 *  [NSBundle setLanguage:@"en"];
 *  [NSBundle setLanguage:@"fr"];
 *  [NSBundle setLanguage:nil];  To reset back to system defaults, simply pass nil:
 *
 *  @param language 语种
 */
+ (void)setLanguage:(NSString *)language;

@end
