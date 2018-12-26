class UserSerializer < ActiveModel::Serializer
  attributes :id , :email , :name , :profile , :count_reviews , :count_love , :count_disLike

  def profile
   return scope[:base_url]+object.profile.url
  end
end
