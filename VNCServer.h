//
//  VNCServer.h
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

#import <Cocoa/Cocoa.h>
#import "rfb/rfb.h"

@interface VNCServer : NSObject {
  rfbScreenInfoPtr screenInfo;
  NSData *frameBufferData;
}

@property (readonly) NSData *frameBufferData;

+ (VNCServer *) serverWithQCImage: (id<QCPlugInInputImageSource>) image;
- (VNCServer *) initWithQCImage: (id<QCPlugInInputImageSource>) image;
- (VNCServer *) initWithWidth: (int) width height: (int) height bitsPerSample: (int) bitsPerSample samplesPerPixel: (int) samplesPerPixel bytesPerPixel: (int) bytesPerPixel;

//- (void) setScreenWithWidth: (int) width height: (int) height bitsPerSample: (int) bitsPerSample samplesPerPixel: (int) samplesPerPixel bytesPerPixel: (int) bytesPerPixel;

- (void) runEventLoopInBackground: (BOOL) runInBackground;

- (void) updateWithQCImage: (id<QCPlugInInputImageSource>) image;

- (void) markAsModifiedWithRect: (NSRect) rect;
- (void) markAsModified;

@end
