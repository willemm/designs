<script>
import { onMount } from 'svelte';

let sending = true
let queue = null
export let hue, sat, val
$: sentcolor = sendcolor(sentcolor, hue, sat, val)

onMount(async () => {
  const res = await fetch('/get')
  let hsv = await res.json()
  hue = hsv.hue
  sat = hsv.sat
  val = hsv.val
  sending = false
  queue = null
});

function sendcolor(sentcolor, hue, sat, val)
{
  let newcolor = ""+hue+":"+sat+":"+val
  if (newcolor != sentcolor) {
    if (sending) {
      queue = {
        sentcolor: sentcolor,
        hue: hue,
        sat: sat,
        val: val
      }
    } else {
      sending = true
      fetch('/set', {
        method: 'POST',
        body: JSON.stringify({
          hue: hue,
          sat: sat,
          val: val
        })
      }).then(
        res => res.json()
      ).then(data => {
        console.log('Sent', newcolor, 'Result', data)
        hue = data.hue
        sat = data.sat
        val = data.val
      }).catch(err => {
        console.log('Error: ', err)
      }).finally(() => {
        sending = false
        if (queue) {
          sendcolor(queue.sentcolor, queue.hue, queue.sat, queue.val)
          queue = null
        }
      })
    }
  }
  return newcolor
}
</script>
