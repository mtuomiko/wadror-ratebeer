FactoryBot.define do
  factory :user do
    username { 'Pekka' }
    password { 'Foobar1' }
    password_confirmation { 'Foobar1' }
  end

  factory :brewery do
    name { 'anonymous' }
    year { 1900 }
  end

  factory :beer do
    name { 'anonymous' }
    style # uses style factory
    brewery # uses brewery factory to create the object
  end

  factory :rating do
    score { 10 }
    beer # uses beer factory
    user # uses user factory
  end

  factory :style do
    name { 'Lager' }
    description { 'Hop flavor is significant and of noble varieties, bitterness is moderate.' }
  end
end
