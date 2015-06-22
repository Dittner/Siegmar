CREATE TABLE header
(
	fileID int PRIMARY KEY AUTOINCREMENT,
	parentID int,
	fileType int,
	title String NOT NULL,
	password String,
	options Object
)