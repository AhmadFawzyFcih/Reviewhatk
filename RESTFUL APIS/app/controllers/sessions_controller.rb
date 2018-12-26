class SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      render json: [resource] , root: "data"  , status: :ok ,  scope: {'base_url': base_url }, meta: {
        status: true
      } 
    end

    def respond_to_on_destroy
      render json:[{message:'you logged out successfully...!'}] , root: "data"  ,  meta: {status: true} , status: :ok 
    end
end