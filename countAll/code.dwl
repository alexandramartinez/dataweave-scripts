%dw 2.0
output application/json
fun countAll(count: Number): Array<Number> =
    if (count <= 1) [count]
    else [count ~ countAll(count-1)]
---
countAll(3)