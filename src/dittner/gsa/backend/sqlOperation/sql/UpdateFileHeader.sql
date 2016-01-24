UPDATE header
SET
    parentID = :parentID,
	  fileType = :fileType,
	  title = :title,
	  isReserved = :isReserved,
	  isFavorite = :isFavorite,
	  options = :options
WHERE fileID = :fileID