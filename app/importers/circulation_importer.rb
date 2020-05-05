class CirculationImporter
  include ActiveModel::Model
  attr_accessor :item_identifier, :use_restriction, :circulation_status, :dummy,
    :item_record, :result, :action

  def self.import(csv, **options)
    entries = []
    CSV.foreach(csv, encoding: 'UTF-8', headers: true, col_sep: "\t") do |row|
      entry = CirculationImporter.new(
        item_identifier: row['item_identifier'],
        use_restriction: row['use_restriction'],
        circulation_status: row['circulation_status'],
        dummy: row['dummy'],
        action: options[:action]
      )
      
      entry.import unless entry.dummy.present?
      entry.result = :skipped unless entry.result

      entries << entry
    end

    entries
  end

  def import
    return if dummy.present?
    self.item_record = find_by_item_identifier
    return unless item_record

    case action
    when 'create'
      create
    when 'update'
      update
    end
  end

  private

  def create
    import_use_restriction
    import_circulation_status
  end

  def update
    import_use_restriction
    import_circulation_status
  end

  def find_by_item_identifier
    return if item_identifier.blank?
    item = Item.find_by(item_identifier: item_identifier.strip)
  end

  def import_use_restriction
    record = UseRestriction.find_by(name: use_restriction.strip)
    if record
      self.item_record.update!(use_restriction: record)
      self.result = :imported
    else
      self.result = :skipped
    end
  end

  def import_circulation_status
    record = CirculationStatus.find_by(name: circulation_status.strip)
    if record
      self.item_record.update!(circulation_status: record)
      self.result = :imported
    else
      self.result = :skipped
    end
  end
end
