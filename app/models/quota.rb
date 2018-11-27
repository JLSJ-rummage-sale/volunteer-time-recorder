class Quota < ApplicationRecord
  # Required fields:
  validates :name, presence: true
  validates :hours, presence: true

  # Other methods:

  def category
    category_id = self.category_id;

    if (category_id)
      puts("Category ID found in time_record: " + category_id.to_s);

      category = Category.find_by_id(category_id);

      if (category)
        puts("Category OBJECT found in quota: category: " + category.name);
        return category
      else
        puts("Category OBJECT NOT found in quota: category_id: " + category_id.to_s);
        return nil
      end

    else
      return nil
    end
  end
end
