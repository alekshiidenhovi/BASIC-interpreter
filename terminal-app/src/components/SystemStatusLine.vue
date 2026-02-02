<script setup lang="ts">
import { ref, onMounted } from "vue";
import { Icon } from "@iconify/vue";
import { assertNever } from "@/utils";

interface SystemBatteryStatus {
  level: number;
  isCharging: boolean;
}

type SystemNetworkStatus = {
  onlineStatus: "online" | "offline";
}

const hasMounted = ref(false);
const systemBatteryStatus = ref<SystemBatteryStatus | null>(null);
const systemNetworkStatus = ref<SystemNetworkStatus | null>(null);

const updateBatteryStatus = (battery: BatteryManager) => {
  systemBatteryStatus.value = {
    level: battery.level * 100,
    isCharging: battery.charging,
  }
}

const turnOnlineStatus = () => {
  systemNetworkStatus.value = {
    onlineStatus: "online",
  }
}

const turnOfflineStatus = () => {
  systemNetworkStatus.value = {
    onlineStatus: "offline",
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

const selectNetworkIcon = (systemNetworkStatus: SystemNetworkStatus | null) => {
  if (systemNetworkStatus === null) {
    return "lucide:wifi-off";
  }

  if (systemNetworkStatus.onlineStatus === "offline") {
    return "lucide:wifi-off";
  }

  if (systemNetworkStatus.onlineStatus === "online") {
    return "lucide:wifi";
  }

  assertNever(systemNetworkStatus.onlineStatus);
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

  if (navigator.onLine) {
    turnOnlineStatus();
  } else {
    turnOfflineStatus();
  }

  window.addEventListener("online", () => {
    turnOnlineStatus();
  })

  window.addEventListener("offline", () => {
    turnOfflineStatus();
  })

  hasMounted.value = true;
})

</script>

<template>
  <div v-if="hasMounted" class="system-status-line">
    <div class="status-container">
      <Icon :icon="selectBatteryIcon(systemBatteryStatus)" class="icon" />
      <span v-if="systemBatteryStatus">{{ systemBatteryStatus.level }}%</span>
      <span v-else>BATTERY API UNAVAILABLE</span>
    </div>
    <div class="status-container">
      <Icon :icon="selectNetworkIcon(systemNetworkStatus)" class="icon" />
      <span v-if="!systemNetworkStatus">CONNECTION API UNAVAILABLE</span>
      <span v-else-if="systemNetworkStatus.onlineStatus === 'online'">ONLINE</span>
      <span v-else>OFFLINE</span>
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
