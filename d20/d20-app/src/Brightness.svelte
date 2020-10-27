<script>
  import Slider from './Slider.svelte'
  export let values = []
</script>

<div class="sliders" style="--columns:{values.length}">
{#each values as value}
<Slider bind:value={value}/>
{/each}
</div>

<style>
div.sliders {
  margin: 40px;
  display: grid;
  grid-template-columns: repeat(var(--columns), auto);
  width: 300px;
}
</style>
