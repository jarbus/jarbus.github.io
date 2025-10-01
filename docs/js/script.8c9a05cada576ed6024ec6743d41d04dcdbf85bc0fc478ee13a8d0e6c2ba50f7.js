document.addEventListener("DOMContentLoaded", () => {
  const btn = document.querySelector(".toc-button");
  const menu = document.querySelector(".toc-menu");

  if (btn && menu) {
    btn.addEventListener("click", () => menu.classList.toggle("open"));

    menu.querySelectorAll("a").forEach(link => {
      link.addEventListener("click", () => {
        menu.classList.remove("open");
      });
    });
  }
});
