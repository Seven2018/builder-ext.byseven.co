const initTree = () => {
  const toggler = document.getElementsByClassName("caret");
  let i;
  for (i = 0; i < toggler.length; i++) {
    toggler[i].addEventListener("click", function() {
      this.parentElement.querySelector(".nested").classList.toggle("nested-active");
      this.parentElement.classList.toggle("theme-active");
      this.classList.toggle("caret-down");
    });
  }
}

initTree();
