FactoryGirl.define do
  factory :segment do
    lat 40.7028983
    lng -73.91233849999999
    association :city, factory: :nyc
    association :user
    distance 11
  end
end
