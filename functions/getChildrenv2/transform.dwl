%dw 2.0
output application/json skipNullOn="everywhere"
var grouped = payload groupBy $.level
var parent = grouped["1"][0]
fun getChildren(data, level:Number, child:String) = do {
    var c = data[level as String] filter ($.parent ~= child) map {
        name: $.name,
        children: getChildren(data, level+1, $.child)
    }
    ---
    c match {
        case ch if isEmpty(ch) -> null
        else -> c
    }
}
---
{
    parent: parent.parent,
    name: parent.name,
    children: getChildren(grouped, 2, parent.child)
}