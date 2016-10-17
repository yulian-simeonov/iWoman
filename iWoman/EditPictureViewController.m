//
//  EditPictureViewController.m
//  InstapicPhotoKiosk
//
//  Created by osone on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditPictureViewController.h"

#define NUMBER_OF_ITEMS ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 19: 12)
#define ITEM_SPACING 320
#define PAPER_SIZE_MAX 255
#define PAPER_SIZE_MID 200
#define PAPER_SIZE_MINI 150

@implementation EditPictureViewController

@synthesize carousel;
@synthesize mImageArray;
@synthesize photoSize;
@synthesize curPhotoIndex;
@synthesize dictOrgImage = _dictOrgImage;
@synthesize dictOrgBorderedImage = _dictOrgBorderedImage;
@synthesize arrayImageView = _arrayImageView;
@synthesize arrayIsBordered = _arrayIsBordered;
@synthesize imageTempPath = _imageTempPath;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (self.mImageArray.count == 0)
            self.mImageArray = [AppDelegate sharedAppDelegate].curAlbumList;
        self.photoSize = PAPER_SIZE_MAX;
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mImageArray = [AppDelegate sharedAppDelegate].curAlbumList;

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStylePlain target:self action:@selector(onClickPrint:)];
    [rightButton setTintColor:[UIColor blackColor]];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [rightButton release];
    self.dictOrgImage = [[NSMutableDictionary alloc] initWithCapacity:self.mImageArray.count];
    self.dictOrgBorderedImage = [[NSMutableDictionary alloc] initWithCapacity:self.mImageArray.count];
    self.arrayImageView = [[NSMutableDictionary alloc] initWithCapacity:mImageArray.count];
    self.arrayIsBordered = [[NSMutableDictionary alloc] initWithCapacity:mImageArray.count];
    for (int i=0; i<mImageArray.count; i++) {
        UIImage *image = [UIImage imageWithContentsOfFile:[self.mImageArray objectAtIndex:i]];
        NSLog(@"%f", image.size.height);
        NSLog(@"%f", image.size.width);
        
        int width = image.size.width;
        int height = image.size.height;
        UIImageView* newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        UIImage* newImage = [[self resizedImage1:image inRect:CGRectMake(0, 0, width, height)] retain];
        [newImageView setImage:newImage];
        [self.arrayImageView setObject:newImageView forKey:[NSNumber numberWithInt:i]];
        [newImageView release];
    }
    [carousel reloadData];
    [carousel scrollToItemAtIndex:self.curPhotoIndex animated:YES];
    // Do any additional setup after loading the view from its nib.

}

-(UIImage*)resizedImage1:(UIImage*)inImage  inRect:(CGRect)thumbRect {
	// Creates a bitmap-based graphics context and makes it the current context.
	UIGraphicsBeginImageContext(thumbRect.size);
	[inImage drawInRect:thumbRect];
	
	return UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    self.carousel.type = 0;
    return self.mImageArray.count;
}

- (void) viewWillAppear:(BOOL) animated {
    
    
	[self.navigationController setNavigationBarHidden:NO];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{ 

    UIImage *image = [UIImage imageWithContentsOfFile:[self.mImageArray objectAtIndex:index]];
    int width = image.size.width;
    int height = image.size.height;
    if (width > height) {
        if (image.size.width >= 320) {
            width = 320;
            height = image.size.height / image.size.width * 320;
        } else if (image.size.height >= 300){
            height = 300;
            width = image.size.width / image.size.height * 300;
        }
    } else {
            if (image.size.height >= 300) {
                height = 300;
                width = image.size.width / image.size.height * 300;
            } 
    }

    
    CGRect aRect = CGRectMake(0, 0, width, height);
    UIView *masterView = [[UIView alloc] initWithFrame:aRect];
    masterView.autoresizesSubviews = YES;

    
    UIImageView *theImageView = [[UIImageView alloc] initWithImage:image];
    theImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // re-specify the size of the image subview's frame, since apparently initWithImage resets it to match the size of the image; if I don't do this, the image is displayed at full size and just flows off the side of the screen
    theImageView.frame = masterView.frame;
    
    [masterView addSubview:theImageView];
    
    return masterView;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return ITEM_SPACING;
}

- (void) printItem:(NSInteger) index {
    
    NSString *path = [self.mImageArray objectAtIndex:index];
    NSData *dataFromPath = [NSData dataWithContentsOfFile:path];
    
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    
    if(printController && [UIPrintInteractionController canPrintData:dataFromPath]) {
        
        printController.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = dataFromPath;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [printController presentAnimated:YES completionHandler:completionHandler];
        
    }
}

- (void) printAllItem {
    
    NSMutableArray* arrayItemData = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<self.mImageArray.count; i++) {
        NSData *dataImage = [NSData dataWithContentsOfFile:[self.mImageArray objectAtIndex:i]];        
        if ([UIPrintInteractionController canPrintData:dataImage])
            [arrayItemData addObject:dataImage];
    }
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    
    if(printController) {
        
        printController.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
//        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItems = arrayItemData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [printController presentAnimated:YES completionHandler:completionHandler];
        
    }
}

- (UIPrintPaper *)printInteractionController:(UIPrintInteractionController *)pic
                                 choosePaper:(NSArray *)paperList {
    // custom method & properties...
    CGSize size;
    if (self.photoSize == PAPER_SIZE_MAX)
        size = CGSizeMake(1500, 1000);
    else if (self.photoSize == PAPER_SIZE_MAX)
        size = CGSizeMake(1000, 500);
    else if (self.photoSize == PAPER_SIZE_MAX)
        size = CGSizeMake(687.5, 875);
    
    CGSize pageSize = size;
    return [UIPrintPaper bestPaperForPageSize:pageSize
                          withPapersFromArray:paperList];
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [sender tag];
    
    [[[[UIAlertView alloc] initWithTitle:@"Button Tapped"
                                 message:[NSString stringWithFormat:@"You tapped button number %i.You can print this photo.", index]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];
    [self printItem:index];
}

- (UIImage*) convertBlackWhiteImage:(UIImage*)originalImage {

    CGColorSpaceRef colorSapce = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, originalImage.size.width,     originalImage.size.height, 8, originalImage.size.width, colorSapce, kCGImageAlphaNone);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, originalImage.size.width, originalImage.size.height), [originalImage CGImage]);
    CGImageRef bwImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSapce);
    
    UIImage *resultImage = [UIImage imageWithCGImage:bwImage]; // This is result B/W image.
    CGImageRelease(bwImage);
    
    return resultImage;
}

- (IBAction)removeItem
{
    if (carousel.numberOfItems > 0)
    {
        NSInteger index = carousel.currentItemIndex;
        [carousel removeItemAtIndex:index animated:YES];
        [self.mImageArray removeObjectAtIndex:index];
        [[AppDelegate sharedAppDelegate] writePlist:DB_FILE_NAME];
    }
}

- (IBAction) onClickBlackWhite:(id)sender {

    if (mImageArray.count > 0) {
        NSInteger index = carousel.currentItemIndex;
        NSLog(@"%d", index);
        NSString* fullPath = [self.mImageArray objectAtIndex:index];
        NSData* orgImageData = [self.dictOrgImage objectForKey:[NSString stringWithFormat:@"%d",index]];
        UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
        int width = image.size.width;
        int height = image.size.height;
        NSData* newImageData;
        if (orgImageData == nil) {
            orgImageData = UIImagePNGRepresentation(image);
            [self.dictOrgImage setObject:orgImageData forKey:[NSString stringWithFormat:@"%d",index]];
            newImageData = UIImagePNGRepresentation( [self convertBlackWhiteImage:image] );
        } else {
            newImageData = [orgImageData mutableCopy];
            [self.dictOrgImage setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"%d",index]];
        }
        
        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        [fileManager createFileAtPath:fullPath contents:newImageData attributes:nil];
        if ([fileManager fileExistsAtPath:fullPath]) {
            NSLog(@"exist");
        }
        
        
        UIImage *imageChanged = [UIImage imageWithContentsOfFile:fullPath];
        UIImageView* imageViewNew = [[UIImageView alloc] initWithImage:imageChanged];
        [imageViewNew setFrame:CGRectMake(0, 0, width, height)];
        [self.arrayImageView setObject:imageViewNew forKey:[NSNumber numberWithInt:index]];
//        [imageViewNew released];
        [self saveImage:index];
        [carousel reloadData];
    }
}

- (IBAction) onClickSizeMax:(id)sender {

    int index = [self.carousel currentItemIndex];
    UIImage* image = [UIImage imageWithContentsOfFile:[self.mImageArray objectAtIndex:index]];
    int width = image.size.width;
    int height = image.size.height;
    UIImageView* newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [newImageView setImage:image];
    [self.arrayImageView setObject:newImageView forKey:[NSNumber numberWithInt:index]];
    [self saveImage:index];
    [carousel reloadData];
}

- (IBAction) onClickSizeMid:(id)sender {

    self.photoSize = PAPER_SIZE_MID;
    int index = [self.carousel currentItemIndex];
    CGRect rect = [[self.arrayImageView objectForKey:[NSNumber numberWithInt:index]] frame];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];

    UIImage* image = [UIImage imageWithContentsOfFile:[self.mImageArray objectAtIndex:index]];
    int width = image.size.width;
    int height = image.size.height;
    int width1 = (width - 20) / 2;
    int height1 = height - 10;

    [imageView setBackgroundColor:[UIColor whiteColor]];
    for (int i=0; i<2; i++) {
        UIImageView* newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*width1+5*(i+1), 5, width1, height1)];
        [newImageView setImage:image];
        [imageView addSubview:newImageView];
        [newImageView release];
    }
    
    [self.arrayImageView setObject:imageView forKey:[NSNumber numberWithInt:index]];
    [self saveImage:index];
    [carousel reloadData];
}

- (IBAction) onClickSizeMini:(id)sender {
 
    int index = [self.carousel currentItemIndex];
    CGRect rect = [[self.arrayImageView objectForKey:[NSNumber numberWithInt:index]] frame];
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
    UIImage* image = [UIImage imageWithContentsOfFile:[self.mImageArray objectAtIndex:index]];
    [imageView setBackgroundColor:[UIColor whiteColor]];
    int width = image.size.width;
    int height = image.size.height;
    int width1 = (width - 20) / 3;
    int height1 = (height - 15) / 2;
    for (int i=0; i<2; i++) {
        for (int j=0; j<3; j++) {
            UIImageView* newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width1*j+5*(j+1), 5*(i+1)+i*height1, width1, height1)];
            [newImageView setImage:image];
            [imageView addSubview:newImageView];
            [newImageView release];

        }
    }
    self.photoSize = PAPER_SIZE_MINI;
    [self.arrayImageView setObject:imageView forKey:[NSNumber numberWithInt:index]];
    [self saveImage:index];
    [carousel reloadData];
}

static const void* GetBytePointer(void* info)
{
	return info; // info is a pointer to the buffer
}

static void ReleaseBytePointer(void*info, const void* pointer)
{
	
}


static size_t GetBytesAtPosition(void* info, void* buffer, off_t position, size_t count)
{
    memcpy(buffer, ((char*)info) + position, count);
    return count;
}

- (IBAction) onClickBorder:(id)sender {

    if (mImageArray.count > 0) {
        int index = [self.carousel currentItemIndex];
        NSString* fullPath = [self.mImageArray objectAtIndex:index];
        UIImage* image = [UIImage imageWithContentsOfFile:[self.mImageArray objectAtIndex:index]];
        int width = image.size.width;
        int height = image.size.height;
        NSData* orgImageData = [self.dictOrgBorderedImage objectForKey:[NSString stringWithFormat:@"%d",index]];
        NSData* newImageData;
        if (orgImageData == nil) {
            orgImageData = UIImagePNGRepresentation(image);
            [self.dictOrgBorderedImage setObject:orgImageData forKey:[NSString stringWithFormat:@"%d",index]];
            
            CGRect rect = [[self.arrayImageView objectForKey:[NSNumber numberWithInt:index]] frame];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:rect];
            [imageView setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView* newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, width-10, height-10)];
            [newImageView setImage:image];
            [imageView addSubview:newImageView];
            
            
            UIGraphicsBeginImageContext(imageView.frame.size);
            [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
            
            newImageData = UIImagePNGRepresentation(screenshot);
        } else {
            newImageData = [orgImageData mutableCopy];
            [self.dictOrgBorderedImage setObject:UIImagePNGRepresentation(image) forKey:[NSString stringWithFormat:@"%d",index]];
        }

        NSFileManager* fileManager = [NSFileManager defaultManager];
        
        [fileManager createFileAtPath:fullPath contents:newImageData attributes:nil];
        if ([fileManager fileExistsAtPath:fullPath]) {
            NSLog(@"exist");
        }
        
        
        UIImage *imageChanged = [UIImage imageWithContentsOfFile:fullPath];
        UIImageView* imageViewNew = [[UIImageView alloc] initWithImage:imageChanged];
        [imageViewNew setFrame:CGRectMake(0, 0, width, height)];
        [self.arrayImageView setObject:imageViewNew forKey:[NSNumber numberWithInt:index]];
                [imageViewNew release];
        [self saveImage:index];
        
        [carousel reloadData];
        
    }
}

- (void) saveImage:(NSInteger)index {

    UIImageView* imageView = [self.arrayImageView objectForKey:[NSNumber numberWithInt:index]];
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    NSString* fullPath = [self.mImageArray objectAtIndex:index];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    [fileManager createFileAtPath:fullPath contents:UIImagePNGRepresentation(screenshot) attributes:nil];
    if ([fileManager fileExistsAtPath:fullPath]) {
        NSLog(@"exist");
    }
//    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    UIGraphicsEndImageContext();
}

- (IBAction) onClickPrint:(id)sender {
    
    NSInteger index = [carousel indexOfItemView:sender];
    
    [[[[UIAlertView alloc] initWithTitle:@""
                                 message:[NSString stringWithFormat:@"You are printing all photos in this album.", index]
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];
    [self printAllItem];
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
    CGSize size = [source size];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(15, 15, size.width-30, size.height-30);
    [source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0); 
    CGContextStrokeRect(context, rect);
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return testImg;
}

- (UIImage *)captureView:(UIView *)view {
    CGRect screenRect = CGRectMake(0, 0, 250, 200);
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *) drawBorderWithUIView:(UIImage*) source {
    
    CGSize size = [source size];
    UIView *blackBG = [[UIView alloc] initWithFrame:CGRectMake(0,0,size.width,size.height)];

    blackBG.backgroundColor = [UIColor blackColor];

    UIImageView *myPicture = [[UIImageView alloc] initWithImage:source];

    int borderWidth = 10;

    myPicture.frame = CGRectMake(borderWidth,
                             borderWidth,
                             blackBG.frame.size.width-borderWidth*2,
                             blackBG.frame.size.height-borderWidth*2);

    [blackBG addSubview: myPicture];
    return [self captureView:blackBG];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc {

    [super dealloc];
    [mImageArray release];
    [carousel release];
    [_dictOrgImage release];
    [_dictOrgBorderedImage release];
    [_arrayImageView release];
    [_arrayIsBordered release];
    [_imageTempPath release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
