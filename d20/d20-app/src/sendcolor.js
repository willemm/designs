export function sendcolor(sentcolor, hue, sat, val)
{
  let newcolor = ""+hue+":"+sat+":"+val
  if (newcolor != sentcolor) {
    fetch('/set', {
      method: 'POST',
      body: newcolor }).then(
      res => res.text()
    ).then(data => {
      console.log('Sent', newcolor, 'Result', data)
    })
  }
  return newcolor
}
