-- Week 2: verify a live pgAdmin connection to the local server.
SELECT current_database() AS database_name,
       current_user AS database_role,
       current_setting('server_version') AS server_version,
       inet_server_addr() AS server_address,
       inet_server_port() AS port;
