class Episode < ActiveRecord::Base
  belongs_to :tv_show

  validates_uniqueness_of :episode, :scope => :tv_show_id
end
