atom_feed do |feed|
  feed.title("Knowledge Base Records")
  feed.updated((@records.first.created_at))
  for record in @records
    feed.entry(record) do |entry|
      entry.title(record.name)
      entry.content("#{record.notes_summary}...", :type => 'text')
    end
  end
end