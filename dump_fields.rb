def dump_fields(obj)
  puts "#{obj.class} #{obj.id}"
  obj.class.column_names.reject{|c| ['created_at', 'updated_at', 'id'].include?(c)}.each{|f| v = obj.send(f); puts "  #{f} => #{v}" if v}
  nil
end
