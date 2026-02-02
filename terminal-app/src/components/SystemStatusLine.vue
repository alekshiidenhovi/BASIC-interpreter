<script setup lang="ts">
import { ref, onMounted } from "vue";
import { Icon } from "@iconify/vue";

interface SystemBatteryStatus {
  level: number;
  isCharging: boolean;
}

const systemBatteryStatus = ref<SystemBatteryStatus | null>(null);

const updateBatteryStatus = (battery: BatteryManager) => {
  systemBatteryStatus.value = {
    level: battery.level * 100,
    isCharging: battery.charging,
  }
}

const selectBatteryIcon = (systemBatteryStatus: SystemBatteryStatus | null) => {
  if (systemBatteryStatus === null) {
    return "lucide:battery-warning";
  }
  if (systemBatteryStatus.isCharging) {
    return "lucide:battery-charging";
  } else {
    if (systemBatteryStatus.level < 20) {
      return "lucide:battery-low";
    } else if (systemBatteryStatus.level < 60) {
      return "lucide:battery-medium";
    } else {
      return "lucide:battery-full";
    }
  }
}

onMounted(async () => {
  if ("getBattery" in navigator) {
    const battery = await navigator.getBattery();
    updateBatteryStatus(battery);

    battery.addEventListener("chargingchange", () => {
      updateBatteryStatus(battery);
    });

    battery.addEventListener("levelchange", () => {
      updateBatteryStatus(battery);
    });
  }
})

</script>

<template>
  <div class="system-status-line">
    <div class="status-container">
      <Icon :icon="selectBatteryIcon(systemBatteryStatus)" class="icon" />
      <span v-if="systemBatteryStatus">{{ systemBatteryStatus.level }}%</span>
      <span v-else>BATTERY API UNAVAILABLE</span>
    </div>
  </div>
</template>

<style scoped>
.system-status-line {
  display: flex;
  gap: 1.5rem;
  align-items: center;
}

.status-container {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.icon {
  width: 1.25rem;
  height: 1.25rem;
}
</style>
