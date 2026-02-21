<script setup lang="ts">
import { ref, nextTick } from "vue";
import type { Statement } from "@/types";
import CodeEditorView from "./CodeEditorView.vue";
import CodeEditorRepl from "./CodeEditorRepl.vue";

type Mode = 'editor' | 'repl';

const selectedMode = ref<Mode>('editor');
const replInput = ref<string>("");
const replOutputs = ref<Statement[]>([]);

const switchToRepl = () => {
  selectedMode.value = 'repl';
  nextTick(() => {
    focusReplInput();
  });
}
const switchToEditor = () => {
  selectedMode.value = 'editor';
}
const toggleViewMode = (event: KeyboardEvent) => {
  event.preventDefault();
  if (selectedMode.value === 'editor') {
    switchToRepl();
  } else {
    switchToEditor();
  }
}

const executeReplCommand = () => {
  const codeInput = replInput.value;
  console.log("codeInput", codeInput);
  const inputId = window.crypto.randomUUID();

  if (!window.interpretReplLine) {
    throw new Error("Interpreter not loaded");
  }

  const result = window.interpretReplLine(codeInput);
  if (result.ok === false) {
    console.error(result.error);
  }

  replOutputs.value.push({
    id: inputId,
    code: codeInput,
    printOutput: result,
  });
  replInput.value = "";
}

const focusReplInput = () => {
  const replInputContainer = document.querySelector(".repl-input") as HTMLInputElement;
  replInputContainer.focus();
}

const resetReplContext = () => {
  if (!window.resetReplContext) {
    throw new Error("Interpreter not loaded");
  }
  window.resetReplContext();
  replOutputs.value = [];
  replInput.value = "";

  focusReplInput();
}

const handleReplInput = (event: InputEvent) => {
  replInput.value = (event.target as HTMLInputElement).value;
}


interface Props {
  starterCode: string[] | undefined
}

const props = defineProps<Props>();
</script>

<template>
  <div class="editor-container" :class="{
    'editor-container-view-layout': selectedMode === 'editor', 'editor-container-repl-layout': selectedMode
      === 'repl'
  }">
    <div class="editor-mode-container">
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'editor' }"
        @click="switchToEditor()">Editor</button>
      <button class="editor-mode-button" :class="{ 'selected-mode': selectedMode === 'repl' }"
        @click="switchToRepl()">REPL</button>
    </div>
    <CodeEditorView v-if="selectedMode === 'editor'" :starterCode="props.starterCode" />
    <CodeEditorRepl v-if="selectedMode === 'repl'" :replOutputs="replOutputs" :replInput="replInput"
      :executeReplCommand="executeReplCommand" :resetReplContext="resetReplContext"
      :handleReplInput="handleReplInput" />
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
