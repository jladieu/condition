Condition::Application.routes.draw do
  resource :status, :only => [:show, :update]
end
