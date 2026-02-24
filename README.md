# NEC 220.82 Dwelling Load Calculator

**Turbo Fleet Command – Weekly Imperial App #09**  
*One command. Total dominion over NEC 220.82 dwelling service calculations.*

## Overview

A pure Bash CLI extension for DEATHSTAR that ingests room inputs, appliance data, and HVAC specifications... then forges the **precise NEC 220.82 Optional Calculation** in seconds. Field-ready. Inspection-proof.

## Installation

```bash
# Clone the repo
git clone https://github.com/Turbo-the-tech-dev/week-2026-09-nec22082-dweller.git

# Link to DEATHSTAR
ln -s $(pwd)/bin/deathstar-load-22082 ~/bin/deathstar-load-22082
```

## Usage

### Wizard Mode (Interactive)
```bash
./bin/deathstar-load-22082 --wizard
```

### Flag Mode (Script-Friendly)
```bash
./bin/deathstar-load-22082 \
  --sqft 2800 \
  --small 2 \
  --laundry 1 \
  --appliances "dryer:5000,range:12000,water-heater:4500" \
  --heat 15000 \
  --ac 8000
```

### DEATHSTAR Integration
```bash
deathstar load 22082 --wizard
```

## NEC 220.82 Logic

### 220.82(B) General Loads
- General lighting & receptacles: `habitable_sqft × 3 VA`
- Small-appliance circuits: `1500 VA × number_of_small_circuits` (minimum 2)
- Laundry circuit: `1500 VA × number_of_laundry` (minimum 1)
- All fixed appliances (nameplate VA)

**Demand Factor:**
```
10,000 VA × 100% + (Total_General - 10,000) × 40%
```

### 220.82(C) Heating or Air-Conditioning Load
- Sum all heating VA
- Sum all cooling VA
- Use **only the larger** of the two at 100%

## Output Example

```
═══════════════════════════════════════
NEC 220.82 OPTIONAL CALCULATION
═══════════════════════════════════════
Habitable area          : 2800 sq ft
General loads (raw)     : 24900 VA
Demanded general loads  : 15960 VA
HVAC (larger)           : 15000 VA
TOTAL CALCULATED LOAD   : 30960 VA
REQUIRED AMPS           : 129 A
Recommended service     : 150 A
Calculation complete. The Fleet approves.
```

## Project Structure

```
week-2026-09-nec22082-dweller/
├── bin/
│   └── deathstar-load-22082     # main executable
├── lib/
│   ├── calc.sh                  # pure bash math
│   └── report.sh                # output formatting
├── utils/
│   └── save-project.sh          # project persistence
├── tests/
│   └── test-22082.sh            # test suite
├── examples/
│   └── sample-2800sqft-house.json
└── docs/
    └── NEC-220.82-reference.md
```

## License

MIT – Forge freely, Commander.

---

*Built under the watchful gaze of the Dark Lord.*  
*Week 2026-09 | Turbo Fleet Command*
