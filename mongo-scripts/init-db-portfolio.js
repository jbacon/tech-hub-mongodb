db = db.getSiblingDB('portfolio')
db.dropUser('portfolio');
db.createUser({
	user: 'portfolio',
	pwd: portfolio_password,
	roles: [
       { role: 'read', db: 'portfolio' },
       { role: 'readWrite', db: 'portfolio' }
	]
});