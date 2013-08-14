# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

#get 'global_roadmap', :to => 'global_roadmap#index'
get '/projects/:project_id/global_roadmap' , :to => "global_roadmap#index", :as => :global_roadmap
