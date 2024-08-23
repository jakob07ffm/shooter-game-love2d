function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("Shooter Game")

    player = {
        x = 400,
        y = 500,
        speed = 300,
        width = 50,
        height = 20
    }

    bullets = {}
    bulletSpeed = 500
    canShoot = true
    canShootTimerMax = 0.2
    canShootTimer = canShootTimerMax

    enemies = {}
    enemySpeed = 100
    createEnemyTimerMax = 0.4
    createEnemyTimer = createEnemyTimerMax

    score = 0
    isAlive = true
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        player.x = player.x - player.speed * dt
    elseif love.keyboard.isDown("right") then
        player.x = player.x + player.speed * dt
    end

    canShootTimer = canShootTimer - dt
    if canShootTimer < 0 then
        canShoot = true
    end

    if love.keyboard.isDown("space") and canShoot then
        newBullet = { x = player.x + player.width / 2 - 2.5, y = player.y, width = 5, height = 10 }
        table.insert(bullets, newBullet)
        canShoot = false
        canShootTimer = canShootTimerMax
    end

    for i, bullet in ipairs(bullets) do
        bullet.y = bullet.y - (bulletSpeed * dt)
        if bullet.y < 0 then
            table.remove(bullets, i)
        end
    end

    createEnemyTimer = createEnemyTimer - dt
    if createEnemyTimer < 0 then
        createEnemyTimer = createEnemyTimerMax
        randomNumber = math.random(10, love.graphics.getWidth() - 10)
        newEnemy = { x = randomNumber, y = -10, width = 40, height = 40 }
        table.insert(enemies, newEnemy)
    end

    for i, enemy in ipairs(enemies) do
        enemy.y = enemy.y + (enemySpeed * dt)
        if enemy.y > 600 then
            table.remove(enemies, i)
        end
    end

    for i, enemy in ipairs(enemies) do
        for j, bullet in ipairs(bullets) do
            if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height, bullet.x, bullet.y, bullet.width, bullet.height) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 1
            end
        end

        if CheckCollision(enemy.x, enemy.y, enemy.width, enemy.height, player.x, player.y, player.width, player.height) and isAlive then
            table.remove(enemies, i)
            isAlive = false
        end
    end

    if not isAlive and love.keyboard.isDown('r') then
        bullets = {}
        enemies = {}
        canShootTimer = canShootTimerMax
        createEnemyTimer = createEnemyTimerMax
        player.x = 400
        player.y = 500
        score = 0
        isAlive = true
    end
end

function love.draw()
    if isAlive then
        love.graphics.setColor(0, 1, 0)  -- Green color for the player
        love.graphics.rectangle("fill", player.x, player.y, player.width, player.height)
    else
        love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

    love.graphics.setColor(1, 1, 1)  -- White color for bullets
    for i, bullet in ipairs(bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end

    love.graphics.setColor(1, 0, 0)  -- Red color for enemies
    for i, enemy in ipairs(enemies) do
        love.graphics.rectangle("fill", enemy.x, enemy.y, enemy.width, enemy.height)
    end

    love.graphics.setColor(1, 1, 1)  -- White color for the score
    love.graphics.print("Score: " .. score, 10, 10)
end

function CheckCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 < x2 + w2 and
           x2 < x1 + w1 and
           y1 < y2 + h2 and
           y2 < y1 + h1
end
