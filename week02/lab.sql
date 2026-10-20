-- Week 2: verify the existing Homebrew PostgreSQL installation.
CREATE SCHEMA week02;
SELECT current_database() AS database_name, current_user AS database_role,
       current_setting('server_version') AS server_version;
SELECT inet_server_addr() AS server_address, inet_server_port() AS port;
SELECT version();
SELECT rolname, rolcanlogin FROM pg_roles WHERE rolname = current_user;
