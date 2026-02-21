import { onMounted, onUnmounted, readonly, ref } from 'vue'
import { useStore } from '@nanostores/vue'
import {
  $activeScope,
  $shortcutBindings,
  $scopedShortcutBindings,
  registerKeyboardShortcut,
  setScope,
  unregisterKeyboardShortcut,
  type ShortcutScope,
  type ShortcutBinding,
} from '@/stores/keyboardShortcuts'

export function useShortcutRegistry() {
  const bindings = useStore($shortcutBindings)
  const activeScope = useStore($activeScope)
  const scopedBindings = useStore($scopedShortcutBindings)

  return {
    bindings: readonly(bindings),
    activeScope: readonly(activeScope),
    scopedBindings: readonly(scopedBindings),
    setScope,
  }
}

export function useKeyboardShortcut(args: Omit<ShortcutBinding, 'id'>) {
  let id: string | null = null
  onMounted(() => {
    id = registerKeyboardShortcut(args)
  })
  onUnmounted(() => {
    if (id) unregisterKeyboardShortcut(id)
  })
}

export function useScope(scope: ShortcutScope) {
  const previous = ref<ShortcutScope>('global')
  onMounted(() => {
    previous.value = $activeScope.get()
    setScope(scope)
  })
  onUnmounted(() => {
    setScope(previous.value)
  })
}
