# DataWeave Scripts

Here's a compilation of some of the (fairly complex) DW scripts I've done.

Click on a title to see the function's code, input, and output.

## More Info

The screenshots were generated using the DataWeave Playground. To learn more about this, please read this article: [How to run locally the DataWeave Playground Docker Image](https://www.prostdev.com/post/how-to-run-locally-the-dataweave-playground-docker-image).

For questions, you can contact me here: www.alexandramartinez.world/contact

## Table of Contents

**Recursive Functions**
- [getChildren](#getchildren)

**Tail Recursive Functions**
- [addIndexTailRecursive](#addindextailrecursive)
- [getDaysBetween](#getdaysbetween)
- [extractPath](#extractpath)
- [filterValueByConditions](#filtervaluebyconditions)
- [extractPathWithFilters](#extractpathwithfilters)

**Other Functions**
- [maskFields](#maskfields)
- [containsEmptyValues](#containsemptyvalues)

**Other Transformations**
- [`Array<String>` to `Array<Object>`](#arraystring-to-arrayobject)

## Recursive Functions

### [getChildren](/getChildren)

Creates a tree from a flat array with parent/child relationship.

Video: [DataWeave Scripts Repo: getChildren recursive function | #Codetober 2021 Day 9](https://youtu.be/ZRm1POYgwG0)

Keywords: `fun`, `do`, `var`, `as`, `filter`, `~=`, `==`, `if/else`, `isEmpty`, `match/case`, `map`, `$`, `orderBy`, `skipNullOn`

Input: `Array<Object>`

Output: `Object`

Example input
```json
[
	{
		"parent": "111",
		"child": "222",
		"name": "node1",
		"level": "1"
	},
	{
		"parent": "222",
		"child": "333",
		"name": "node2",
		"level": "2"
	},
	{
		"parent": "333",
		"child": "444",
		"name": "node3",
		"level": "3"
	},
	{
		"parent": "222",
		"child": "555",
		"name": "node4",
		"level": "2"
	},
	{
		"parent": "333",
		"child": "666",
		"name": "node5",
		"level": "3"
	}
]
```

Script
```dataweave
%dw 2.0
output application/json skipNullOn="everywhere"

fun getChildren(items, parentItem) = do {
    var parentLevel = parentItem.level as Number
    var thisLevelItemsFiltered = items filter (
        ($.level ~= (parentLevel + 1))
        and ($.parent == parentItem.child)
    )
    ---
    if (isEmpty(thisLevelItemsFiltered)) null
    else (
        thisLevelItemsFiltered match {
            case [] -> null
            else -> thisLevelItemsFiltered map {
                name: $.name,
                children: getChildren(items, $)
            }
        }
    ) 
}

var items = payload orderBy $.level
var parentItem = items[0]
---
{
    parent: parentItem.parent,
    name: parentItem.name,
    children: getChildren(items, parentItem)
}
```

Example output
```json
{
  "parent": "111",
  "name": "node1",
  "children": [
    {
      "name": "node2",
      "children": [
        {
          "name": "node3"
        },
        {
          "name": "node5"
        }
      ]
    },
    {
      "name": "node4"
    }
  ]
}
```

## Tail Recursive Functions

### [addIndexTailRecursive](/addIndexTailRecursive)

Transforms a JSON payload into a different JSON structure and keeps a count of the indexes accross the whole output array. This function has its own repository that contains additional explanations and links to other resources such as slides and previous versions. To learn more about it please go to this repository: [Reviewing a Complex DataWeave Transformation Use-case](https://github.com/alexandramartinez/reviewing-a-complex-dw-transformation-use-case).

Video: [DataWeave Scripts Repo: addIndexTailRecursive tail recursive function | #Codetober 2021 Day 10](https://youtu.be/7LNsn_Mu_Fw)

Keywords: `dw::util::Values`, `import`, `update/with`, `fun`, `if/else`, `do`, `var`, `~=`, `+`, `to`, `default`, `map`, `$`, `++`

Input: `Object`

Output: `Array<Object>`

Example input
```json
{
    "FlightOptions": [
        {
            "Connections": [
                {
                    "ReferenceID": 111,
                    "TaxCode": "ABC",
                    "EndOfConnection": false
                },
                {
                    "ReferenceID": 222,
                    "TaxCode": "DEF",
                    "EndOfConnection": true
                }
            ]
        },
        {
            "Connections": [
                {
                    "ReferenceID": 333,
                    "TaxCode": "GHI",
                    "EndOfConnection": true
                },
                {
                    "ReferenceID": 444,
                    "TaxCode": "JKL",
                    "EndOfConnection": true
                }
            ]
        },
        {
            "Connections": [
                {
                    "ReferenceID": 555,
                    "TaxCode": "MNO",
                    "EndOfConnection": false
                },
                {
                    "ReferenceID": 666,
                    "TaxCode": "PQR",
                    "EndOfConnection": false
                },
                {
                    "ReferenceID": 777,
                    "TaxCode": "STU",
                    "EndOfConnection": false
                }
            ]
        },
        {
            "Connections": [
                {
                    "ReferenceID": 888,
                    "TaxCode": "VWX",
                    "EndOfConnection": false
                }
            ]
        },
        {
            "Connections": [
                {
                    "ReferenceID": 999,
                    "TaxCode": "MNO",
                    "EndOfConnection": false
                },
                {
                    "ReferenceID": 101,
                    "TaxCode": "PQR",
                    "EndOfConnection": true
                },
                {
                    "ReferenceID": 102,
                    "TaxCode": "STU",
                    "EndOfConnection": false
                }
            ]
        }
    ]
}
```

Script
```dataweave
%dw 2.0
output application/json 
import update from dw::util::Values 

fun addIndexTailRecursive(
    connectionsArray: Array<Object>, 
    indexAccumulatorArray: Array = [], 
    index: Number = 1, 
    connectionsAccumulatorArray: Array = [] 
) = (
    if (isEmpty(connectionsArray)) connectionsAccumulatorArray 
    else do { 
        var thisConnection: Object = connectionsArray[0] 
        var thisConnectionIsEndOfConnection: Boolean = thisConnection.EndOfConnection ~= true 
        var newIndexAccumulatorArray = if (thisConnectionIsEndOfConnection) [] else indexAccumulatorArray + index 
        ---
        addIndexTailRecursive( 
            connectionsArray[1 to -1] default [],
            newIndexAccumulatorArray,
            index + 1, 
            if (thisConnectionIsEndOfConnection) (
                connectionsAccumulatorArray + { 
                        AppliedTaxCode: thisConnection.TaxCode,
                        AppliedConnections: (indexAccumulatorArray + index) map {
                            Type: "Connection",
                            IndexValue: $
                        }
                    }
            )
            else connectionsAccumulatorArray 
        )
    }
)
---
addIndexTailRecursive( 
    payload.FlightOptions.Connections
    reduce ((flightOption, accumulator = []) -> do { 
        var lastConnection = { 
            (flightOption[-1] update "EndOfConnection" with true)
        }
        var updatedConnections = (flightOption[0 to -2] default []) + lastConnection
        ---
        accumulator ++ updatedConnections 
    })
)
```

Example output
```json
[
  {
    "AppliedTaxCode": "DEF",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 1
      },
      {
        "Type": "Connection",
        "IndexValue": 2
      }
    ]
  },
  {
    "AppliedTaxCode": "GHI",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 3
      }
    ]
  },
  {
    "AppliedTaxCode": "JKL",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 4
      }
    ]
  },
  {
    "AppliedTaxCode": "STU",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 5
      },
      {
        "Type": "Connection",
        "IndexValue": 6
      },
      {
        "Type": "Connection",
        "IndexValue": 7
      }
    ]
  },
  {
    "AppliedTaxCode": "VWX",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 8
      }
    ]
  },
  {
    "AppliedTaxCode": "PQR",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 9
      },
      {
        "Type": "Connection",
        "IndexValue": 10
      }
    ]
  },
  {
    "AppliedTaxCode": "STU",
    "AppliedConnections": [
      {
        "Type": "Connection",
        "IndexValue": 11
      }
    ]
  }
]
```

### [getDaysBetween](/getDaysBetween)

Count the number of days between two dates using certain filters to either count some days or keep them out.

Filters:
- `includeEndDate` - Boolean to include the endDate in count or not. Default value is `false`.
- `includingDaysOfWeek` - Array of Numbers to include just certain days of the week in count. Default is to count all days of the week (1-7).
- `excludingDates` - Array of Dates to include certain dates that should not be counted. Default is empty.

Video: [DataWeave Scripts Repo: getDaysBetween tail recursive function | #Codetober 2021 Day 12](https://youtu.be/QiP6WalvwRM)

Keywords: `var`, `as`, `fun`, `do`, `contains`, `and`, `not`, `if/else`, `+`, `>`, `==`, `|P|` (Period)

Input: NA

Output: `Number`

Script
```dataweave
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
```

Example output
```json
{
  "Start_Date": "2021-02-01",
  "End_Date": "2021-02-22",
  "Count_Working_Days_Including_EndDate": 16,
  "Count_Working_Days_Excluding_EndDate": 15,
  "If_Every_Weekend_Was_A_Long_Weekend": 13,
  "Count_Working_Days_With_Exclusion_Dates": 11,
  "Count_All_Days_Including_EndDate": 22,
  "Count_All_Days_Excluding_EndDate": 21
}
```

### [extractPath](/extractPath)

Extract values from a JSON input using a String representation of a path.

Video: [DataWeave Scripts Repo: extractPath tail recursive function | #Codetober 2021 Day 13](https://youtu.be/rg9i_xMO4c0)

Keywords: `dw::core::Strings`, `import`, `isNumeric`, `substringAfter`, `fun`, `do`, `var`, `scan`, `regex`, `isEmpty`, `if/else`, `match/case`, `as`

Input: `Object`, `Array`

Output: Whichever value was selected from the input and with the path.

Example input
```json
{
    "object": {
        "array": [
            {
                "test": "value1"
            },
            {
                "test": "value2"
            }
        ]
    }
}
```

Script
```dataweave
%dw 2.0
output application/json
import isNumeric, substringAfter from dw::core::Strings

fun extractPath(value, path: String) = do {
    var nextItem = (path scan /\w+/)[0][0]
    ---
    if (isEmpty(nextItem)) value
    else do {
        var isIndex = isNumeric(nextItem)
        var extractor = isIndex match {
            case true -> nextItem as Number
            else -> nextItem
        }
        var restOfPath = substringAfter(path, nextItem)
        ---
        extractPath(
            value[extractor],
            restOfPath
        )
    }
}
---
extractPath(payload, "object.array[0].test")
```

Example output
```json
"value1"
```

### [filterValueByConditions](/filterValueByConditions)

Returns the filtered given value using the conditions passed in an Array of Strings.

Video: [DataWeave Scripts Repo: filterValueByConditions tail recursive function | #Codetober 2021 Day 17](https://youtu.be/aKgplxe8w4I)

Keywords: `fun`, `if/else`, `isEmpty`, `do`, `var`, `splitBy`, `filter`, `~=`, `to`

Input: `Array<Object>`

Output: `Array<Object>`

Example input
```json
[
    {
        "id": 123,
        "name": "abc",
        "active": true
    },
    {
        "id": 456,
        "name": "def",
        "active": true
    },
    {
        "id": 789,
        "name": "abc",
        "active": false
    }
]
```

Script
```dataweave
%dw 2.0
output application/json

fun filterValueByConditions(value, conditions) = (
    if (isEmpty(conditions[0])) value
    else do {
        var firstConditionArr = conditions[0] splitBy ":"
        ---
        filterValueByConditions(
            value filter ($[firstConditionArr[0]] ~= firstConditionArr[1]),
            conditions[1 to -1]
        )
    }
)
---
payload filterValueByConditions [
    "active:true",
    "name:abc"
]
```

Example output
```json
[
  {
    "id": 123,
    "name": "abc",
    "active": true
  }
]
```

### [extractPathWithFilters](/extractPathWithFilters)

Mixing the previous two functions (`extractPath` and `filterValueByConditions`) and adding a bit more code to them, this function extracts a specific path and filters the output depending on the given conditions. This also contains an additional function: `isArrayOfArray` to check if a given value is of the type `Array<Array>`.

*Note*: in order to apply the filters successfully, the given `key` must be from an Array.

Video: [DataWeave Scripts Repo: extractPathWithFilters tail recursive function | #Codetober 2021 Day 21](https://youtu.be/Tu5nRmRURgQ)

Keywords: `dw::core::Strings`, `import`, `isNumeric`, `substringAfter`, `typeOf`, `~=`, `fun`, `if/else`, `isEmpty`, `do`, `var`, `splitBy`, `filter`, `$`, `to`, `scan`, `match/case`, `as`

Input: `Object`, `Array`

Output: Whichever value was selected from the input and with the path.

Example input
```json
{
    "site": "ProstDev",
    "contributors": [
        {
            "active": true,
            "id": 123,
            "name": {
                "firstName": "Alexandra",
                "lastName": "Martinez"
            },
            "posts": [
                {
                    "name": "blogpost1",
                    "duration": 3,
                    "comments": [
                        {
                            "name": "Jane Doe",
                            "text": "Good Job, Alex!"
                        }
                    ]
                },
                {
                    "name": "blogpost2",
                    "duration": 5
                },
                {
                    "name": "blogpost3",
                    "duration": 2,
                    "comments": [
                        {
                            "name": "Pravallika",
                            "text": "Good Job, Alex!"
                        }
                    ]
                }
            ]
        },
        {
            "active": true,
            "id": 456,
            "name": {
                "firstName": "Pravallika",
                "lastName": "Nagaraja"
            },
            "posts": [
                {
                    "name": "blogpost4",
                    "duration": 2
                },
                {
                    "name": "blogpost5",
                    "duration": 3,
                    "comments": [
                        {
                            "name": "Jane Doe",
                            "text": "Good Job, Pravallika!"
                        }
                    ]
                },
                {
                    "name": "blogpost6",
                    "duration": 7,
                    "comments": [
                        {
                            "name": "Alex",
                            "text": "Good Job, Pravallika!"
                        }
                    ]
                }
            ]
        },
        {
            "active": false,
            "id": 789,
            "name": {
                "firstName": "Jane",
                "lastName": "Doe"
            },
            "posts": [
                {
                    "name": "blogpost7",
                    "duration": 3,
                    "comments": [
                        {
                            "name": "Alex",
                            "text": "Good Job, Jane!"
                        }
                    ]
                }
            ]
        }
    ]
}
```

Script
```dataweave
%dw 2.0
output application/json
import isNumeric, substringAfter from dw::core::Strings

fun isArrayOfArray(value): Boolean = (
    (typeOf(value) ~= "Array") 
    and (typeOf(value[0]) ~= "Array")
)

fun filterValueByConditions(value, conditions) = (
    if (isEmpty(conditions[0])) value
    else do {
        var firstConditionArr = conditions[0] splitBy ":"
        ---
        filterValueByConditions(
            value filter ($[firstConditionArr[0]] ~= firstConditionArr[1]),
            conditions[1 to -1]
        )
    }
)

fun extractPathWithFilters(value, path: String, filters: Array = []) = do {
    var nextItem = (path scan /\w+/)[0][0]
    ---
    if (isEmpty(nextItem)) value
    else do {
        var isIndex = isNumeric(nextItem)
        var extractor = isIndex match {
            case true -> nextItem as Number
            else -> nextItem
        }
        var extractedValue = value[extractor]
        var newValue = filterValueByConditions(
            isArrayOfArray(extractedValue) match {
                case true -> flatten(extractedValue) // flatten array of arrays
                else ->extractedValue
            },
            (filters filter ($.key contains nextItem)).condition
        )
        ---
        extractPathWithFilters(
            newValue,
            substringAfter(path, nextItem),
            filters
        )
    }
}
---
{
    all_comments: extractPathWithFilters(
        payload,
        "contributors.posts.comments"
    ),
    all_posts_duration_3: extractPathWithFilters(
        payload,
        "contributors.posts",
        [
            {
                "key": "posts",
                "condition": "duration:3"
            }
        ]
    ),
    all_posts_duration_3_and_active_contributor: extractPathWithFilters(
        payload,
        "contributors.posts",
        [
            {
                "key": "posts",
                "condition": "duration:3"
            },
            {
                "key": "contributors",
                "condition": "active:true"
            }
        ]
    )
}
```

Example output
```json
{
  "all_comments": [
    {
      "name": "Jane Doe",
      "text": "Good Job, Alex!"
    },
    {
      "name": "Pravallika",
      "text": "Good Job, Alex!"
    },
    {
      "name": "Jane Doe",
      "text": "Good Job, Pravallika!"
    },
    {
      "name": "Alex",
      "text": "Good Job, Pravallika!"
    },
    {
      "name": "Alex",
      "text": "Good Job, Jane!"
    }
  ],
  "all_posts_duration_3": [
    {
      "name": "blogpost1",
      "duration": 3,
      "comments": [
        {
          "name": "Jane Doe",
          "text": "Good Job, Alex!"
        }
      ]
    },
    {
      "name": "blogpost5",
      "duration": 3,
      "comments": [
        {
          "name": "Jane Doe",
          "text": "Good Job, Pravallika!"
        }
      ]
    },
    {
      "name": "blogpost7",
      "duration": 3,
      "comments": [
        {
          "name": "Alex",
          "text": "Good Job, Jane!"
        }
      ]
    }
  ],
  "all_posts_duration_3_and_active_contributor": [
    {
      "name": "blogpost1",
      "duration": 3,
      "comments": [
        {
          "name": "Jane Doe",
          "text": "Good Job, Alex!"
        }
      ]
    },
    {
      "name": "blogpost5",
      "duration": 3,
      "comments": [
        {
          "name": "Jane Doe",
          "text": "Good Job, Pravallika!"
        }
      ]
    }
  ]
}
```

## Other Functions

### [maskFields](/maskFields)

Replaces the value with a masked String when the field or the field's attribute contains private information. This function can also be used for different data types, you just need to remove the first condition since it's no longer reading the XML attributes (`fieldsToMask contains value.@name`).

Video: [DataWeave Scripts Repo: maskFields function | #Codetober 2021 Day 24](https://youtu.be/NBWLXaMYUB8)

Keywords: `dw::util::Tree`, `import`, `mapLeafValues`, `var`, `fun`, `if/else`, `or`, `contains`, `@`

Input: Can be anything, but in this example is `XML Object`

Output: Same as input

Example input
```xml
<?xml version='1.0' encoding='UTF-8'?>
<a>
    <Data name="ssn">123456789</Data>
    <Data name="accountType">savings</Data>
    <Data name="accountNo">111222333444</Data>
    <ssn>123456789</ssn>
    <accountNo>111222333444</accountNo>
    <account>
        <person>
            <ssn>123456789</ssn>
            <name>Jane Doe</name>
        </person>
        <accountDetails>
            <accountNo>111222333444</accountNo>
            <accountType>savings</accountType>
            <Data name="accountNo">111222333444</Data>
        </accountDetails>
    </account>
</a>
```

Script
```dataweave
%dw 2.0
output application/xml
import mapLeafValues from dw::util::Tree

var maskedValue = "****" // Replace the value with this String
var fieldsToMask = ["ssn", "accountNo"] // List of fields that need to be masked

fun maskFields(data) = (
    data mapLeafValues ((value, path) -> 
        if (
            (fieldsToMask contains value.@name) // If the name of the attribute matches
            or (fieldsToMask contains path[-1].selector) // If the name of the field matches
        ) maskedValue // Replace value
        else value // Leave value as-is
    )
)
---
maskFields(payload) 
```

Example output
```xml
<?xml version='1.0' encoding='UTF-8'?>
<a>
  <Data name="ssn">****</Data>
  <Data name="accountType">savings</Data>
  <Data name="accountNo">****</Data>
  <ssn>****</ssn>
  <accountNo>****</accountNo>
  <account>
    <person>
      <ssn>****</ssn>
      <name>Jane Doe</name>
    </person>
    <accountDetails>
      <accountNo>****</accountNo>
      <accountType>savings</accountType>
      <Data name="accountNo">****</Data>
    </accountDetails>
  </account>
</a>
```

### [containsEmptyValues](/containsEmptyValues)

Evaluates if the values from an Array contain at least one empty value (`null`, `[]`, `""`, `{}`). To read more about these 3 different approaches please check out this post: [How to check for empty values in an array in DataWeave | Part 4: Arrays Module](https://www.prostdev.com/post/how-to-check-for-empty-values-in-an-array-in-dataweave-part-4-arrays-module).

Video: [DataWeave Scripts Repo: containsEmptyValues function | #Codetober 2021 Day 26](https://youtu.be/sP_p78lkNAQ)

Keywords: `dw::core::Arrays`, `import`, `some`, `fun`, `if/else`, `isEmpty`, `$`, `match/case`

Input: `Array`, `Null`

Output: `Boolean`

Script
```dataweave
%dw 2.0
output application/json
import some from dw::core::Arrays

// Arrays module
fun containsEmptyValues1(arr) = if (isEmpty(arr)) true 
    else arr some isEmpty($)

// Pattern Matching
fun containsEmptyValues2(arr) = arr match {
    case [] -> true
    case a is Array -> a some isEmpty($)
    else -> isEmpty(arr)
}

// Function Overloading
fun containsEmptyValues3(value: Null) = true 
fun containsEmptyValues3(arr: Array) = arr match { 
    case [] -> true
    else -> arr some isEmpty($)
}
---
{
    fun1: containsEmptyValues1(["1", null]),
    fun2: containsEmptyValues2(["1", "2"]),
    fun3: containsEmptyValues3(["1", ""])
}
```

Example output
```json
{
  "fun1": true,
  "fun2": false,
  "fun3": true
}
```

## Other Transformations

### [`Array<String>` to `Array<Object>`](/arrayString-to-arrayObject)

Transforms an Array of Strings containing key-value pair strings into an Array of Objects with the provided key-value pairs. **Note:** the solution does not include the handling of other scenarios (i.e., invalid keys, not enough args, nulls, etc.)

Keywords: `dw::core::Arrays`, `import`, `divideBy`, `map`, `$`, `[]`

Input: `Array`, `Array<String>`

Output: `Array`, `Array<Object>`


Example input
```json
["key1","value1","key2","value2","key3","value3"]
```

Script
```dataweave
%dw 2.0
output application/json
import divideBy from dw::core::Arrays
---
payload divideBy 2
map {
    ($[0]): $[1]
}
```

Example output
```json
[
  {
    "key1": "value1"
  },
  {
    "key2": "value2"
  },
  {
    "key3": "value3"
  }
]
```