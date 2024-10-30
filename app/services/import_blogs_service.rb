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
    Rails.logger.info "CSV import completed successfully."
  rescue => e
    Rails.logger.error "Import failed: #{e.message}"
  end

  private

  def parse_csv
    CSV.foreach(@file.to_io, headers: true, encoding: 'utf8') do |row|
      @rows << @user.blogs.new(row.to_h)

      if @rows.size >= @batch_size
        ActiveRecord::Base.transaction do
          insert_rows(@rows)
        end
        @rows.clear
      end
    end
    rescue CSV::MalformedCSVError => e
      Rails.logger.error "CSV Parsing Error: #{e.message}"
  end

  def insert_rows(rows)
    Blog.import(rows)
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Database Insert Error: #{e.message}"
  end
end
