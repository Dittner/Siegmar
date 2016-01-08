INSERT INTO header
(
	parentID,
	fileType,
	title,
	isReserved,
	options
)
VALUES
(
	:parentID,
	:fileType,
	:title,
	:isReserved,
	:options
)