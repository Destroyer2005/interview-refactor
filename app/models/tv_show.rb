class TvShow < ActiveRecord::Base
  belongs_to :user
  has_many :episodes

  validates :title, presence: true

  def as_json(options={})
    { :id => self.id, title: title, episodes: episodes.as_json(only: [:id, :title])}
  end
end
