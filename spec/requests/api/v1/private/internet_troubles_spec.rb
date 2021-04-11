require 'swagger_helper'

include JsonWebToken

RSpec.describe "Api::V1::Private::InternetTroubles", type: :request do

  user = User.create!(
    name: 'Test',
    email: "#{Time.now.to_i.to_s}@users.com", 
    password: 'password'
  )

  trouble = InternetTrouble.create!(
    user_id: user.id,
    trouble: 'Some trouble'
  )

  token = JsonWebToken.encode(
    JsonWebToken.payload(user.id)
  )
    
  path '/api/v1/private/internet_troubles' do
    post 'Create new internet trouble' do
      tags 'InternetTrouble'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authorization,
                in: :header,
                type: :string

      parameter name: :internet_trouble,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    trouble: { type: :string },
                    category: { type: :string },
                    status: { type: :string },
                    is_predicted: { type: :boolean }
                  },
                  required: [
                    :trouble
                  ]
                }

      response '201', 'Created' do
        let (:Authorization) { "Bearer #{token}" }
        let (:internet_trouble) {
          {
            trouble: 'Some trouble'
          }
        }

        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string },
                  internet_trouble: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      trouble: { type: :string },
                      status: { type: :string, nullable: true },
                      category: { type: :string, nullable: true },
                      is_predicted: { type: :boolean }
                    },
                    required: [
                      :id,
                      :trouble,
                      :is_predicted
                    ]
                  }
                },
                required: [
                  :success,
                  :message,
                  :internet_trouble
                ]
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['internet_trouble']['trouble']).to eq('Some trouble')
          expect(data['internet_trouble']['is_predicted']).to eq(false)
        end
      end

      response '400', 'Validation error' do
        let (:Authorization) { "Bearer #{token}" }
        let (:internet_trouble) {
          {}
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

  path '/api/v1/private/internet_troubles/{id}/edit' do
    put 'Update created internet trouble' do
      tags 'InternetTrouble'
      consumes 'application/json'
      produces 'application/json'
  
      parameter name: :Authorization,
                in: :header,
                type: :string
  
      parameter name: :id,
                in: :path,
                type: :string
  
      parameter name: :internet_trouble,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    trouble: { type: :string },
                    category: { type: :string },
                    status: { type: :string },
                    is_predicted: { type: :boolean }
                  }
                }
  
      response '200', 'Updated' do
        let (:Authorization) { "Bearer #{token}" }
        let (:id) { "#{user.internet_troubles.first.id}" }
        let (:internet_trouble) {
          {
            trouble: 'updated',
            category: 'updated',
            status: 'updated',
            is_predicted: true
          }
        }
  
        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string },
                  internet_trouble: {
                    type: :object,
                    properties: {
                      trouble: { type: :string, nullable: true },
                      status: { type: :string, nullable: true },
                      category: { type: :string, nullable: true },
                      is_predicted: { type: :boolean },
                    }
                  }
                },
                required: [
                  :success,
                  :message,
                  :internet_trouble
                ]
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['internet_trouble']['trouble']).to eq('updated')
          expect(data['internet_trouble']['status']).to eq('updated')
          expect(data['internet_trouble']['category']).to eq('updated')
          expect(data['internet_trouble']['is_predicted']).to eq(true)
        end
      end

      response '400', 'Validation error' do
        let (:Authorization) { "Bearer #{token}" }
        let (:id) { "#{user.internet_troubles.first.id}" }
        let (:internet_trouble) {
          {
            trouble: '',
            category: '',
            status: '',
            is_predicted: ''
          }
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
      
      response '404', 'Not Found' do
        let (:Authorization) { "Bearer #{token}" }
        let (:id) { "#{time.to_i.to_s}" }
        let (:internet_trouble) {
          {
            trouble: '',
            category: '',
            status: '',
            is_predicted: ''
          }
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