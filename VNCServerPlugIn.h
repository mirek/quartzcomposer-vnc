//
//  VNCServerPlugIn.h
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

#import <Quartz/Quartz.h>
#import "VNCServer.h"
#import "QCXPlugIn.h"

@interface VNCServerPlugIn : QCXPlugIn {
  VNCServer *vncServer;
}

@property (assign) id<QCPlugInInputImageSource> inputImage;
//@property (assign) NSUInteger inputPort;

@end
