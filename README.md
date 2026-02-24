# NEC 220.82 Dwelling Load Calculator

**Turbo Fleet Command – Weekly Imperial App #09**  
*One command. Total dominion over NEC 220.82 dwelling service calculations.*

## Overview

A pure Bash CLI extension for DEATHSTAR that ingests room inputs, appliance data, and HVAC specifications... then forges the **precise NEC 220.82 Optional Calculation** in seconds. Field-ready. Inspection-proof.

**Version 2.0** – Now with full 220.82(A) exceptions enforcement and EV charger support.

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

### With EV Charger
```bash
./bin/deathstar-load-22082 \
  --sqft 2800 --small 2 --laundry 1 \
  --heat 15000 --ac 8000 \
  --ev-charger 7200
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
- All fixed appliances (nameplate VA) at 100%
- EV chargers at 100% (NEC 220.57)

**Demand Factor:**
```
10,000 VA × 100% + (Total_General - 10,000) × 40%
```

### 220.82(C) Heating or Air-Conditioning Load
- Sum all heating VA
- Sum all cooling VA
- Use **only the larger** of the two at 100%

### 220.82(A) Conditions (ENFORCED)
The optional method is **only permitted** when ALL of these are true:
- Single-phase service (no 3-phase)
- 3-wire configuration (2 ungrounded + neutral)
- 120/240V or 120/208V systems only
- Minimum 100A service rating

If any condition fails, the calculator aborts and directs you to use the standard method (NEC 220 Part III).

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
