%dw 2.0
output application/json
fun infiniteCountFrom(startingNumber: Number): Array<Number> =
    [startingNumber ~ infiniteCountFrom(startingNumber + 1)]
---
// remove the [1 to 10] to make it really infinite
// warning: it will NEVER stop running
// watch the video for more information: https://youtu.be/WDi0g2VtFIg
infiniteCountFrom(0)[1 to 10]