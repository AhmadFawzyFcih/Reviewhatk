class RegistrationsController < Devise::RegistrationsController
    
    private
    
    def respond_with(resource, _opts = {})
      render_resource(resource) 
    end

    def sign_up_params
      params.require(:user).permit(:email,:password, :name , :profile)
    end

end