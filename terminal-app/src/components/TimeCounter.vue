<script setup lang="ts">
import { ref, onMounted } from "vue";

const addLeadingZero = (num: number): string => {
  return num < 10 ? `0${num}` : num.toString();
}

interface Time {
  date: string;
  time: string;
}

const time = ref<Time | null>(null);

const iterateTime = () => {
  const today = new Date();

  const year = today.getFullYear();
  const month = today.toLocaleString("default", { month: "short" });
  const day = addLeadingZero(today.getDate());

  const hours = addLeadingZero(today.getHours());
  const minutes = addLeadingZero(today.getMinutes());
  const seconds = addLeadingZero(today.getSeconds());

  time.value = {
    date: `${month} ${day}, ${year}`,
    time: `${hours}:${minutes}:${seconds}`,
  }

  setTimeout(iterateTime, 1000);
}

onMounted(() => {
  iterateTime();
})

</script>

<template>
  <div>
    <span>{{ time?.date }}</span>
    <span>{{ time?.time }}</span>
  </div>
</template>

<style scoped>
div {
  display: flex;
  gap: 1.5rem;
}
</style>
