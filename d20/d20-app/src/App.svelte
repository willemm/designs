<script>
  import Brightness from './Brightness.svelte'
  import Color from './Color.svelte'
  import Sendcolor from './Sendcolor.svelte'
  let brightness = [0,0,0,0,0,0]
  let hue = 0
  let sat = 0

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

<Sendcolor bind:hue={hue} bind:sat={sat} bind:val={brightness[0]}/>
<Color bind:hue={hue} bind:sat={sat}/>
<Brightness bind:values={brightness}/>
<span class="color" style="border-color: {hsv2rgb(hue, sat/256, brightness[0]/255)}">
	Brightness: {brightness}, Hue: {hue}, Saturation: {sat}, Color: {hsv2rgb(hue, sat/256, brightness[0]/255)}
</span>

<style>
span.color {
  border: 10px solid black;
  padding: 5px;
  border-radius: 20px;
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
