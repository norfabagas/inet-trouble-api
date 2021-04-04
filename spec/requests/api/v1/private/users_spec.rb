require 'swagger_helper'

RSpec.describe 'api/v1/private/users', type: :request do
  path '/api/v1/private/users' do
    post 'Create new user' do
      tags 'User'
      consumes 'application/json'
      produces 'application/json'
      
      parameter name: :user, in: :body, schema: {
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
          { name: 'test',
            email: 'test@mail.com',
            password: 'password'   
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
          expect(data['user']['name']).to eq('test')
          expect(data['user']['email']).to eq('test@mail.com')
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
end
