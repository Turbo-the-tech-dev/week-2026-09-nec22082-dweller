#!/bin/bash
# DEATHSTAR Project Save Utility
# Saves and loads calculation projects

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SAVE_DIR="$HOME/.deathstar/projects"

# Create save directory
mkdir -p "$SAVE_DIR"

save_project() {
    local name="$1"
    local sqft="$2"
    local small="$3"
    local laundry="$4"
    local appliances="$5"
    local heat="$6"
    local ac="$7"
    
    local timestamp=$(date -Iseconds)
    
    cat > "$SAVE_DIR/${name}.json" << EOF
{
  "name": "$name",
  "created": "$timestamp",
  "project_type": "nec_22082_dwelling",
  "input": {
    "sqft": $sqft,
    "small_circuits": $small,
    "laundry_circuits": $laundry,
    "appliances": [$appliances],
    "heat_va": $heat,
    "ac_va": $ac
  }
}
EOF
    
    echo "Project saved to: $SAVE_DIR/${name}.json"
}

list_projects() {
    echo "Saved projects in $SAVE_DIR:"
    echo ""
    
    if [[ -d "$SAVE_DIR" ]]; then
        for file in "$SAVE_DIR"/*.json; do
            if [[ -f "$file" ]]; then
                local name=$(basename "$file" .json)
                local created=$(grep '"created"' "$file" | cut -d'"' -f4)
                echo "  • $name (created: $created)"
            fi
        done
    else
        echo "  No projects found."
    fi
}

delete_project() {
    local name="$1"
    local file="$SAVE_DIR/${name}.json"
    
    if [[ -f "$file" ]]; then
        rm "$file"
        echo "Project '$name' deleted."
    else
        echo "Project '$name' not found."
    fi
}

# CLI interface
case "${1:-}" in
    save)
        save_project "$2" "$3" "$4" "$5" "$6" "$7" "$8"
        ;;
    list)
        list_projects
        ;;
    delete)
        delete_project "$2"
        ;;
    *)
        echo "Usage: $0 {save|list|delete} [args...]"
        echo ""
        echo "Commands:"
        echo "  save <name> <sqft> <small> <laundry> <appliances_json> <heat> <ac>"
        echo "  list"
        echo "  delete <name>"
        ;;
esac
