%dw 2.0
output application/xml
import mapLeafValues from dw::util::Tree

var maskedValue = "****" // Replace the value with this String
var fieldsToMask = ["ssn", "accountNo"] // List of fields that need to be masked

fun maskFields(data) = (
    data mapLeafValues ((value, path) -> 
        if (
            (fieldsToMask contains value.@name) // If the name of the attribute matches
            or (fieldsToMask contains path[-1].selector) // If the name of the field matches
        ) maskedValue // Replace value
        else value // Leave value as-is
    )
)
---
maskFields(payload) 