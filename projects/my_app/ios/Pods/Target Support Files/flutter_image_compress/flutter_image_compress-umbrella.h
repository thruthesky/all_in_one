#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CompressFileHandler.h"
#import "CompressHandler.h"
#import "CompressListHandler.h"
#import "FlutterImageCompressPlugin.h"
#import "NSDictionary+SY.h"
#import "SYMetadata.h"
#import "SYMetadata8BIM.h"
#import "SYMetadataBase.h"
#import "SYMetadataCIFF.h"
#import "SYMetadataDNG.h"
#import "SYMetadataExif.h"
#import "SYMetadataExifAux.h"
#import "SYMetadataGIF.h"
#import "SYMetadataGPS.h"
#import "SYMetadataIPTC.h"
#import "SYMetadataIPTCContactInfo.h"
#import "SYMetadataJFIF.h"
#import "SYMetadataMakerCanon.h"
#import "SYMetadataMakerFuji.h"
#import "SYMetadataMakerMinolta.h"
#import "SYMetadataMakerNikon.h"
#import "SYMetadataMakerOlympus.h"
#import "SYMetadataMakerPentax.h"
#import "SYMetadataPNG.h"
#import "SYMetadataRaw.h"
#import "SYMetadataTIFF.h"
#import "UIImage+scale.h"

FOUNDATION_EXPORT double flutter_image_compressVersionNumber;
FOUNDATION_EXPORT const unsigned char flutter_image_compressVersionString[];

