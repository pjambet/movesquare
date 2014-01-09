FactoryGirl.define do
  factory :user do
    token 'XXX'
    refresh_token 'YYY'
    expires_at 1234
  end
end
