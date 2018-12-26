class User < ApplicationRecord

       has_many :reviews
       # Include default devise modules. Others available are:
       # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
       devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :validatable,
              :database_authenticatable,:jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

       mount_uploader :profile , ProfileUploader

       validates :name, presence: true , length: {maximum: 200}
       validates :profile ,file_size: { less_than_or_equal_to: 1000.kilobytes }, #megabytes or kilobytes
                            file_content_type: { allow: ['image/jpeg', 'image/png' , 'image/jpg'] }
end
