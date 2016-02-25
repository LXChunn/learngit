//
//  UIImage+XPKit.m
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

#import "UIImage+XPKit.h"
#import "NSNumber+XPKit.h"
#import "UIColor+XPKit.h"
#import "XPLog.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h> // For CGImageDestination
#import <MobileCoreServices/MobileCoreServices.h> // For the UTI types constants
#import <AssetsLibrary/AssetsLibrary.h> // For photos album saving

CGContextRef XPImageCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow);

CGContextRef XPImageCreateARGBBitmapContext(const size_t width, const size_t height, const size_t bytesPerRow) {
	/// Use the generic RGB color space
	/// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	/// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
	CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8 /*Bits per component*/, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

	CGColorSpaceRelease(colorSpace);

	return bmContext;
}

#if __has_feature(objc_arc)
#define toCF (__bridge CFTypeRef)
#else
#define toCF (CFTypeRef)
#endif

@interface UIImage (private)

- (CFStringRef)utiForType:(XPImageType)type;
+ (NSString *)extensionForUTI:(CFStringRef)uti;

@end


CGSize sizeForSizeString(NSString *sizeString) {
	NSArray *array = [sizeString componentsSeparatedByString:@"x"];
	if (array.count != 2) return CGSizeZero;

	return CGSizeMake([array[0] floatValue], [array[1] floatValue]);
}

UIColor *colorForColorString(NSString *colorString) {
	if (!colorString) {
		return [UIColor lightGrayColor];
	}

	SEL colorSelector = NSSelectorFromString([colorString stringByAppendingString:@"Color"]);
	if ([UIColor respondsToSelector:colorSelector]) {
		return [UIColor performSelector:colorSelector];
	}
	else {
		return [UIColor colorWithHexString:colorString];
	}
}

@implementation UIImage (XPKit)

+ (void)load {
	static dispatch_once_t predicate;
	dispatch_once(&predicate, ^{
	    [self exchangeClassMethod:@selector(imageNamed:) withMethod:@selector(dummy_imageNamed:)];
	});
}

+ (NSString *)extensionForUTI:(CFStringRef)uti {
	if (!uti) return nil;

	NSDictionary *declarations = (__bridge NSDictionary *)UTTypeCopyDeclaration(uti);

	if (!declarations) return nil;

	id extensions = [(NSDictionary *)[declarations objectForKey:(NSString *)kUTTypeTagSpecificationKey] objectForKey : (NSString *)kUTTagClassFilenameExtension];
	NSString *extension = ([extensions isKindOfClass:[NSArray class]]) ? [extensions objectAtIndex:0] : extensions;
	CFRelease((__bridge CFTypeRef)(declarations));
	return extension;
}

- (CFStringRef)utiForType:(XPImageType)type {
	CFStringRef uti = NULL;

	switch (type) {
		case XPImageTypeBMP:
			uti = kUTTypeBMP;
			break;

		case XPImageTypeJPEG:
			uti = kUTTypeJPEG;
			break;

		case XPImageTypePNG:
			uti = kUTTypePNG;
			break;

		case XPImageTypeTIFF:
			uti = kUTTypeTIFF;
			break;

		case XPImageTypeGIF:
			uti = kUTTypeGIF;
			break;

		default:
			uti = kUTTypePNG;
			break;
	}
	return uti;
}

- (NSString *)base64Encoding {
	if (!self) {
		return nil;
	}
	NSData *data = UIImagePNGRepresentation(self);
	return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (CGFloat)width {
	return self.size.width;
}

- (CGFloat)height {
	return self.size.height;
}

+ (UIImage *)dummy_imageNamed:(NSString *)name {
	if (!name) return nil;

	UIImage *result;

	NSArray *array = [name componentsSeparatedByString:@"."];
	if ([[array[0] lowercaseString] isEqualToString:@"dummy"]) {
		NSString *sizeString = array[1];
		if (!sizeString) return nil;

		NSString *colorString = nil;
		if (array.count >= 3) {
			colorString = array[2];
		}

		return [self dummyImageWithSize:sizeForSizeString(sizeString) color:colorForColorString(colorString)];
	}
	else {
		result = [self dummy_imageNamed:name];
	}

	return result;
}

+ (UIImage *)dummyImageWithSize:(CGSize)size color:(UIColor *)color {
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);

	[color setFill];
	CGContextFillRect(context, rect);

	[[UIColor blackColor] setFill];
	NSString *sizeString = [NSString stringWithFormat:@"%d x %d", (int)size.width, (int)size.height];
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
		NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		style.alignment = NSTextAlignmentCenter;
		NSDictionary *attributes = @{ NSParagraphStyleAttributeName : style };
		[sizeString drawInRect:rect withAttributes:attributes];
	}
	else {
		[sizeString drawInRect:rect withFont:[UIFont systemFontOfSize:12] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
	}

	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();

	UIGraphicsEndImageContext();

	return result;
}

+ (void)exchangeClassMethod:(SEL)selector1 withMethod:(SEL)selector2 {
	Method fromMethod = class_getClassMethod(self, selector1);
	Method toMethod = class_getClassMethod(self, selector2);
	method_exchangeImplementations(fromMethod, toMethod);
}

- (UIImage *)blendOverlay {
	UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
	[self drawInRect:CGRectMake(0.0, 0.0, self.size.width, self.size.height) blendMode:kCGBlendModeOverlay alpha:1];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

- (UIImage *)maskWithImage:(UIImage *)image andSize:(CGSize)size {
	CGContextRef mainViewContentContext;
	CGColorSpaceRef colorSpace;
	colorSpace = CGColorSpaceCreateDeviceRGB();
	mainViewContentContext = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);

	if (mainViewContentContext == NULL) return NULL;

	CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), image.CGImage);
	CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, size.width, size.height), self.CGImage);
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	UIImage *returnImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
	CGImageRelease(mainViewContentBitmapContext);

	return returnImage;
}

- (UIImage *)maskWithImage:(UIImage *)image {
	CGContextRef mainViewContentContext;
	CGColorSpaceRef colorSpace;
	colorSpace = CGColorSpaceCreateDeviceRGB();
	mainViewContentContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
	CGColorSpaceRelease(colorSpace);

	if (mainViewContentContext == NULL) return NULL;

	CGContextClipToMask(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), image.CGImage);
	CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	UIImage *returnImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
	CGImageRelease(mainViewContentBitmapContext);

	return returnImage;
}

- (UIImage *)imageAtRect:(CGRect)rect {
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
	UIImage *subImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);

	return subImage;
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
	UIImage *sourceImage = self;
	UIImage *newImage = nil;

	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;

	if ([UIDevice isRetina]) {
		CGSize retinaTargetSize = CGSizeMake(targetSize.width * 2, targetSize.height * 2);
		if (!CGSizeEqualToSize(imageSize, retinaTargetSize)) targetSize = retinaTargetSize;
	}

	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;

	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;

	CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;

		if (widthFactor > heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;

		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;

		if (widthFactor > heightFactor) thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		else if (widthFactor < heightFactor) thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
	}

	UIGraphicsBeginImageContext(targetSize);
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	if (newImage == nil) XPLog(@"Could not scale image");

	return newImage;
}

- (UIImage *)imageByScalingProportionallyToMaximumSize:(CGSize)targetSize {
	if ([UIDevice isRetina]) {
		CGSize retinaMaxtSize = CGSizeMake(targetSize.width * 2, targetSize.height * 2);
		if (!CGSizeEqualToSize(targetSize, retinaMaxtSize)) targetSize = retinaMaxtSize;
	}

	if ((self.size.width > targetSize.width || targetSize.width == targetSize.height) && self.size.width > self.size.height) {
		float factor = (targetSize.width * 100) / self.size.width;
		float newWidth = (self.size.width * factor) / 100;
		float newHeight = (self.size.height * factor) / 100;

		CGSize newSize = CGSizeMake(newWidth, newHeight);
		UIGraphicsBeginImageContext(newSize);
		[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	}
	else if ((self.size.height > targetSize.height || targetSize.width == targetSize.height) && self.size.width < self.size.height) {
		float factor = (targetSize.height * 100) / self.size.height;
		float newWidth = (self.size.width * factor) / 100;
		float newHeight = (self.size.height * factor) / 100;

		CGSize newSize = CGSizeMake(newWidth, newHeight);
		UIGraphicsBeginImageContext(newSize);
		[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	}
	else if ((self.size.height > targetSize.height || self.size.width > targetSize.width) && self.size.width == self.size.height) {
		float factor = (targetSize.height * 100) / self.size.height;
		float newDimension = (self.size.height * factor) / 100;

		CGSize newSize = CGSizeMake(newDimension, newDimension);
		UIGraphicsBeginImageContext(newSize);
		[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	}
	else {
		CGSize newSize = CGSizeMake(self.size.width, self.size.height);
		UIGraphicsBeginImageContext(newSize);
		[self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
	}

	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return returnImage;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
	UIImage *sourceImage = self;
	UIImage *newImage = nil;

	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;

	if ([UIDevice isRetina]) {
		CGSize retinaTargetSize = CGSizeMake(targetSize.width * 2, targetSize.height * 2);
		if (!CGSizeEqualToSize(imageSize, retinaTargetSize)) targetSize = retinaTargetSize;
	}

	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;

	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;

	CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;

		if (widthFactor < heightFactor) scaleFactor = widthFactor;
		else scaleFactor = heightFactor;

		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;

		if (widthFactor < heightFactor) thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		else if (widthFactor > heightFactor) thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
	}

	UIGraphicsBeginImageContext(targetSize);

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	if (newImage == nil) XPLog(@"Could not scale image");

	return newImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
	UIImage *sourceImage = self;
	UIImage *newImage = nil;

	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;

	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;

	CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

	UIGraphicsBeginImageContext(targetSize);

	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;

	[sourceImage drawInRect:thumbnailRect];

	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	if (newImage == nil) XPLog(@"Could not scale image");

	return newImage;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians {
	return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees {
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;

	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();

	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);

	//   // Rotate the image context
	CGContextRotateCTM(bitmap, DegreesToRadians(degrees));

	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);

	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (BOOL)hasAlpha {
	CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
	return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast ||
	        alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

- (UIImage *)removeAlpha {
	if (![self hasAlpha]) return self;

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 0, colorSpace, kCGImageAlphaNoneSkipLast);
	CGColorSpaceRelease(colorSpace);

	CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
	CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	UIImage *returnImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
	CGImageRelease(mainViewContentBitmapContext);

	return returnImage;
}

- (UIImage *)fillAlpha {
	CGRect im_r;
	im_r.origin = CGPointZero;
	im_r.size = self.size;

	UIGraphicsBeginImageContext(self.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, im_r);
	[self drawInRect:im_r];

	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return returnImage;
}

- (UIImage *)fillAlphaWithColor:(UIColor *)color {
	CGRect im_r;
	im_r.origin = CGPointZero;
	im_r.size = self.size;

	CGColorRef cgColor = [color CGColor];

	UIGraphicsBeginImageContext(self.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, cgColor);
	CGContextFillRect(context, im_r);
	[self drawInRect:im_r];

	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return returnImage;
}

- (BOOL)isGrayscale {
	CGImageRef imgRef = [self CGImage];
	CGColorSpaceModel clrMod = CGColorSpaceGetModel(CGImageGetColorSpace(imgRef));

	switch (clrMod) {
		case kCGColorSpaceModelMonochrome:
			return YES;

		default:
			return NO;
	}
}

- (UIImage *)imageToGrayscale {
	CGSize size = self.size;
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaNone);
	CGColorSpaceRelease(colorSpace);
	CGContextDrawImage(context, rect, [self CGImage]);
	CGImageRef grayscale = CGBitmapContextCreateImage(context);
	UIImage *returnImage = [UIImage imageWithCGImage:grayscale];
	CGContextRelease(context);
	CGImageRelease(grayscale);

	return returnImage;
}

- (UIImage *)imageToBlackAndWhite {
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	CGContextRef context = CGBitmapContextCreate(nil, self.size.width, self.size.height, 8, self.size.width, colorSpace, kCGImageAlphaNone);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGContextSetShouldAntialias(context, NO);
	CGContextDrawImage(context, CGRectMake(0, 0, self.size.width, self.size.height), [self CGImage]);

	CGImageRef bwImage = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);

	UIImage *returnImage = [UIImage imageWithCGImage:bwImage];
	CGImageRelease(bwImage);

	return returnImage;
}

- (UIImage *)invertColors {
	UIGraphicsBeginImageContext(self.size);
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeCopy);
	[self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
	CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeDifference);
	CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor whiteColor].CGColor);
	CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, self.size.width, self.size.height));

	UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return returnImage;
}

- (UIImage *)bloom:(float)radius intensity:(float)intensity {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

- (UIImage *)bumpDistortion:(CIVector *)center radius:(float)radius scale:(float)scale {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortion"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:center forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

- (UIImage *)bumpDistortionLinear:(CIVector *)center radius:(float)radius angle:(float)angle scale:(float)scale {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CIBumpDistortionLinear"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:center forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:scale] forKey:@"inputScale"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

- (UIImage *)circleSplashDistortion:(CIVector *)center radius:(float)radius {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CICircleSplashDistortion"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:center forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

- (UIImage *)circularWrap:(CIVector *)center radius:(float)radius angle:(float)angle {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CICircularWrap"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:center forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:radius] forKey:@"inputRadius"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

- (UIImage *)cmykHalftone:(CIVector *)center width:(float)width angle:(float)angle sharpness:(float)sharpness gcr:(float)gcr ucr:(float)ucr {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CICMYKHalftone"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:center forKey:@"inputCenter"];
	[filter setValue:[NSNumber numberWithFloat:width] forKey:@"inputWidth"];
	[filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
	[filter setValue:[NSNumber numberWithFloat:sharpness] forKey:@"inputSharpness"];
	[filter setValue:[NSNumber numberWithFloat:gcr] forKey:@"inputGCR"];
	[filter setValue:[NSNumber numberWithFloat:ucr] forKey:@"inputUCR"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

- (UIImage *)sepiaToneWithIntensity:(float)intensity {
	CIContext *context = [CIContext contextWithOptions:nil];
	CIImage *image = [CIImage imageWithCGImage:[self CGImage]];
	CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
	[filter setValue:image forKey:kCIInputImageKey];
	[filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
	CIImage *result = [filter valueForKey:kCIOutputImageKey];
	CGImageRef cgImage = [context createCGImage:result fromRect:[result extent]];

	UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
	CFRelease(cgImage);

	return returnImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0, 0, 1, 1);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);

	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

- (UIImage *)flip:(BOOL)horizontal {
	CGImageRef cgImage = self.CGImage;
	const CGFloat originalWidth = CGImageGetWidth(cgImage);
	const CGFloat originalHeight = CGImageGetHeight(cgImage);
	const size_t bytesPerRow = (size_t)originalWidth * 4;
	CGContextRef bmContext = XPImageCreateARGBBitmapContext((size_t)originalWidth, (size_t)originalHeight, bytesPerRow);

	if (!bmContext) return nil;

	CGContextSetShouldAntialias(bmContext, true);
	CGContextSetAllowsAntialiasing(bmContext, true);
	CGContextSetInterpolationQuality(bmContext, kCGInterpolationHigh);
	horizontal ? CGContextScaleCTM(bmContext, -1.0f, 1.0f) : CGContextScaleCTM(bmContext, 1.0f, -1.0f);
	const CGRect r = horizontal ? (CGRect) {.origin.x = -originalWidth, .origin.y = 0.0f, .size.width = originalWidth, .size.height = originalHeight } : (CGRect) {.origin.x = 0.0f, .origin.y = -originalHeight, .size.width = originalWidth, .size.height = originalHeight };
	CGContextDrawImage(bmContext, r, cgImage);
	CGImageRef flippedImageRef = CGBitmapContextCreateImage(bmContext);
	UIImage *flipped = [UIImage imageWithCGImage:flippedImageRef];
	CGImageRelease(flippedImageRef);
	CGContextRelease(bmContext);
	return flipped;
}

- (UIImage *)verticalFlip {
	return [self flip:NO];
}

- (UIImage *)horizontalFlip {
	return [self flip:YES];
}

- (UIImage *)boxBlurImageWithBlur:(CGFloat)blur {
	if (blur < 0.f || blur > 1.f) {
		blur = 0.5f;
	}
	int boxSize = (int)(blur * 50);
	boxSize = boxSize - (boxSize % 2) + 1;

	CGImageRef img = self.CGImage;

	vImage_Buffer inBuffer, outBuffer;

	vImage_Error error;

	void *pixelBuffer;

	CGDataProviderRef inProvider = CGImageGetDataProvider(img);
	CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

	inBuffer.width = CGImageGetWidth(img);
	inBuffer.height = CGImageGetHeight(img);
	inBuffer.rowBytes = CGImageGetBytesPerRow(img);

	inBuffer.data = (void *)CFDataGetBytePtr(inBitmapData);

	pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

	if (pixelBuffer == NULL)
		XPLog(@"No pixelbuffer");

	outBuffer.data = pixelBuffer;
	outBuffer.width = CGImageGetWidth(img);
	outBuffer.height = CGImageGetHeight(img);
	outBuffer.rowBytes = CGImageGetBytesPerRow(img);

	error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

	if (error)
		XPLog(@"Error from convolution %ld", error);

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef ctx = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
	CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
	UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

	CGContextRelease(ctx);
	CGColorSpaceRelease(colorSpace);

	free(pixelBuffer);
	CFRelease(inBitmapData);

	CGImageRelease(imageRef);

	return returnImage;
}

- (BOOL)saveToPhotosAlbum {
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	__block BOOL ret = YES;

	[library writeImageToSavedPhotosAlbum:self.CGImage
	                          orientation:(ALAssetOrientation)self.imageOrientation
	                      completionBlock: ^(NSURL *assetURL, NSError *error) {
	    if (!assetURL) {
	        ret = NO;
		}
	}];
	return ret;
}

- (BOOL)saveToPath:(NSString *)path uti:(CFStringRef)uti backgroundFillColor:(UIColor *)fillColor compressionQuality:(CGFloat)quality {
	if (!path) return NO;

	if (!uti) uti = kUTTypePNG;

	CGImageDestinationRef dest = CGImageDestinationCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], uti, 1, NULL);

	if (!dest) return NO;

	/// Set the options, 1 -> lossless
	CFMutableDictionaryRef options = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

	if (!options) {
		CFRelease(dest);
		return NO;
	}

	CFDictionaryAddValue(options, kCGImageDestinationLossyCompressionQuality, (CFNumberRef)[NSNumber numberWithFloat: quality]);        // No compression

	if (fillColor) CFDictionaryAddValue(options, kCGImageDestinationBackgroundColor, fillColor.CGColor);

	/// Add the image
	CGImageDestinationAddImage(dest, self.CGImage, (CFDictionaryRef)options);

	/// Write it to the destination
	const bool success = CGImageDestinationFinalize(dest);

	/// Cleanup
	CFRelease(options);
	CFRelease(dest);

	return success;
}

- (BOOL)saveToPath:(NSString *)path type:(XPImageType)type backgroundFillColor:(UIColor *)fillColor compressionQuality:(CGFloat)quality {
	if (!path) return NO;

	return [self saveToPath:path uti:[self utiForType:type] backgroundFillColor:fillColor compressionQuality:quality];
}

- (BOOL)saveToPath:(NSString *)path compressionQuality:(CGFloat)quality {
	return [self saveToPath:path type:XPImageTypePNG backgroundFillColor:nil compressionQuality:quality];
}

- (BOOL)saveToPath:(NSString *)path {
	if (!path) return NO;

	return [self saveToPath:path compressionQuality:1.0f];
}

@end
