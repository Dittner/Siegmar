CREATE TABLE IF NOT EXISTS photo
(
	id int PRIMARY KEY AUTOINCREMENT,
	fileID int,
	preview Object NOT NULL,
	bytes Object NOT NULL,
	title String NOT NULL
)