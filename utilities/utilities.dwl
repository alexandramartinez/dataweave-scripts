import try from dw::Runtime

fun isDate(value: Any): Boolean = try(() -> value as Date).success
fun isString(value: Any): Boolean = try(() -> value as String).success
fun isNumber(value: Any): Boolean = try(() -> value as Number).success
fun isNumberType(value: Any): Boolean = typeOf(value) ~= "Number"
fun isArray(value: Any): Boolean = try(() -> value as Array).success
fun isObject(value: Any): Boolean = try(() -> value as Object).success
fun isError(str: String, errorString: String): Boolean = str startsWith errorString
fun isError(value: Any, errorString: Any = null): Boolean = false

fun getDate(value: Any): Date | Null = (
    if ( isDate(value) ) value as Date
    else null
)
fun getString(value: Any): String | Null = (
    if ( isString(value) ) value as String
    else null
)
fun getArray(value: Any): Array | Null = (
    if ( isArray(value) ) value as Array
    else null
)
fun getNumber(value: Any): Number | Null = (
    if ( isNumber(value) ) value as Number
    else null
) 
fun getObject(value: Any): Object | Null = (
	if ( isObject(value) ) value as Object
	else null
)