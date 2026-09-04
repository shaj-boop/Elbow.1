// Elbow-1 firmware v0.1 — Arduino Uno + Dynamixel Shield
// Will not enable torque unless the e-stop is armed.
//
// Serial 115200. Commands:
//   ARM          — torque on if e-stop is high
//   DISARM       — torque off
//   MOVE <deg>   — 0..90, both actuators, torque-capped
//   CYCLE        — three 0→90→0 sweeps (Week 2 protocol)
//   LOG ON|OFF   — CSV: t_ms,angle_deg,load_n,flex,ext,estop
//
// If it fails, the failure is in the log too.

#include <Dynamixel2Arduino.h>
#include "HX711.h"
#include "config.h"

Dynamixel2Arduino dxl(DXL_SERIAL, DXL_DIR_PIN);
HX711 scale;

bool armed = false;
bool logging = false;
uint32_t t0 = 0;
float goalDeg = 0;

uint16_t degToTick(float deg) {
  if (deg < 0) deg = 0;
  if (deg > 90) deg = 90;
  return (uint16_t)(POS_ZERO + deg * (TICKS_PER_REV / 360.0f));
}

bool estopArmed() {
  return digitalRead(ESTOP_PIN) == HIGH;
}

void torqueOff() {
  dxl.torqueOff(ID_FLEX);
  dxl.torqueOff(ID_EXT);
  armed = false;
  digitalWrite(LED_ARMED, LOW);
}

bool torqueOn() {
  if (!estopArmed()) {
    torqueOff();
    Serial.println(F("# ESTOP open — not arming"));
    return false;
  }
  dxl.writeControlTableItem(TORQUE_LIMIT, ID_FLEX, TORQUE_LIMIT);
  dxl.writeControlTableItem(TORQUE_LIMIT, ID_EXT,  TORQUE_LIMIT);
  dxl.torqueOn(ID_FLEX);
  dxl.torqueOn(ID_EXT);
  armed = true;
  digitalWrite(LED_ARMED, HIGH);
  Serial.println(F("# armed"));
  return true;
}

void goDeg(float deg) {
  if (!armed) return;
  goalDeg = deg;
  uint16_t t = degToTick(deg);
  dxl.setGoalPosition(ID_FLEX, t);
  dxl.setGoalPosition(ID_EXT,  TICKS_PER_REV - t); // antagonist
}

float readLoadN() {
  if (!scale.is_ready()) return 0;
  return scale.get_units(1) * 9.80665f / 1000.0f; // gram-ish cal → N
}

void setup() {
  pinMode(ESTOP_PIN, INPUT_PULLUP);
  pinMode(LED_ARMED, OUTPUT);
  digitalWrite(LED_ARMED, LOW);

  Serial.begin(115200);
  dxl.begin(DXL_BAUD);
  dxl.setPortProtocolVersion(DXL_PROTOCOL);

  scale.begin(HX711_DOUT, HX711_SCK);
  scale.set_scale(1.0f / SCALE_N_PER_COUNT);
  scale.tare();

  torqueOff();
  Serial.println(F("# Elbow-1 v0.1  e-stop must be armed"));
  Serial.println(F("t_ms,angle_deg,load_n,flex,ext,estop"));
  t0 = millis();
}

void loop() {
  if (!estopArmed() && armed) {
    torqueOff();
    Serial.println(F("# ESTOP — torque off"));
  }

  float load = readLoadN();
  if (armed && fabs(load) > SPIKE_N) {
    torqueOff();
    Serial.print(F("# spike N="));
    Serial.println(load);
  }

  if (logging && (millis() % LOG_MS) < 2) {
    Serial.print(millis() - t0); Serial.print(',');
    Serial.print(goalDeg); Serial.print(',');
    Serial.print(load, 3); Serial.print(',');
    Serial.print(dxl.getPresentPosition(ID_FLEX)); Serial.print(',');
    Serial.print(dxl.getPresentPosition(ID_EXT)); Serial.print(',');
    Serial.println(estopArmed() ? 1 : 0);
  }

  if (Serial.available()) handleLine();
}

void handleLine() {
  String line = Serial.readStringUntil('\n');
  line.trim();
  if (line.equalsIgnoreCase("ARM")) { torqueOn(); return; }
  if (line.equalsIgnoreCase("DISARM")) { torqueOff(); return; }
  if (line.startsWith("MOVE")) {
    goDeg(line.substring(4).toFloat());
    return;
  }
  if (line.equalsIgnoreCase("CYCLE")) {
    if (!torqueOn()) return;
    logging = true;
    for (uint8_t c = 0; c < 3; c++) {
      goDeg(90); delay(2500);
      goDeg(0);  delay(2500);
    }
    torqueOff();
    Serial.println(F("# cycle done"));
    return;
  }
  if (line.equalsIgnoreCase("LOG ON"))  { logging = true;  t0 = millis(); }
  if (line.equalsIgnoreCase("LOG OFF")) { logging = false; }
}
