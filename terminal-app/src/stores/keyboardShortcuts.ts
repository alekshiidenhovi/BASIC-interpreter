import { atom, computed } from 'nanostores'

const MODIFIER_KEYS = new Set(['ctrl', 'shift', 'alt'])

/**
  * A type for a function that is called when a shortcut is triggered.
  */
export type ShortcutHandler = (event: KeyboardEvent) => void

/**
 * A type for a shortcut scope.
 */
export type ShortcutScope = 'global' | 'editor' | 'repl' | 'modal' | "menu"

/**
 * A type for a normalized shortcut key.
 */
type NormalizedShortcutKey = string & { __normalized: true }

/**
 * A type for a shortcut binding.
 */
export interface RegisteredShortcutBinding {
  /** The unique identifier for the binding. */
  id: string
  /** The key in normalized string format. */
  key: NormalizedShortcutKey
  /** The handler function for the keyboard shortcut event. */
  handler: ShortcutHandler
  /** The scope where the shortcut should be active. */
  scope: ShortcutScope
  /** The description of what the shortcut does. */
  description: string
}

export type UnregisteredShortcutBinding = Omit<RegisteredShortcutBinding, 'id'>

/**
 * A store for keyboard shortcut bindings.
 */
export const $shortcutBindings = atom<Record<string, RegisteredShortcutBinding>>({})

/**
 * A store for currently active shortcut scope.
 */
export const $activeScope = atom<ShortcutScope>('global')

/**
 * A computed store for scoped shortcut bindings.
 */
export const $scopedShortcutBindings = computed(
  [$shortcutBindings, $activeScope],
  (bindings, scope) =>
    Object.values(bindings).filter(
      (b) => b.scope === scope || b.scope === 'global'
    )
)

/**
 * Normalizes a keyboard event into a normalized shortcut key.
 * @param e The keyboard event to normalize.
 * @returns The normalized shortcut key.
 */
function normalizeKeyboardEvent(e: KeyboardEvent): NormalizedShortcutKey {
  const parts: string[] = []
  if (e.ctrlKey || e.metaKey) parts.push('ctrl')

  const key = e.key.toLowerCase()
  if (!MODIFIER_KEYS.has(key)) {
    parts.push(key)
  }

  return parts.join('+') as NormalizedShortcutKey
}

export function normalizeKey({
  key,
  hasCtrlOrMetaKey,
}: {
  key: string
  hasCtrlOrMetaKey: boolean
}): NormalizedShortcutKey {
  const parts: string[] = []
  if (hasCtrlOrMetaKey) parts.push('ctrl')
  parts.push(key.toLowerCase())
  return parts.join('+') as NormalizedShortcutKey;
}

/**
  * Groups the shortcuts by scope.
  * @param bindings The shortcuts to group.
  * @returns The grouped shortcuts.
  */
export function groupShortcutsByScope(bindings: readonly RegisteredShortcutBinding[]): Partial<Record<ShortcutScope, RegisteredShortcutBinding[]>> {
  const grouped: Partial<Record<ShortcutScope, RegisteredShortcutBinding[]>> = {};
  bindings.forEach((binding) => {
    const scope = binding.scope;
    if (!grouped[scope]) {
      grouped[scope] = [];
    }
    grouped[scope].push(binding);
  });
  return grouped;
}


/**
 * Registers a shortcut binding.
 * @param binding The shortcut binding to register.
 * @returns The ID of the registered binding.
 */
export function registerKeyboardShortcut(binding: Omit<RegisteredShortcutBinding, 'id'> & { id?: string }): string {
  const id = binding.id ?? `${binding.scope}:${binding.key}`
  $shortcutBindings.set({
    ...$shortcutBindings.get(),
    [id]: { ...binding, id }
  })
  return id
}

/**
 * Unregisters a shortcut binding.
 * @param id The ID of the binding to unregister.
 */
export function unregisterKeyboardShortcut(id: string): void {
  const current = { ...$shortcutBindings.get() }
  delete current[id]
  $shortcutBindings.set(current)
}

/**
 * Sets the active shortcut scope.
 * @param scope The shortcut scope to set.
 */
export function setScope(scope: ShortcutScope): void {
  $activeScope.set(scope)
}

let initialized = false

/**
 * Initializes the shortcut bindings.
 */
export function initKeyboardShortcuts(): void {
  if (initialized || typeof window === 'undefined') return
  initialized = true

  window.addEventListener('keydown', (e: KeyboardEvent) => {
    const pressed = normalizeKeyboardEvent(e)
    const match = $scopedShortcutBindings.get().find(b => b.key === pressed)

    if (match) {
      e.preventDefault()
      match.handler(e)
    }
  })
}
