' ------------------------------------------------------------------------------
' -- src/query_filters/component_field_value_query_filter.bmx
' --
' -- Query filter for limiting a collection by field values.
' --
' -- This file is part of pangolin.mod (https://www.sodaware.net/pangolin/)
' -- Copyright (c) 2009-2019 Phil Newton
' --
' -- See COPYING for full license information.
' ------------------------------------------------------------------------------


''' <summary>Filter a list of entities by component field values.</summary>
Type ComponentFieldValueEntityQueryFilter extends BaseEntityQueryFilter
	Field _componentType:ComponentType
	Field _fieldName:String
	Field _value:Object

	Method filter:EntityBag(bag:EntityBag)
		Local size:Int = bag._size - 1

		For Local i:Int = 0 To size
			If bag._objects[i] = Null Then Continue

			' Remove if the object does not have the component type.
			If bag._objects[i]._typeBits & Self._componentType._bit <> Self._componentType._bit Then
				bag._objects[i] = Null
				Continue
			End If

			' Check the field value.
			Local e:Entity          = bag._objects[i]
			Local c:EntityComponent = e.getComponent(Self._componentType)
			Local t:TTypeId         = TTypeId.forobject(c)
			Local f:TField          = t.FindField(Self._fieldName)

			' TODO: Would like to not cast these.
			If f.get(c).toString() <> Self._value.toString() Then
				bag._objects[i] = Null
			EndIf
		Next

		Return bag
	End Method

	Function Create:ComponentFieldValueEntityQueryFilter(t:ComponentType, name:String, value:Object)
		Local this:ComponentFieldValueEntityQueryFilter = new ComponentFieldValueEntityQueryFilter

		this._componentType = t
		this._fieldName     = name
		this._value         = value

		Return this
	End Function
End Type
