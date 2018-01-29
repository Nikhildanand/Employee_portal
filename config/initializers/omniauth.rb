Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'],
             {scope: 'user_about_me, email, user_birthday, user_hometown, user_posts,user_hometown,user_location'}
end