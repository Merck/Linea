# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'pg'

conn = PG::Connection.open(dbname:  'sampleDatabase_development')

# This first query joins the dataset, dataset_columns, and columns table together resulting in rows that contain
# the dataset id and column info
q1 = "SELECT b.id as dataset_id, b.name AS dataset_name, c.name AS column_name, c.description, c.data_type, \
a.column_alias FROM dataset_columns a LEFT JOIN datasets b ON a.dataset_id = b.id LEFT JOIN columns c ON \
a.column_id = c.id ORDER BY b.id;"
join_res = conn.exec(q1)

# For each row from the results of q1...
join_res.each do |r|
  # Check to see if a table for the dataset exists
  # If not, create a table for that dataset
  q2 = "SELECT * FROM tables WHERE dataset_id = #{r['dataset_id']}"
  row_res = conn.exec(q2)
  if row_res.ntuples == 0
    q3 = "INSERT INTO tables (dataset_id) VALUES (#{r['dataset_id']})"
    conn.exec(q3)
    # Now we need to get to a state where we can get the table id, i.e. we need to
    # run q2 again to get the resulting table from the previous insertion
    row_res = conn.exec(q2)
  end

  # Get the table id that will be used when making the column
  table_id = row_res[0]['id']

  # We need to build query from both ends because some of the columns from the original dataset do not have a data_type
  # and we can't enter an empty string into sql
  q4 = "INSERT INTO columns (name, description, business_name, is_business_key, table_id"
  q4_end = " ) VALUES (\'#{r['column_name']}\', \'#{r['description']}\', \'#{r['column_name']}\', TRUE, #{table_id} "

  unless r['data_type'].length == 0
    q4 += ", data_type"
    q4_end += ", \'#{r['data_type']}\'"
  end

  # Combine the query parts
  q4 = q4 + q4_end + ")"
  # Add in the column
  conn.exec(q4)
end

# This query deletes all of the old columns from the old linea database
conn.exec('DELETE FROM columns WHERE table_id IS NULL;')

# Close the connection
conn.close
