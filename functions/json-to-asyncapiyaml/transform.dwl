%dw 2.0
output application/yaml skipNullOn="objects"
fun getTypeField(data):Object = {"type": lower(typeOf(data) as String)}
fun getValueStructure(data) = {
    (getTypeField(data)),
    examples: [data]
}
fun getArrayStructure(data:Array) = {
    (getTypeField(data)),
    items: (
        if (!isEmpty(data[0])) getValueStructure(data[0])
        else null
    )
}
fun getObjectStructure(data:Object) = {
    (getTypeField(data)),
    properties: data mapObject ((value, key) -> {
        (key): (value match {
            case is Object -> getObjectStructure(value)
            case is Array -> getArrayStructure(value)
            else -> getValueStructure(value)
        })
    })
}
---
payload: getObjectStructure(payload)