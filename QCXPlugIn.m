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

#include "QCXPlugIn.h"

// Do not access this variable directly, use [QXCPlugIn plugInInfos] from your derived class instead.
// { classNameA : { ... }, classNameB: { ... } } dictionary to cache xml attributes for multiple classes
// ...one day Objective-C will support class attributes with inheritance and we won't have to do it.
NSMutableDictionary *QCXPlugIn_plugInInfos;

@implementation QCXPlugIn

+ (NSMutableDictionary *) plugInInfos {
  if (QCXPlugIn_plugInInfos == nil) {
    QCXPlugIn_plugInInfos = [[NSMutableDictionary alloc] init];
  }
  return QCXPlugIn_plugInInfos;
}

+ (NSMutableDictionary *) plugInInfoWithClass: (Class) aClass {
  return [self.plugInInfos objectForKey: NSStringFromClass(aClass)];
}

+ (void) setPlugInInfo: (NSMutableDictionary *) plugInInfo forClass: (Class) aClass {
  [self.plugInInfos setObject: plugInInfo forKey: NSStringFromClass(aClass)];
}

+ (NSDictionary *) plugInInfo {
  NSPropertyListFormat format;
  NSString *errorDescription;
  //@synchronized {
    NSDictionary *r = [self plugInInfoWithClass: [self class]];
    if (r == nil) {
      NSString *path = [[NSBundle bundleForClass: [self class]] pathForResource: NSStringFromClass([self class]) ofType: @"xml"];
      NSData *data = [[NSFileManager defaultManager] contentsAtPath: path];
      r = [NSPropertyListSerialization propertyListFromData: data
                                           mutabilityOption: NSPropertyListImmutable
                                                     format: &format
                                           errorDescription: &errorDescription];
      [self setPlugInInfo: r forClass: [self class]];
    }
  //}
  return r;
}

+ (NSDictionary *) attributes {
	return [self plugInInfo];
}

+ (NSDictionary *) attributesForPropertyPortWithKey:(NSString *) key {
  return [[[self plugInInfo] objectForKey: @"attributes"] objectForKey: key];
}

+ (NSString *) pixelFormatWithColorSpace: (CGColorSpaceRef) colorSpace {
  if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelMonochrome)
    return QCPlugInPixelFormatI8;
  else if (CGColorSpaceGetModel(colorSpace) == kCGColorSpaceModelRGB)
#if __BIG_ENDIAN__
    return QCPlugInPixelFormatARGB8;
#else
  return QCPlugInPixelFormatBGRA8;
#endif
  else
    return nil;  
}


@end
