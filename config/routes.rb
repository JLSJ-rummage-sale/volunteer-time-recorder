Rails.application.routes.draw do

  root 'welcome#index', as: 'home'

  get 'welcome/index'

  #get 'volunteers/index'

  # Resources: (maps HTTP verbs to Controller actions)

  resources :volunteers do
    # Make time_records a nested resource (ex: volunteers/1/time_records/1):
    resources :time_records;

    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  resources :events do
    # Make time_records a nested resource (ex: volunteers/1/time_records/1):
    resources :time_records;

    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  resources :time_records do
    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  resources :member_types do
    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  resources :planned_shifts do
    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_planned_shift_path".
      get :check_in
      patch :checked_in

      get :check_out
      patch :checked_out
    end
  end

  resources :categories do
    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  resources :quotas do
    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  resources :spreadsheets do
    collection { post :import }
    
    member do
      get :delete # Add delete action; not added by default in Rails.
          # This lets us use "delete_volunteer_path".
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
