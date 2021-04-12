require 'swagger_helper'

include JsonWebToken

RSpec.describe "Api::V1::Private::Admins", type: :request do
  
  admin = User.create!(
    name: 'Admin',
    email: "#{Time.now.to_i.to_s}@admin.com",
    password: 'password',
    role: 'admin'
  )

  user = User.create!(
    name: 'User test',
    email: "#{Time.now.to_i.to_s}@user#{Time.now.to_i.to_s}.com",
    password: 'password'
  )

  trouble = InternetTrouble.create!(
    user_id: user.id,
    trouble: 'created trouble'
  )

  token = JsonWebToken.encode(
    JsonWebToken.payload(admin.id)
  )
  
  path '/api/v1/private/get_troubles' do
    get 'Internet Troubles' do
      tags 'Admin'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :Authorization,
                in: :header,
                type: :string

      parameter name: :page,
                in: :query,
                type: :string,
                required: false
      
      parameter name: :size,
                in: :query,
                type: :string,
                required: false

      parameter name: :type,
                in: :query,
                type: :string,
                required: false

      response '200', 'Get internet troubles' do
        let (:Authorization) { "Bearer #{token}" }

        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string },
                  page: { type: :integer },
                  size: { type: :integer },
                  internet_troubles: { type: :array }
                },
                required: [
                  :success,
                  :message,
                  :page,
                  :size,
                  :internet_troubles
                ]
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['page']).to eq(1)
          expect(data['size']).to eq(10)
          expect(data['type']).to eq('all')
        end
      end

      response '403', 'Unauthorized' do
        let (:Authorization) { "Bearer token" }
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
