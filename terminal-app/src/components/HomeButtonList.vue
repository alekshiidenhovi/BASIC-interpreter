<script setup lang="ts">
import MenuButton from "@components/ButtonMenu/MenuButton.vue"
import MenuButtonList from "@components/ButtonMenu/MenuButtonList.vue"
</script>

<template>
  <MenuButtonList :initialIndex="0">
    <MenuButton :index="0" label="Tutorial" href="/tutorial" textCenter />
    <MenuButton :index="1" label="Github" href="https://github.com/alekshiidenhovi/BASIC-interpreter" textCenter
      openInNewTab />
  </MenuButtonList>
</template>
