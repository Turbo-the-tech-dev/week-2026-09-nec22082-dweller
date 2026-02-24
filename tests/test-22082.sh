#!/bin/bash
# DEATHSTAR NEC 220.82 Test Suite
# Validates calculation accuracy against known examples

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$SCRIPT_DIR/../bin/deathstar-load-22082"

passed=0
failed=0

run_test() {
    local name="$1"
    local expected_amps="$2"
    shift 2
    local args=("$@")
    
    echo -n "Testing: $name... "
    
    # Run calculation and capture output
    local output=$("$BIN" "${args[@]}" --output terminal 2>&1)
    local actual_amps=$(echo "$output" | grep "REQUIRED AMPS" | grep -oE '[0-9]+')
    
    if [[ "$actual_amps" == "$expected_amps" ]]; then
        echo -e "${GREEN}✓ PASSED${NC}"
        ((passed++))
    else
        echo -e "${RED}✗ FAILED${NC}"
        echo "  Expected: $expected_amps A"
        echo "  Got: $actual_amps A"
        ((failed++))
    fi
}

echo -e "${YELLOW}╔═══════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║     DEATHSTAR NEC 220.82 Test Suite – Week 2026-09    ║${NC}"
echo -e "${YELLOW}╚═══════════════════════════════════════════════════════╝${NC}"
echo ""

# Test 1: Basic 2800 sq ft house
# General: 2800*3 + 2*1500 + 1*1500 = 8400 + 3000 + 1500 = 12900 VA
# Demanded: 10000 + (12900-10000)*0.4 = 10000 + 1160 = 11160 VA
# HVAC: 15000 (heat > ac)
# Total: 11160 + 15000 = 26160 VA
# Amps: 26160/240 = 109 A
run_test "2800 sq ft with heat" "109" \
    --sqft 2800 --small 2 --laundry 1 --heat 15000 --ac 8000

# Test 2: Small apartment 1200 sq ft
# General: 1200*3 + 2*1500 + 1*1500 = 3600 + 3000 + 1500 = 8100 VA
# Demanded: 8100 (under 10k, no demand factor)
# HVAC: 5000
# Total: 8100 + 5000 = 13100 VA
# Amps: 13100/240 = 54 A -> minimum 100 A service
run_test "1200 sq ft apartment" "54" \
    --sqft 1200 --small 2 --laundry 1 --heat 5000 --ac 3000

# Test 3: Large house with many appliances
# General: 4000*3 + 3*1500 + 2*1500 = 12000 + 4500 + 3000 = 19500
# Appliances: 12000 + 5000 + 4500 + 1500 + 1000 + 6000 + 8000 = 38000
# Total general: 19500 + 38000 = 57500 VA
# Demanded: 10000 + (57500-10000)*0.4 = 10000 + 19000 = 29000 VA
# HVAC: 20000
# Total: 29000 + 20000 = 49000 VA
# Amps: 49000/240 = 204 A -> 300 A service
run_test "4000 sq ft with all appliances" "204" \
    --sqft 4000 --small 3 --laundry 2 \
    --appliances "range:12000,dryer:5000,water-heater:4500,dishwasher:1500,disposal:1000,oven:6000,cooktop:8000" \
    --heat 20000 --ac 15000

# Test 4: AC-dominated load (Florida house)
# General: 2500*3 + 2*1500 + 1*1500 = 7500 + 3000 + 1500 = 12000 VA
# Demanded: 10000 + (12000-10000)*0.4 = 10000 + 800 = 10800 VA
# HVAC: 12000 (ac > heat)
# Total: 10800 + 12000 = 22800 VA
# Amps: 22800/240 = 95 A -> minimum 100 A service
run_test "2500 sq ft Florida (AC dominated)" "95" \
    --sqft 2500 --small 2 --laundry 1 --heat 3000 --ac 12000

# Test 5: With JSON output
echo -n "Testing: JSON output format... "
output=$("$BIN" --sqft 2000 --small 2 --laundry 1 --heat 10000 --ac 8000 --output json 2>&1)
if echo "$output" | grep -q '"total_va"'; then
    echo -e "${GREEN}✓ PASSED${NC}"
    ((passed++))
else
    echo -e "${RED}✗ FAILED${NC}"
    ((failed++))
fi

# Test 6: Wizard mode help
echo -n "Testing: Help output... "
output=$("$BIN" --help 2>&1)
if echo "$output" | grep -q "220.82"; then
    echo -e "${GREEN}✓ PASSED${NC}"
    ((passed++))
else
    echo -e "${RED}✗ FAILED${NC}"
    ((failed++))
fi

echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"
echo -e "Tests Passed: ${GREEN}$passed${NC}"
echo -e "Tests Failed: ${RED}$failed${NC}"
echo -e "${YELLOW}═══════════════════════════════════════════════════════${NC}"

if [[ $failed -gt 0 ]]; then
    exit 1
fi

echo -e "${GREEN}All tests passed. The Fleet approves.${NC}"
