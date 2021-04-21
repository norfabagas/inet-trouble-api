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
                  total_page: { type: :integer },
                  total_size: { type: :integer },
                  internet_troubles: { 
                    type: :array,
                    items: {
                      properties: {
                        id: { type: :integer },
                        user_id: { type: :integer },
                        trouble: { type: :string },
                        status: { type: :string, nullable: true },
                        category: { type: :string, nullable: true },
                        is_predicted: { type: :boolean },
                        created_at: { type: :string },
                        updated_at: { type: :string },
                        is_read_by_admin: { type: :string, nullable: true }
                      }
                    } 
                  }
                },
                required: [
                  :success,
                  :message,
                  :page,
                  :size,
                  :total_page,
                  :total_size,
                  :internet_troubles
                ]
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['success']).to eq(true)
          expect(data['page']).to eq(1)
          expect(data['size']).to eq(5)
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

  path '/api/v1/private/internet_troubles/{id}/edit' do
    put 'Update internet trouble' do
      tags 'Admin'
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
        let (:id) { "#{Time.now.to_i.to_s}" }
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

  path '/api/v1/private/show_trouble/{id}' do
    get 'Show specific trouble' do
      tags 'Admin'
      consumes 'application/json'
      produces 'application/json'
  
      parameter name: :Authorization,
                in: :header,
                type: :string
  
      parameter name: :id,
                in: :path,
                type: :string
  
      response '200', 'Found' do
        let (:Authorization) { "Bearer #{token}" }
        let (:id) { "#{user.internet_troubles.first.id}" }
  
        schema  type: :object,
                properties: {
                  success: { type: :boolean },
                  message: { type: :string },
                  internet_trouble: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
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
          expect(data['internet_trouble']['id']).to eq(user.internet_troubles.first.id)
          expect(data['internet_trouble']['trouble']).to eq(user.internet_troubles.first.trouble)
          expect(data['internet_trouble']['status']).to eq(user.internet_troubles.first.status)
          expect(data['internet_trouble']['category']).to eq(user.internet_troubles.first.category)
          expect(data['internet_trouble']['is_predicted']).to eq(user.internet_troubles.first.is_predicted)
        end
      end
      
      response '404', 'Not Found' do
        let (:Authorization) { "Bearer #{token}" }
        let (:id) { 0 }

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
