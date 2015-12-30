CREATE TABLE IF NOT EXISTS header
(
	fileID int PRIMARY KEY AUTOINCREMENT,
	parentID int,
	fileType int,
	title String NOT NULL,
	options Object
)