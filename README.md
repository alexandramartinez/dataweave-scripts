# DataWeave Scripts

Here's a compilation of all the (fairly complex) DW scripts I've done.

Click on a title to see the function's code, input, and output.

## Table of Contents

**Recursive Functions**
- [getChildren](#getchildren)

**Tail Recursive Functions**
- [getDaysBetween](#getdaysbetween)
- [extractPath](#extractpath)

**Others**
- [maskFields](#maskfields)

## Recursive Functions

### [getChildren](/getChildren)

Creates a tree from a flat array with parent/child relationship.

Keywords: `fun`, `do`, `var`, `as`, `filter`, `~=`, `==`, `if/else`, `isEmpty`, `match/case`, `map`, `$`, `orderBy`, `skipNullOn`

Input: `Array<Object>`

Output: `Object`

Example:

![getChildren recursive function used from the DataWeave Playground](/images/getChildren.png)

## Tail Recursive Functions

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
