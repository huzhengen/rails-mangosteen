docker 启动 MySQL

```bash
docker run -v /home/mysql57/data:/var/lib/mysql57/data --name=mysql -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
```

创建项目

```
rails _5.2.6_ new rails-mangosteen --skip-bundle --database=mysql --skip-test --api
bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails db:migrate
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

[RSpec](https://github.com/rspec/rspec-rails/tree/5-1-maintenance)

```
bin/rails generate rspec:install
```

测试环境数据库

```
RAILS_ENV=test bin/rails db:create
RAILS_ENV=test bin/rails db:migrate
bin/rails db:migrate RAILS_ENV=test
```

[Request spec](https://relishapp.com/rspec/rspec-rails/docs/request-specs/request-spec)

[`change` matcher](https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers/change-matcher)

```
bin/rails g rspec:request items
bin/rails g rspec:request validation_codes
```

```
EDITOR="code --wait" bin/rails credentials:edit
EDITOR="code --wait" bin/rails credentials:edit --environment production
```

已经提交到了 git，再添加到 .gitignore，无法忽略怎么办？
```
git rm -r --cached dist
```

--amend
```
git add .
git commit --amend -m "update"
```

发邮箱验证码
```
bin/rails generate mailer User
# 使用 rails console 手动发送验证码
rails c
validation_code = ValidationCode.new email: 'xxx@xx.com', kind: 'sign_in', code: '123456'
validation_code.save
UserMailer.welcome_email('test@test.com').deliver
```

生成 API 文档 [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)
```
gem 'rspec_api_documentation'
bin/rake docs:generate
npx http-server doc/api/ -p8001
```

清空表
```
ValidationCode.destroy_all
```