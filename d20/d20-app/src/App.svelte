<script>
  import Brightness from './Brightness.svelte'
  import Color from './Color.svelte'
  let brightness = [0,0,0,0,0,0]
  let hue = 100
  let sat = 100

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

<Brightness bind:values={brightness}/>
<Color bind:hue={hue} bind:sat={sat}/>
<span class="color" style="border-color: {hsv2rgb(hue, sat/100, 1)}">
	Brightness: {brightness}, Hue: {hue}, Saturation: {sat}, Color: {hsv2rgb(hue, sat/100, 1)}
</span>

<style>
span.color {
  border: 5px solid black;
  padding: 10px;
  border-radius: 10px;
}
</style>
