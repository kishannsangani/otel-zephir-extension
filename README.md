### Step to build

```
docker-compose up -d --build
docker exec -it ubuntu20_zephir bash -l
php -m
cd example
php sample.php
```