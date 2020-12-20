<script>
  import Slider from './Slider.svelte'
  import Color from './Color.svelte'
  import Sendcolor from './Sendcolor.svelte'
  let colors = [
    { hue: 0, sat: 0, val: 0 },
    { hue: 0, sat: 0, val: 0 }
  ]
  let selected = 0

  function hsv2rgb(H,S,V)
  {
    const C = V * S
    const X1 = C * Math.min(1,(  (H/60) % 2))
    const X2 = C * Math.min(1,(2-(H/60) % 2))
    const m = V - C
    const io = (H/120) >>> 0
    let rgb = [0,0,0]
    rgb[((io+0) % 3)] = ((X2+m)*255)>>>0
    rgb[((io+1) % 3)] = ((X1+m)*255)>>>0
    rgb[((io+2) % 3)] = (m*255)>>>0
    return 'rgb('+rgb.join(',')+')'
  }
</script>

<Sendcolor bind:colors={colors} />
{#each colors as color}
<Color bind:color={color} />
<div class="slider">
<Slider bind:value={color.val} />
</div>
<div class="color" style="border-color: {hsv2rgb(color.hue, color.sat/256, color.val/255)}">
  Hue: {color.hue}, Saturation: {color.sat}, Value: {color.val},Color: {hsv2rgb(color.hue, color.sat/256, color.val/255)}
</div>
{/each}

<style>
div.slider {
  width: 400px;
}
div.color {
  display: table;
  border: 10px solid black;
  padding: 5px;
  border-radius: 20px;
  margin-bottom: 2px;
}
:global(html), :global(body) {
	position: relative;
	width: 100%;
	height: 100%;
}

:global(body) {
        background-color: #123;
	color: #dec;
	margin: 0;
	padding: 8px;
	box-sizing: border-box;
}
</style>
