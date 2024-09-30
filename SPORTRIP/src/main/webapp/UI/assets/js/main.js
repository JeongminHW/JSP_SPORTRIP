const players = document.querySelectorAll('.player-card');
const playerImg = document.querySelector('.player-photo');

// 플레이어 카드 클릭 시 이벤트
players.forEach((item) => {
    item.addEventListener('click', () => {
    // players.forEach((item) => {
    //   item.classList.remove('active');
    // });
    item.classList.toggle('active');
    playerImg.src = item.querySelector('img').src;
  });
});