%dw 2.0
output text/plain
var p = payload splitBy "\n\n" map (
    $ splitBy "\n"
)
var units = (p[1][0] splitBy ", ")[-1]
var sizes = p[0]
var name1 = (p[1][0] splitBy ",")[0]
var column1 = p[1][1 to -1]
var name2 = (p[2][0] splitBy ",")[0]
var column2 = p[2][1 to -1]
---
sizes map (
    "$($) - $(name1): $(column1[$$]) $(units), $(name2): $(column2[$$]) $(units)"
) joinBy "\n"