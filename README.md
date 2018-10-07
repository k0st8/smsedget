## Installation

` $ composer install`

## Databases MySql

`$ mysql -u root -p`

Set your password for dbsms user:

`mysql> GRANT ALL PRIVILEGES ON dbagrigator.* To 'dbsms'@'localhost' IDENTIFIED BY 'your-password'; `

`mysql> FLUSH PRIVILEGES;`

Import all structure.sql and then data.sql files ( located in _application/data_ folder ).

`$ mysql -u root < /full/path/to/schema.sql`

`$ mysql -u dbsms < /full/path/to/data.sql`

If you want to check that everything imported:

`mysql> show procedure status;`

`mysql> show events;`

Run couple times to generate dummy data:

`mysql> CALL RandomRunning(@p0); `

Check that rows created:

`mysql> SELECT COUNT(*) FROM send_log; `

Wait for the Event happen or set time that you want and see changes


## Codeigniter database

 - Don't forget to change password for _dbsms_ user.
 - See other configuration in
 	-	Routes
 	-	Database 
 	-	Autoload

## Apache vshots config

```
<VirtualHost *:80>
	DocumentRoot /your/path/to/project/smsedge
    ServerName smsedge.loc
	ErrorLog /var/log/smsedge-error.log
	CustomLog /var/log/smsedge-access.log common
</VirtualHost>
```
Restart server 

`$ apache2ctl restart`

## Hosts config
Add domain to hosts file 

```
127.0.0.1    smsegde.loc
```


---
You've done. :+1: