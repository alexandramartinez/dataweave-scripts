%dw 2.0
output application/json
---
payload filter ((item, index) -> item.active == true and item.name == "abc" )
