<script setup lang="ts">
import MenuButton from "@components/ButtonMenu/MenuButton.vue"
import MenuButtonList from "@components/ButtonMenu/MenuButtonList.vue"

interface Props {
  path: string;
}

const props = defineProps<Props>();
</script>

<template>
  <MenuButtonList :initialIndex="0" :path="props.path">
    <MenuButton :index="0" label="Tutorial" href="/tutorial" textCenter />
    <MenuButton :index="1" label="Github" href="https://github.com/alekshiidenhovi/BASIC-interpreter" textCenter
      openInNewTab />
  </MenuButtonList>
</template>
