config = Rails::Configuration.new.database_configuration['development']

db = config['database']
user = config['username']
password = config['password']

tables = %w(cancellations cancelled_payments payments registrations users instruments)

filename = 'tmp/db-full.sql'

task :data_save do
  if password
    cmd = "mysqldump -u#{user} -p#{password} -c -t #{db} #{tables.join(' ')} > #{filename}"
  else
    cmd = "mysqldump -u#{user} -c -t #{db} #{tables.join(' ')} > #{filename}"
  end
  system(cmd)
end

task :data_restore do
  if password
    cmd = "mysql #{db} -u#{user} -p#{password} < #{filename}"
  else
    cmd = "mysql #{db} -u#{user} < #{filename}"
  end
  system(cmd)
end
