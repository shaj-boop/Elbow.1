# Elbow-1

An open single-joint elbow assist. One degree of freedom. One working elbow.

CAD freeze **v0** for a Solo Grant application (ask: **$1,000**). The grant buys two ROBOTIS Dynamixel MX-28AT actuators and the cuff, sensors, and e-stop around them.

Builder: **Dmitrii Naumov**, solo.

**Not a medical device.** Not a clinic product. Not a full-body suit.

| | |
|---|---|
| Stage | CAD + firmware skeleton. Actuators not purchased. |
| Ask | $1,000 |
| DoF | 1 (elbow) |
| Actuators | MX-28AT ×2 (agonist / antagonist) |
| License | CERN-OHL-S v2 (hardware) / MIT (firmware) |

## What v1 is

- One elbow, not a suit
- Two MX-28AT actuators (position + PID in the box, 2.5 N·m stall at 12 V)
- 3D-printed PETG cuffs on a short 2020 aluminum frame
- Load cell in the load path
- Arduino firmware that will not move unless the e-stop is armed
- Bench test: hold 2 kg through 90°, log angle and load to CSV
- Then the same test on an arm

## Repo layout

```
cad/elbow1.scad          OpenSCAD source (parametric)
cad/stl/                 Printable parts
firmware/Elbow1.ino      Arduino + Dynamixel Shield
firmware/config.h        Pins, IDs, torque cap
BOM.md                   Priced parts, Sep 2026
BUILD.md                 Four-week plan after parts land
SAFETY.md                E-stop, torque cap, no medical claims
CONSTRAINTS.md           What v1 will not grow into
GRANT.md                 Written application
FORM_ANSWERS.md          Airtable paste sheet
LICENSE                  CERN-OHL-S / MIT
```

## Print recipe

PETG · 0.2 mm layer · 5 perimeters · 40% gyroid.

| Part | File |
|---|---|
| Upper-arm cuff (ID 96 mm) | `cad/stl/cuff_upper.stl` |
| Forearm cuff (ID 80 mm) | `cad/stl/cuff_forearm.stl` |
| Horn adapter ×2 | `cad/stl/horn_adapter.stl` |
| Load-cell bracket | `cad/stl/loadcell_bracket.stl` |
| Extrusion clip ×2 | `cad/stl/extrusion_clip.stl` |

Open `cad/elbow1.scad` in [OpenSCAD](https://openscad.org). `part = "assembly";` shows the hinge.

## Firmware

Arduino Uno + Dynamixel Shield. Serial 115200.

```
ARM / DISARM / MOVE <deg> / CYCLE / LOG ON
```

Torque stays off until the latching e-stop is armed. See `SAFETY.md`.

## After the money lands

See `BUILD.md`. Order both MX-28ATs on day 0. Week 2 is the 2 kg / 90° bench. Week 4 is publish — or an honest miss.

## Working stage

- [x] Constraint list (one joint, no suit)
- [x] BOM priced with live sources, Sep 2026
- [x] Safety rules
- [x] OpenSCAD assembly + printable STLs
- [x] Arduino firmware skeleton (will not move unarmed)
- [x] Bench protocol: 2 kg through 90°, three cycles, CSV
- [ ] MX-28AT ×2 purchased — this is the wall
- [ ] Week 1: one motor, e-stop in the enable line
- [ ] Week 2: 2 kg / 90° logged on the bench
- [ ] Week 3: PETG cuffs on a padded dummy, then an arm
- [ ] Week 4: publish video + CSV, or an honest miss
