class Appentry

 include Mongoid::Document
 include Mongoid::Timestamps

 field :uid, type: String
 field :story_url, type: String
 field :img_src, type: String
 field :description, type: String
 field :status, type: String
 field :like_count, type: String
 field :comment_count, type: String
 field :share_count, type: String
 field :points, type: String

end
