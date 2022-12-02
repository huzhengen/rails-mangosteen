Starting MySQL with docker

```bash
docker run -v /home/mysql57/data:/var/lib/mysql57/data --name=mysql -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7
```

Starting MySQL with docker on M1 Mac
```
docker run --platform linux/amd64 -v /Users/xxx/database/mysql57/data:/var/lib/mysql57/data --name=db-for-mysql -it -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root -d --network=network1 mysql:5.7
```

Failed to start project on M1 Mac: https://github.com/RefugeRestrooms/refugerestrooms/pull/672

Create project

```
rails _5.2.6_ new rails-mangosteen --skip-bundle --database=mysql --skip-test --api
bundle exec rails db:drop
bundle exec rails db:create
bundle exec rails db:migrate
```

code model controller

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

Pagination

```
gem 'kaminari'
rails g kaminari:config
```

[RSpec](https://github.com/rspec/rspec-rails/tree/5-1-maintenance)

```
bin/rails generate rspec:install
```

Database for test environment

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
# 使用上面的命令需要把 config 文件夹里的 master.key 和 credentials.yml.enc 删除
```
```
bin/rails console
Rails.application.credentials.config
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

Send the verification code to the email address
```
bin/rails generate mailer User
# 使用 rails console 手动发送验证码
rails c
validation_code = ValidationCode.new email: 'xxx@xx.com', kind: 'sign_in', code: '123456'
validation_code.save
UserMailer.welcome_email('test@test.com').deliver
```

Generate API documentation [rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)
```
gem 'rspec_api_documentation'
bin/rake docs:generate
npx http-server doc/api/ -p8001
```

Emptying database tables
```
ValidationCode.destroy_all
```

session controller
```
bin/rails g controller api/v1/sessions_controller
```

> rspec 出错，试试 bundle exe rspec

me controller
```
bin/rails g controller api/v1/me_controller
```

tags model controller
```bash
bin/rails g model tag user:references name:string sign:string deleted_at:datetime
bin/rails db:migrate
bin/rails g controller api/v1/tags_controller
bin/rails db:migrate RAILS_ENV=test
```

Linux

```
sudo adduser mangosteen
apt-get update
usermod -a -G docker mangosteen
mkdir /home/mangosteen/.ssh
cp ~/.ssh/authorized_keys /home/mangosteen/.ssh
chown -R mangosteen:mangosteen /home/mangosteen/.ssh/
chmod +x bin/pack_for_remote.sh bin/setup_remote.sh
```