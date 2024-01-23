%dw 2.0
output application/yaml skipNullOn="objects"
import try from dw::Runtime
fun isDate(value: Any): Boolean = try(() -> value as Date).success
fun isDateTime(value: Any): Boolean = try(() -> value as DateTime).success
---
{
    openapi: "3.0.3",
    components: {
        schemas: payload mapObject ((mainObj, mainObjKey) -> 
            (mainObjKey): {
                "type": lower(typeOf(mainObj)),
                properties: mainObj mapObject ((props, propsKey) -> 
                    (propsKey): {
                        "type": lower(typeOf(props)),
                        format: (props match {
                            case is Number -> null
                            case d if isDateTime(d) -> "date-time"
                            case d if isDate(d) -> "date"
                            else -> null
                        })
                    }
                )
            }
        )
    }
}