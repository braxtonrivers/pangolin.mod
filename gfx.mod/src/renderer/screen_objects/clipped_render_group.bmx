' ------------------------------------------------------------------------------
' -- src/renderer/screen_objects/clipped_render_group.bmx
' --
' -- Holds a collection of renderable items that will be clipped if they stretch
' -- outside of a specific area.
' --
' -- This file is part of pangolin.mod (https://www.sodaware.net/pangolin/)
' -- Copyright (c) 2009-2017 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


SuperStrict

Import brl.linkedlist
Import brl.max2d
Import "render_group.bmx"


Type ClippedRenderGroup Extends RenderGroup

	Field _boundingBox:Rectangle2D		'''< Optional clipping area
	Field _currentPosition:Position2D
	
	Function Create:ClippedRenderGroup(x:Float, y:Float, w:Float, h:Float)
		Local this:ClippedRenderGroup = New ClippedRenderGroup
		this._currentPosition = New Position2D
		this._currentPosition.setPosition(x, y)
		this._boundingBox = Rectangle2D.Create(0, 0, w, h)
		Return this
	End Function
	
	
	' ------------------------------------------------------------
	' -- Position
	' ------------------------------------------------------------

	Method getX:Float()
		Return Self._currentPosition._xPos
	End Method
	
	Method getY:Float()
		Return Self._currentPosition._yPos
	End Method
	
	
	' ------------------------------------------------------------
	' -- Moving
	' ------------------------------------------------------------

	Method move(xOff:Float, yOff:Float)
		Self._currentPosition.addValue(xOff, yOff)
    	For Local r:AbstractRenderRequest = EachIn Self._items
			r.move(xOff, yOff)
		Next
	EndMethod
	
	
	' ------------------------------------------------------------
	' -- Rendering
	' ------------------------------------------------------------

	Method render(tween:Double, camera:AbstractRenderCamera, isFixed:Int = False)
		Local x:Int, y:Int, w:Int, h:Int
		
		If Self._boundingBox Then
			GetViewport(x,y,w,h)
			SetViewport( ..
				Self.getX() + Self._boundingBox.getX(), ..
				Self.getY() + Self._boundingBox.gety(), .. 
				Self._boundingBox.getWidth(), .. 
				Self._boundingBox.getHeight() ..
			)
		EndIf
		For Local item:AbstractRenderRequest = EachIn Self._items
			item.render(tween, camera, isFixed)
		Next
		If Self._boundingBox Then
			SetViewport(x,y,w,h)
		EndIf
	End Method
	
End Type
