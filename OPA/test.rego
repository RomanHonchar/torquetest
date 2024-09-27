package torque.environment
import future.keywords.if

result = { "decision": "Denied", "reason": "Requested environment duration exceeds 180 minutes" } if {
   input.duration_minutes >= 180
}

result = { "decision": "Approved", "reason": "Requested environment duration do not exceeds 180 minutes" } if {
   input.duration_minutes < 180
}