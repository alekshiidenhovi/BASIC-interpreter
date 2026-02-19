<script setup lang="ts">
import MenuButton from "@components/ButtonMenu/MenuButton.vue"
import MenuButtonList from "@components/ButtonMenu/MenuButtonList.vue"

interface Tutorial {
  data: {
    index: number;
    title: string;
  }
}

interface Props {
  tutorials: Tutorial[];
}
const { tutorials } = defineProps<Props>();
</script>

<template>
  <MenuButtonList :initialIndex="0">
    <MenuButton v-for="tutorial in tutorials" :index="tutorial.data.index - 1" :label="`${tutorial.data.index}.
      ${tutorial.data.title}`" :href="`/tutorial/${tutorial.data.index}`" />
  </MenuButtonList>
</template>
