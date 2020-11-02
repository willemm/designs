<script>
import { onMount } from 'svelte';

let sending = true
let queue = null
export let colors
$: sentcolor = sendcolor(sentcolor, colors)

onMount(async () => {
  const res = await fetch('/get')
  let hsv = await res.json()
  for (let c = 0; c < hsv.length; c++) {
    colors[c] = hsv[c]
  }
  sending = false
  queue = null
});

function sendcolor(sent, tosend)
{
  let newcolor = JSON.stringify(tosend)
  if (newcolor != sent) {
    if (sending) {
      queue = {
        sent: sent,
        tosend: tosend
      }
    } else {
      sending = true
      fetch('/set', {
        method: 'POST',
        body: newcolor
      }).then(
        res => res.json()
      ).then(data => {
        console.log('Sent', newcolor, 'Result', data)
        if (!queue) {
          colors = data
        }
      }).catch(err => {
        console.log('Error: ', err)
      }).finally(() => {
        sending = false
        if (queue) {
          sendcolor(queue.sent, queue.tosend)
          queue = null
        }
      })
    }
  }
  return newcolor
}
</script>
