require 'swagger_helper'

RSpec.describe "Api::V1::Public::InternetTroubles", type: :request do
  user = User.create!(
    name: 'Test',
    email: "#{Time.now.to_i.to_s}@tests.com", 
    password: 'password'
  )

  trouble = InternetTrouble.create!(
    user_id: user.id,
    trouble: 'Some trouble'
  )

  path '/api/v1/internet_troubles' do
    post 'Internet Trouble' do
      tags 'InternetTrouble'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :internet_trouble,
                in: :body,
                schema: {
                  type: :object,
                  properties: {
                    email: { type: :string },
                    trouble_id: { type: :int }
                  },
                  required: [
                    :email,
                    :trouble_id
                  ]
                }
      
      response '200', 'Show Internet Trouble' do
        let (:internet_trouble) {
          {
            email: user.email,
            trouble_id: trouble.id
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
          expect(data['internet_trouble']['id']).to eq(trouble.id)
          expect(data['internet_trouble']['trouble']).to eq(trouble.trouble)
        end
      end

      response '404', 'Not Found' do
        let (:internet_trouble) {
          {
            email: user.email,
            trouble_id: Time.now.to_i
          }
        }

        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string }
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
