<script>
  export let color
  $: curx = -Math.cos(color.hue * Math.PI/180)*color.sat*100/256
  $: cury = Math.sin(color.hue * Math.PI/180)*color.sat*100/256

  function colorcircle(canvas)
  {
    const ctx = canvas.getContext('2d')
    const imageData = ctx.getImageData(0,0,canvas.width,canvas.height)

    const w = canvas.width
    const h = canvas.height
    for (let p = 0; p < imageData.data.length; p += 4) {
      const x = ((p/4) % w) - (w-1)/2
      const y = ((p/4)/w >>> 0) - (h-1)/2
      const d = Math.sqrt(x*x + y*y) / (w/2)
      if (d <= 1) {
        const a = (Math.atan(x/y)+(y<0)*Math.PI+Math.PI/2)*180/Math.PI
        const V = 1
        const H = a
        const S = d
        const C = V * S
        const X1 = C * Math.min(1,(  (H/60) % 2))
        const X2 = C * Math.min(1,(2-(H/60) % 2))
        const m = V - C
        const io = (H/120) >>> 0
        // console.log(x, y, V, H, S, C, X1, X2, m, io)
        imageData.data[p+((io+0) % 3)] = (X2+m)*255
        imageData.data[p+((io+1) % 3)] = (X1+m)*255
        imageData.data[p+((io+2) % 3)] = m*255
        imageData.data[p+3] = 255
      }
    }
    ctx.putImageData(imageData, 0, 0)

    function handleMousedown(event)
    {
      window.addEventListener('mousemove', handleMousemove)
      window.addEventListener('mouseup', handleMouseup)
      handleMousemove(event)
    }
    function handleMousemove(event)
    {
      const x = event.clientX - 40 -(canvas.width-1)/2
      const y = event.clientY - 40 -(canvas.height-1)/2
      color.sat = Math.min(1,Math.sqrt(x*x + y*y) / (w/2))*256 >>> 0
      color.hue = (Math.atan(x/y)+(y<0)*Math.PI+Math.PI/2)*180/Math.PI >>> 0
    }
    function handleMouseup(event)
    {
      window.removeEventListener('mousemove', handleMousemove)
      window.removeEventListener('mouseup', handleMouseup)
    }
    canvas.parentElement.addEventListener('mousedown', handleMousedown)
    return {
      destroy() {
        canvas.parentElement.removeEventListener('mousedown', handleMousedown)
      }
    }
  }
</script>

<div class="colorcircle">
<canvas use:colorcircle
        width={200}
        height={200}
/>
<div class="cursor" style="left: {curx + 100}px; top: {cury + 100}px;" />
</div>

<style>
div.colorcircle {
  width: 200px;
  height: 200px;
  border: 1px solid #333;
  border-radius: 100%;
  box-shadow: 1px 1px 3px 3px #000;
  margin: 30px;
  overflow: hidden;
  position: relative;
}
div.colorcircle canvas {
  position: absolute;
}
div.cursor {
  position: absolute;
  height: 6px;
  width: 6px;
  margin-left: -5px;
  margin-top: -5px;
  border: 2px solid rgba(32,48,64,0.3);
  box-shadow: 1px 1px 1px 0px #469 inset, 1px 1px 1px 0px #246;
  border-radius: 100%;
  z-index: 5;
}
</style>
