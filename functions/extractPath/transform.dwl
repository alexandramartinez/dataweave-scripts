%dw 2.0
output application/json
import isNumeric, substringAfter from dw::core::Strings

fun extractPath(value, path: String) = do {
    var nextItem = (path scan /\w+/)[0][0]
    ---
    if (isEmpty(nextItem)) value
    else do {
        var isIndex = isNumeric(nextItem)
        var extractor = isIndex match {
            case true -> nextItem as Number
            else -> nextItem
        }
        var restOfPath = substringAfter(path, nextItem)
        ---
        extractPath(
            value[extractor],
            restOfPath
        )
    }
}
---
extractPath(payload, "object.array[0].test")