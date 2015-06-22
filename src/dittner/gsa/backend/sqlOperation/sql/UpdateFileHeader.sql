UPDATE header
SET
    parentID = :parentID,
	  fileType = :fileType,
	  title = :title,
	  password = :password,
	  options = :options
WHERE fileID = :fileID