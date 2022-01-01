<script>
  import { tick } from 'svelte'
  import Slider from './Slider.svelte'
  export let colors = []
  export let selected = 0
</script>

<div class="sliders" style="--columns:{colors.length}">
{#each colors as color, idx}
<Slider bind:value={color.val} on:focus={() => { selected = idx }}/>
{/each}
</div>

<style>
div.sliders {
  margin: 20px;
  width: 300px;
}
</style>
