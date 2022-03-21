docker 启动 MySQL
```bash
docker run -v /home/mysql57/data:/var/lib/mysql57/data --name=mysql -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
```

创建项目
```
rails _5.2.6_ new rails-mangosteen --skip-bundle --database=mysql --skip-test --api
```

