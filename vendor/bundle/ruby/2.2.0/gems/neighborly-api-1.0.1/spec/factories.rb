FactoryGirl.define do
  factory :access_token, class: 'Neighborly::Api::AccessToken' do
    user
  end

  factory :category do
    name_pt { "category-#{rand}" }
  end

  factory :project, class: 'Neighborly::Api::Project' do
    about    'a-big-text-about-the-project'
    goal     10_000
    headline 'attractive-headline'
    location 'New York, NY'
    name     'z-project'
    state    :online
    user
    category
  end

  factory :contribution do
    project { create(:project, state: 'online') }
    user
    confirmed_at Time.now
    value 10.00
    state 'confirmed'
    credits false
  end

  factory :tag do
    name    { "subject-#{rand}" }
    visible true
  end

  factory :tag_popular, parent: :tag do
    after(:create) do |resource, evaluator|
      projects = create_list(:project, 4, state: :online)
      projects.map do |project|
        project.tags << resource
        project.save
      end
    end
  end

  factory :user do
    name         'Joãozinho'
    password     'right-password'
    email        { "person#{rand}@example.com" }
    confirmed_at { Time.now }
  end

  factory :channel do
    user { create(:user, profile_type: 'channel') }
    name 'Test'
    description 'Lorem Ipsum'
    sequence(:permalink) { |n| "#{n}-test-page" }
    state 'online'
  end

  factory :channel_member do
    user
    channel
  end

  factory :press_asset do
    title 'Lorem'
    url 'http://lorem.com'
    image File.open("#{Neighborly::Api::Engine.root}/spec/fixtures/image.png")
  end

  factory :reward do
    project
    title 'Awesome Foo Bar'
    minimum_value 10.00
    description 'Foo bar'
    days_to_delivery 10
  end
end
