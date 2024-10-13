// 팀 번호 전달
function sendTeamNum(teamNum, page) {
    var form = document.createElement("form");
    form.setAttribute("method", "POST");
    form.setAttribute("action", page + ".jsp");

    var teamField = document.createElement("input");
    teamField.setAttribute("type", "hidden");
    teamField.setAttribute("name", "teamNum");
    teamField.setAttribute("value", teamNum);
    form.appendChild(teamField);

    document.body.appendChild(form);
    form.submit();
}

// 선수 출력
function showPlayers() {
    document.getElementById('player-List').style.display = 'block';
    document.getElementById('coach-List').style.display = 'none';
    document.getElementById('player').getElementsByTagName('a')[0].style.color = '#FFFFFF';
    document.getElementById('player').style.backgroundColor = '#000000';
    document.getElementById('coach').getElementsByTagName('a')[0].style.color = '#000000';
    document.getElementById('coach').style.backgroundColor = '#FBFBFB';
    var playerCards = document.querySelectorAll('.player-card');
    playerCards.forEach(function(card) {
        card.style.display = 'inline-block';
    });
    var positionItems = document.querySelectorAll('.p_top .item');
    positionItems.forEach(function(item) {
        item.classList.remove('selected-item');
        item.getElementsByTagName('a')[0].style.color = '#000000';
        item.style.backgroundColor = '#FBFBFB';
    });
}

// 감독 출력
function showCoaches() {
    document.getElementById('player-List').style.display = 'none';
    document.getElementById('coach-List').style.display = 'block';
    document.getElementById('player').style.backgroundColor = '#FBFBFB';
    document.getElementById('player').getElementsByTagName('a')[0].style.color = '#000000';
    document.getElementById('coach').style.backgroundColor = '#000000';
    document.getElementById('coach').getElementsByTagName('a')[0].style.color = '#FFFFFF';
}

// 포지션에 따라 선수 필터링
function filterByPosition(position) {
    var playerCards = document.querySelectorAll('.player-card');
    var positionItems  = document.querySelectorAll('.p_top .item');

    playerCards.forEach(function(card) {
        if (card.getAttribute('data-position') === position) {
            card.style.display = 'inline-block';
        } else {
            card.style.display = 'none';
        }
    });
    
    positionItems.forEach(function(item) {
        item.classList.remove('selected-item');
        item.getElementsByTagName('a')[0].style.color = '#000000';
    });
    
    var currentItem = event.target.parentElement;
    currentItem.classList.add('selected-item');
    currentItem.getElementsByTagName('a')[0].style.color = '#FFFFFF';
}

// 모든 선수 보여주기
function showAllPlayers() {
    var playerCards = document.querySelectorAll('.player-card');
    playerCards.forEach(function(card) {
        card.style.display = 'block';
    });
}

// 등록하기
function addPlayer() {
    const playerFrame = document.getElementById('player-List');
    const coachFrame = document.getElementById('coach-List');
    if (coachFrame.style.display == 'block' || playerFrame.style.display == 'none') {
        document.location.href="admin_addCoach.jsp";
    } else {
        document.location.href="admin_addPlayer.jsp";
    }
}

// 선수 클릭 시 번호 저장
let selectedPlayerNum = null;

document.querySelectorAll('.player-card').forEach((item) => {
    item.addEventListener('click', (event) => {
        item.classList.toggle('active');
        selectedPlayerNum = item.getAttribute('data-player-num');
        const playerName = item.querySelector('.player-name');
        if (item.classList.contains('active')) {
            playerName.style.marginLeft = '3px';
            playerName.style.bottom = '-3px';
        } else {
            playerName.style.marginLeft = '';
            playerName.style.bottom = '';
        }
    });
});

// 감독 클릭 시 번호 저장
let selectedCoachNum = null;

document.querySelectorAll('.coach-card').forEach((item) => {
    item.addEventListener('click', () => {
        item.classList.toggle('active');
        selectedCoachNum = item.getAttribute('data-coach-num');
        const coachName = item.querySelector('.coach-name');
        if (item.classList.contains('active')) {
            coachName.style.marginLeft = '3px';
            coachName.style.bottom = '-3px';
        } else {
            coachName.style.marginLeft = '';
            coachName.style.bottom = '';
        }
    });
});

// 수정하기
function editPlayer() {
    const playerFrame = document.getElementById('player-List');
    const coachFrame = document.getElementById('coach-List');
    if (selectedPlayerNum) {
        var form = document.createElement("form");
        form.setAttribute("method", "POST");
        form.setAttribute("action", "admin_updatePlayer.jsp");
        var playerField = document.createElement("input");
        playerField.setAttribute("type", "hidden");
        playerField.setAttribute("name", "playerNum");
        playerField.setAttribute("value", selectedPlayerNum);
        form.appendChild(playerField);
        document.body.appendChild(form);
        form.submit();
    } else if (selectedCoachNum) {
        var form = document.createElement("form");
        form.setAttribute("method", "POST");
        form.setAttribute("action", "admin_updateCoach.jsp");
        var coachField = document.createElement("input");
        coachField.setAttribute("type", "hidden");
        coachField.setAttribute("name", "coachNum");
        coachField.setAttribute("value", selectedCoachNum);
        form.appendChild(coachField);
        document.body.appendChild(form);
        form.submit();
    } else {
        alert("수정할 선수를 또는 감독을 선택하세요.");
    }
}

// 삭제
function deletePlayer() {
    const playerFrame = document.getElementById('player-List');
    const coachFrame = document.getElementById('coach-List');
    if (coachFrame.style.display == 'block' && selectedCoachNum) {
        const params = new URLSearchParams();
        params.append('selectedCoachNum', selectedCoachNum);
        fetch('delete_coach.jsp?' + params.toString(), {
            method: 'GET',
        })
        .then(response => response.text())
        .then(data => {
            if (data.includes("success")) {
                alert('감독 삭제가 완료되었습니다.');
                location.href = "admin_player.jsp";
            } else {
                alert('감독 삭제가 되지 않았습니다.');
            }
        })
        .catch(error => console.error('Error:', error));
    } else if (playerFrame.style.display == 'block' && selectedPlayerNum) {
        const params = new URLSearchParams();
        params.append('selectedPlayerNum', selectedPlayerNum);
        fetch('delete_player.jsp?' + params.toString(), {
            method: 'GET',
        })
        .then(response => response.text())
        .then(data => {
            if (data.includes("success")) {
                alert('선수 삭제가 완료되었습니다.');
                location.href = "admin_player.jsp";
            } else {
                alert('선수 삭제가 되지 않았습니다.');
            }
        })
        .catch(error => console.error('Error:', error));
    } else {
        alert('삭제할 감독이나 선수를 선택하세요.');
    }
}
