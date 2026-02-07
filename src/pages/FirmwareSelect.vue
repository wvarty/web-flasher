<script setup>
import {store} from '../js/state';
import HoverCard from '../components/HoverCard.vue';

const emit = defineEmits(['onClick']);

// Set firmware and targetType in state store, then update page to pages selection page
function setFirmware(firmware, targetType) {
  store.firmware = firmware;
  store.targetType = targetType;
  emit('onClick');
}
</script>

<template>
  <div class="containerMain">
    <div class="containerHeader">
      <VCardTitle>Main Firmware</VCardTitle>
    </div>
    <VRow>
      <VCol md="6">
        <HoverCard min-height="100%" @click="setFirmware('firmware', 'tx')"
              image="/assets/brand/Controller%20Icon.png" hover-image="/assets/brand/Controller%20Icon.png"
                    title="Transmitter"
                    text="Install or update the main TitanLRS firmware on any compatible Transmitter module.
                    Internal and external modules supported."/>
      </VCol>
      <VCol md="6">
        <HoverCard min-height="100%" @click="setFirmware('firmware', 'rx')"
              image="/assets/brand/Radio%20Icon.png" hover-image="/assets/brand/Radio%20Icon.png"
                    title="Receiver"
                    text="Install or update the main TitanLRS firmware on any compatible Receiver. Serial and PWM
                    Receivers supported."/>
      </VCol>
    </VRow>
  </div>
  <div class="containerMain">
    <div class="containerHeader">
      <VCardTitle>Backpack Firmware</VCardTitle>
    </div>
    <VRow>
      <VCol md="6">
        <HoverCard min-height="100%" @click="setFirmware('backpack', 'txbp')"
                    image="/assets/brand/Module%20Icon.png" hover-image="/assets/brand/Module%20Icon.png"
                    title="Transmitter Backpack"
                    text="Install or update the firmware on the secondary Backpack module inside the Transmitter."/>
      </VCol>
      <VCol md="6">
        <HoverCard min-height="100%" @click="setFirmware('backpack', 'vrx')"
                    image="/assets/brand/Video%20Receiver%20Combined%20Icon.png" hover-image="/assets/brand/Video%20Receiver%20Combined%20Icon.png"
                    title="Backpack Receiver"
                    text="Install or update the firmware on a Backpack receiver. For example: A VRX Backpack RX."/>
      </VCol>
    </VRow>
  </div>
  <!--
  <VRow>
    <VCol md="3">
      <HoverCard min-height="100%" @click="setFirmware('backpack', 'aat')"
                  image="satellite_2637312.png" hover-image="satellite_2637314.png"
                  title="Antenna Tracker"
                  text="Flying long-range and need your antenna pointed in just the right direction? This is the backpack
                  for you!"/>
    </VCol>
    <VCol md="3">
      <HoverCard min-height="100%" @click="setFirmware('backpack', 'timer')"
                  image="stopwatch_4354897.png" hover-image="stopwatch_4355918.png"
                  title="Race Timer"
                  text="Connects to the RotorHazard race timing system and sends OSD message with lap times and current
                  place during the race so you always know where you're placed."/>
    </VCol>
  </VRow>
  -->
</template>

<style scoped>
.v-card-title {
  padding: 0;
  font-size: 24px;
  font-weight: 600;
  color: #ffffff;
  letter-spacing: 0.02em;
}

.v-card-subtitle {
  padding: 0;
  font-size: 16px;
  font-weight: 600;
  color: #9ca3af;
}
</style>