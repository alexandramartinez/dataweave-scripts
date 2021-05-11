%dw 2.0
output application/json
// example vars
var exampleStartDate = "2021-02-01" as Date
var exampleEndDate = "2021-02-22" as Date
// tail recursive function
fun getDaysBetween (
    startDate: Date, // starting date 
    endDate: Date, // ending date
    includeEndDate: Boolean = false, // boolean to include endDate in count
    includingDaysOfWeek: Array<Number> = [1, 2, 3, 4, 5, 6, 7], // default value is all days of the week (Mon-Sun)
    excludingDates: Array<Date> = [], // send array with holidays
    count: Number = 0 // counter for tail recursive function
) = do {
    var includesDayOfWeek = includingDaysOfWeek contains startDate.dayOfWeek
    var isExcludedDate = excludingDates contains startDate
    var isValidDate = includesDayOfWeek and not isExcludedDate
    var newCount = if (isValidDate) count + 1 else count
    ---
    if (startDate > endDate) count
    else if (startDate == endDate) (
        if (includeEndDate and isValidDate) count + 1
        else count
    )
    else getDaysBetween (
        startDate + |P1D|, 
        endDate,
        includeEndDate,
        includingDaysOfWeek,
        excludingDates,
        newCount
    )
}
---
{
    Start_Date: exampleStartDate,
    End_Date: exampleEndDate,
    Count_Working_Days_Including_EndDate: getDaysBetween(
        exampleStartDate, 
        exampleEndDate, 
        true,
        [1, 2, 3, 4, 5]
    ),
    Count_Working_Days_Excluding_EndDate: getDaysBetween(
        exampleStartDate, 
        exampleEndDate, 
        false,
        [1, 2, 3, 4, 5]
    ),
    If_Every_Weekend_Was_A_Long_Weekend: getDaysBetween(
        exampleStartDate, 
        exampleEndDate, 
        true,
        [1, 2, 3, 4]
    ),
    Count_Working_Days_With_Exclusion_Dates: getDaysBetween(
        exampleStartDate, 
        exampleEndDate, 
        true,
        [1, 2, 3, 4, 5],
        [
            "2021-02-15" as Date,
            "2021-02-16" as Date,
            "2021-02-17" as Date,
            "2021-02-18" as Date,
            "2021-02-19" as Date
        ]
    ),
    Count_All_Days_Including_EndDate: getDaysBetween(
        exampleStartDate, 
        exampleEndDate, 
        true
    ),
    Count_All_Days_Excluding_EndDate: getDaysBetween(
        exampleStartDate, 
        exampleEndDate
    )
}