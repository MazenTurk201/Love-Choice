fetch('assets/modules/nav.html')
    .then(res => res.text())
    .then(data => {
        let nav = document.querySelector('nav'); // أول nav
        nav.innerHTML = data;

        // نجيب الـ id من الـ nav نفسه
        let currentPage = nav.id;

        let link = document.querySelector(`[data-page="${currentPage}"]`);
        if (link) {
            link.classList.add("active");
        }
    });

window.addEventListener("scroll", function () {
    const nav = document.querySelector(".navbar");

    if (window.scrollY > 50) {
        nav.classList.add("scrolled");
    } else {
        nav.classList.remove("scrolled");
    }
});