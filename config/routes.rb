Refuge::Application.routes.draw do

  devise_for :users

  root :to=> "blog#index"

  match '/members/search' => 'members#search', :via=>:post
  match '/members/mail' => 'members#mail_member', :via=>:post

#  match '/admin/occupation' => 'admin#occupation', :via=>:put

  resources :images,   :only => [:index, :create, :destroy]
  resources :surveys,  :only => [:create]
  resources :comments, :only => [:destroy]

  match 'blog/category/:id' => 'blog#show_category', :as => :blog_category, :via => :get
  match 'blog/archives/:year/:month' => 'blog#show_archives', :as => :blog_archives, :via => :get
  resources :blog
  resources :members

  resources :pages
  resources :dashboard

  match 'medias/download/:id' => 'medias#download', :as => :media_download, :via => :get
  resources :medias, :only => [:index, :show, :create]

  namespace :admin do
    resources :conf,            :only => [:index, :create]
    resources :headlines,       :only => [:index, :create]
    resources :stats,           :only => [:index]
    resources :locations,       :only => [:index, :create, :update, :destroy]
    resources :blog_categories, :only => [:index, :create, :update, :destroy]
    resources :ads,             :only => [:index, :create, :update, :destroy]

    match 'medias/media/:id' => 'medias#delete_media', :as => :delete_media, :via => :delete
    resources :medias,     :only => [:index, :create, :update, :destroy] do
      member do
        post :upload_media
      end
    end

    resources :surveys,    :only => [:index, :create, :update, :destroy] do
      member do
        post   :create_answer
        delete :delete_answer
      end
    end
  end

end

