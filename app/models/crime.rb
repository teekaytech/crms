class Crime < ApplicationRecord
  belongs_to :user
  has_many :crime_categories
  has_many :categories, through: :crime_categories
  validates :accused, :accuser, :unknown_others, :date, :statements, presence: true, length: { minimum: 3 }

  def update_with_categories(categories, params)
    delete_categories
    create_new_categories(categories)
    update(params)
  end

  def create_with_categories(cat_params)
    save
    create_new_categories(cat_params)
  end

  def create_new_categories(categories)
    categories.each do |cat|
      CrimeCategory.create!(crime_id: id, category_id: cat)
    end
  end

  def delete_categories
    CrimeCategory.where(crime_id: id).destroy_all
  end

end
