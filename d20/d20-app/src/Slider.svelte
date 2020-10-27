<script>
  export let value = 0
</script>

<input type="range" bind:value={value} min="0" max="255" orient="vertical"/>

<style>
input {
  -webkit-appearance: none;
  writing-mode: bt-lr;
  background-color: #235;
  width: 10px;
  margin: 25px;
  height: 200px;
}
input[type=range]::-webkit-slider-runnable-track,
input[type=range]::-moz-range-track {
  width: 34px;
  height: 210px;
  background: #235;
  background-image: linear-gradient(20deg, #123, #446);
  border: 5px solid #235;
  border-radius: 12px;
  box-shadow: 1px 1px 4px 2px #000 inset, 1px 1px 2px 1px #000;
}
input[type=range]::-webkit-slider-thumb,
input[type=range]::-moz-range-thumb {
  -webkit-appearance: none;
  border: 4px solid #579;
  height: 2px;
  width: 20px;
  border-radius: 5px;
  background: #345;
  margin-top: -6px;
  box-shadow: 1px 2px 5px #000;
}
input[type=range]:focus {
  outline: none;
}
input[type=range]:focus::-webkit-slider-runnable-track,
input[type=range]:focus::-moz-range-track {
  border-color: #346;
}

</style>
