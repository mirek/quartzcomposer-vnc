# Quartz Composer VNC Server PlugIn

Quartz Composer port by Mirek Rusin <mirek [at] me [dot] com>
Homepage http://quartzcomposer.com/, source-code http://github.com/mirek/quartzcomposer-vnc
Based on libvncserver v0.9.8.2 by J. E. Schindelin et al - http://libvncserver.sourceforge.net

## Usage

    git clone git://github.com/mirek/quartzcomposer-vnc.git
    cd quartzcomposer-vnc
    xcodebuild

Alternativelly you can open the project in Xcode and Run.

This will launch Quartz Composer with example composition serving vnc.
    
Use any vnc client to connect:

    vncviewer localhost

To install vncviewer use:

    brew install tiger-vnc

## License

This is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this software; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307,
USA.