%dw 2.0
output application/json 
import filterTree from dw::util::Tree
fun removeDynamodbKeys(data) = do {
    var dynamodbKeys = ["l", "m", "n", "s", "bool"] // add the keys you want to remove
    var dynamodbKeyUpdate = "unrepeatableKey" // change this name if this key is indeed repeated within your input
    fun removeDynamodbKeysRec(value) = value match {
        case obj is Object -> do {
            var finalObj = obj mapObject ((value, key) -> 
                if (dynamodbKeys contains (key as String))
                    (dynamodbKeyUpdate): removeDynamodbKeysRec(value)
                else
                    (key): removeDynamodbKeysRec(value)
            )
            ---
            finalObj[dynamodbKeyUpdate] default finalObj
        }
        case arr is Array -> arr map removeDynamodbKeysRec($)
        else -> value
    }
    ---
    data filterTree ($ != null) 
    then removeDynamodbKeysRec($)
}
---
removeDynamodbKeys(payload.items)