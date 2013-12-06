SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for charges
-- ----------------------------
CREATE TABLE `charges` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `year` varchar(255) NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for instruments
-- ----------------------------
CREATE TABLE `instruments` (
  `id` int(11) NOT NULL auto_increment,
  `display_name` varchar(255) NOT NULL,
  `closed` tinyint(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for registrations
-- ----------------------------
CREATE TABLE `registrations` (
  `id` int(11) NOT NULL auto_increment,
  `year` varchar(4) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `street1` varchar(255) default NULL,
  `street2` varchar(255) default NULL,
  `city` varchar(255) default NULL,
  `state` varchar(255) default NULL,
  `zip` varchar(255) default NULL,
  `primaryphone` varchar(255) default NULL,
  `secondaryphone` varchar(255) default NULL,
  `emergency_contact_name` varchar(255) default NULL,
  `emergency_contact_phone` varchar(255) default NULL,
  `firsttime` tinyint(1) default '0',
  `mailinglist` tinyint(1) default '1',
  `donotpublish` tinyint(1) default '0',
  `dorm` tinyint(1) default '1',
  `share_housing_with` varchar(255) default NULL,
  `meals` tinyint(1) default '1',
  `vegetarian` tinyint(1) default '0',
  `gender` varchar(255) default 'F',
  `participant` tinyint(1) default '1',
  `instrument_id` int(11) default NULL,
  `monday` tinyint(1) default '0',
  `tshirtm` int(11) default '0',
  `tshirtl` int(11) default '0',
  `tshirtxl` int(11) default '0',
  `tshirtxxl` int(11) default '0',
  `discount` tinyint(1) default '0',
  `donation` int(11) NOT NULL default '0',
  `comments` text,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `fk_registrations_user_id` (`user_id`),
  CONSTRAINT `fk_registrations_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for schema_info
-- ----------------------------
CREATE TABLE `schema_info` (
  `version` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for sessions
-- ----------------------------
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL auto_increment,
  `session_id` varchar(255) default NULL,
  `data` text,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Table structure for users
-- ----------------------------
CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(255) NOT NULL,
  `admin` tinyint(1) default '0',
  `hashed_password` varchar(255) default NULL,
  `salt` varchar(255) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records 
-- ----------------------------
INSERT INTO `charges` VALUES ('1', 'Registration', '2007', '125.00');
INSERT INTO `charges` VALUES ('2', 'Tuition', '2007', '320.00');
INSERT INTO `charges` VALUES ('3', 'Dorm', '2007', '125.00');
INSERT INTO `charges` VALUES ('4', 'Meals', '2007', '180.00');
INSERT INTO `charges` VALUES ('5', 'Monday Arrival', '2007', '50.00');
INSERT INTO `charges` VALUES ('6', 'Tshirts', '2007', '20.00');
INSERT INTO `charges` VALUES ('7', 'Discount', '2007', '-50.00');
INSERT INTO `charges` VALUES ('8', 'Registration', '2008', '125.00');
INSERT INTO `charges` VALUES ('9', 'Tuition', '2008', '330.00');
INSERT INTO `charges` VALUES ('10', 'Dorm', '2008', '135.00');
INSERT INTO `charges` VALUES ('11', 'Meals', '2008', '185.00');
INSERT INTO `charges` VALUES ('12', 'Monday Arrival', '2008', '50.00');
INSERT INTO `charges` VALUES ('13', 'Tshirts', '2008', '20.00');
INSERT INTO `charges` VALUES ('14', 'Discount', '2008', '-50.00');
INSERT INTO `instruments` VALUES ('1', 'Voice - Soprano', '0');
INSERT INTO `instruments` VALUES ('2', 'Voice - Alto', '0');
INSERT INTO `instruments` VALUES ('3', 'Voice - Tenor', '0');
INSERT INTO `instruments` VALUES ('4', 'Voice - Baritone', '0');
INSERT INTO `instruments` VALUES ('5', 'Voice - Bass', '0');
INSERT INTO `instruments` VALUES ('6', 'Violin', '0');
INSERT INTO `instruments` VALUES ('7', 'Viola', '0');
INSERT INTO `instruments` VALUES ('8', 'Cello', '0');
INSERT INTO `instruments` VALUES ('9', 'Double Bass', '0');
INSERT INTO `instruments` VALUES ('10', 'Piccolo', '0');
INSERT INTO `instruments` VALUES ('11', 'Flute', '0');
INSERT INTO `instruments` VALUES ('12', 'Oboe', '0');
INSERT INTO `instruments` VALUES ('13', 'English Horn', '0');
INSERT INTO `instruments` VALUES ('14', 'Bassoon', '0');
INSERT INTO `instruments` VALUES ('15', 'Clarinet', '0');
INSERT INTO `instruments` VALUES ('16', 'Bass Clarinet', '0');
INSERT INTO `instruments` VALUES ('17', 'Saxophone', '0');
INSERT INTO `instruments` VALUES ('18', 'Saxophone - Soprano', '0');
INSERT INTO `instruments` VALUES ('19', 'Saxophone - Alto', '0');
INSERT INTO `instruments` VALUES ('20', 'Saxophone - Tenor', '0');
INSERT INTO `instruments` VALUES ('21', 'Saxophone - Baritone', '0');
INSERT INTO `instruments` VALUES ('22', 'Trumpet', '0');
INSERT INTO `instruments` VALUES ('23', 'French Horn', '0');
INSERT INTO `instruments` VALUES ('24', 'Trombone', '0');
INSERT INTO `instruments` VALUES ('25', 'Trombone - Bass', '0');
INSERT INTO `instruments` VALUES ('26', 'Euphonium', '0');
INSERT INTO `instruments` VALUES ('27', 'Tuba', '0');
INSERT INTO `instruments` VALUES ('28', 'Percussion', '0');
INSERT INTO `instruments` VALUES ('29', 'Snare Drum', '0');
INSERT INTO `instruments` VALUES ('30', 'Mallets', '0');
INSERT INTO `instruments` VALUES ('31', 'Timpani', '0');
INSERT INTO `instruments` VALUES ('32', 'Harp', '0');
INSERT INTO `instruments` VALUES ('33', 'Organ', '0');
INSERT INTO `instruments` VALUES ('34', 'Piano', '0');
INSERT INTO `instruments` VALUES ('35', 'Guitar', '0');
INSERT INTO `registrations` VALUES ('1', '2007', '3', 'Steve', 'Hanks', '4421A 44th Ave SW', '', 'Seattle', 'WA', '98116', '206-932-5796', '', null, null, '0', '1', '0', '1', 'Alan Shaw', '1', '0', 'M', '0', null, '0', '0', '1', '0', '0', '0', '0', null, '2007-12-08 11:08:08');
INSERT INTO `registrations` VALUES ('2', '2007', '4', 'Gennie', 'Winkler', '3813 NE 190th Pl', '', 'Lake Forest Park', 'WA', '98155', '206 324 6689', '206 852 6574', null, null, '0', '0', '0', '0', '', '1', '0', 'F', '1', '6', '0', '0', '0', '0', '1', '0', '0', 'Hi Tricia...don\'t want to be wait-listed! Gennie', '2007-12-08 11:08:09');
INSERT INTO `registrations` VALUES ('3', '2007', '5', 'Dona', 'McAdam', '119 Crockett Street', '', 'Seattle', 'WA', '98109', '206-282-7679', '', null, null, '0', '0', '0', '0', '', '1', '1', 'F', '1', '11', '0', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:09');
INSERT INTO `registrations` VALUES ('4', '2007', '6', 'Joe', 'Boyd', '6620 SW Lombard Ave', '', 'Beaverton', 'OR', '97008', '(503) 646-4412', '(503) 703-4298', null, null, '0', '1', '0', '1', 'Marty Deer', '1', '0', 'M', '1', '4', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:09');
INSERT INTO `registrations` VALUES ('5', '2007', '7', 'Charlotte', 'Byers', '8217 19th Ave NE', '', 'seattle', 'WA', '98115', '206 522-9778', '', null, null, '1', '1', '0', '1', '', '1', '0', 'F', '1', '8', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:09');
INSERT INTO `registrations` VALUES ('6', '2007', '8', 'Martha', 'Nester', '9534 Lakeshore Blvd. NE', '', 'Seattle', 'WA', '98115', '206-527-8863', '206-527-8863', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '8', '1', '1', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:09');
INSERT INTO `registrations` VALUES ('7', '2007', '9', 'Michelle', 'Wilcox', '5031 44th Ave S', '', 'Seattle', 'WA', '98118', '206-725-9252', '206-937-2800', null, null, '0', '0', '0', '1', '', '1', '0', 'F', '1', '32', '1', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:09');
INSERT INTO `registrations` VALUES ('8', '2007', '10', 'Jeffrey', 'Freed', '17716 Densmore Ave. N', '', 'Shoreline', 'WA', '98133-5120', '206-280-5205', '', null, null, '0', '1', '0', '1', '', '1', '1', 'M', '1', '6', '1', '0', '0', '0', '0', '0', '0', 'If possible, I would like to be included in a group with Erica Hamlin (viola) and Charlotte Byers (cello).', '2007-12-08 11:08:10');
INSERT INTO `registrations` VALUES ('9', '2007', '11', 'Jessica', 'Croysdale', '12639 NW Ally Elizabeth Ct.', '', 'Portland', 'OR', '97229', '503-922-3000', '503-975-5915', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '12', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:10');
INSERT INTO `registrations` VALUES ('10', '2007', '12', 'Loretta', 'Tatum', '924 Scripps Drive', '', 'claremont', 'CA', '91711', '909-621-2634', '909-993-7116', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '6', '1', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:10');
INSERT INTO `registrations` VALUES ('11', '2007', '13', 'erica', 'Hamlin', '5148 NE 54th St', '', 'Seattle', 'WA', '98105', '206-729-0408', '206-832-1102', null, null, '0', '1', '0', '1', 'Nason Hamlin', '1', '0', 'F', '1', '7', '0', '1', '0', '0', '0', '0', '0', 'Deposit in the mail today for both Nason and me (but no post office because of President Ford\'s funeral.)', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('12', '2007', '14', 'Nason', 'Hamlin', '5148 NE 54th St', '', 'Seattle', 'WA', '98105', '206-729-0408', '206-559-8479', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '4', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('13', '2007', '15', 'Mary', 'Budrow', '3662 Kendra Way', '', 'San Jose', 'CA', '95130', '408-244-9095', '408-315-5751', null, null, '0', '1', '0', '1', 'Karen Tyree, French Horn', '1', '0', 'F', '1', '23', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('14', '2007', '16', 'Robert', 'Kremers', '2020 E Lynn St', '', 'Seattle', 'WA', '98112-2620', '206.329.5964', '650.245.0496', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '20', '0', '0', '0', '1', '0', '0', '50', '', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('15', '2007', '17', 'Maureen', 'Kremers', '2020 E Lynn St', '', 'Seattle', 'WA', '98112', '206.329.5964', '650.245.9357', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '2', '0', '0', '1', '0', '0', '0', '50', '', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('16', '2007', '18', 'Gerald', 'Tomory', 'PO Box 515', '', 'Kalaheo', 'HI', '96741', '808-639-4999', '808-639-4999', null, null, '1', '1', '0', '1', '', '1', '0', 'M', '1', '23', '1', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('17', '2007', '19', 'Virginia', 'Knight', '6319 22nd Ave NW', '', 'Seattle', 'WA', '98107', '206-850-2761', '', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '11', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:11');
INSERT INTO `registrations` VALUES ('18', '2007', '20', 'Morven', 'Balmidiano', '5713 - 285th Ave SE', '', 'Issaquah', 'WA', '98027', '425-222-4839', '425-213-6492', null, null, '0', '1', '0', '1', 'Jeremy Tapp', '1', '0', 'M', '1', '8', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:12');
INSERT INTO `registrations` VALUES ('19', '2007', '21', 'Chris', 'Worswick', '3903 NE 110th St', '', 'Seattle', 'WA', '98125', '206.363.2504', '206.714.3132', null, null, '0', '0', '0', '1', '', '1', '0', 'M', '1', '8', '1', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:12');
INSERT INTO `registrations` VALUES ('20', '2007', '22', 'Jill', 'Bowers', '6549 Fordham Way', '', 'Sacramento', 'CA', '95831', '(916) 475-3568', '(916) 323-1948', null, null, '0', '1', '0', '1', '', '1', '1', 'F', '1', '7', '1', '0', '0', '0', '1', '0', '0', 'I would like a single in Prentiss, Room 234 if possible. I understand that you may not know yet whether any single rooms will be available to MMR participants. My deposit follows by surface mail.  Thank you!', '2007-12-08 11:08:12');
INSERT INTO `registrations` VALUES ('21', '2007', '23', 'JENNIFER', 'WILLMER', '1 SUNNYLAW ROAD  BRIDGE OF ALLAN', 'STIRLINGSHIRE', 'SCOTLAND', 'UK', 'FK9 4QD', '011 44 1786 833767', '07811 359549', null, null, '0', '1', '0', '1', 'PHYLLIS KAIDEN', '1', '0', 'F', '1', '6', '1', '0', '1', '0', '0', '0', '0', 'Dear Tricia,  Would it upset your bookwork proceedures if I paid the full amount for the course:  $820.00. instead of sending a deposit? I won\'t forward my check until I get confirmation from you.  I\'m looking forward to the course, and seeing you all once again. Kind regards, Jennifer.', '2007-12-08 11:08:12');
INSERT INTO `registrations` VALUES ('22', '2007', '24', 'Richard', 'Simon', '733 Bryant Avenue', '', 'Walla Walla', 'WA', '99362', '509-301-4647', '509-525-2126', null, null, '0', '1', '0', '0', '', '1', '0', 'M', '1', '14', '0', '0', '0', '0', '1', '0', '100', '', '2007-12-08 11:08:12');
INSERT INTO `registrations` VALUES ('23', '2007', '25', 'Monica', 'Kidder', '860 Windrose Dr.', '', 'Coupeville,', 'WA', '98239', '(360)678-1807', '360-672-4997', null, null, '1', '1', '0', '1', '', '1', '0', 'F', '1', '9', '0', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('24', '2007', '26', 'Gina Marie', 'Lindsey', '1818 Ontario Pl. NW', '', 'Washington', 'DC', '20009', '202 236-2672', '202 232-0968', null, null, '0', '0', '0', '0', '', '1', '1', 'F', '1', '11', '0', '1', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('25', '2007', '27', 'George', 'Roberts', '14204 177th Ave SE', '', 'Renton', 'WA', '98059', '425-271-1993', '206-498-5668', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '16', '1', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('26', '2007', '28', 'David', 'Greger', '3146 NE 32nd Place', '', 'Portland', 'OR', '97212', '503-281-1713', '503-226-1855', null, null, '0', '0', '0', '1', 'Farwell Perry', '1', '0', 'M', '1', '6', '0', '0', '0', '0', '0', '0', '100', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('27', '2007', '29', 'Terumi', 'Nakagawa', 'P.O BOX  194', '', 'Koloa', 'Hi', '96756', '808-635-4450', '', null, null, '1', '1', '0', '1', 'Gerald Tomory', '1', '1', 'F', '1', '6', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('28', '2007', '30', 'Terry', 'Cook', '3508 W Government Way', '', 'Seattle', 'WA', '98199', '(206)691-3630', '(206)228-5172', null, null, '0', '0', '0', '1', '', '1', '0', 'F', '1', '8', '0', '0', '0', '0', '0', '0', '50', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('29', '2007', '31', 'Joan', 'Levers', '2024 SW Howards Way, #502', '', 'Portland', 'OR', '97201', '503-241-7125', '', null, null, '1', '1', '0', '1', 'David Manhart', '1', '0', 'F', '1', '2', '0', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:13');
INSERT INTO `registrations` VALUES ('30', '2007', '32', 'David', 'Manhart', '2024 SW Howards Way, #502', '', 'Portland', 'OR', '97201', '503-241-7125', '', null, null, '1', '0', '0', '1', 'Joan Levers', '1', '0', 'M', '1', '3', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:14');
INSERT INTO `registrations` VALUES ('31', '2007', '33', 'John', 'Edwards', '5747 60th Ave NE', '', 'Seattle', 'WA', '98105', '206 525 4137', '', null, null, '0', '1', '0', '1', 'Dexter Day', '1', '0', 'M', '1', '5', '1', '0', '0', '0', '0', '0', '20', '', '2007-12-08 11:08:14');
INSERT INTO `registrations` VALUES ('32', '2007', '34', 'Douglas', 'Potter', '2155 N 128th St', '', 'Seattle', 'WA', '98133', '(206) 362-5521', '425-706-4932', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '15', '1', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:14');
INSERT INTO `registrations` VALUES ('33', '2007', '35', 'Susan', 'Zell', '6717 Cleopatra PL NW', '', 'Seattle', 'Wa', '98117', '206-783-4336', '', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '8', '1', '0', '1', '0', '0', '0', '0', 'Hi Trish, I am signing up on paper.  I don\'t have the money right now for the registration fee.  January is the worst time for me, between taxes and a spring show booth fee.  I would like to be in Prentis in the late night wing.  Second choice is Douglas on the shady side of the first floor, preferably private.  I have not gotten a room mate as yet for Prentis.  If you see someone who needs one, like Michele, I would be happy with anyone.  If I kneed to put money down to hold my place, perhaps we can negotiate an amount.  Thanks, Tricia.  I will abide by your decisions.  Hope you are doing well.  Suecello', '2007-12-08 11:08:14');
INSERT INTO `registrations` VALUES ('34', '2007', '36', 'Roy', 'Sillence', '7508  28thNE', '', 'Seattle', 'WA', '98115-4636', '(206) 526-7295', 'n/a', null, null, '0', '1', '0', '1', 'Kirk Fay', '1', '0', 'M', '1', '15', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:14');
INSERT INTO `registrations` VALUES ('35', '2007', '37', 'Molly', 'Mowat', '824 Shoshone Drive', '', 'LaConner', 'WA', '98257', '360  982  4131', '360 770 4877', null, null, '0', '1', '0', '1', 'Carolyn Moloney', '1', '0', 'F', '1', '8', '1', '0', '1', '0', '0', '0', '50', 'If available, I would appreciate being housed in Prentiss Hall.  A double room on the back side of the building would be wonderful (the bell kept me awake) Please note that my address has changed from last year.  Thank you!  Molly', '2007-12-08 11:08:15');
INSERT INTO `registrations` VALUES ('36', '2007', '38', 'Carolyn', 'Moloney', '2557 35th Ave W', '', 'Seattle', 'WA', '98199', '206 285 9163', '', null, null, '0', '1', '0', '1', 'Molly Mowat', '1', '0', 'F', '1', '8', '1', '0', '0', '0', '0', '0', '10', 'Request for Prentiss Hall as last year due to air conditioning/location. Molly Mowat as roomate.', '2007-12-08 11:08:15');
INSERT INTO `registrations` VALUES ('37', '2007', '39', 'Kathleen', 'Farrington', '7816 40th Street NW', '', 'Gig Harbor', 'WA', '98335', '253.265.2571', '253.678.9149', null, null, '1', '1', '0', '0', '', '0', '0', 'F', '1', '15', '1', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:15');
INSERT INTO `registrations` VALUES ('38', '2007', '40', 'Fredericka', 'Hoeveler', '5835 NE 31st Avenue', '', 'Portland', 'OR', '97211', '503-493-9529', '503-891-9529', null, null, '1', '1', '0', '1', '', '1', '0', 'F', '1', '12', '0', '1', '0', '0', '0', '0', '0', 'I would also like to register as a voice student for mezzosoprano/ alto.  I sing with Melody Boyce in ORS in Portland, and I am studying voice as well as oboe.', '2007-12-08 11:08:15');
INSERT INTO `registrations` VALUES ('39', '2007', '41', 'Richard', 'Carr', '9100 NE 30th Ave.', '', 'Vancouver', 'WA', '98665', '360-574-8386', '503-418-5685', null, null, '1', '1', '1', '1', '', '1', '0', 'M', '1', '22', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:15');
INSERT INTO `registrations` VALUES ('40', '2007', '42', 'Gay', 'Jungemann', '27415 94th Ave. S.W.', '', 'Vashon', 'WA', '98070', '206-463-5193', '206-715-6563', null, null, '1', '1', '0', '0', '', '1', '0', 'F', '1', '3', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:15');
INSERT INTO `registrations` VALUES ('41', '2007', '43', 'Edna', 'Dam', '14035 - 107th Way SW', '', 'Vashon', 'WA', '98070', '(206) 567-5279', '', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '2', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:16');
INSERT INTO `registrations` VALUES ('42', '2007', '44', 'george', 'sale', '5801 battle point', '', 'bainbridge', 'wa', '98110', '206 842 7872', '206 288 1352', null, null, '0', '1', '0', '1', 'Ed Sale', '1', '0', 'F', '1', '6', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:16');
INSERT INTO `registrations` VALUES ('43', '2007', '45', 'Lynn', 'Morgan', '25752 Gold Beach Dr. SW', '', 'Vashon', 'WA', '98070', '206 463-5220', '206 930-2352', null, null, '1', '1', '0', '0', '', '1', '0', 'F', '1', '2', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:16');
INSERT INTO `registrations` VALUES ('44', '2007', '46', 'Claric', 'Nash', '12215 Ridgepoint Cir NW', '', 'Silverdale', 'WA', '98383', '360.698.9368', '360.990.3648', null, null, '0', '1', '0', '0', '', '1', '0', 'F', '1', '17', '1', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:16');
INSERT INTO `registrations` VALUES ('45', '2007', '47', 'Bob', 'Nash', '12215 Ridgepoint Cir NW', '', 'Silverdale', 'WA', '98383', '360.698.9368', '360.990.7821', null, null, '0', '0', '0', '0', '', '1', '0', 'M', '1', '28', '1', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:16');
INSERT INTO `registrations` VALUES ('46', '2007', '48', 'john', 'vasko', '19411 NE 43rd Pl.', '', 'Sammamish', 'WA', '98074', '(425) 868-8540', '206-817-5274', null, null, '0', '0', '0', '1', '', '1', '0', 'M', '1', '12', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:16');
INSERT INTO `registrations` VALUES ('47', '2007', '49', 'Frank', 'Kenny', '2335 SW Briggs Rd Apt 12', '', 'Beaverton', 'OR', '97005', '503-641-8547', '', null, null, '1', '1', '0', '1', '', '1', '0', 'M', '1', '14', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:17');
INSERT INTO `registrations` VALUES ('48', '2007', '50', 'Phyllis', 'Kaiden', 'P.O. Box 1738', '', 'Vashon', 'WA', '98070', '206-463-3810', '206-251-8943', null, null, '0', '1', '0', '1', 'Jennifer Wilmer', '1', '1', 'F', '1', '7', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:17');
INSERT INTO `registrations` VALUES ('49', '2007', '51', 'Leroy', 'Searle', '6273 19th Ave NE', '', 'Seattle', 'WA', '98115', '206 409 8878', '206 5274642', null, null, '0', '1', '0', '1', '', '1', '0', 'M', '1', '22', '1', '0', '0', '0', '1', '0', '25', '', '2007-12-08 11:08:17');
INSERT INTO `registrations` VALUES ('50', '2007', '52', 'James', 'Boardman', '10619 SW Cowan Rd', '', 'Vashon', 'WA', '98070', '206-567-5040', '206-999-2897', null, null, '0', '1', '0', '1', 'Rick Skillman or Stan Merrill', '1', '0', 'M', '1', '5', '1', '0', '0', '1', '0', '0', '25', '', '2007-12-08 11:08:17');
INSERT INTO `registrations` VALUES ('51', '2007', '53', 'dennis', 'latham', '1245 Judge Place', '', 'Victoria', 'bc', 'v8p2c7', '250-385-7104', '', null, null, '0', '1', '0', '1', '', '1', '0', 'M', '1', '26', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:17');
INSERT INTO `registrations` VALUES ('52', '2007', '54', 'jan', 'Doyle', '2668 Mexeye Loop', 'C', 'Coos Bay', 'OR', '97440', '541 888 5037', '541 34724415', null, null, '1', '1', '0', '1', '', '1', '0', 'F', '1', '11', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:17');
INSERT INTO `registrations` VALUES ('53', '2007', '55', 'Barbara', 'Saur', '353 Wallace Way NE, #15', '', 'Bainbridge Island', 'WA', '98110', '206.780.5451', '206.384.6724', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '1', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:18');
INSERT INTO `registrations` VALUES ('54', '2007', '56', 'joe', 'BROOKRESON', '396  Thatcher Rd.', '', 'martinsburg', 'wV', '25403', '304 263 2823', '304 263 3367', null, null, '1', '1', '0', '1', 'Susan Brookreson', '1', '0', 'M', '1', '5', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:18');
INSERT INTO `registrations` VALUES ('55', '2007', '57', 'Leo', 'Gilbert', '724A 3rd Pl S', '', 'Kirkland', 'WA', '98033', '206 909-3245', '', null, null, '0', '1', '0', '0', '', '0', '0', 'M', '1', '20', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:18');
INSERT INTO `registrations` VALUES ('56', '2007', '58', 'Mary', 'Ethridge', 'P.O.Box 814', '', 'Coupeville', 'wa', '98239', '360-678-4456', '', null, null, '1', '1', '0', '1', '', '1', '0', 'F', '1', '8', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:18');
INSERT INTO `registrations` VALUES ('57', '2007', '59', 'Sandra', 'Hunt', 'PO Box 1803', '', 'Rogue River', 'OR', '97537', '541-582-0278', '541-660-1070', null, null, '1', '1', '0', '1', '', '1', '0', 'F', '1', '11', '1', '0', '0', '0', '1', '0', '0', '', '2007-12-08 11:08:18');
INSERT INTO `registrations` VALUES ('58', '2007', '60', 'William', 'Haeckler', '1394 Kubli Road', '', 'Grants Pass', 'OR', '97527', '541-846-6812', '', null, null, '1', '1', '0', '1', 'Pamela Haeckler (spouse)', '1', '0', 'M', '1', '11', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:18');
INSERT INTO `registrations` VALUES ('59', '2007', '61', 'Joanna', 'Ryan', '702 18th Ave', '', 'Seattle', 'WA', '98122', '206-324-7923', '', null, null, '1', '1', '0', '1', '', '1', '1', 'F', '1', '2', '1', '1', '0', '0', '0', '0', '0', 'I would like to carpool (a euphemism for have a ride) from Seattle on Monday.  Will this be possible?  I will send deposit ASAP.', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('60', '2007', '62', 'Alan W.', 'Thompson', 'W253S6750 Longview Dr', '', 'Waukesha', 'WI', '53186', '262-662-4654', '414-229-5032', null, null, '0', '1', '0', '1', 'Linda Thompson', '1', '0', 'M', '1', '3', '0', '0', '0', '0', '0', '0', '0', 'Not sure about Monday arrival, depends on transportation arrangements', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('61', '2007', '63', 'Linda G.', 'Thompson', 'W253S6750 Longview Dr', '', 'Waukesha', 'WI', '53186', '262-662-4654', '262-524-7140', null, null, '0', '1', '0', '1', 'Alan Thompson', '1', '0', 'F', '1', '1', '0', '0', '0', '0', '0', '0', '0', 'Not sure about Monday arrival, depends on transportation arrangements.', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('62', '2007', '64', 'ELAINE', 'lAYNE', '249 CORSAIR WAY', '', 'SEAL BEACH', 'CA', '90740', '562 431 7448', '714 835 2336', null, null, '1', '1', '0', '1', 'ANY OTHER ASSIGNED FEMALE FLUTIST', '1', '0', 'F', '1', '11', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('63', '2007', '65', 'Carole', 'Robinson', '2009 Yale Ave East Apt. 203', '', 'Seattle', 'WA', '98102', '206.861.8080', 'none', null, null, '1', '1', '0', '1', 'open', '1', '0', 'F', '1', '28', '1', '0', '0', '0', '0', '0', '0', 'If possible please give me an airconditioned bedroom.', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('64', '2007', '66', 'Sue', 'Raycraft', '3301 Leonard Rd', '', 'Grants Pass', 'OR', '97527', '(541) 474-2091', '(541) 659-3200', null, null, '0', '1', '0', '0', '', '0', '0', 'F', '1', '15', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('65', '2007', '67', 'Glenda', 'Carper', '11740 Burke Ave. N., #2', '', 'Seattle', 'WA', '98133', '206-306-7233', '206-730-7368  cell', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '1', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:19');
INSERT INTO `registrations` VALUES ('66', '2007', '68', 'Alison (A.J.)', 'Newland', '2823 N.W. Golden Drive', '', 'Seattle', 'Wa', '98117', '206-789-4095', '206-567-4454', null, null, '0', '1', '0', '1', 'Ruth Williamson', '1', '0', 'F', '1', '1', '1', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('67', '2007', '69', 'Mary Q.', 'Clark', '4545 Sand Point NE #203', 'Note change of address', 'Seattle', 'WA', '98105', '206 523 1685', '', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '1', '1', '0', '0', '0', '0', '0', '0', 'I did not receive any info from you this year. PLEASE note address change above.  I will mail a registration fee today.  Will you kindly notify me of final date for complete refund if cancellation becomes necessary before you deposit my check? Thanks. Mary Quiatt Clark', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('68', '2007', '70', 'Robert', 'Carson', '3687 West Blakely Avenue', '', 'Bainbridge Island', 'WA', '98110', '206-842-0434', '', null, null, '0', '1', '0', '1', '', '1', '0', 'M', '1', '8', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('69', '2007', '71', 'Donald', 'Schaefer', '2612 S Lamonte St', '', 'Spokane', 'WA', '99203', '(509) 747-2631', '(509) 747-2631', null, null, '1', '1', '0', '1', '', '1', '1', 'M', '1', '11', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('70', '2007', '72', 'Roy', 'Halliday', '37859 3rd St', '', 'Fremont', 'CA', '94536', '510-792-0402', '510-468-7591', null, null, '0', '1', '0', '1', '', '1', '0', 'M', '1', '28', '1', '0', '0', '1', '0', '0', '0', 'Hi Tricia.  check is in the mail.  I hope there are some air conditioned rooms left.  best regards, roy halliday', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('71', '2007', '73', 'Jennifer', 'Williams', '8109 134th Pl. NE', '', 'Redmond', 'WA', '98052', '(425) 881-8435', '', null, null, '0', '0', '0', '1', '', '1', '0', 'F', '1', '11', '1', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('72', '2007', '74', 'Barbara', 'Broad', '12856 Mueller Drive', '', 'Groveland', 'CA', '95321', '209 962-7730', '209 985-7730', null, null, '1', '1', '0', '1', 'Janet Telford', '1', '1', 'F', '1', '2', '1', '1', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:20');
INSERT INTO `registrations` VALUES ('73', '2007', '75', 'John', 'Dimond', '24203 7th Ave SE', '', 'Bothell', 'WA', '98021', '425-806-1479', '', null, null, '0', '0', '0', '1', '', '1', '0', 'M', '1', '14', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:21');
INSERT INTO `registrations` VALUES ('74', '2007', '76', 'Diane', 'Wright', 'P. O. Box 424', '', 'Standard', 'CA', '95373', '209 533 4988', '209 770 4988', null, null, '1', '1', '0', '1', 'Barbara Broad, Janet Telford or Abigail Howard', '1', '0', 'F', '1', '1', '0', '1', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:21');
INSERT INTO `registrations` VALUES ('75', '2007', '77', 'Margaret', 'Davis', '840 Courtney St', '', 'Moscow', 'ID', '83843', '208-874-2809', '208-882-3532', null, null, '1', '1', '1', '1', 'Leslie Wisocki', '1', '0', 'F', '1', '11', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:21');
INSERT INTO `registrations` VALUES ('76', '2007', '78', 'Leslie', 'Wisocki', '840 Courtney St', '', 'Moscow', 'ID', '83843', '208-882-3532', '208-874-2811', null, null, '1', '0', '1', '1', 'Margaret Davis', '1', '0', 'F', '0', null, '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:21');
INSERT INTO `registrations` VALUES ('77', '2007', '79', 'Loren', 'Kayfetz', 'P.O. Box 1324', '', 'Kilauea', 'HI', '96754', '8088286424', '9255707434', null, null, '1', '1', '0', '1', '', '1', '0', 'M', '1', '11', '0', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:21');
INSERT INTO `registrations` VALUES ('78', '2007', '80', 'Eric', 'Klobas', '14351 Bagley Ave N', '', 'seattle', 'WA', '98133', '206 396-2981', '206 362-7245', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '22', '0', '0', '1', '0', '0', '0', '0', 'Orchestra time...;)', '2007-12-08 11:08:22');
INSERT INTO `registrations` VALUES ('79', '2007', '81', 'Abigail', 'Howard', 'PO Box 708', '`3416 Nugget Court', 'Arnold', 'Ca', '95223-0708', '209-795-5315', '209-401-6799', null, null, '1', '1', '0', '1', 'Diane Wright', '1', '0', 'F', '1', '2', '0', '0', '0', '0', '0', '0', '0', '', '2007-12-08 11:08:22');
INSERT INTO `registrations` VALUES ('80', '2007', '82', 'Theresa', 'Stevens', '5941 Farm to Market Rd', '', 'Bow', 'WA', '98232', '(360)766-4117', '(360) 679-5320', null, null, '1', '1', '0', '1', 'Charles Stevens', '1', '0', 'F', '1', '2', '0', '0', '1', '0', '0', '0', '0', '', '2007-12-08 11:08:22');
INSERT INTO `registrations` VALUES ('81', '2007', '83', 'Charles', 'Stevens', '5941 Farm to Market Rd', '', 'Bow', 'WA', '98232', '(360) 766-4117', '(360) 426-7803', null, null, '1', '1', '0', '1', 'Theresa Stevens', '1', '0', 'M', '1', '24', '0', '0', '0', '1', '0', '0', '0', '', '2007-12-08 11:08:22');
INSERT INTO `registrations` VALUES ('82', '2007', '84', 'Sara', 'McPhail', '3044 NW Market St., #4', '', 'Seattle', 'WA', '98107', '206-393-8912', '', null, null, '0', '1', '0', '1', '', '1', '0', 'F', '1', '7', '1', '0', '0', '0', '1', '0', '0', '', '2007-12-08 11:08:22');
INSERT INTO `registrations` VALUES ('83', '2007', '85', 'Margaret', 'Jamison', '822 Newell St.', '', 'Walla Walla', 'WA', '99362', '509 529-2237', '', null, null, '0', '1', '0', '0', '', '0', '0', 'F', '1', '11', '0', '0', '0', '0', '0', '0', '0', 'Please note that I have a new address.', '2007-12-08 11:08:22');
INSERT INTO `schema_info` VALUES ('8');
INSERT INTO `sessions` VALUES ('1', '242b0c3284efadad7da43d56c4caa38b', 'BAh7CToRb3JpZ2luYWxfdXJpIgsvYWRtaW46D2xvZ2luX3R5cGU6CmFkbWlu\nOgx1c2VyX2lkaQYiCmZsYXNoSUM6J0FjdGlvbkNvbnRyb2xsZXI6OkZsYXNo\nOjpGbGFzaEhhc2h7AAY6CkB1c2VkewA=\n', '2007-12-08 11:08:22');
INSERT INTO `users` VALUES ('1', 'admin@musicalretreat.org', '1', 'd72086f441abd6cf6702163fa926bc072a3d0108', '323769600.605584637820531');
INSERT INTO `users` VALUES ('2', 'registrar@musicalretreat.org', '1', 'de90d0e48c752322a969142af5c512ebe31a896a', '323283600.461135761298724');
INSERT INTO `users` VALUES ('3', 'hanks@pobox.com', '0', '9fdaf4283c0ceedfeba5405afca96a498d4e654d', '381374900.120788176542366');
INSERT INTO `users` VALUES ('4', 'groupw@rocketwire.net', '0', '508dbc3f0c4de1f0b608ac39de98c9d84b414ed3', '378833100.265683509855538');
INSERT INTO `users` VALUES ('5', 'donamac@mac.com', '0', '134278c8915418e3855812b96077177bd95a23fa', '377583800.939944152246805');
INSERT INTO `users` VALUES ('6', 'joeb@teleport.com', '0', '966d2b4b7b2f3a3dc9b04173ea6cc0722b77e6dd', '376373500.554588842306141');
INSERT INTO `users` VALUES ('7', 'byers345@comcast.net', '0', 'eff8b79a4f8704e0dabba7f77b42939ca4164d0e', '375475100.121230962705362');
INSERT INTO `users` VALUES ('8', 'mtnester@seanet.com', '0', 'bcb886e21e559ef572233199dd8a6050196def2f', '374565700.162873093013154');
INSERT INTO `users` VALUES ('9', 'ivoryharp@juno.com', '0', 'a7c43b290bf22fdd0ba5d41195bd97fc8f315e28', '373699800.704039761448313');
INSERT INTO `users` VALUES ('10', 'stan_byerman@juno.com', '0', '24cbf0b478a15ee8b8e9e24e2a1920589b0f5deb', '372781100.189006592893746');
INSERT INTO `users` VALUES ('11', 'jessicacroysdale@yahoo.cm', '0', '61c3f616e8ab61d69c32afb43fff8e161c6ef022', '371911400.172718087360445');
INSERT INTO `users` VALUES ('12', 'stringsrock@verizon.net', '0', 'e1ddd223c2e9e2367ba9f03cef4c8d0e8672d8f2', '371044300.028719601221724');
INSERT INTO `users` VALUES ('13', 'ehamlin@universityprep.org', '0', '17c2fb2bc5c54ab9a4ceeb57c19d069b015c4b80', '382253600.452261610880025');
INSERT INTO `users` VALUES ('14', 'nhamlin11.@msn.com', '0', 'ff87c89fba4ef9178cc97811b339438e125b8304', '380716900.420965099913673');
INSERT INTO `users` VALUES ('15', 'astock5436@sbcglobal.net', '0', 'a34b25ff48380f5e19e7ae6f2bc8b84082952478', '378858400.212203562678385');
INSERT INTO `users` VALUES ('16', 'rkremers@earthlink.net', '0', '0c8f0608b339faf28d511d9b4ae4aafb9c4a6164', '377800600.579347356248047');
INSERT INTO `users` VALUES ('17', 'mekremers@earthlink.net', '0', '76beeff6aa417d60937883e8c92514fde8c56191', '376756000.867683403710185');
INSERT INTO `users` VALUES ('18', 'g.tomory@gmail.com', '0', '77df6496c87a5617299fde00b8edfc08a993512c', '375663900.0134409864038615');
INSERT INTO `users` VALUES ('19', 'virginia_knight@hotmail.com', '0', '7e355f3326a449a917749d6ad3b4b4d20ff8757b', '374755300.0674312276983264');
INSERT INTO `users` VALUES ('20', 'warmsun06@gmail.com', '0', '0ec3f33a397e4953de1f84fef30e2454fc51ef6e', '373883900.388667695690589');
INSERT INTO `users` VALUES ('21', 'chris.worswick@comcast.net', '0', 'fc8fd0b76602b0898d769cb53eaca13f416f12ec', '372965500.466824761213633');
INSERT INTO `users` VALUES ('22', 'jill.bowers@doj.ca.gov', '0', 'b6acda12693aadae84036ab80bc0ca5b68749d65', '372099400.0512820849670373');
INSERT INTO `users` VALUES ('23', 'jenny@jwillmer.fslife.co.uk', '0', '966eb3adb0823c674c7c1b666488bd6e94fc3a1b', '371225600.282002346628028');
INSERT INTO `users` VALUES ('24', 'simori@charter.net', '0', '2a5ee0ffe2e3ea92a5b7ff80276305623bd63a44', '382365400.401011128142271');
INSERT INTO `users` VALUES ('25', 'mkidder@ohsd.net', '0', '0a5126b4d290205178bb110eed975bed9b8e5859', '380841100.760628594936518');
INSERT INTO `users` VALUES ('26', 'ginamer04@yahoo.com', '0', 'd63d3cc6cd6d2a63da8784f9be057dfee787add3', '379010200.815204756641306');
INSERT INTO `users` VALUES ('27', 'georoberts@comcast.net', '0', '921ab4f1f4568b0cd11769de403307b0583ced29', '377889300.328005491420682');
INSERT INTO `users` VALUES ('28', 'dcecgreger@aol.com', '0', 'ba2723be9a87cec69badfa891ee95080f6080f42', '376849800.579611722665785');
INSERT INTO `users` VALUES ('29', 'nekoviolin@gmail.com', '0', '2c3c9eedc6cd658ce5ae5208c8d9587d0c673d5e', '375738200.78911039836739');
INSERT INTO `users` VALUES ('30', 'tacoook@hotmail.com  (3 o\'s)', '0', 'cdd422a06979a70af8b130afb2670ad0bc867f3b', '374829200.725113608529564');
INSERT INTO `users` VALUES ('31', 'levershart@comcast.net', '0', '920d7d7526077e6ae8a65c4ea80d965a80c90606', '373963000.0118616493650849');
INSERT INTO `users` VALUES ('32', 'dmanhart@tnc.org', '0', '6049eb0a9db5ec321440f2879c2ced5fd1b4f5ba', '373042900.163500316875266');
INSERT INTO `users` VALUES ('33', 'hardsnow@u.washington.edu', '0', '8fa20a6289bacc228b4874a331b84e62c3e7ae80', '372176500.637279222781324');
INSERT INTO `users` VALUES ('34', 'doug@conicwave.net', '0', 'ac917ecef35b99de81c41aa267ec59363dd24c04', '371309000.18346245488377');
INSERT INTO `users` VALUES ('35', 'szell41534@aol.com', '0', '1b5c6bcb8d78058265bbbb05a857c5234076a3de', '382674500.891899904450553');
INSERT INTO `users` VALUES ('36', 'royzee2000@hotmail.com', '0', '7e6be3eaf12c97303ab896a54450abb811a3094a', '381094400.649125897859888');
INSERT INTO `users` VALUES ('37', 'mmowat3885@aol.com', '0', '9d53c0f7c3dc5491cb2f1189aad80a81fcf92923', '379120900.554128293546232');
INSERT INTO `users` VALUES ('38', 'moloneyc@comcast.net', '0', '3f2a40d224102b88e9142aefbb95d6bd653e9e6e', '378048500.625068539588352');
INSERT INTO `users` VALUES ('39', 'kfarring@harbornet.com', '0', 'fdf53145d57f2167d81a327a4a065652a6122f6b', '376947200.465979961274773');
INSERT INTO `users` VALUES ('40', 'krishoevelerpsyd@comcast.net', '0', 'fbbe0220345e2c57a0bb11eaa59ab54295f685eb', '375835600.845069191734954');
INSERT INTO `users` VALUES ('41', 'rcjj@comcast.net', '0', 'c0579086618d7e83c4b6d129b6b1180c0c73e004', '374924600.437679074011559');
INSERT INTO `users` VALUES ('42', 'oldisle@centurytel.net', '0', 'a6eebece8227c4863bbb3ace951f9532c6f5b185', '374055100.567404441599854');
INSERT INTO `users` VALUES ('43', 'eadnjd@comcast.net', '0', 'ad3f05c8721ef08475c016fa6a9c7f8d64de00ac', '373159500.553651602931087');
INSERT INTO `users` VALUES ('44', 'gsale@fhcrc.org;dovesono2001@comcast.net', '0', '5c01f9eeefcfabb4a986d9a8e9ab58f89685e492', '372270100.00741953899839298');
INSERT INTO `users` VALUES ('45', 'morganford19@yahoo.com', '0', '5feaabfd2fec431e48e995bceaef76bf2aa0aed3', '371403100.18442249228603');
INSERT INTO `users` VALUES ('46', 'flutetooter@wavecable.com', '0', 'f249c279e2830cbba97e5ee9b504033c2882590a', '382641700.546505521064465');
INSERT INTO `users` VALUES ('47', 'nashvilleslim@wavecable.com', '0', 'd02acf5deefda9cc3be10f46b050b9e7296578c1', '381106800.303519426913189');
INSERT INTO `users` VALUES ('48', 'boanerges@comcast.net', '0', 'a9dc20d0f7fa6771999d7b018539f8cab55444fd', '379129900.49872843848109');
INSERT INTO `users` VALUES ('49', 'Frank314@earthlink.net', '0', '1b9f990d03a832ced59af983a21739d9a26e0e5f', '378067500.137624918685167');
INSERT INTO `users` VALUES ('50', 'pkaiden@yahoo.com', '0', '6f1865762d14a41e12ca1d096e735af139377ddc', '376967700.780865026333335');
INSERT INTO `users` VALUES ('51', 'lsearle@u.washington.edu', '0', '8ae43a463b6f112d572cf5eef89cea5d1b2216f9', '375855900.813778613862249');
INSERT INTO `users` VALUES ('52', 'jboardman22@gmail.com', '0', '9c05d73716277a25864eb97894ede022a773c849', '374888400.680380488307041');
INSERT INTO `users` VALUES ('53', 'd.latham@shaw.ca', '0', 'baa01e2e141bd13dd97e80fbdce4a09510d8addf', '374017900.802963832225484');
INSERT INTO `users` VALUES ('54', 'janherbertdoyle@yahoo.com', '0', '85e1f4077ce2949a8b9afab97b19220e89daf846', '373123100.591371329054613');
INSERT INTO `users` VALUES ('55', 'sbarbara@comcast.net', '0', '2ca074df1ac1df4ec4c3089a3eff415424ddd760', '372233700.113298422408558');
INSERT INTO `users` VALUES ('56', 'brookre@earthlink.net', '0', 'ee6d3861d445a7ea31aca3696e52fa33fb482888', '371358100.781775147653529');
INSERT INTO `users` VALUES ('57', 'leog@u.washington.edu', '0', 'a1c5715407d00eea74a26de8fe5d7938100ad154', '382889100.662198437076363');
INSERT INTO `users` VALUES ('58', 'marbil678@comcast.net', '0', 'a9d2410be82409aa0defb24954a56b8f501c2941', '381381500.948008563119638');
INSERT INTO `users` VALUES ('59', 'thehunts@starband.net', '0', '080532095ec90401f1d160402738ec5db0bfd055', '379593400.102036595110087');
INSERT INTO `users` VALUES ('60', 'beepee2@hughes.net', '0', '93aacdc6cb3d371948c941a1215270ae265c1fa3', '378228100.0424170823901934');
INSERT INTO `users` VALUES ('61', 'joanna.ryan@att.net', '0', 'f19f3dfc0b8f9903cf49588e3fb9c994903b855b', '377036200.568393173776506');
INSERT INTO `users` VALUES ('62', 'athomp@uwm.edu', '0', '731419faa8800fd8f06d469efd66a3b6a7a9aabb', '375919900.535219547245417');
INSERT INTO `users` VALUES ('63', 'lthomp@cc.edu', '0', '6f095b865f4a04056418240624d0f1f95000840a', '375012800.382200993750532');
INSERT INTO `users` VALUES ('64', 'SBEL@MRCORNER.COM', '0', 'a12a4d80c929fdf8a0b5b4de1ea92e6e0be51cc4', '374141300.895681746306291');
INSERT INTO `users` VALUES ('65', 'cjoycer@comcast.net', '0', '0f4bece36e5bdf9e66a0d77f19154baa7db390fd', '373245200.700059833018184');
INSERT INTO `users` VALUES ('66', 'susieray23@yahoo.com', '0', 'def8674fea9a3fd969d58da55250886cf88c75da', '372354400.976113111418744');
INSERT INTO `users` VALUES ('67', 'gycwash@juno.com', '0', '939557ebaf22d8aedaf3856ccc4b6e0bfcb55594', '371486400.824121395583624');
INSERT INTO `users` VALUES ('68', 'anewland@seanet.com', '0', '99544d4cffd8a6aac12ef7346f25c451d8007490', '370579700.786423017175563');
INSERT INTO `users` VALUES ('69', 'bobandmaryclark@comcast.net', '0', '6dda7c87e35a3bfb7da634e7526a08931c1b803b', '381553600.778057252633125');
INSERT INTO `users` VALUES ('70', 'rob.carson@thenewstribune.com', '0', 'f0b761764cc45241b83c31ded0e7dce9a194fa00', '379784100.820253357143288');
INSERT INTO `users` VALUES ('71', 'dschaefer@sisna.com', '0', '509cfd82ac33de585a9bbd212264e307e3465365', '378343100.43397622517072');
INSERT INTO `users` VALUES ('72', 'royhalliday@sbcglobal.net', '0', '0f75889990a6680501d2825230bcb9204ae7cab8', '377234400.943833267728184');
INSERT INTO `users` VALUES ('73', 'jenwill@BSharpMajor.com', '0', 'd4104224810f39ecd73610a054d5667d35ebb95d', '376089800.37875834546837');
INSERT INTO `users` VALUES ('74', 'bbroad@aol.com', '0', '07394bd819f3199339e6fc17a5e911f536e7da08', '375222800.952766571988055');
INSERT INTO `users` VALUES ('75', 'johntheoboe@yahoo.com', '0', '91aef920eca180179de56db153601a5da02434ce', '374312800.204700096215234');
INSERT INTO `users` VALUES ('76', 'dwright@hub3.net', '0', 'd391896a7428bf8c209d5068aa53cd97d3083bed', '373446900.159385896642575');
INSERT INTO `users` VALUES ('77', 'madavis@vetmed.wsu.edu', '0', '37783181c1710e7717bd0c41c93476293ee126cc', '372527100.582291510888475');
INSERT INTO `users` VALUES ('78', 'cat317537@yahoo.com', '0', '078be3209b21a37a28e2abf030468f3f2ccc75c8', '371661000.664314630644133');
INSERT INTO `users` VALUES ('79', 'lkayfetz@personalfinancial.net', '0', 'fdb0b3adfeb1c739c6cb473248fddb910806a86a', '370793400.592732542559877');
INSERT INTO `users` VALUES ('80', 'ejklobas@comcast.net', '0', '36a680b6c8144c47e595341b97000c0369580ef1', '381856800.486291744695527');
INSERT INTO `users` VALUES ('81', 'abigailhoward@goldrush.com', '0', '17f761d1d54ba4ef251e3799ca089bd56019c573', '380181000.60782021525821');
INSERT INTO `users` VALUES ('82', 'stevenst@wavecable.com', '0', '85ed933fccca85dd58f44edc2fef6f9b5ce91e55', '378598500.15703012111736');
INSERT INTO `users` VALUES ('83', 'stevensc@wavecable.com', '0', 'eddf00ba0f8568fbff816c6e9be0094159cd71c6', '377515800.964579831772595');
INSERT INTO `users` VALUES ('84', 'saram@greenbusch.com', '0', '90ff3e33ef359bd567ddd3ca5652035d9f3d0476', '376328700.535283757872518');
INSERT INTO `users` VALUES ('85', 'mgjamison@msn.com', '0', '2b6d0abda147f1f4a19a08dc49725d5a5f1ee9ce', '375307000.386303982567946');
