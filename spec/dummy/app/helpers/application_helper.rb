# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include EnjuLeaf::EnjuLeafHelper
  include EnjuBiblio::BiblioHelper if defined?(EnjuBiblio)
  include PictureFilesHelper if defined?(EnjuLibrary)
  include EnjuManifestationViewer::ManifestationViewerHelper if defined?(EnjuManifestationViewer)
end
