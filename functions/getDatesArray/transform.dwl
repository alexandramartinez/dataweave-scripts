%dw 2.0
output application/json
var date = "2022-10-16" as Date
var dateFinal = "2022-10-18" as Date
fun getDatesArray ( 
    startDate: Date,
    endDate: Date,
    datesArray: Array = []
) = do {
    var newArray = datesArray + startDate 
    ---
    if (startDate > endDate) []
    else if (startDate == endDate) (
        newArray 
    )
    else getDatesArray (
        startDate + |P1D|, 
        endDate, 
        newArray 
    )
}
---
getDatesArray(date, dateFinal)