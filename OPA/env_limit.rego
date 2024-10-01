package torque.consumption
import future.keywords.if

result = { "decision": "Denied", "reason": "Owner already have an active enviroinment in this space" } if {
   input.owner_active_environments_in_space >= 2
}

result = { "decision": "Approved", "reason": "Owner don't have an active enviroinment in this space" } if {
   input.owner_active_environments_in_space < 2
} 
