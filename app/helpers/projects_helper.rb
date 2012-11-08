module ProjectsHelper
  def new_or_edit_path(project, new, video_extras, photo_extras)
    if new
      return new_project_path(project, :video_extras => video_extras, :photo_extras => photo_extras)
    else
      return edit_project_path(project, :video_extras => video_extras, :photo_extras => photo_extras)
    end
  end
end
