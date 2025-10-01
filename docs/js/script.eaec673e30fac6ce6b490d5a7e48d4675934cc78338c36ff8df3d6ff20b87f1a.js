
document.addEventListener("DOMContentLoaded", () => {
  const menu = document.querySelector(".toc-menu");
  const btn = document.querySelector(".toc-button");
  if (!btn || !menu) return;

  btn.addEventListener("click", () => menu.classList.toggle("open"));

  menu.querySelectorAll("a").forEach(link => {
    link.addEventListener("click", () => {
      menu.classList.remove("open");
    });
  });

  const headings = Array.from(document.querySelectorAll("h2, h3, h4"));
  const updateButton = () => {
    const scrollTop = window.scrollY;
    const dropdownBottom = btn.getBoundingClientRect().bottom + window.scrollY;

    // find last heading above the dropdown
    let current = headings[0];
    for (let h of headings) {
      if (h.offsetTop <= dropdownBottom) {
        current = h;
      } else {
        break;
      }
    }
    btn.textContent = `▼ ${current.textContent}`;
  };

  window.addEventListener("scroll", updateButton);
  updateButton(); // initial

});

