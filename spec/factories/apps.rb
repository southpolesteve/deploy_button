# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :app do
    owner 'begriffs'
    name 'lucre'
    user

    factory :app_created_on_heroku do
      deploy_started_at { Time.now - 5.minutes }
      created_on_heroku_at { Time.now - 3.minutes }
      create_response { {"id"=>"7cbc4420-1d23-4919-ab78-66d286b919a6",
       "name"=>"afternoon-brook-7719",
       "tier"=>"legacy",
       "owner"=>
        {"email"=>"southpolesteve+deploybot@gmail.com", "id"=>"73b09bd5-8bc4-4936-8b92-177d5d655c2b"},
       "stack"=>"cedar",
       "region"=>
        {"id"=>"59accabd-516d-4f0e-83e6-6e3757701145", "name"=>"us"},
       "git_url"=>"git@heroku.com:afternoon-brook-7719.git",
       "web_url"=>"http://afternoon-brook-7719.herokuapp.com/",
       "repo_size"=>nil,
       "slug_size"=>nil,
       "created_at"=>"2013-07-28T16:10:43-00:00",
       "updated_at"=>"2013-07-28T16:10:43-00:00",
       "maintenance"=>"false",
       "released_at"=>"2013-07-28T16:10:43-00:00",
       "buildpack_provided_description"=>nil} }
    end
  end
end
