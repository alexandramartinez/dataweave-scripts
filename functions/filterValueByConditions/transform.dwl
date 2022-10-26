%dw 2.0
output application/json

fun filterValueByConditions(value, conditions) = (
    if (isEmpty(conditions[0])) value
    else do {
        var firstConditionArr = conditions[0] splitBy ":"
        ---
        filterValueByConditions(
            value filter ($[firstConditionArr[0]] ~= firstConditionArr[1]),
            conditions[1 to -1]
        )
    }
)
---
payload filterValueByConditions [
    "active:true",
    "name:abc"
]