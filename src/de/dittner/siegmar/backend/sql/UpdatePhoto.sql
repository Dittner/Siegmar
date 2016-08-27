UPDATE photo
SET bytes = :bytes,
    preview = :preview,
	  fileID = :fileID,
	  title = :title
WHERE id = :id