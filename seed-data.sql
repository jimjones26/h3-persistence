INSERT INTO h3.scopes (name, description)
VALUES  ('admin', 'This is the scope for the admin role.'),
        ('client', 'This is the scope for the client role.'),
        ('practitioner', 'This is the scope for the practitioner role.');

INSERT INTO h3.users (email, first_name, last_name, first_visit)
VALUES  ('admin@admin.com', 'Jimmy', 'Jones', false),
        ('prac@prac.com', null, null, true);


INSERT INTO h3.users_scopes (user_id, scope_id)
VALUES  ((SELECT id FROM h3.users WHERE email='admin@admin.com'),
        (SELECT id FROM h3.scopes WHERE name='admin')),
        ((SELECT id FROM h3.users WHERE email='prac@prac.com'),
        (SELECT id FROM h3.scopes WHERE name='practitioner'));