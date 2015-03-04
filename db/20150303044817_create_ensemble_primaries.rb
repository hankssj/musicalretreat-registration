drop table ensemble_primaries;
create table ensemble_primaries (id int(11) primary key auto_increment, 
                                 registration_id int(11) not null, 
                                 primary_instrument_id int(11) not null, 
                                 large_ensemble_choice int(11) not null, 
                                 chamber_ensemble_choice int(11) not null, 
                                 ack_no_morning_ensemble tinyint(1),
                                 want_sing_in_chorus tinyint(1),
                                 want_percussion_in_band tinyint(1),
                                 created_at datetime, 
                                 updated_at datetime);

