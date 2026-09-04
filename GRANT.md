# Solo Grant application — Elbow-1

Short written application. Amount: $1,000. Voice: a text to a friend.

Form: https://airtable.com/appHaOk5VRk50CpcF/pag93ybs2R8OfxZXD/form

---

## Personal background

I'm Dmitrii Naumov. I build by myself. I have a Mac mini M4 on the desk and I can CAD, print, and wire. What I cannot cover is the actual joint: two smart actuators, a clean cuff, and sensors with an e-stop.

[Dmitrii: add 4–6 lines only you can write — where you live, work/income, dependents if any, anything you have built before even if it broke. Solo Grants weigh that. Do not invent a city.]

---

## Project

**Name:** Elbow-1

**The problem, in one breath.** Full-body exoskeletons eat a workshop and a five-figure BOM. A first version that works is one elbow.

**What I'm making.** A single degree-of-freedom elbow assist. Two ROBOTIS Dynamixel MX-28AT actuators (position and PID in the box, 2.5 N·m stall at 12 V), 3D-printed cuffs on a short 2020 aluminum frame, a load cell in the load path, firmware on an Arduino that will not move without the e-stop armed. Open CAD, open firmware, a video of the bench test, then a video of it on an arm lifting a known weight through a known angle.

**Why it's compelling.** The grant ledger already has a dorm-room strength suit. This is the opposite: a copyable joint, not a costume. Open CAD, open firmware, a pass/fail bench (2 kg, 90°).

**Current progress.** CAD machine on the desk. BOM priced. Safety and constraint notes written. No Dynamixels purchased.

**What happens after the money lands.** See `method/BUILD.md`. Order both MX-28ATs day 0. Bench, then cuff, then publish.

---

## Budget

See `BOM.md`. Short form:

```
Actuators (MX-28AT ×2): $580
Controller + power: $80
Sensing + safety: $55
Structure + wear: $185
Shipping / spares: $100
Total ask: $1,000
```

---

## Essay (field 11 — paste this; 1000-word cap)

I'm Dmitrii Naumov. I build by myself. I have a Mac mini M4 on the desk and I can CAD, print, and wire. What I cannot cover is the actual joint: two smart actuators, a clean cuff, and sensors with an e-stop.

The wall is specific. A full-body exoskeleton is a fantasy at $1,000. One elbow that moves, measures torque, and stops when I hit the mushroom button is a first version that works.

I'm making Elbow-1. A single degree-of-freedom elbow assist. Two ROBOTIS Dynamixel MX-28AT actuators (position and PID in the box, 2.5 N·m stall at 12 V), 3D-printed cuffs on a short 2020 aluminum frame, a load cell in the load path, firmware on an Arduino that will not move without the e-stop armed. Open CAD, open firmware, a video of the bench test, then a video of it on an arm lifting a known weight through a known angle.

This is not a product and not a clinic device. It is the smallest wearable joint I can finish. Other people have built heroic full-body suits. I want the boring module: one joint, documented, so the next person can copy the elbow instead of starting from a blog post.

Already done, before any grant money: the machine for CAD, a written bill of materials with live prices, a constraint list (one joint, torque cap, e-stop, no medical claims), and a build order for the month after the parts land. I have not bought the Dynamixels. That is the wall.

After the money lands: order the two MX-28ATs and the shield the same day. Print cuffs while they ship. Bench-spin one actuator with the e-stop in the loop. Assemble the elbow. Log angle and load. Publish the repo the week it first holds a 2 kg mass through 90 degrees without the software fighting me. If it fails, the failure is in the repo too.

The next dollar unlocks the actuators. Without them I have drawings. With them I have a joint.
