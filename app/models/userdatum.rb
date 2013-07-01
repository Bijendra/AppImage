class Userdatum

 include Mongoid::Document
 include Mongoid::Timestamps

 field :uid, type: String
 field :name, type: String
 field :email, type: String

end
