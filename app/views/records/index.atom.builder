atom_feed do |feed|
  feed.title("Knowledge Base Records")
  feed.updated @records.collect(&:updated_at).max
  for record in @records
    feed.entry(record) do |entry|
      entry.title record.name
      entry.content("#{record.notes_summary}...", :type => 'text')
      entry.published record.created_at
      entry.updated record.updated_at
    end
  end
end