UPDATE header
SET
    parentID = :parentID,
	  fileType = :fileType,
	  title = :title,
	  isReserved = :isReserved,
	  options = :options
WHERE fileID = :fileID