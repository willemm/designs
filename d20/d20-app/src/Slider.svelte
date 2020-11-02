<script>
  export let value = 0
</script>

<input type="range" bind:value={value} min="0" max="255" on:focus/>

<style>
input {
  -webkit-appearance: none;
  background-color: #235;
  width: calc(100% - 80px);
  margin: 8px 0;
  height: 30px;
}
input[type=range]::-webkit-slider-runnable-track,
input[type=range]::-moz-range-track {
  width: 100%;
  height: 100%;
  background: #235;
  background-image: linear-gradient(20deg, #123, #446);
  border: 5px solid #235;
  border-radius: 20px;
  box-shadow: 1px 1px 4px 2px #000 inset, 1px 1px 2px 1px #000;
}
input[type=range]::-webkit-slider-thumb,
input[type=range]::-moz-range-thumb {
  -webkit-appearance: none;
  border: 4px solid #579;
  height: 16px;
  width: 16px;
  border-radius: 100%;
  background: #358;
  box-shadow: 1px 2px 5px #000, 0px 0px 4px 2px #579 inset;
}
input[type=range]:focus {
  outline: none;
}
input[type=range]:focus::-webkit-slider-runnable-track,
input[type=range]:focus::-moz-range-track {
  border-color: #346;
}

</style>
