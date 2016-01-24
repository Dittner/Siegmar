INSERT INTO header
(
	parentID,
	fileType,
	title,
	isReserved,
	isFavorite,
	options
)
VALUES
(
	:parentID,
	:fileType,
	:title,
	:isReserved,
	:isFavorite,
	:options
)