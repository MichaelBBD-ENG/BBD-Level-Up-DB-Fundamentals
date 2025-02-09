flyway migrations should live here


flyway migrate script (from root directory) = flyway -url=jdbc:postgresql://localhost:5432/MagicBeanDB -user=db-username -password=db-password -locations=filesystem:..  migrate