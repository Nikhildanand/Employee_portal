module EmployeesHelper

  # Returns the Gravatar for the given user.
  def gravatar_for(user, size: 180)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def date_converter(dates)
    birthday = dates.split('/')
    birthday[0], birthday[1] = birthday[1], birthday[0]
    birthday.join('/')
  end
end