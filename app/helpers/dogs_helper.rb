module DogsHelper
  def current_user_owns_dog?
    @dog.user.present? && @dog.user == current_user
  end
end
