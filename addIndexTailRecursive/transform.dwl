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