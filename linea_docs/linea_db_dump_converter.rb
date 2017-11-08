# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
abort("Exiting: No filename given.") if ARGV[0].nil? || ARGV[1].nil?

# Get the name of the input file and the name of the file to output.
input_file = ARGV[0]
output_file = ARGV[1]

# keywords == names of the tables
keywords = %w(terms_of_services users subject_areas datasources datasets algorithms columns contributors dataset_algorithms tags dataset_tags dataset_visual_tools like_activities lineages review_activities share_activities newsfeed_items dataset_columns links organizations)

# The beginning is used to find the relevant section that needs to be copied
#
# -- Data for Name: terms_of_services; Type: TABLE DATA; Schema: public; Owner: dochouse
# --
# ...
beginning = '-- Data for Name: '

# We'll put all the lines in an array before writing the file because memory is cheap
lines_to_write = []

# For each keyword
keywords.each do |kw|
  # Line to ensure that the table is empty
  lines_to_write << "DELETE FROM #{kw};"

  # We need to open the file each time because the data sections are presented out of order
  File.open(input_file, 'r') do |f|
    beginning_found = false

    # Iterate over each line
    while line = f.gets
      # Skip the line unless the beginning of the data section has been found
      next unless line.start_with?(beginning + kw) || beginning_found == true

      # SELECT pg_catalog... is the last line that we need from the data section
      if line.start_with?('SELECT pg_catalog.setval')
        beginning_found = false
      else
        beginning_found = true
      end

      lines_to_write << line
    end
  end

  # Add some new lines for spacing/human legibility
  lines_to_write << "\n\n\n"
end

# Write everything to a file
File.open(output_file, 'w') do |fw|
  lines_to_write.each do |l|
    fw.puts l
  end
end
