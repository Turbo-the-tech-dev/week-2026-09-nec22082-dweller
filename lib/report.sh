#!/bin/bash
# DEATHSTAR Report Formatting Library
# Output formatting functions for terminal, markdown, and JSON

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Print section header
print_header() {
    local title="$1"
    local width=${2:-50}
    local half=$(( (width - 2 - ${#title}) / 2 ))
    
    echo -e "${GREEN}╔$(printf '═%.0s' $(seq 1 $width))╗${NC}"
    printf "${GREEN}║${NC}"
    printf '%*.s' $half ''
    echo -e "${YELLOW} $title ${NC}${GREEN}"
    printf '╚%.0s' $(seq 1 $width)
    echo -e "╗${NC}"
}

# Print key-value pair
print_kv() {
    local key="$1"
    local value="$2"
    local width=${3:-35}
    
    printf "  ${CYAN}%-${width}s${NC} %s\n" "$key:" "$value"
}

# Print warning
print_warning() {
    local message="$1"
    echo -e "${RED}⚠ WARNING: $message${NC}"
}

# Print success
print_success() {
    local message="$1"
    echo -e "${GREEN}✓ $message${NC}"
}

# Print error
print_error() {
    local message="$1"
    echo -e "${RED}✗ Error: $message${NC}"
}

# Print NEC reference
print_nec_ref() {
    local code="$1"
    local description="$2"
    echo -e "  ${BLUE}•${NC} $code – $description"
}

# Generate markdown table row
md_table_row() {
    local col1="$1"
    local col2="$2"
    echo "| $col1 | $col2 |"
}

# Generate markdown table header
md_table_header() {
    local col1="$1"
    local col2="$2"
    echo "| $col1 | $col2 |"
    echo "|---------|-------|"
}

# Format VA value
format_va() {
    local va=$1
    echo "$va VA"
}

# Format amps value
format_amps() {
    local amps=$1
    echo "$amps A"
}

# Format square footage
format_sqft() {
    local sqft=$1
    echo "$sqft sq ft"
}
