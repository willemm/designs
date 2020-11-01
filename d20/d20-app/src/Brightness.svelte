<script>
  import Slider from './Slider.svelte'
  export let values = []
  let linksets = [
    [[0,1,2,3,4,5]],
    [[0,1,2],[3,4,5]],
    [[0,1],[2,3],[4,5]],
    [[0],[1],[2],[3],[4],[5]]
  ]
  let links = 2
  let curvalues = []
  $: for (let i = 0; i < values.length; i++) {
    let val = values[i]
    if (curvalues[i] != val) {
      let block = linksets[links].find(el => el.indexOf(i) >= 0)
      for (let j = 0; j < block.length; j++) {
        values[block[j]] = val
        curvalues[block[j]] = val
      }
    }
  }
</script>

<div class="sliders" style="--columns:{values.length}">
{#each values as value}
<Slider bind:value={value}/>
{/each}
</div>

<style>
div.sliders {
  margin: 20px;
  width: 300px;
}
</style>
