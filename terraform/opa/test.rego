package torque.environment

result = { "decision": "Denied", "reason": "Requested environment duration exceeds 180 minutes" } if {
   input.duration_minutes > 180
} 