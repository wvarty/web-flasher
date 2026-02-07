<script setup>
import {VCard, VCardText, VCardTitle, VHover} from 'vuetify/components'
import {ref} from "vue";

defineProps(['image', 'hoverImage', 'title', 'text'])

let hovered = ref(false)
function imageClass(isHovering) {
  if (isHovering) {
    hovered = true
  }
  return isHovering ? 'fadeInImage' : 'fadeOutImage'
}
</script>

<template>
  <VHover v-slot:default="{ isHovering, props }">
    <VCard v-bind="$attrs, props" class='default-card' :class="{'hover-card' : isHovering}">
      <div class="parent">
        <img :src="image" height="100px" width="100px"/>
        <img :src="hoverImage" height="100px" width="100px" :class="imageClass(isHovering)" :style="hovered ? 'display:block' : 'display:none'"/>
      </div>
      <VCardTitle>{{ title }}</VCardTitle>
      <VCardText>{{ text }}
      </VCardText>
    </VCard>
  </VHover>
</template>

<style scoped>
@keyframes fadeOut {
  0% {
    opacity: 1;
  }
  100% {
    opacity: 0;
  }
}

.fadeOutImage {
  animation: fadeOut 600ms forwards;
  position: absolute;
}

@keyframes fadeIn {
  0% {
    opacity: 0;
  }
  100% {
    opacity: 1;
  }
}

.fadeInImage {
  animation: fadeIn 600ms forwards;
  position: absolute;
}

.default-card {
  border-radius: 14px;
  border: 1px solid #1f1f1f;
  background: linear-gradient(180deg, rgba(42, 42, 42, 0.85), rgba(26, 26, 26, 0.95));
  transition: transform 280ms ease, box-shadow 280ms ease, border-color 280ms ease;
  box-shadow: none;
  text-align: left;
  padding: 0;
}

.hover-card {
  transform: translateY(-6px);
  border-color: #fa8423;
  box-shadow: 0 18px 34px rgba(0, 0, 0, 0.45);
}

.v-card-title {
  padding: 0 20px 0 20px;
  margin: 18px 0 6px 0;
  font-weight: 600;
  font-size: 16px;
  color: #ffffff;
}

.v-card-text {
  padding: 0 20px 20px 20px;
  font-size: 13px;
  color: #9ca3af;
}

.parent {
  display: flex;
  justify-content: center;
  background: radial-gradient(120px 80px at 50% 40%, rgba(250, 132, 35, 0.22), rgba(26, 26, 26, 0));
  border-bottom: 1px solid #1f1f1f;
  height: 140px;
  align-items: center;
}

</style>