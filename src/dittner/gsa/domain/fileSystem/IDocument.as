package dittner.gsa.domain.fileSystem {
import dittner.gsa.domain.fileSystem.body.DocBody;

public interface IDocument extends ISystemFile {
	function get body():DocBody
}
}
