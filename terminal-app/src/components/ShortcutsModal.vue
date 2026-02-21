<script setup lang="ts">
import { ref, watch, computed } from "vue";
import { useKeyboardShortcut, useShortcutRegistry } from "@/composables/useKeyboardShortcuts";
import { setScope, groupShortcutsByScope, initKeyboardShortcuts, type NormalizedShortcutKey, type ShortcutScope } from "@/stores/keyboardShortcuts";

initKeyboardShortcuts();

const previousScope = ref<ShortcutScope>('global');
const showModal = ref(false);
const toggleModal = () => (showModal.value = !showModal.value);
const closeModal = () => (showModal.value = false);

const registry = useShortcutRegistry();
const groupedShortcuts = computed(() =>
  groupShortcutsByScope(
    Object.values(registry.bindings.value).sort((a, b) => a.key.localeCompare(b.key))
  )
);

watch(showModal, (open) => {
  if (open) {
    previousScope.value = registry.activeScope.value;
    setScope("modal");
  } else {
    setScope(previousScope.value);
  }
});

useKeyboardShortcut({
  key: "?" as NormalizedShortcutKey,
  handler: toggleModal,
  scope: "global",
  description: "Toggle keybindings modal",
  useRawKey: true,
});

useKeyboardShortcut({
  key: "escape" as NormalizedShortcutKey,
  scope: "modal",
  handler: closeModal,
  description: "Close keybindings modal",
});

defineOptions({ inheritAttrs: false });
</script>

<template>
  <button v-bind="$attrs" @click="toggleModal">
    <span class="key-symbol">[?]</span>
    <span>Keybindings</span>
  </button>

  <Teleport to="body">
    <div class="modal-overlay" v-if="showModal" @click.self="closeModal">
      <div class="modal-container">
        <div class="keybindings-group" v-for="(shortcuts, scope) in groupedShortcuts" :key="scope">
          <h2>{{ scope }}</h2>
          <div class="keybindings-list">
            <div class="keybinding-list-item" v-for="shortcut in shortcuts" :key="shortcut.key">
              <kbd class="keybinding-list-item-symbol">{{ shortcut.key }}</kbd>
              <span>{{ shortcut.description }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<style scoped>
button {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  background-color: transparent;
  outline: none;
  border: none;
  color: inherit;
  font-size: inherit;
  text-transform: uppercase;
  letter-spacing: inherit;
}

.key-symbol {
  letter-spacing: 0.25rem;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  width: 100dvw;
  height: 100dvh;
  background: color-mix(in srgb, var(--slate-900) 50%, transparent);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 9999;
  text-transform: uppercase;
}

.modal-container {
  display: flex;
  flex-direction: column;
  gap: 2.5rem;
  background-color: var(--slate-900);
  padding: 2rem;
  border: 2px solid var(--sky-400);
  max-width: 40rem;
  width: 100%;
  color: var(--sky-500);
}

.keybindings-group {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

h2 {
  font-size: 1.375rem;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--sky-400);
  font-weight: 400;
}

.keybindings-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.keybinding-list-item {
  display: grid;
  grid-template-columns: 12rem 1fr;
  gap: 1rem;
  color: var(--sky-500);
  font-size: 0.875rem;
}

.keybinding-list-item-symbol {
  font-weight: 500;
}
</style>
