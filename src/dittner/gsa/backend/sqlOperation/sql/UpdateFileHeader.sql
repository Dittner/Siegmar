UPDATE header
SET
    parentID = :parentID,
	  fileType = :fileType,
	  title = :title,
	  options = :options
WHERE fileID = :fileID