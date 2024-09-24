package torque.environment
 
result = output {
    # Deny if duration exceeds or equals 180 minutes
    input.duration_minutes >= 180
    output := {
        "decision": "Denied",
        "reason": "Requested environment duration exceeds 180 minutes"
    }
}
 
result = output {
    # Approve if duration is less than 180 minutes
    input.duration_minutes < 180
    output := {
        "decision": "Approved",
        "reason": "Requested environment duration does not exceed 180 minutes"
    }
}