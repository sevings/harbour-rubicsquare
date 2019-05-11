var board = [];
var component = Qt.createComponent('Square.qml');
var level = 4;
var width, height;
var square;
var db = LocalStorage.openDatabaseSync("SquarikScores", "1.0", "Squarik High Scores", 100);
db.transaction(
    function(tx) {
                //tx.executeSql('drop table scores');
                tx.executeSql('CREATE TABLE IF NOT EXISTS scores(level INTEGER, score UNSIGNED INTEGER, solutions UNSIGNED INTEGER, PRIMARY KEY(level))');
    });

function index(column, row) {
    return column + (row * width);
}

function moveUp(column) {
    var swap = board[index(column, 0)];
    swap.visible = false;
    board[index(column, height - 1)].type = board[index(column, 1)].type;
    board[index(column, height - 1)].visible = true;
    for (var i = 1; i < height; i++)
        board[index(column, i-1)] = board[index(column, i)];
    board[index(column, height - 1)] = swap;
}

function moveDown(column) {
    var swap = board[index(column, height - 1)];
    swap.visible = false;
    board[index(column, 0)].type = board[index(column, height - 2)].type;
    board[index(column, 0)].visible = true;
    for (var i = height-1; i > 0; i--)
        board[index(column, i)] = board[index(column, i-1)];
    board[index(column, 0)] = swap;
}

function moveLeft(row) {
    var swap = board[index(0, row)];
    swap.visible = false;
    board[index(width-1, row)].type = board[index(1, row)].type;
    board[index(width-1, row)].visible = true;
    for (var i = 1; i < width; i++)
        board[index(i-1, row)] = board[index(i, row)];
    board[index(width - 1, row)] = swap;
}

function moveRight(row) {
    var swap = board[index(width-1, row)];
    swap.visible = false;
    board[index(0, row)].type = board[index(width - 2, row)].type;
    board[index(0, row)].visible = true;
    for (var i = width - 1; i > 0; i--)
        board[index(i, row)] = board[index(i-1, row)];
    board[index(0, row)] = swap;
}

function updateCanvas() {
    for (var i = 0; i < width; i++)
        for (var j = 0; j < height; j++) {
            board[index(i, j)].x = (i-1) * canvas.blockSize;
            board[index(i, j)].y = (j-1) * canvas.blockSize;
            //board[index(i, j)].n = index(i, j);
        }
}

function victoryCheck() {
    var victory = true;
    var type;
    var i, j;
    for (i = 1; i < width-1; i++) {
        type = board[index(i, 1)].type;
        for (j = 2; j < height-1; j++)
            if (board[index(i, j)].type !== type) {
                victory = false;
                break;
        }
    }
    if (victory && canvas.gameIsRunning) {
        //console.log('Victory!');
        //gameDuration = Math.ceil((new Date() - gameDuration) / 1000);
        canvas.gameIsRunning = false;
        newGameButton.enabled = true;
        var text = 'Congratulations!\nSolved in ' + canvas.score + ' turns.';
        if (saveScore(canvas.level, canvas.score))
            text += '\nIt\'s your best result!'
        dialog.show(text);
        setBestText();
    }
    return victory;
}

function startNewGame(gameLevel) {
    canvas.gameIsRunning = false;
    canvas.movingSquares = false;
    if (board.length === 0 || level !== gameLevel) {
        if (gameLevel === undefined)
            level = 4;
        else
            level = gameLevel;
        canvas.level = level;
        width = level + 2;
        height = canvas.nrows + 2;
        var i, j;
        for (i = 0; i < board.length; i++)
            board[i].destroy();
        board = new Array(width * height);
        for (i = 0; i < width; i++)
            for (j = 0; j < height; j++) {
                board[index(i, j)] = component.createObject(canvas,
                        {'type': i-1,
                            'x': (i-1) * canvas.blockSize,
                            'y': (j-1) * canvas.blockSize,
                            //'n': index(i, j)
                        })
            }
        //updateCanvas();
    }

    square = 0;
    shuffleTimer.start();
    shuffle(true);
                //var square = Math.floor(Math.random() * size);

    //gameDuration = new Date();
    canvas.score = 0;
}

function shuffle(first) {
//    while (Math.floor(square / width) === 0
//           || Math.floor(square % width) === height - 1
//           || square % width === 0 || square % width === width - 1)
//        square++;
    var row = Math.floor(Math.random() * (height-2)) + 1;
    var column = Math.floor(Math.random() * (width-2)) + 1;
    var direction;
    if (first)
        direction = 3;
    else
        direction = Math.floor(Math.random() * 4) + 1;
    //console.log(square, direction)
    switch (direction) {
    case 1:
        moveUp(column);
        break;
    case 2:
        moveDown(column);
        break;
    case 3:
        moveLeft(row);
        break;
    case 4:
        moveRight(row);
        break;
    }
    updateCanvas();
    square++;
    if (square >= board.length - (width + height)*2 + 4) {
        if (victoryCheck()) {
            square = width + 1;
            shuffleTimer.start();
        }
        else {
            canvas.gameIsRunning = true;
            shuffleTimer.stop();
        }
    }
    else
        shuffleTimer.start();
}

var pressedRow = 0;
var pressedColumn = 0;

function handlePress(x, y) {
    dialog.close();
    if (!canvas.gameIsRunning && canvas.movingSquares)
        return;
    pressedColumn = Math.floor(x/canvas.blockSize)+1;
    pressedRow = Math.floor(y/canvas.blockSize)+1;
}

function handleRelease(x, y) {
    if (!canvas.gameIsRunning || canvas.movingSquares)
        return;
    var direction;
    var column = Math.floor(x/canvas.blockSize)+1;
    var row = Math.floor(y/canvas.blockSize)+1;
    if (pressedColumn === column) {
        if (pressedRow > row)
            direction = 'up';
        else if (pressedRow < row)
            direction = 'down';
        else
            return;
    }
    else if (pressedRow === row) {
        if (pressedColumn > column)
            direction = 'left';
        else if (pressedColumn < column)
            direction = 'right';
        else
            return;
    }
    else
        return;

    //console.log(direction);
    var i, j, swap;
    switch (direction) {
    case 'up':
        moveUp(column);
        break;
    case 'down':
        moveDown(column);
        break;
    case 'left':
        moveLeft(row);
        break;
    case 'right':
        moveRight(row);
        break;
    default:
        console.log('unknown direction: ' + direction);
        break;
    }
    canvas.score++;
    updateCanvas();
    newGameButton.enabled = true;
    victoryCheck();
}

function setBestText() {
    var best = readBestScore(canvas.newGameLevel);
    if (best > 0)
        bestText.text = 'Best: ' + best + ' turns'
    else
        bestText.text = 'Unsolved'
}

function readBestScore(level) {
    var best;
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT score FROM scores WHERE level = '+ level);
            if (rs.rows.length === 1)
                best = rs.rows.item(0).score;
            else
                best = 0;
        });
    return best;
}

function saveScore(level, newScore) {
    var sql = "INSERT OR REPLACE INTO scores VALUES(?, ?, ?)";
    var best = readBestScore(level);
    var solutions = readSolutions(level);
    solutions++;
    db.transaction(
        function(tx) {
            tx.executeSql(sql, [level, newScore > best && best !== 0 ? best : newScore, solutions]);
        });
    if (level === canvas.maxLevel)
        canvas.maxLevel = readMaxLevel();
    if (best !== 0 && best < newScore)
        return false;
    return true;
}

function readMaxLevel() {
    var maxLevel = 4;
    db.transaction(
        function(tx) {
                    var rs = tx.executeSql('SELECT MAX(level) as "maxlevel" FROM scores WHERE solutions >= 5');
            if (rs.rows.length === 1) {
                maxLevel = rs.rows.item(0).maxlevel;
                if (maxLevel > 2 && maxLevel < 9)
                    maxLevel++;
                else
                    maxLevel = 4;

            }
        });
    //console.log(maxLevel);
    return maxLevel;
}

function readSolutions(level) {
    var s;
    db.transaction(
        function(tx) {
            var rs = tx.executeSql('SELECT solutions FROM scores WHERE level = '+ level);
            if (rs.rows.length === 1)
                s = rs.rows.item(0).solutions;
            else
                s = 0;
        });
    return s;
}
