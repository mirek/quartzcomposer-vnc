//
//  VNCServer.m
//  VNC Server
//
//  Created by Mirek Rusin for http://quartzcomposer.com this is minimal wrapper for libvncserver by J. E. Schindelin et al
//  Copyright 2010 Inteliv Ltd
//
//  This is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This software is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this software; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
//  USA.
//

#import "VNCServer.h"

@implementation VNCServer

@synthesize frameBufferData;

+ (VNCServer *) serverWithQCImage: (id<QCPlugInInputImageSource>) image {
  return [[self alloc] initWithQCImage: image];
}

- (VNCServer *) initWithQCImage: (id<QCPlugInInputImageSource>) image {
  if (self = [super init]) {
    int width = [image imageBounds].size.width;
    int height = [image imageBounds].size.height;
    int bitsPerSample;
    int samplesPerPixel;
    int bytesPerPixel;
    
    // Supported formats are:
    // * ARGB8 (8-bit alpha, red, green, blue)
    // * BGRA8 (8-bit blue, green, red, and alpha)
    // * RGBAf (floating-point, red, green, blue, alpha)
    // * I8    (8-bit intensity), and
    // * If    (floating-point intensity).
    if ([image bufferPixelFormat] == QCPlugInPixelFormatARGB8) {
      bitsPerSample = 8;
      samplesPerPixel = 4;
      bytesPerPixel = 4;
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatBGRA8) {
      bitsPerSample = 8;
      samplesPerPixel = 4;
      bytesPerPixel = 4;
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatRGBAf) {
      bitsPerSample = 32;
      samplesPerPixel = 4;
      bytesPerPixel = 16;
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatI8) {
      bitsPerSample = 8;
      samplesPerPixel = 1;
      bytesPerPixel = 1;
    } else if ([image bufferPixelFormat] == QCPlugInPixelFormatIf) {
      bitsPerSample = 32;
      samplesPerPixel = 1;
      bytesPerPixel = 4;
    } else {
      NSLog(@"* Unsupported image type %@", [image bufferPixelFormat]);
      assert(false);
    }
    
    [self createScreenWithWidth: width
                         height: height
                  bitsPerSample: bitsPerSample
                samplesPerPixel: samplesPerPixel
                  bytesPerPixel: bytesPerPixel];
    
    // DRY man!
    screenInfo->deferUpdateTime = 0;
    screenInfo->cursor = NULL;
    
    rfbInitServer(screenInfo);
  }
  return self;
}

- (VNCServer *) initWithWidth: (int) width height: (int) height bitsPerSample: (int) bitsPerSample samplesPerPixel: (int) samplesPerPixel bytesPerPixel: (int) bytesPerPixel {
  if (self = [super init]) {
    [self createScreenWithWidth: width height: height bitsPerSample: bitsPerSample samplesPerPixel: samplesPerPixel bytesPerPixel: bytesPerPixel];
    screenInfo->deferUpdateTime = 0;
    screenInfo->cursor = NULL;
    rfbInitServer(screenInfo);
  }
  return self;
}

- (void) markAsModifiedWithRect: (NSRect) rect {
  int x1 = (int)rect.origin.x;
  int y1 = (int)rect.origin.y;
  int x2 = (int)(rect.origin.x + rect.size.width);
  int y2 = (int)(rect.origin.y + rect.size.height);
  rfbMarkRectAsModified(screenInfo, x1, y1, x2, y2);
}

- (void) markAllAsModified {
  rfbMarkRectAsModified(screenInfo, 0, 0, screenInfo->width, screenInfo->height);
}

- (void) updateWithQCImage: (id<QCPlugInInputImageSource>) image {
  memcpy((char *)[frameBufferData bytes], [image bufferBaseAddress], [frameBufferData length]);
  [self markAllAsModified];
}

- (void) createScreenWithWidth: (int) width height: (int) height bitsPerSample: (int) bitsPerSample samplesPerPixel: (int) samplesPerPixel bytesPerPixel: (int) bytesPerPixel {
  screenInfo = rfbGetScreen(0, NULL, width, height, bitsPerSample, samplesPerPixel, bytesPerPixel);
  frameBufferData = [[NSData alloc] initWithBytesNoCopy: malloc(width * height * bytesPerPixel) length: width * height * bytesPerPixel freeWhenDone: YES];
  screenInfo->frameBuffer = (char *)[frameBufferData bytes];
}

- (void) runEventLoopInBackground: (BOOL) runInBackground {
  rfbRunEventLoop(screenInfo, -1, runInBackground);
}

@end
