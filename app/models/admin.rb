class Admin < ApplicationRecord

    scope :search, -> (key) { Admin.where("words LIKE ?","%"+key+"%") } 

    def index
    end
  
    def user

        scope :search, -> (key) { Admin.where("words LIKE ?","%"+key+"%") } 

    end

    def error
    end
end

