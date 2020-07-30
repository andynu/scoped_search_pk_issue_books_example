class Comment < ApplicationRecord

  belongs_to :book, foreign_key: 'isbn', primary_key: 'isbn'

end
