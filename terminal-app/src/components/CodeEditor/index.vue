<script setup lang="ts">
import { ref } from "vue";
import CodeEditorView from "./CodeEditorView.vue";
import CodeEditorRepl from "./CodeEditorRepl.vue";
import type { Statement } from "@/types";

type Mode = 'editor' | 'repl';

const selectedMode = ref<Mode>('editor');

interface Props {
  initialCode: Statement[]
}

const props = defineProps<Props>();
</script>

<template>
  <div class="editor-container"
    :class="{ 'editor-container-view-layout': selectedMode === 'editor', 'editor-container-repl-layout': selectedMode === 'repl' }">
    <div class="editor-mode-container">
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'editor' }"
        @click="selectedMode = 'editor'">Editor</button>
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'repl' }"
        @click="selectedMode = 'repl'">REPL</button>
    </div>
    <CodeEditorView v-if="selectedMode === 'editor'" :initialCode="props.initialCode" />
    <CodeEditorRepl v-if="selectedMode === 'repl'" />
  </div>
</template>

<style scoped>
button:focus,
button:focus-visible {
  outline: none;
}

.editor-container {
  display: grid;
  grid-template-rows: auto minmax(0, 1fr) auto minmax(0, 1fr);
  border: 2px solid var(--sky-900);
  height: 100%;
  min-height: 0;
}

.editor-container-view-layout {
  grid-template-rows: auto minmax(0, 1fr) auto minmax(0, 1fr);
}

.editor-container-repl-layout {
  grid-template-rows: auto minmax(0, 1fr) auto;
}

.editor-container>*+* {
  border-top: 2px solid var(--sky-900);
}

.editor-mode-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
}

.editor-mode-container>*+* {
  border-left: 2px solid var(--sky-900);
}

.editor-mode-button {
  background-color: transparent;
  color: var(--sky-700);
  padding: 1.5rem;
  font-size: 1.5rem;
  cursor: pointer;
  text-transform: uppercase;
  border: none;
  letter-spacing: 3px;
}

.editor-mode-button:nth-child(1) {
  border-right: 2px solid var(--sky-900);
}

.selected-mode {
  color: var(--sky-500);
  font-weight: 700;
}
</style>
