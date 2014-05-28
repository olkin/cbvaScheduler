class Team < ActiveRecord::Base
	has_many :matches
  validates :name, :captain, presence:true
  validates :email, format: { with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/,
                                    message: "format is wrong" },
            allow_nil: true, allow_blank: true
end
