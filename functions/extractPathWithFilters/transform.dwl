%dw 2.0
output application/json
import isNumeric, substringAfter from dw::core::Strings

fun isArrayOfArray(value): Boolean = (
    (typeOf(value) ~= "Array") 
    and (typeOf(value[0]) ~= "Array")
)

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

fun extractPathWithFilters(value, path: String, filters: Array = []) = do {
    var nextItem = (path scan /\w+/)[0][0]
    ---
    if (isEmpty(nextItem)) value
    else do {
        var isIndex = isNumeric(nextItem)
        var extractor = isIndex match {
            case true -> nextItem as Number
            else -> nextItem
        }
        var extractedValue = value[extractor]
        var newValue = filterValueByConditions(
            isArrayOfArray(extractedValue) match {
                case true -> flatten(extractedValue) // flatten array of arrays
                else ->extractedValue
            },
            (filters filter ($.key contains nextItem)).condition
        )
        ---
        extractPathWithFilters(
            newValue,
            substringAfter(path, nextItem),
            filters
        )
    }
}
---
{
    all_comments: extractPathWithFilters(
        payload,
        "contributors.posts.comments"
    ),
    all_posts_duration_3: extractPathWithFilters(
        payload,
        "contributors.posts",
        [
            {
                "key": "posts",
                "condition": "duration:3"
            }
        ]
    ),
    all_posts_duration_3_and_active_contributor: extractPathWithFilters(
        payload,
        "contributors.posts",
        [
            {
                "key": "posts",
                "condition": "duration:3"
            },
            {
                "key": "contributors",
                "condition": "active:true"
            }
        ]
    )
}