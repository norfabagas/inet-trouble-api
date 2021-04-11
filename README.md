# Internet Trouble API

## Requirements
- Ruby : 3.0.0
- Rails : 6.1.3.1
- Bundler : 2.2.3
- PostgreSQL : ^9.3

## Run locally
- git clone this repository
- install ruby 3.0.0
- install bundler 2.2.3
- install postgresql 9.3
- run `bundle install` to install all required libraries
- generate .env file (`cp .env.example .env`) and fill all required values
- create db (`rake db:create`)
- migrate db (`rake db:migrate`)
- run server (`rails s`)

## API Docs
- refer to /api-docs to view & explore created API Documentations
## Run tests
`bundle exec rspec`

## Generate api docs
`RAILS_ENV=test rails rswag`