FactoryGirl.define do
  factory :city, class: Location do
    location_type :city

    factory :nyc do
      lat 40.7028983
      lng -73.91233849999999
      slug 'new york'
      name 'New York'
    end

    factory :bdx do
      lat 44.83175929999999
      lng -0.5697435
      slug 'bordeaux'
      name 'Bordeaux'
      location_type 'city'
    end
  end
end
