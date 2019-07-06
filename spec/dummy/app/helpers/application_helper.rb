# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include EnjuLeaf::ApplicationHelper
  include EnjuBiblio::ApplicationHelper
  include EnjuManifestationViewer::ManifestationViewerHelper
  include EnjuManifestationViewer::BookJacketHelper
end
