#!/bin/bash
# DEATHSTAR NEC 220.82 Calculation Library
# Pure Bash math functions for load calculations

# Calculate general loads per 220.82(B)
calc_general_loads() {
    local sqft=$1
    local small_circuits=$2
    local laundry_circuits=$3
    shift 3
    local appliances=("$@")
    
    local general_lighting=$(( sqft * 3 ))
    local small_appliance=$(( small_circuits * 1500 ))
    local laundry=$(( laundry_circuits * 1500 ))
    
    local general=$(( general_lighting + small_appliance + laundry ))
    
    for app in "${appliances[@]}"; do
        local va=$(echo "$app" | cut -d':' -f2)
        general=$(( general + va ))
    done
    
    echo $general
}

# Apply demand factor per 220.82(B)
apply_demand_factor() {
    local general_loads=$1
    
    if (( general_loads > 10000 )); then
        local demanded=$(( 10000 + (general_loads - 10000) * 40 / 100 ))
    else
        local demanded=$general_loads
    fi
    
    echo $demanded
}

# Calculate HVAC load per 220.82(C) - use larger of heating or cooling
calc_hvac_load() {
    local heat_va=$1
    local ac_va=$2
    
    if (( heat_va > ac_va )); then
        echo $heat_va
    else
        echo $ac_va
    fi
}

# Calculate amps from VA
calc_amps() {
    local total_va=$1
    local voltage=${2:-240}
    
    echo $(( total_va / voltage ))
}

# Get recommended service size
get_service_size() {
    local amps=$1
    local standard_sizes=(100 125 150 200 400 600)
    
    for size in "${standard_sizes[@]}"; do
        if (( amps <= size )); then
            echo $size
            return
        fi
    done
    
    # If exceeds all standard sizes, round up to nearest 100
    echo $(( (amps + 99) / 100 * 100 ))
}

# Validate NEC minimums
validate_nec_minimums() {
    local small_circuits=$1
    local laundry_circuits=$2
    local service_size=$3
    
    local warnings=()
    
    if (( small_circuits < 2 )); then
        warnings+=("NEC 210.11(C)(1): Minimum 2 small-appliance circuits required")
    fi
    
    if (( laundry_circuits < 1 )); then
        warnings+=("NEC 210.11(C)(2): Minimum 1 laundry circuit required")
    fi
    
    if (( service_size < 100 )); then
        warnings+=("NEC 230.79(C): Minimum 100A service required for dwellings")
    fi
    
    if [[ ${#warnings[@]} -gt 0 ]]; then
        printf '%s\n' "${warnings[@]}"
        return 1
    fi
    
    return 0
}
