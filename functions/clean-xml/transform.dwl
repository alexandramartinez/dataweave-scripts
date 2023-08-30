%dw 2.0
output text/plain
---
write(payload,"application/xml") 
replace "<?xml version='1.0' encoding='UTF-8'?>\n" with ""
replace "<" with "&lt;"
replace ">" with "&gt;"