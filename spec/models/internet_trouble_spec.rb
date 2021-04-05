require 'rails_helper'

RSpec.describe InternetTrouble, type: :model do
  user = User.create!(
    name: 'Test',
    email: "#{Time.now.to_i.to_s}@mail.test",
    password: '12345678'
  )

  subject {
    described_class.new(
      user_id: user.id,
      trouble: 'Some message',
      category: 'Some category',
      status: 'Some status',
      is_predicted: false
    )
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without user id' do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without trouble string' do
    subject.trouble = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with trouble string < 6 chars' do
    subject.trouble = 'abcde'
    expect(subject).to_not be_valid
  end

  it 'is not valid with trouble string > 255 chars' do
    chars = (0...256).map { ('a'..'z').to_a[rand(26)] }.join
    subject.trouble = chars
    expect(subject).to_not be_valid
  end

  it 'is valid without category' do
    subject.category = nil
    expect(subject).to be_valid
  end

  it 'is valid without status' do
    subject.status = nil
    expect(subject).to be_valid
  end

  it 'is valid boolean is_predicted type' do
    subject.is_predicted = true
    expect(subject).to be_valid

    subject.is_predicted = false
    expect(subject).to be_valid
  end
end
