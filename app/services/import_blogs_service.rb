require 'csv'

class ImportBlogsService
  def initialize(user, file, batch_size: 1000)
    @user = user
    @file = file
    @batch_size = batch_size
    @rows = []
  end

  def import
    parse_csv
    insert_rows(@rows) if @rows.any?
  end

  private

  def parse_csv
    CSV.foreach(@file.to_io, headers: true, encoding: 'utf8') do |row|
      @rows << @user.blogs.new(row.to_h)

      if @rows.size >= @batch_size
        insert_rows(@rows)
        @rows.clear
      end
    end
  end

  def insert_rows(rows)
    Blog.import(rows)
  end
end
