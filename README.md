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

**Others**
- [maskFields](#maskfields)
- [containsEmptyValues](#containsemptyvalues)

## Recursive Functions

### [getChildren](/getChildren)

Creates a tree from a flat array with parent/child relationship.

Video: [DataWeave Scripts Repo: getChildren recursive function | #Codetober 2021 Day 9](https://youtu.be/ZRm1POYgwG0)

Keywords: `fun`, `do`, `var`, `as`, `filter`, `~=`, `==`, `if/else`, `isEmpty`, `match/case`, `map`, `$`, `orderBy`, `skipNullOn`

Input: `Array<Object>`

Output: `Object`

Example:

![getChildren recursive function used from the DataWeave Playground](/images/getChildren.png)

## Tail Recursive Functions

### [addIndexTailRecursive](/addIndexTailRecursive)

Transforms a JSON payload into a different JSON structure and keeps a count of the indexes accross the whole output array. This function has its own repository that contains additional explanations and links to other resources such as slides and previous versions. To learn more about it please go to this repository: [Reviewing a Complex DataWeave Transformation Use-case](https://github.com/alexandramartinez/reviewing-a-complex-dw-transformation-use-case).

Video: [DataWeave Scripts Repo: addIndexTailRecursive tail recursive function | #Codetober 2021 Day 10](https://youtu.be/7LNsn_Mu_Fw)

Keywords: `dw::util::Values`, `import`, `update/with`, `fun`, `if/else`, `do`, `var`, `~=`, `+`, `to`, `default`, `map`, `$`, `++`

Input: `Object`

Output: `Array<Object>`

Example:

![addIndexTailRecursive tail recursive function used from the DataWeave Playground](/images/addIndexTailRecursive.png)

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

Example:

![getDaysBetween tail recursive function used from the DataWeave Playground](/images/getDaysBetween.png)

### [extractPath](/extractPath)

Extract values from a JSON input using a String representation of a path.

Video: [DataWeave Scripts Repo: extractPath tail recursive function | #Codetober 2021 Day 13](https://youtu.be/rg9i_xMO4c0)

Keywords: `dw::core::Strings`, `import`, `isNumeric`, `substringAfter`, `fun`, `do`, `var`, `scan`, `regex`, `isEmpty`, `if/else`, `match/case`, `as`

Input: `Object`, `Array`

Output: Whichever value was selected from the input and with the path.

Example:

![extractPath tail recursive function used from the DataWeave Playground](/images/extractPath.png)

### [filterValueByConditions](/filterValueByConditions)

Returns the filtered given value using the conditions passed in an Array of Strings.

Video: [DataWeave Scripts Repo: filterValueByConditions tail recursive function | #Codetober 2021 Day 17](https://youtu.be/aKgplxe8w4I)

Keywords: `fun`, `if/else`, `isEmpty`, `do`, `var`, `splitBy`, `filter`, `~=`, `to`

Input: `Array<Object>`

Output: `Array<Object>`

Example:

![filterValueByConditions tail recursive function used from the DataWeave Playground](/images/filterValueByConditions.png)

### [extractPathWithFilters](/extractPathWithFilters)

Mixing the previous two functions (`extractPath` and `filterValueByConditions`) and adding a bit more code to them, this function extracts a specific path and filters the output depending on the given conditions. This also contains an additional function: `isArrayOfArray` to check if a given value is of the type `Array<Array>`.

*Note*: in order to apply the filters successfully, the given `key` must be from an Array.

Video: [DataWeave Scripts Repo: extractPathWithFilters tail recursive function | #Codetober 2021 Day 21](https://youtu.be/Tu5nRmRURgQ)

Keywords: `dw::core::Strings`, `import`, `isNumeric`, `substringAfter`, `typeOf`, `~=`, `fun`, `if/else`, `isEmpty`, `do`, `var`, `splitBy`, `filter`, `$`, `to`, `scan`, `match/case`, `as`

Input: `Object`, `Array`

Output: Whichever value was selected from the input and with the path.

Example:

![extractPathWithFilters tail recursive function used from the DataWeave Playground](/images/extractPathWithFilters.png)

## Others

### [maskFields](/maskFields)

Replaces the value with a masked String when the field or the field's attribute contains private information. This function can also be used for different data types, you just need to remove the first condition since it's no longer reading the XML attributes (`fieldsToMask contains value.@name`).

Video: [DataWeave Scripts Repo: maskFields function | #Codetober 2021 Day 24](https://youtu.be/NBWLXaMYUB8)

Keywords: `dw::util::Tree`, `import`, `mapLeafValues`, `var`, `fun`, `if/else`, `or`, `contains`, `@`

Input: Can be anything, but in this example is `XML Object`

Output: Same as input

Example:

![maskFields and mapLeafValues functions used from the DataWeave Playground](/images/maskFields.png)

### [containsEmptyValues](/containsEmptyValues)

Evaluates if the values from an Array contain at least one empty value (`null`, `[]`, `""`, `{}`). To read more about these 3 different approaches please check out this post: [How to check for empty values in an array in DataWeave | Part 4: Arrays Module](https://www.prostdev.com/post/how-to-check-for-empty-values-in-an-array-in-dataweave-part-4-arrays-module).

Keywords: `dw::core::Arrays`, `import`, `some`, `fun`, `if/else`, `isEmpty`, `$`, `match/case`

Input: `Array`, `Null`

Output: `Boolean`

Example:

![containsEmptyValues functions used from the DataWeave Playground](/images/containsEmptyValues.png)
