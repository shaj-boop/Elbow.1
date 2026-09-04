#pragma once
// Elbow-1 — pin map and hard limits.
// MX-28AT stall is 2.5 N·m at 12 V. Command cap sits well under that.

#include <stdint.h>

static const uint8_t ID_FLEX = 1;
static const uint8_t ID_EXT  = 2;

// Dynamixel Shield on Uno: UART via the onboard buffer.
#define DXL_SERIAL   Serial
#define DXL_DIR_PIN  2
static const float DXL_PROTOCOL = 1.0f;
static const uint32_t DXL_BAUD  = 1000000;

// MX-28: 12-bit, 4096 ticks / rev.
static const uint16_t TICKS_PER_REV = 4096;
static const uint16_t POS_ZERO      = 2048;          // 0°
static const uint16_t POS_FLEX90    = 2048 + 1024;   // 90°

// Torque cap: 1.2 N·m ≈ 48% of stall. Register units 0–1023.
static const uint16_t TORQUE_LIMIT = 490;

// Latching mushroom. Hardware cuts enable; this pin only senses it.
// HIGH = armed. LOW = pressed / open loop / crash-safe disable.
static const uint8_t ESTOP_PIN = 4;

// HX711 on the 20 kg bar in the load path.
static const uint8_t HX711_DOUT = A1;
static const uint8_t HX711_SCK  = A0;
static const float   SCALE_N_PER_COUNT = 0.0024f; // calibrate on the 2 kg mass
static const float   SPIKE_N = 40.0f;             // unexpected load → disable

static const uint8_t LED_ARMED = 13;
static const uint16_t LOG_MS   = 20;              // 50 Hz CSV
