RegistrationDevelopment::Application.routes.draw do
  get "ensembles/choose"
  get "static/index"
  root 'static#index'

  get "registration/update_participant"
  get "registration/update_meals_selection"
  get "registration/update_dorm_selection"
  get "registration/update_sunday"
  get "registration/update_single_room"
  get "registration/update_tshirts"
  get "registration/update_tshirtm"
  get "registration/update_tshirtl"
  get "registration/update_tshirtxl"
  get "registration/update_tshirtxxl"
  get "registration/update_tshirtxxxl"
  get "registration/update_donation"
  get "registration/update_wine_glasses"
  get "registration/update_payment_mode"

  get "/registration", to: "registration#index"
  get "registration/index"
  get "registration/update"
  post "registration/new_password"
  post "registration/change_password"
  post "registration/login"
  post  "registration/show"
  get  "registration/payment"
  get  "registration/new_password"
  get  "registration/change_password"
  get  "registration/logout"
  get  "registration/confirm_registration"
  get  "registration/done"

  resources :registration

  get "login/change_password"
  post "login/change_password"
  get "login/login"
  get "login/logout"
  post "login/login"
  post "login/logout"

  get "admin", to: "admin#index"

  get "ensembles/primary"
  get "ensembles/chamber"
  post "ensembles/create_electives"
  patch "ensembles/create_chamber"

  get ":controller/:action"
  post ":controller/:action"
end
