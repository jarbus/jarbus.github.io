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

    // observe headings
    const headings = document.querySelectorAll("h2, h3, h4");
    const observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          btn.textContent = entry.target.textContent;
        }
      });
    }, { rootMargin: "-50% 0px -50% 0px", threshold: 0 });

    headings.forEach(h => observer.observe(h));
  }
});

