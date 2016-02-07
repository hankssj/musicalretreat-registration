drop table if exists mmrtest.users;
create table users like mmrdev.users;
insert into mmrtest.users select * from mmrdev.users;

drop table if exists mmrtest.registrations;
create table registrations like mmrdev.registrations;
insert into mmrtest.registrations select * from mmrdev.registrations;

drop table if exists mmrtest.payments;
create table payments like mmrdev.payments;
insert into mmrtest.payments select * from mmrdev.payments;

