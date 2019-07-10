' ------------------------------------------------------------------------------
' -- pangolin_gfx.bmx
' -- 
' -- Static helper class for using Pangolin graphics. Nothing too fancy, but
' -- makes it easier to set up graphics and use virtual resolutions.
' --
' -- This file is part of pangolin.mod (https://www.sodaware.net/pangolin/)
' -- Copyright (c) 2009-2017 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

' -- Graphics drivers
Import "src/driver/graphics_manager.bmx"
Import "src/driver/virtual_screen_resolution.bmx"

' -- Import helper functions
Import "src/util/hex_util.bmx"
Import "src/util/graphics_util.bmx"
import "src/util/render_state.bmx"
Import "src/util/scale_image.bmx"


Type PangolinGfx
	
	''' <summary>
	''' Initialize the graphics engine. Sets up the width, scale, refresh-rate, 
	''' colour depth and driver type.
	''' </summary>
	''' <param name="width">The width of the graphics area in pixels.</param>
	''' <param name="height">The height of the graphics area in pixels.</param>
	''' <param name="scale">Use this to enlarge pixels. For example, a scale of 2.0 will scale everything 2x its original size.</param>
	''' <param name="refreshRate">The number of times a second to refresh the screen.</param>
	''' <param name="isWindowed">If true will start in windowed mode.</param>
	''' <param name="depth">Colour depth of the screen.</param>
	''' <param name="waitVBlank">If true will wait for a VBlank between frames.</param>
	''' <param name="driverType">The type of graphics driver to use. Defaults to OpenGL.</param>
	Function initGraphics(width:Int, height:Int, scale:Float = 1.0, refreshRate:Int = 60, isWindowed:Byte = False, depth:Int = 32, waitVBlank:Int = True, driverType:Int = GraphicsManager.DRIVER_TYPE_OPENGL)
		
		' Set up graphics manager
		GraphicsManager.getInstance()..
			.setWidth(width * scale)..
			.setHeight(height * scale)..
			.setDepth(depth)..
			.setRefreshRate(refreshRate)..
			.setIsWindowed(isWindowed)..
			.setDriverType(driverType)
		
		' Set up virtual resolution
		VirtualScreenResolution.getInstance()._height = height
		VirtualScreenResolution.getInstance()._width = width
		
		' Start graphics
		GraphicsManager.getInstance().startGraphics()
		
	End Function

	''' <summary>Get the width of the screen in actual pixels.</summary>
	Function getScreenWidth:Int()
		Return GraphicsManager.getInstance().getWidth()
	End Function

	''' <summary>Get the height of the screen in actual pixels.</summary>
	Function getScreenHeight:Int()
		Return GraphicsManager.getInstance().getHeight()
	End Function

	''' <summary>Get the width of the screen in virtual pixels.</summary>
	Function getGraphicsWidth:Int()
		Return VirtualScreenResolution.getInstance().getWidth()
	End Function
	
	''' <summary>Get the height of the screen in virtual pixels.</summary>
	Function getGraphicsHeight:Int()
		Return VirtualScreenResolution.getInstance().getHeight()
	End Function
	
	Function setColorInt(color:Int)
		SetColor 255 & (color Shr 16), 255 & (color Shr 8), 255 & color
	End Function
	
	Function intToRgb(color:Int, r:Byte Var, g:Byte Var, b:Byte Var)
		r = color Shr 16
		g = color Shr 8
		b = color
	End Function

	Function rgbToInt:Int(r:Byte, g:Byte, b:Byte)
		Return 0 + (r Shl 16) + (g Shl 8) + (b)
	End Function
	
End Type
