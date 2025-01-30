%dw 2.0
output application/json
fun flattenNestedArrays(data) = data match {
    case is Array -> flatten(data map flattenNestedArrays($))
    else -> data
}
---
flattenNestedArrays(payload)