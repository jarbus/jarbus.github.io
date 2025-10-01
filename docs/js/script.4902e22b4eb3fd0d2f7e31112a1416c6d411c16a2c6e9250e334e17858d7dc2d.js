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
    btn.textContent = `· ${current.textContent}`;
  };

  window.addEventListener("scroll", updateButton);
  updateButton(); // initial

});

