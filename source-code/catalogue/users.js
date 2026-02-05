db = db.getSiblingDB('users');
db.users.drop();
db.users.insertMany([
    {name: 'user', password: 'password', email: 'user@me.com'},
    {name: 'stan', password: 'bigbrain', email: 'stan@instana.com'},
    {name: 'partner-57', password: 'worktogether', email: 'howdy@partner.com'}
]);
db.users.createIndex({name: 1}, {unique: true});
