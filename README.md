# IOSurfaceTest

Clone into openFrameworks/apps/	

the 64bit version works with Marek's 64bit OF
https://github.com/mazbox/of64

This is a proof of concept to try to replace the built in video players with IOSurface backed buffers and textures.

This will let us offload 32 bit dependencies into a small binary managed by the main OF application. This is how Quicktime Pro and QTKit 64-bit work.

thx to YCAM interlab