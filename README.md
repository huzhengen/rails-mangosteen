docker 启动 MySQL
```bash
docker run -v /home/mysql57/data:/var/lib/mysql57/data --name=mysql -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
```

创建项目
```
rails _5.2.6_ new rails-mangosteen --skip-bundle --database=mysql --skip-test --api
```

验证码 model controller
```
rails g model ValidationCode
rails g controller api/v1/validation_codes
rails g controller Api::V1::ValidationCodes
```

item model controller
```
rails g model Item
rails g controller api/v1/items
rails g controller Api::V1::Items
```

分页
```
gem 'kaminari'
rails g kaminari:config
```