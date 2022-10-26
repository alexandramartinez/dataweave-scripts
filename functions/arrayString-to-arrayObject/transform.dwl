%dw 2.0
output application/json
import divideBy from dw::core::Arrays
---
payload divideBy 2
map {
    ($[0]): $[1]
}