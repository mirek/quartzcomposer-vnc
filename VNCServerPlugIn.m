//
//  VNCServerPlugIn.m
//  VNC Server
//
//  Created by Mirek Rusin for http://quartzcomposer.com
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

/* It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering */
#import <OpenGL/CGLMacro.h>
#import "VNCServerPlugIn.h"

@implementation VNCServerPlugIn

@dynamic inputImage;
//@dynamic inputPort;

+ (QCPlugInExecutionMode) executionMode {
	return kQCPlugInExecutionModeConsumer;
}

+ (QCPlugInTimeMode) timeMode {
	return kQCPlugInTimeModeNone;
}

- (id) init {
	if (self = [super init]) {
	}
	return self;
}

// Release any non-garbage collected resources initialized in -init
- (void) finalize {
	[super finalize];
}

- (void) dealloc {
	[super dealloc];
}

// Provide custom serialization for the plug-in internal settings that are not values complying to the <NSCoding> protocol.
// The return object must be nil or a PList compatible i.e. NSString, NSNumber, NSDate, NSData, NSArray or NSDictionary.
- (id) serializedValueForKey:(NSString*)key; {
	return [super serializedValueForKey:key];
}

// Provide deserialization for the plug-in internal settings that were custom serialized in -serializedValueForKey.
// Deserialize the value, then call [self setValue:value forKey:key] to set the corresponding internal setting of the plug-in instance to that deserialized value.
- (void) setSerializedValue:(id)serializedValue forKey:(NSString*)key {
	[super setSerializedValue:serializedValue forKey:key];
}

// Return a new QCPlugInViewController to edit the internal settings of this plug-in instance.
// You can return a subclass of QCPlugInViewController if necessary.
- (QCPlugInViewController*) createViewController {
	return [[QCPlugInViewController alloc] initWithPlugIn:self viewNibName:@"Settings"];
}

@end

@implementation VNCServerPlugIn (Execution)

- (BOOL) startExecution:(id<QCPlugInContext>)context {
	return YES;
}

- (void) enableExecution:(id<QCPlugInContext>)context {
}

- (BOOL) execute:(id<QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary*)arguments {
  
  if ([self didValueForInputKeyChange: @"inputImage"]) {
    
    // Avoid accessing self.inputImage more than once
    id<QCPlugInInputImageSource> image = self.inputImage;
    
    CGColorSpaceRef colorSpace = [image imageColorSpace];
    NSString *pixelFormat = [[self class] pixelFormatWithColorSpace: colorSpace];
    if (![image lockBufferRepresentationWithPixelFormat: pixelFormat colorSpace: colorSpace forBounds: [image imageBounds]])
      return NO;

    // If it's the first frame, setup vnc server based on image info and run in background
    if (vncServer == nil) {
      vncServer = [VNCServer serverWithQCImage: image];
      [vncServer runEventLoopInBackground: YES];
    }
    
    if (self.inputImage != nil) {
      [vncServer updateWithQCImage: image];
    }
    
    [image unlockBufferRepresentation];
  }
	
	return YES;
}

- (void) disableExecution:(id<QCPlugInContext>)context {
}

- (void) stopExecution:(id<QCPlugInContext>)context {
}

@end
