<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Snake Game</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        canvas {
            border: 1px solid #000;
            background-color: #fff;
        }
        .controls {
            margin-bottom: 20px;
        }
        button {
            margin: 0 5px;
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="controls">
        <button id="startButton">Start</button>
        <button id="pauseButton" disabled>Pause</button>
    </div>
    <canvas id="gameCanvas" width="400" height="400"></canvas>
    <script>
        const canvas = document.getElementById('gameCanvas');
        const ctx = canvas.getContext('2d');

        const scale = 20;
        const rows = canvas.height / scale;
        const cols = canvas.width / scale;

        let snake = [{ x: 2 * scale, y: 2 * scale }];
        let food = { x: 5 * scale, y: 5 * scale };
        let dx = scale;
        let dy = 0;
        let score = 0;
        let gameInterval;
        let isPaused = false;

        function draw() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Draw snake
            ctx.fillStyle = 'green';
            for (let i = 0; i < snake.length; i++) {
                ctx.fillRect(snake[i].x, snake[i].y, scale, scale);
            }

            // Draw food
            ctx.fillStyle = 'red';
            ctx.fillRect(food.x, food.y, scale, scale);

            // Draw score
            ctx.fillStyle = 'black';
            ctx.font = '20px Arial';
            ctx.fillText('Score: ' + score, 10, 20);

            // Update snake position
            let head = { x: snake[0].x + dx, y: snake[0].y + dy };
            snake.unshift(head);

            // Check if snake eats food
            if (head.x === food.x && head.y === food.y) {
                score++;
                food = {
                    x: Math.floor(Math.random() * cols) * scale,
                    y: Math.floor(Math.random() * rows) * scale
                };
            } else {
                snake.pop();
            }

            // Check if snake hits the wall or itself
            if (
                head.x < 0 || head.x >= canvas.width ||
                head.y < 0 || head.y >= canvas.height ||
                snake.slice(1).some(segment => segment.x === head.x && segment.y === head.y)
            ) {
                clearInterval(gameInterval);
                alert('Game Over! Your score was ' + score);
                document.getElementById('startButton').disabled = false;
                document.getElementById('pauseButton').disabled = true;
            }
        }

        function changeDirection(event) {
            const key = event.keyCode;
            if (key === 37 && dx === 0) { // Left arrow
                dx = -scale;
                dy = 0;
            } else if (key === 38 && dy === 0) { // Up arrow
                dx = 0;
                dy = -scale;
            } else if (key === 39 && dx === 0) { // Right arrow
                dx = scale;
                dy = 0;
            } else if (key === 40 && dy === 0) { // Down arrow
                dx = 0;
                dy = scale;
            }
        }

        function startGame() {
            snake = [{ x: 2 * scale, y: 2 * scale }];
            food = { x: 5 * scale, y: 5 * scale };
            dx = scale;
            dy = 0;
            score = 0;
            document.getElementById('startButton').disabled = true;
            document.getElementById('pauseButton').disabled = false;
            isPaused = false;
            gameInterval = setInterval(draw, 100);
        }

        function pauseGame() {
            if (isPaused) {
                gameInterval = setInterval(draw, 100);
                document.getElementById('pauseButton').textContent = 'Pause';
                isPaused = false;
            } else {
                clearInterval(gameInterval);
                document.getElementById('pauseButton').textContent = 'Resume';
                isPaused = true;
            }
        }

        document.getElementById('startButton').addEventListener('click', startGame);
        document.getElementById('pauseButton').addEventListener('click', pauseGame);
        document.addEventListener('keydown', changeDirection);
    </script>
</body>
</html>

