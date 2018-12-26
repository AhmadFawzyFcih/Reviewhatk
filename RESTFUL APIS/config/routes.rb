Rails.application.routes.draw do
#***************************************************# 
  devise_for :users, 
              path: '',
              path_names: {
                sign_in: 'login',
                registration: 'register',
                sign_out: 'logout'
              },
              controllers: {
                sessions: 'sessions',
                registrations: 'registrations'
              }
#***************************************************# 
  namespace 'api' do
    namespace 'v1' do
      
      resources :categories , only: [:index]

      get '/my_reviews', to: 'reviews#my_reviews'
      get '/top_trusted', to: 'review_reactions#top_trusted'
      resources :reviews , only: [:index, :create, :show, :destory]  do
        member do
          delete :destroy
        end
      end
      
      get '/me/reacted_reviews/:react_type', to: 'review_reactions#reacted_reviews_by_me'
      post '/react', to: 'review_reactions#make_reaction'
      post '/share_review', to: 'review_reactions#share_review'
      
    end
  end
#***************************************************# 
end
