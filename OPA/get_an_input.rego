package torque.environment

#### Making inputs more friendly, not really necessary
bp_inputs := input.inputs

#result = { "decision": "Denied", "reason": sprintf("DUMPING::: %v", [input]) }
result = { "decision": "Denied", "reason": sprintf("DUMPING::: %v", [input.active_environments_in_space]) }