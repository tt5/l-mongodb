db.auth('root', 'password')

db = db.getSiblingDB('one')

db.createUser({
  user: 'user',
  pwd: 'password',
  roles: [
    {
      role: 'root',
      db: 'one',
    },
  ],
});
