# DataWeave Scripts

Here's a compilation of some of the (fairly complex) DW scripts I've done.

Check out the [Table of Contents](#table-of-contents) to find all the functions listed here. 

In each function's section, you'll find a brief description of what it does, the input/script/output to run the function, and a button to open the example in the DataWeave Playground directly -- without having to copy and paste each example yourself.

## More Info

To learn more about DataWeave, please go to DataWeave's official landing page: [dataweave.mulesoft.com](https://dataweave.mulesoft.com/). There you will find aditional resources like the link to join the official DataWeave Slack workspace, the DataWeave Playground, the Visual Studio Code extension, the documentation, and so on.

If you want to open an example in Visual Studio Code, you can use the **Export** button located at the top of the DataWeave Playground, extract the `.zip` file, and open the extracted folder in VSCode. Make sure you already installed Java 8, Maven, and the DataWeave extension for VSCode. For more information, please see the resources below.

- Video: [How to export a script from the DataWeave Playground to Visual Studio Code | Short Tutorial](https://youtu.be/_8kCFBdgX5A)
- Tutorial: [Getting started with the DataWeave extension for Visual Studio Code](https://developer.mulesoft.com/tutorials-and-howtos/dataweave/dataweave-extension-vscode-getting-started/)

For additional questions, you can contact me here: [alexmartinez.ca/contact](https://www.alexmartinez.ca/contact)

## Table of Contents

**Recursive Functions**
- [getChildren](#getchildren)

**Tail Recursive Functions**
- [addIndexTailRecursive](#addindextailrecursive)
- [getDaysBetween](#getdaysbetween)
- [extractPath](#extractpath)
- [filterValueByConditions](#filtervaluebyconditions)
- [extractPathWithFilters](#extractpathwithfilters)
- [getDatesArray](#getdatesarray)

**Head and Tail Constructor**
- [daysUntil](#daysuntil)
- [countAll](#countall)
- [infiniteCountFrom](#infinitecountfrom)

**Other Functions**
- [maskFields](#maskfields)
- [containsEmptyValues](#containsemptyvalues)

**Other Transformations**
- [`Array<String>` to `Array<Object>`](#arraystring-to-arrayobject)

## Recursive Functions

I don't personally recommend using recursive functions because they can reach the Stack Overflow error and mess with your code's performance. But there are some cases where it is needed.

To understand recursive functions better, take a look at this video: [What are recursive functions and how to use them in DataWeave | #Codetober 2022 Day 22](https://youtu.be/9ewcIXukbtc)

### getChildren

Creates a tree from a flat array with parent/child relationship.

Video: [DataWeave Scripts Repo: getChildren recursive function | #Codetober 2021 Day 9](https://youtu.be/ZRm1POYgwG0)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FgetChildren"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

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
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

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
</details>

## Tail Recursive Functions

If you really want to use recursion in DataWeave, I very much recommend using tail-recursive functions instead of the regular recursive functions. These are better performance-wise because they do not reach the Stack Overflow error.

To understand tail-recursive functions better, take a look at this video: [What are TAIL-recursive functions and how to use them in DataWeave | #Codetober 2022 Day 23](https://youtu.be/LKmOEpEVFxw)

### addIndexTailRecursive

Transforms a JSON payload into a different JSON structure and keeps a count of the indexes accross the whole output array. This function has its own repository that contains additional explanations and links to other resources such as slides and previous versions. To learn more about it please go to this repository: [Reviewing a Complex DataWeave Transformation Use-case](https://github.com/alexandramartinez/reviewing-a-complex-dw-transformation-use-case).

Video: [DataWeave Scripts Repo: addIndexTailRecursive tail recursive function | #Codetober 2021 Day 10](https://youtu.be/7LNsn_Mu_Fw)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FaddIndexTailRecursive"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

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
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

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
</details>

### getDaysBetween

Count the number of days between two dates using certain filters to either count some days or keep them out.

Filters:
- `includeEndDate` - Boolean to include the endDate in count or not. Default value is `false`.
- `includingDaysOfWeek` - Array of Numbers to include just certain days of the week in count. Default is to count all days of the week (1-7).
- `excludingDates` - Array of Dates to include certain dates that should not be counted. Default is empty.

Video: [DataWeave Scripts Repo: getDaysBetween tail recursive function | #Codetober 2021 Day 12](https://youtu.be/QiP6WalvwRM)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FgetDaysBetween"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

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
</details>

### extractPath

Extract values from a JSON input using a String representation of a path.

Video: [DataWeave Scripts Repo: extractPath tail recursive function | #Codetober 2021 Day 13](https://youtu.be/rg9i_xMO4c0)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FextractPath"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

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
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

  ```json
  "value1"
  ```
</details>

### filterValueByConditions

Returns the filtered given value using the conditions passed in an Array of Strings.

Video: [DataWeave Scripts Repo: filterValueByConditions tail recursive function | #Codetober 2021 Day 17](https://youtu.be/aKgplxe8w4I)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FfilterValueByConditions"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

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
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

  ```json
  [
    {
      "id": 123,
      "name": "abc",
      "active": true
    }
  ]
  ```
</details>

### extractPathWithFilters

Mixing the previous two functions (`extractPath` and `filterValueByConditions`) and adding a bit more code to them, this function extracts a specific path and filters the output depending on the given conditions. This also contains an additional function: `isArrayOfArray` to check if a given value is of the type `Array<Array>`.

> **Note**
>
> In order to apply the filters successfully, the given `key` must be from an Array.

Video: [DataWeave Scripts Repo: extractPathWithFilters tail recursive function | #Codetober 2021 Day 21](https://youtu.be/Tu5nRmRURgQ)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FextractPathWithFilters"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

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
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

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
</details>

### getDatesArray

Outputs an Array of Dates `Array<Date>` containing all the dates between two given dates. (See [daysUntil](#daysuntil) for an alternate solution)

Video: [DataWeave Scripts repo: getDatesArray tail recursive function | #Codetober 2022 Day 24](https://youtu.be/BKHgaldKEgs)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FgetDatesArray"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

  ```dataweave
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
  ```
</details>

<details>
  <summary>Output</summary>

  ```json
  [
    "2022-10-16",
    "2022-10-17",
    "2022-10-18"
  ]
  ```
</details>

## Head and Tail Constructor

This syntax hasn't been documented so far, but in the following examples you can get a better feeling of how it works. It can be used with the `Array` and `Object` types.

The general idea is that you create a function that will essentially be recursive, but since this syntax is a lazy evaluation, you won't receive the Stack Overflow error. Inside the function, specify the head, then use `~` to specify the tail afterwards. Surround this in `[]` for Array or `{}` for Object.

This is said to be a better syntax than using recursive or tail-recursive functions. So, I recommend you get familiar with it to use it in your Array/Object transformations.

### daysUntil

Outputs an Array of Dates `Array<Date>` containing all the dates between two given dates. (See [getDatesArray](#getdatesarray) for an alternate solution)

Video: [DataWeave Scripts repo: daysUntil function (head and tail constructor) | #Codetober 2022 Day 25](https://youtu.be/UdDzgpOv2oo)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FdaysUntil"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

  ```dataweave
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
  ```
</details>

<details>
  <summary>Output</summary>

  ```json
  [
    "2022-10-16",
    "2022-10-17",
    "2022-10-18"
  ]
  ```
</details>

### countAll

Outputs an array of numbers `Array<Number>` containing all the numbers from `1` to the given input.

Video: [DataWeave Scripts repo: daysUntil function (head and tail constructor) | #Codetober 2022 Day 25](https://youtu.be/UdDzgpOv2oo)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FcountAll"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

  ```dataweave
  %dw 2.0
  output application/json
  fun countAll(count: Number): Array<Number> =
      if (count <= 1) [count]
      else [count ~ countAll(count-1)]
  ---
  countAll(3)
  ```
</details>

<details>
  <summary>Output</summary>

  ```json
  [
      3,
      2,
      1
  ]
  ```
</details>

### infiniteCountFrom

Creates an infinite array of numbers `Array<Number>` without reaching a stack overflow error, thanks to the head & tail constructor's lazy evaluation. The index/range selector is used to extract a portion of the infinite array to actually see the result.

Video: [DataWeave Scripts repo: infiniteCountFrom func (head & tail constructor) | #Codetober 2022 Day 26](https://youtu.be/WDi0g2VtFIg)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FinfiniteCountFrom"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

  ```dataweave
  %dw 2.0
  output application/json
  fun infiniteCountFrom(startingNumber: Number): Array<Number> =
      [startingNumber ~ infiniteCountFrom(startingNumber + 1)]
  ---
  // remove the [1 to 10] to make it really infinite
  // warning: it will NEVER stop running
  // watch the video for more information: https://youtu.be/WDi0g2VtFIg
  infiniteCountFrom(0)[1 to 10]
  ```
</details>

<details>
  <summary>Output</summary>

  ```json
  [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10
  ]
  ```
</details>

## Other Functions

I wasn't sure where to put these functions, so I just dropped them here 😄

### maskFields

Replaces the value with a masked String when the field or the field's attribute contains private information. This function can also be used for different data types, you just need to remove the first condition since it's no longer reading the XML attributes (`fieldsToMask contains value.@name`).

Video: [DataWeave Scripts Repo: maskFields function | #Codetober 2021 Day 24](https://youtu.be/NBWLXaMYUB8)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FmaskFields"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

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
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

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
</details>

### containsEmptyValues

Evaluates if the values from an Array contain at least one empty value (`null`, `[]`, `""`, `{}`). To read more about these 3 different approaches please check out this post: [How to check for empty values in an array in DataWeave | Part 4: Arrays Module](https://www.prostdev.com/post/how-to-check-for-empty-values-in-an-array-in-dataweave-part-4-arrays-module).

Video: [DataWeave Scripts Repo: containsEmptyValues function | #Codetober 2021 Day 26](https://youtu.be/sP_p78lkNAQ)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FcontainsEmptyValues"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

  ```json
  {
    "fun1": true,
    "fun2": false,
    "fun3": true
  }
  ```
</details>

## Other Transformations

These are not necessarily functions that I created, but I thought they still created some additional value to learn other kinds of transformations.

### `Array<String>` to `Array<Object>`

Transforms an Array of Strings containing key-value pair strings into an Array of Objects with the provided key-value pairs. 

> **Note**
>
> The solution does not include the handling of other scenarios (i.e., invalid keys, not enough args, nulls, etc.)

<a href="https://dataweave.mulesoft.com/learn/playground?projectMethod=GHRepo&repo=alexandramartinez%2Fdataweave-scripts&path=functions%2FarrayString-to-arrayObject"><img width="300" src="/images/dwplayground-button.png"><a>

<details>
  <summary>Input</summary>

  ```json
  ["key1","value1","key2","value2","key3","value3"]
  ```
</details>

<details>
  <summary>Script</summary>

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
</details>

<details>
  <summary>Output</summary>

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
</details>
