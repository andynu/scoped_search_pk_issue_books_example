# Scoped Search Issue Toy Example

Given the two model definitions scoped search generates incorrect sql.

    class Book < ApplicationRecord

      has_many :comments, foreign_key: 'isbn', primary_key: 'isbn'

      scoped_search on: [:title]
      scoped_search relation: :comments, on: [:comment]

    end


    class Comment < ApplicationRecord

      belongs_to :book, foreign_key: 'isbn', primary_key: 'isbn'

    end


Now in the console:

    > Book.search_for('test').to_sql

Which returns:

       SELECT "books"."id" AS t0_r0, "books"."isbn" AS t0_r1, "books"."title" AS t0_r2, "books"."created_at" AS t0_r3, 
        "books"."updated_at" AS t0_r4, "comments"."id" AS t1_r0, "comments"."isbn" AS t1_r1, "comments"."comment" AS t1_r2, 
        "comments"."created_at" AS t1_r3, "comments"."updated_at" AS t1_r4 
       FROM "books" 
       LEFT OUTER JOIN "comments" ON "comments"."isbn" = "books"."isbn" 
       WHERE (("books"."title" LIKE '%test%' OR "books"."id" IN (SELECT "isbn" FROM "comments" WHERE "comments"."comment" LIKE '%test%' )))

Specifically in the where clause the books.id vs comments.isbn comparison is invalid.

This traces back to the [ScopedSearch::QueryBuilder line 232](https://github.com/wvanbergen/scoped_search/blob/master/lib/scoped_search/query_builder.rb#L232) where it always chooses the classes primary key, without consideration of the assoiation's override.

I propose that we add consideration of the has_many's :primary_key option. I'll be happy to provide a PR to that effect as soon as I pinpoint how to do that lookup; Any pointers in that direction would be welcome.

