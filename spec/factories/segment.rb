FactoryGirl.define do
  factory :segment do
    lat 40.7028983
    lng -73.91233849999999
    segment_type 'move'
    activity_type 'wlk'
    association :city, factory: :nyc
    association :user
    distance 11
  end
end
