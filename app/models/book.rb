class Book < ApplicationRecord

  has_many :comments, foreign_key: 'isbn', primary_key: 'isbn'

  scoped_search on: [:title]
  scoped_search relation: :comments, on: [:comment]

end
