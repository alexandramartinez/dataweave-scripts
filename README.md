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

**Others**
- [maskFields](#maskfields)
- [containsEmptyValues](#containsemptyvalues)

## Recursive Functions

### [getChildren](/getChildren)

Creates a tree from a flat array with parent/child relationship.

Keywords: `fun`, `do`, `var`, `as`, `filter`, `~=`, `==`, `if/else`, `isEmpty`, `match/case`, `map`, `$`, `orderBy`, `skipNullOn`

Input: `Array<Object>`

Output: `Object`

Example:

![getChildren recursive function used from the DataWeave Playground](/images/getChildren.png)

## Tail Recursive Functions

### [addIndexTailRecursive](/addIndexTailRecursive)

Transforms a JSON payload into a different JSON structure and keeps a count of the indexes accross the whole output array. This function has its own repository that contains additional explanations and links to other resources such as slides and previous versions. To learn more about it please go to this repository: [Reviewing a Complex DataWeave Transformation Use-case](https://github.com/alexandramartinez/reviewing-a-complex-dw-transformation-use-case).

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

Keywords: `var`, `as`, `fun`, `do`, `contains`, `and`, `not`, `if/else`, `+`, `>`, `==`, `|P|` (Period)

Input: NA

Output: `Number`

Example:

![getDaysBetween tail recursive function used from the DataWeave Playground](/images/getDaysBetween.png)

### [extractPath](/extractPath)

Extract values from a JSON input using a String representation of a path.

Keywords: `dw::core::Strings`, `import`, `isNumeric`, `substringAfter`, `fun`, `do`, `var`, `scan`, `regex`, `isEmpty`, `if/else`, `match/case`, `as`

Input: `Object`, `Array`

Output: Whichever value was selected from the input and with the path.

Example:

![extractPath tail recursive function used from the DataWeave Playground](/images/extractPath.png)

## Others

### [maskFields](/maskFields)

Replaces the value with a masked String when the field or the field's attribute contains private information. This function can also be used for different data types, you just need to remove the first condition since it's no longer reading the XML attributes (`fieldsToMask contains value.@name`).

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
