const btn = document.querySelector('.selectbox-btn');
const list = document.querySelector('.selectbox-option');

btn.addEventListener('click', () => {
    btn.classList.toggle('on');
});

list.addEventListener('click', (event) => {
    if (event.target.nodeName === "BUTTON") {
        btn.innerText = event.target.innerText;
        btn.classList.remove('on');
    }
});

window.addEventListener('click', (event) => { 
    if (!btn.contains(event.target)) {
        btn.classList.remove('on');
    }
});