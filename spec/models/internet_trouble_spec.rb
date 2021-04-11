require 'rails_helper'

RSpec.describe InternetTrouble, type: :model do
  user = User.create!(
    name: 'Test',
    email: "#{Time.now.to_i.to_s}@mail.test",
    password: '12345678'
  )

  trouble = described_class.create(
    user_id: user.id,
    trouble: 'Some message',
    category: 'Some category',
    status: 'Some status',
    is_predicted: false
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

  it 'can update trouble data' do
    new_trouble = 'new trouble'
    trouble.trouble = new_trouble
    trouble.save!
    expect(described_class.find(trouble.id).trouble).to eq(new_trouble)
  end

  it 'can update category data' do
    new_category = 'new category'
    trouble.category = new_category
    trouble.save!
    expect(described_class.find(trouble.id).category).to eq(new_category)
  end
  
  it 'can update status data' do
    new_status = 'new status'
    trouble.status = new_status
    trouble.save!
    expect(described_class.find(trouble.id).status).to eq(new_status)
  end
  
  it 'can update is_predicted data' do
    new_is_predicted = true
    trouble.is_predicted = new_is_predicted
    trouble.save!
    expect(described_class.find(trouble.id).is_predicted).to eq(new_is_predicted)
  end
end
