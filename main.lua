
function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("Shooter Game")

    player = {
        x = 400,
        y = 500,
        speed = 300,
        img = nil
    }
    player.img = love.graphics.newImage('player.png')

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
        newBullet = { x = player.x, y = player.y, img = love.graphics.newImage('bullet.png') }
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
        newEnemy = { x = randomNumber, y = -10, img = love.graphics.newImage('enemy.png') }
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
            if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 1
            end
        end

        if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) and isAlive then
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
        love.graphics.draw(player.img, player.x, player.y)
    else
        love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
    end

    for i, bullet in ipairs(bullets) do
        love.graphics.draw(bullet.img, bullet.x, bullet.y)
    end

    for i, enemy in ipairs(enemies) do
        love.graphics.draw(enemy.img, enemy.x, enemy.y)
    end

    love.graphics.print("Score: " .. score, 10, 10)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
    return x1 < x2+w2 and
           x2 < x1+w1 and
           y1 < y2+h2 and
           y2 < y1+h1
end
