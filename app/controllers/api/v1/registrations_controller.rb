class Api::V1::RegistrationsController < Devise::RegistrationsController
  # POST /api/v1/signup
  def create
    build_resource(sign_up_params)

    if resource.save
      render json: { message: 'User created successfully', user: resource }, status: :created
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
