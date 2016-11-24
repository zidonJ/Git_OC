//
//  PickColorView.m
//  RibbonIpad
//
//  Created by Zhongwei Sun on 11-10-12.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "PickColorView.h"

@implementation PickColorView

@synthesize pickedColorImageView;
@synthesize currentColor;
static CGContextRef CreateRGBABitmapContext (CGImageRef inImage) 
{
	CGContextRef context = NULL; 
	CGColorSpaceRef colorSpace; 
	void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。
	int bitmapByteCount; 
	int bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage); 
    
    
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	//分配足够容纳图片字节数的内存空间
	bitmapData = malloc( bitmapByteCount ); 
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
	context = CGBitmapContextCreate (bitmapData, 
                                     pixelsWide, 
                                     pixelsHigh, 
                                     8, 
                                     bitmapBytesPerRow, 
                                     colorSpace, 
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
	CGColorSpaceRelease( colorSpace ); 
	return context;
}

// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
static unsigned char *RequestImagePixelData(UIImage *inImage) 
{
	CGImageRef img = [inImage CGImage]; 
	CGSize size = [inImage size];
    //使用上面的函数创建上下文
	CGContextRef cgctx = CreateRGBABitmapContext(img); 
	
	CGRect rect = {{0,0},{size.width, size.height}};
    //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
	CGContextDrawImage(cgctx, rect, img); 
	unsigned char *data = CGBitmapContextGetData (cgctx); 
    //释放上面的函数创建的上下文
	CGContextRelease(cgctx);
	return data;
}

- (void)changColorOfImage:(UIImage*)inImage withColor:(UIColor *)color{
	CGImageRef inImageRef = [inImage CGImage];
	float w = CGImageGetWidth(inImageRef);
	float h = CGImageGetHeight(inImageRef);
	
	UIGraphicsBeginImageContext(CGSizeMake(w, h));
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h), inImageRef);
    CGContextAddRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeSourceIn);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, w, h));
    self.pickedColorImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

unsigned char *imgPixel;

- (id)initWithCoder:(NSCoder *)aDecoder andSourceImage:(UIImage *)aImage {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSourceImage:(UIImage *)sourceImage {
    width = sourceImage.size.width;
    height = sourceImage.size.height;
    imgPixel = RequestImagePixelData(sourceImage);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)showColorAtPoint:(CGPoint)aPoint {
    int i = 4 * width * aPoint.y + 4 * aPoint.x;
    int r = (unsigned char)imgPixel[i];
    int g = (unsigned char)imgPixel[i+1];
    int b = (unsigned char)imgPixel[i+2];
    
    self.currentColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    [self changColorOfImage:[UIImage imageNamed:@"colorBack.png"] withColor:self.currentColor];
}

- (void)dealloc {
    imgPixel = nil;
    self.pickedColorImageView = nil;
    self.currentColor = nil;
    [super dealloc];
}
@end
