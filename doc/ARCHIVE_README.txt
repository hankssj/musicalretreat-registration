Implementing an archive server

First cut allows uploads/downloads only, and nothing fancy about sorting

Table declaration directly into mysql (sigh...)

CREATE TABLE `archive_entries` (  
	`id`                int(11)       NOT NULL auto_increment,  
	`description`       varchar(255) default NULL,  
	`content_type`      varchar(80)  default NULL,  
	`local_file_name`   varchar(255) default NULL,  
	`remote_file_name`  varchar(255) default NULL,  
	`created_by`        varchar(255) default NULL,  
	`created_at`        datetime     default NULL,  
	PRIMARY KEY (`id`));

Have working version on home machine, but doesn't do any user validation, 
and therefore does not correctly instantiate the created_by field.  First cut 
is to get it working in that form.  Import from home:
   archive_controller
   archive_entry.rb
   views/archive/index, new, and the partial _archive_entry for index

Be sure to adjust file path and mkdir the directory.

At this point the call to 
archive/index does work!

Call to new renders the page, then errors on a 500 but nothing in the log.
However, the record did get added to the database, and the image is there.
Also the index page works correctly.
So something just in the redirect?  Yes!  Remember there's the PUTS!
Got rid of those in the controller and model. (Nothing in the views right??)
Try again....  WORKING!

Now get the validation.  Should be easy right?  Just blanket protect everything in 
the archive controller.  That works!

Now let's put the name in the field.  Really now I think it should be the user_id 
field in the table, so let's change that.  sigh.....

First get the user id in place.  This turns out to be super easy, as it's in 
a hidden field in the new form.  

Now change the created_by to an int.  Really we should have a foreign key 
declaration, so let's add that too.  But that gets me thinking it really should 
just be user_id then everything should work great, right???

First guess is that it's newly this:

CREATE TABLE `archive_entries` (  
	`id`                int(11)       NOT NULL auto_increment,  
	`description`       varchar(255) default NULL,  
	`content_type`      varchar(80)  default NULL,  
	`local_file_name`   varchar(255) default NULL,  
	`remote_file_name`  varchar(255) default NULL,  
	`user_id`           int(11) default NULL,  
	`created_at`        datetime     default NULL,  
 	PRIMARY KEY (`id`),
	KEY `fk_archives_user_id` (`user_id`),
        CONSTRAINT `fk_archives_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`));

And remember to change created_by to user_id in the view.  That should be the only place?
And while we're at it, let's try the belongs_to for the archive_entry.

Now we should be back in working order, PLUS we should be able to see user IDs in 
the database table and indirect back from archive entry to user. 

Got a small glitch in that the index page is still looking at created by, BUT 
we have a good database, and we can indirect to the user.  SIGH!

Next let's give the user a display name.  Cleverly, we'll do that in the model 
by reconstructing created by to be a nice name.  Verified using console.  
Now index should work.

Next let's go after some style, at least to make it compatible with registration.
I want to know how to get the MMR background and style sheet, get a border, and 
make the table wider.

Getting the background is easy in that I copied the layout.  Now make the index list look 
like the registration list.

