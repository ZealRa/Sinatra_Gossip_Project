require 'bundler'
Bundler.require
require 'csv'

class Gossip
  attr_reader :id, :author, :content

  @@id_counter = 0

  def initialize(id, author, content)
    @id = id
    @author = author
    @content = content
  end

  def save
    FileUtils.mkdir_p('db') unless File.directory?('db')
    csv_path = "db/gossip.csv"
    @id = next_id(csv_path) if @id.nil?
    CSV.open(csv_path, "ab") do |csv|
      csv << [@id, author, content]
    end
  end

  def self.all
    all_gossips = []
    CSV.read("./db/gossip.csv").each do |csv_line|
      all_gossips << Gossip.new(csv_line[0], csv_line[1], csv_line[2])
    end
    all_gossips
  end

  def self.find(id)
    all_gossips = self.all
    all_gossips.find { |gossip| gossip.id.to_i == id.to_i }
  end

  def update(author, content)
    csv_path = "db/gossip.csv"
    all_gossips = CSV.read(csv_path)
    index = all_gossips.index { |row| row[0].to_i == id.to_i }
    return unless index
  
    all_gossips[index] = [id, author, content]
  
    CSV.open(csv_path, "wb") do |csv|
      all_gossips.each do |row|
        csv << row
      end
    end
  end
  
  def self.update_gossip(id, author, content)
    gossip = find(id)
    return unless gossip

    gossip.update(author, content)
  end

  private

  def next_id(csv_path)
    if File.exist?(csv_path) && !CSV.read(csv_path).empty?
      last_id = CSV.read(csv_path).map { |row| row[0].to_i }.max
      last_id + 1
    else
      1
    end
  end
end
