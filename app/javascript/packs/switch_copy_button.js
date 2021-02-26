var input = document.querySelector('.copy-input');
var button_copy = document.querySelector('.copy-button');
var button_copy_here = document.querySelector('.copy-here-button');
input.addEventListener('input', (event) => {
  if (input.value != "") {
    button_copy.classList.remove('hidden');
    button_copy_here.classList.add('hidden');
  } else if (input.value == "") {
    button_copy.classList.add('hidden');
    button_copy_here.classList.remove('hidden');
  }
})
