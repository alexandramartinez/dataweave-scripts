%dw 2.0
output application/json
var date = "2022-10-16" as Date
var dateFinal = "2022-10-18" as Date
fun daysUntil ( 
    startDate: Date,
    endDate: Date
): Array<Date> = (
    if (startDate > endDate) []
    else if (startDate == endDate) [startDate]
    else [startDate ~ daysUntil(startDate + |P1D|, endDate)]
)
---
date daysUntil dateFinal