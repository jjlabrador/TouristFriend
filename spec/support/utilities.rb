# encoding: UTF-8
include ApplicationHelper

def full_title(page_title)
  base_title = "TouristFriend"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Contraseña", with: user.password
  click_button "Iniciar sesión"
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: message)
  end
end

def sign_in(user)
  visit signin_path
  fill_in "Email",      with: user.email
  fill_in "Contraseña", with: user.password
  click_button "Iniciar sesión"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end
