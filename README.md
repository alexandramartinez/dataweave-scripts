# DataWeave Scripts

Here's a compilation of all the (fairly complex) DW scripts I've done.

Click on a title to see the function's code, input, and output.

## Table of Contents

**Recursive Functions**
- [getChildren](#getchildren)

**Tail Recursive Functions**
- [extractPath](#extractpath)

## Recursive Functions

### [getChildren](/getChildren)

Creates a tree from a flat array with parent/child relationship.

**Keywords**: `fun`, `do`, `var`, `as`, `filter`, `~=`, `==`, `if/else`, `isEmpty`, `match/case`, `map`, `$`, `orderBy`

**Input**: `Array<Object>`
**Output**: `Object`

Example:

![getChildren recursive function used from the DataWeave Playground](/images/getChildren.png)

## Tail Recursive Functions

### [extractPath](/extractPath)

Extract values from a JSON input using a String representation of a path.

Keywords: `dw::core::Strings`, `import`, `isNumeric`, `substringAfter`, `fun`, `do`, `var`, `scan`, `regex`, `isEmpty`, `if/else`, `match/case`, `as`

Input: `Object`, `Array`
Output: Whichever value was selected from the input and with the path.

Example:

![extractPath tail recursive function used from the DataWeave Playground](/images/extractPath.png)
