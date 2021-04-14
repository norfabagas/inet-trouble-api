require 'swagger_helper'

include JsonWebToken

RSpec.describe 'api/v1/private/users', type: :request do
  path '/api/v1/private/users' do
    post 'Create new user' do
      name = "test"
      email = "#{Time.now.to_i.to_s}@mail.com"
      password = "password"

      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, 
                in: :body, 
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    email: { type: :string },
                    password: { type: :string }
                  },
                  required: [
                    :name,
                    :email,
                    :password
                  ]
                }

      response '201', 'User created' do
        let (:user) {
          { name: name,
            email: email,
            password: password   
          }
        }
        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string },
                  user: {
                    type: :object,
                    properties: {
                      name: { type: :string },
                      email: { type: :string },
                      created: { type: :string }
                    },
                    required: [
                      :name,
                      :email,
                      :created
                    ]
                  }
                },
                required: [
                  :success,
                  :message,
                  :user
                ]

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['user']['name']).to eq(name)
          expect(data['user']['email']).to eq(email)
        end

      end

      response '400', 'User did not pass validation' do
        let (:user) {
          { name: 'test' }
        }

        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :object }
                },
                required: [
                  :success,
                  :message
                ]
        run_test!
      end

    end

  end

  path '/api/v1/private/users/login' do
    
    # First, create user for this test
    user = User.create!(
      name: 'Test name with space',
      email: "#{Time.now.to_i.to_s}@#{Time.now.to_i.to_s}.com", 
      password: 'password'
    )
    
    post 'Authenticate user' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, 
                in: :body, 
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    password: { type: :string }
                  },
                  required: [
                    :email,
                    :password
                  ]
                }
      
      response '200', 'Authenticated' do
        let (:user) {
          {
            email: user.email,
            password: user.password
          }
        }

        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string },
                  name: { type: :string },
                  regular_user: { type: :boolean },
                  token: { type: :string }
                },
                required: [
                  :success,
                  :message,
                  :name,
                  :token,
                  :regular_user,
                ]
        
        run_test! do |response|
          payload = JsonWebToken.payload(user.id)
          token = JsonWebToken.encode(payload)
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['name']).to eq('Test name with space')
          expect(data['token']).to eq(token)
          expect(data['regular_user']).to eq(true)
        end
      end
    end
  end
end
