# drop table preselect_chambers;
# create table preselect_chambers (id int(11) primary key auto_increment, 
#                                  ensemble_primary_id int(11) not null, 
#                                  contact_name varchar(80) not null,
#                                  contact_phone varchar(40) not null,
#                                  name_1 varchar(80) not null,
#                                  instrument_id_1 int not null,
#                                  name_2 varchar(80) not null,
#                                  instrument_id_2 int not null,
#                                  name_3 varchar(80),
#                                  instrument_id_3 int,
#                                  name_4 varchar(80),
#                                  instrument_id_4 int,
#                                  name_5 varchar(80),
#                                  instrument_id_5 int,
#                                  bring_own_music tinyint(1),
#                                  music_name varchar(120),
#                                  music_composer varchar(120)
#                                  created_at datetime, 
#                                  updated_at datetime);

class MmrChamber < ActiveRecord::Base
end
