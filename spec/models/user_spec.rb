require 'rails_helper'

RSpec.describe User, type: :model do
  # crete a new record first
  user = User.create(email: 'alpha@test.com',
                        name: 'alpha test',
                        password: 'alpha_test')

  # use subject as test material
  subject {
    described_class.new(email: 'test@mail.com',
                        name: 'test',
                        password: 'password')
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without an email' do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with email less than 4 char' do
    subject.email = 'a@b'
    expect(subject).to_not be_valid
  end

  it 'is not valid with email more than 255 chars' do
    chars = (0...256).map { ('a'..'z').to_a[rand(26)] }.join
    subject.email = chars
    expect(subject).to_not be_valid
  end

  it 'is not valid with email that already been taken' do
    subject.email = user.email
    expect(subject).to_not be_valid
  end

  it 'is not valid with invalid email format' do
    subject.email = 'test'
    expect(subject).to_not be_valid
  end

  it 'is not valid without a password' do
    subject.password = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with password less than 6 chars' do
    subject.password = '12345'
    expect(subject).to_not be_valid
  end

  it 'is not valid without a name' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid wit name more than 255 chars' do
    chars = (0...256).map { ('a'..'z').to_a[rand(26)] }.join
    subject.name = chars
    expect(subject).to_not be_valid
  end

  it 'is not accepting numeric name' do
    subject.name = '1234'
    expect(subject).to_not be_valid
  end

  it 'is not accepting alphanumeric name' do
    subject.name = 'abc123'
    expect(subject).to_not be_valid
  end

  it 'is valid with only alphabet name' do
    subject.name = 'test name'
    expect(subject).to be_valid
  end

  it 'can be authenticated' do
    subject.save!
    expect(subject.authenticate_password('password')).to be_valid
  end
end
