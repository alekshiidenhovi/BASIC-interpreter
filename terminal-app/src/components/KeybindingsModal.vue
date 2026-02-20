<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";

type Keybinding = {
  key: string;
  description: string;
}

type KeybindingGroup = {
  groupContext: string;
  bindings: Keybinding[];
}

const keybindings: KeybindingGroup[] = [
  {
    groupContext: "Keybindings",
    bindings: [
      {
        key: "?",
        description: "Toggle keybindings modal",
      },
      {
        key: "Esc",
        description: "Close keybindings modal",
      }
    ],
  },
  {
    groupContext: "Menu",
    bindings: [
      {
        key: "Enter",
        description: "Click menu item",
      },
      {
        key: "Esc",
        description: "Navigate back",
      },
      {
        key: "Arrow Up",
        description: "Move up",
      },
      {
        key: "Arrow Down",
        description: "Move down",
      },
    ],
  },
  {
    groupContext: "Editor",
    bindings: [
      {
        key: "Ctrl + Tab",
        description: "Switch to REPL",
      },
      {
        key: "Ctrl + Enter",
        description: "Run program",
      },
      {
        key: "Ctrl + R",
        description: "Reset to starter code",
      },
    ],
  },
  {
    groupContext: "REPL",
    bindings: [
      {
        key: "Enter",
        description: "Execute line",
      },
      {
        key: "Ctrl + R",
        description: "Reset REPL",
      },
    ],
  }
]

const showModal = ref(false);
const toggleModal = () => {
  showModal.value = !showModal.value;
}
const closeModal = () => {
  showModal.value = false;
}
const handleKeydown = (event: KeyboardEvent) => {
  if (event.key === "?") {
    toggleModal();
  }
  if (event.key === "Escape" && showModal.value) {
    closeModal();
  }
}

onMounted(() => {
  document.addEventListener("keydown", handleKeydown);
})
onUnmounted(() => {
  document.removeEventListener("keydown", handleKeydown);
})
</script>

<template>
  <button @click="toggleModal">
    <span class="key-symbol">[?]</span>
    <span>Keybindings</span>
  </button>

  <Teleport to="body">
    <div class="modal-overlay" v-if="showModal" @click.self="closeModal">
      <div class="modal-container">
        <div class="keybindings-group" v-for="group in keybindings" :key="group.groupContext">
          <h2>{{ group.groupContext }}</h2>
          <div class="keybindings-list">
            <div class="keybinding-list-item" v-for="keybinding in group.bindings" :key="keybinding.key">
              <span class="keybinding-list-item-symbol">{{ keybinding.key }}</span>
              <span>{{ keybinding.description }}</span>
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
