<script setup>
import {resetState, store} from './js/state';

import FirmwareSelect from './pages/FirmwareSelect.vue';
import MainHardwareSelect from './pages/MainHardwareSelect.vue';
import VRXHardwareSelect from "./pages/BackpackHardwareSelect.vue";

import TransmitterOptions from './pages/TransmitterOptions.vue';
import ReceiverOptions from './pages/ReceiverOptions.vue';
import BackpackOptions from "./pages/BackpackOptions.vue";

import Download from "./pages/Download.vue";
import SerialFlash from "./pages/SerialFlash.vue";
import STLinkFlash from "./pages/STLinkFlash.vue";

import ReloadPrompt from './components/ReloadPrompt.vue';

function stepPrev() {
  if (store.currentStep === 1) {
    resetState()
  } else {
    store.currentStep--
  }
}

function disableNext() {
  if (store.currentStep === 1) {
    return !store.target ? "next" : false
  } else if (store.currentStep === 2) {
    return !store.options.flashMethod ? "next" : false
  } else if (store.currentStep === 3) {
    return "next"
  }
  return false
}

// Handle any query params
let urlParams = new URLSearchParams(window.location.search);
store.targetType = urlParams.get('type');
if (store.targetType === "tx" || store.targetType === "rx")
  store.firmware = 'firmware'
else if (store.targetType)
  store.firmware = 'backpack'

store.options.flashMethod = urlParams.get('method');

</script>

<template>
  <VApp class="td-app">
    <VLayout>
      <ReloadPrompt />
      <VAppBar height="220" class="td-app-bar" flat>
        <div class="td-app-bar__content">
          <div class="td-brand">
            <img class="td-logo" src="/assets/brand/TD%20Full%20Logo%20white.png" alt="Titan Dynamics" />
          </div>
          <div class="td-title">
            <div class="td-title__name">Titan Dynamics</div>
            <div class="td-title__sub">Web Flasher</div>
          </div>
          <div class="td-build">
            Git: @GITHASH@
          </div>
        </div>
      </VAppBar>
      <VMain class="td-main">
        <div class="section">
          <VFadeTransition mode="out-in" >
            <VContainer max-width="1280px" v-if="!store.targetType" style="display: grid; gap: 40px;">
              <FirmwareSelect/>
            </VContainer>
            <VContainer max-width="1024px" v-else>
              <div class="containerMain">

                <VStepper v-model="store.currentStep" :items="['Hardware', 'Options', 'Flashing']" hideActions>
                  <template v-slot:item.1>
                    <MainHardwareSelect v-if="store.firmware==='firmware'"/>
                    <VRXHardwareSelect vendor-label="Transmitter Module" v-if="store.targetType==='txbp'"/>
                    <VRXHardwareSelect vendor-label="VRx Type" v-if="store.targetType==='vrx'"/>
                    <VRXHardwareSelect vendor-label="Antenna Tracker Type" v-if="store.targetType==='aat'"/>
                    <VRXHardwareSelect vendor-label="Timer Type" v-if="store.targetType==='timer'"/>
                  </template>
                  <template v-slot:item.2>
                    <TransmitterOptions v-if="store.targetType==='tx'"/>
                    <ReceiverOptions v-else-if="store.targetType==='rx'"/>
                    <BackpackOptions v-else/>
                  </template>
                  <template v-slot:item.3>
                    <Download v-if="store.options.flashMethod==='download'"/>
                    <Download v-else-if="store.options.flashMethod==='wifi'"/>
                    <STLinkFlash v-else-if="store.options.flashMethod==='stlink'"/>
                    <SerialFlash v-else/>
                  </template>
                  <VStepperActions :disabled="disableNext()" @click:prev="stepPrev" @click:next="store.currentStep++"/>
                </VStepper>
              </div>
            </VContainer>
          </VFadeTransition>
        </div>
      </VMain>
    </VLayout>
  </VApp>
</template>

<style>
.td-app-bar {
  background: linear-gradient(120deg, rgba(26, 26, 26, 0.98), rgba(10, 10, 10, 0.92)) !important;
  border-bottom: 1px solid #1f1f1f;
}

.td-app-bar__content {
  display: grid;
  grid-template-columns: auto 1fr auto;
  gap: 24px;
  align-items: center;
  width: 100%;
  padding: 16px 48px;
}

.td-brand {
  display: flex;
  align-items: center;
}

.td-logo {
  max-height: 64px;
  width: auto;
}

.td-title {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.td-title__name {
  font-size: 28px;
  font-weight: 400;
  color: #ffffff;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.td-title__sub {
  font-size: 16px;
  font-weight: 600;
  color: #9ca3af;
  letter-spacing: 0.3em;
  text-transform: uppercase;
}

.td-build {
  font-size: 12px;
  color: #9ca3af;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  justify-self: end;
}

@media (max-width: 960px) {
  .td-app-bar__content {
    grid-template-columns: 1fr;
    justify-items: center;
    text-align: center;
    padding: 16px 24px;
  }

  .td-build {
    justify-self: center;
  }
}
</style>