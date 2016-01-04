require 'csv'
require 'pry'

#loads csv file and creates a hash from each row
def load_csv(filename)
  CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
  end
  CSV.new(File.read(filename), 
    :headers => true, 
    :header_converters => :symbol, 
    :converters => [:all, :blank_to_nil]
  ).entries.map { |row| row.to_hash }
	end

#creates a new hash with the column id as the key and an array containing column title and a 
#nested array of the parent hash
def create_column_titles(filename)
column_titles = {}
	
	load_csv(filename).map do |row|
	column_titles[row[:column_id]] =
	row[:column_title],
	column_titles[row[:parent_column_id]]
	end

end

def create_column_id(filename)
	
	load_csv(filename).map do |row|
	row[:column_id]
	end

end

#calls methods with file input

column_titles = create_column_titles('census_column_metadata.csv')

column_id = create_column_id('census_column_metadata.csv')

#creates an array of titles in logical order with snakecase formatting	
processed_titles = column_titles.map { |o|
		o.flatten.compact.reverse.join.downcase.
		gsub(/[^A-Za-z0-9]+/,'_').gsub(/^_/, '').gsub(/_$/, '')
	}

titles = Hash[column_id.zip(processed_titles)]

binding.pry

#########################
# To do
#join the two arrays, make a hash? key = id, value = title?
# Output to a csv with column id | full name


