%dw 2.0
output application/xml
import * from dw::util::Values
---
payload mask field("ssn") with "*****" mask  field("accountNo") with "*****"
