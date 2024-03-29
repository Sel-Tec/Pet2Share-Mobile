//
//  Graphics.m
//  pet2share
//
//  Created by Tony Kieu on 7/10/15.
//  Copyright (c) 2015 Pet 2 Share. All rights reserved.
//

#import "Graphics.h"

@implementation Graphics

#pragma mark - Private Helpers

+ (SIAlertView *)buildAlert:(NSString *)title message:(NSString *)message type:(AlertType)type
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];
    alertView.titleFont = [UIFont systemFontOfSize:20.0f weight:UIFontWeightMedium];
    alertView.messageFont = [UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular];
    alertView.buttonFont = [UIFont systemFontOfSize:17.0f weight:UIFontWeightRegular];
    alertView.cornerRadius = 5.0f;
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    alertView.buttonFont = [UIFont systemFontOfSize:15.0f weight:UIFontWeightRegular];
    
    switch (type)
    {
        case NormalAlert:
            alertView.titleColor = [AppColorScheme blue];
            break;
            
        case WarningAlert:
            alertView.titleColor = [AppColorScheme orange];
            break;
            
        case ErrorAlert:
            alertView.titleColor = [AppColorScheme red];
            break;
            
        default:
            alertView.titleColor = [AppColorScheme darkGray];
            break;
    }
    
    return alertView;
}

#pragma mark - Alert View

+ (void)alert:(NSString *)title message:(NSString *)message type:(AlertType)type
{
    SIAlertView *alertView = [self buildAlert:title message:message type:type];
    [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:^(SIAlertView *alert) {}];
    [alertView show];
    
}

+ (void)alert:(NSString *)title message:(NSString *)message type:(AlertType)type
           ok:(SIAlertViewHandler)okHandler
{
    SIAlertView *alertView = [self buildAlert:title message:message type:type];
    [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:okHandler];
    [alertView show];
    
}

+ (void)promptAlert:(NSString *)title message:(NSString *)message type:(AlertType)type
                 ok:(SIAlertViewHandler)okHandler
             cancel:(SIAlertViewHandler)cancelHandler
{
    SIAlertView *alertView = [self buildAlert:title message:message type:type];
    [alertView addButtonWithTitle:NSLocalizedString(@"OK", @"")
                             type:SIAlertViewButtonTypeDefault
                          handler:okHandler];
    [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", @"")
                             type:SIAlertViewButtonTypeCancel
                          handler:cancelHandler];
    [alertView show];
}

#pragma mark - Color

+ (UIColor *)lighterColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.1, 1.0)
                               green:MIN(g + 0.1, 1.0)
                                blue:MIN(b + 0.1, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)color
{
    CGFloat r, g, b, a;
    if ([color getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

#pragma mark - Views

+ (void)roundView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
    shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset
{
    [self dropShadow:view shadowOpacity:shadowOpacity shadowRadius:shadowRadius offset:shadowOffset];
    view.layer.cornerRadius = cornerRadius;
}

+ (void)dropShadow:(UIView *)view shadowOpacity:(CGFloat)shadowOpacity
      shadowRadius:(CGFloat)shadowRadius offset:(CGSize)shadowOffset
{
    view.layer.masksToBounds = NO;
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    view.layer.shouldRasterize = YES;
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}

+ (void)circleImageView:(UIImageView *)imageView hasBorder:(BOOL)hasBorder
{
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    
    if (hasBorder)
    {
        imageView.layer.borderWidth = 2.0f;
        imageView.layer.borderColor = [AppColorScheme darkGray].CGColor;
    }
}

+ (UIButton *)circleImageButton:(CGFloat)diameter image:(UIImage *)image borderColor:(UIColor *)color
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.bounds = CGRectMake(0.0f, 0.0f, diameter, diameter);
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = diameter/2;
    button.layer.borderColor = color.CGColor;
    button.layer.borderWidth = 1.0f;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
    return button;
}

/**
 * Draw a gradient UIImage separator. The height optimal for 2px and color
 * should be the background color of the container.
 * @param CGFloat height - Separator height
 * @param UIColor color - Container background color
 * @return UIImage
 */
+ (UIImage *)separatorImage:(CGFloat)height backgroundColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, height*2));
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    CGContextSetFillColorWithColor(context, [self darkerColorForColor:color].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 0.25*height*2, height));
    CGContextSetFillColorWithColor(context, [self lighterColorForColor:color].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0.75*height*2, 0.25*height*2, height));
    UIGraphicsPopContext();
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:outputImage.CGImage scale:height orientation:UIImageOrientationUp];
}

+ (UIImage *)circleImage:(UIImage*)image frame:(CGRect)frame
{
    // Create the bitmap graphics context
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(frame.size.width, frame.size.height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Get the width and heights
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat rectWidth = frame.size.width;
    CGFloat rectHeight = frame.size.height;
    
    // Calculate the scale factor
    CGFloat scaleFactorX = rectWidth/imageWidth;
    CGFloat scaleFactorY = rectHeight/imageHeight;
    
    // Calculate the centre of the circle
    CGFloat imageCentreX = rectWidth/2;
    CGFloat imageCentreY = rectHeight/2;
    
    // Create and CLIP to a CIRCULAR Path
    // (This could be replaced with any closed path if you want a different shaped clip)
    CGFloat radius = rectWidth/2;
    CGContextBeginPath (context);
    CGContextAddArc (context, imageCentreX, imageCentreY, radius, 0, 2*M_PI, 0);
    CGContextClosePath (context);
    CGContextClip (context);
    
    // Set the SCALE factor for the graphics context
    // All future draw calls will be scaled by this factor
    CGContextScaleCTM (context, scaleFactorX, scaleFactorY);
    
    // Draw the IMAGE
    CGRect myRect = CGRectMake(0, 0, imageWidth, imageHeight);
    [image drawInRect:myRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize
{
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height )
    {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)tintImage:(UIImage *)source withColor:(UIColor *)color
{
    // Begin a new image context, to draw our colored image onto with the right scale
    UIGraphicsBeginImageContextWithOptions(source.size, NO, [UIScreen mainScreen].scale);
    
    // Get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the fill color
    [color setFill];
    
    // Translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // Generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Return the color-burned image
    return coloredImg;
}

+ (CGSize)getImageViewSizeForImage:(UIImage *)image constraintTo:(CGFloat)width
{
    CGFloat ratio = image.size.height/image.size.width;
    CGSize imageViewSize = CGSizeMake(width, width*ratio);
    DEBUG_SIZE("Image View Size ", imageViewSize);
    return imageViewSize;
}

+ (CGSize)getDeviceSize
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    return screenBounds.size;
}

+ (UIButton *)createBarButtonWithTitle:(NSString *)title
{
    CGSize buttonSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f weight:UIFontWeightBold]}];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0.0f, 0.0f, buttonSize.width, buttonSize.height);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    return button;
}

@end