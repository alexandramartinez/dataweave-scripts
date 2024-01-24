%dw 2.0
output application/json
fun flattenObject(data:Any, result={}) = (
    data match {
        case is Object -> data mapObject ((value, key) ->
            value match {
                case is Object -> flattenObject(value, result)
                else -> flattenObject(value, result ++ {(key):value})
            }
        )
        case is Array -> flattenObject(data[0]) // only first item from array will be taken
        else -> result
    }
)
---
//payload must be an object
payload mapObject ((value, key, index) -> 
    (key): flattenObject(value)
)