%dw 2.0
output application/json
import some from dw::core::Arrays

// Arrays module
fun containsEmptyValues1(arr) = if (isEmpty(arr)) true 
    else arr some isEmpty($)

// Pattern Matching
fun containsEmptyValues2(arr) = arr match {
    case [] -> true
    case a is Array -> a some isEmpty($)
    else -> isEmpty(arr)
}

// Function Overloading
fun containsEmptyValues3(value: Null) = true 
fun containsEmptyValues3(arr: Array) = arr match { 
    case [] -> true
    else -> arr some isEmpty($)
}
---
{
    fun1: containsEmptyValues1(["1", null]),
    fun2: containsEmptyValues2(["1", "2"]),
    fun3: containsEmptyValues3(["1", ""])
}
