class AdminController < ApplicationController

  before_filter :is_admin, :load_conf

  # GET /admin
  # Show app configurations items                          HTML
  # -----------------------------------------------------------
  def show
    if params[:id] == 'surveys'
      @survey = Survey.where(['location_id = ? AND parent_id = 0', $conf.default_location_id]).order('created_at DESC').first
    end
  end

  # POST /admin/conf
  # Update global conf params                          REDIRECT
  # -----------------------------------------------------------
  def conf
    conf = Conf.find(1).update_attributes(params[:conf])

    redirect_to '/admin/conf'
  end

  # POST /admin/categories/create
  # Create a category                                  REDIRECT
  # -----------------------------------------------------------
  def categories_create
    Category.create

    redirect_to '/admin/ads'
  end

  # POST /admin/categories/update
  # Update all categories' names                       REDIRECT
  # -----------------------------------------------------------
  def categories_update
    Category.update(params[:category].keys, params[:category].values)

    redirect_to '/admin/ads'
  end

  # POST /admin/categories/delete/:id
  # Delete a category                                  REDIRECT
  # -----------------------------------------------------------
  def categories_delete
    Category.find(params[:id]).destroy

    redirect_to '/admin/ads'
  end

  # POST /admin/locations/create
  # Create a locations                                 REDIRECT
  # -----------------------------------------------------------
  def locations_create
    Location.create

    redirect_to '/admin/locations'
  end

  # POST /admin/locations/update
  # Update all locations' attributes                   REDIRECT
  # -----------------------------------------------------------
  def locations_update
    Location.update(params[:location].keys, params[:location].values)

    redirect_to '/admin/locations'
  end

  # POST /admin/locations/delete/:id
  # Delete a location                                  REDIRECT
  # -----------------------------------------------------------
  def locations_delete
    Location.find(params[:id]).destroy

    redirect_to '/admin/locations'
  end

  # POST /admin/surveys/create
  # Create a new survey                                REDIRECT
  # -----------------------------------------------------------
  def surveys_create
    Survey.create(
      :question    => params[:question],
      :location_id => $conf.default_location_id,
      :parent_id   => 0,
      :voters      => Array.new
    )

    redirect_to '/admin/surveys'
  end

  # PUT /admin/surveys/update
  # Update a survey                                    REDIRECT
  # -----------------------------------------------------------
  def surveys_update
    Survey.update(params[:survey].keys, params[:survey].values)

    redirect_to '/admin/surveys'
  end

  # POST /admin/answers/create/:id
  # Create a new answer for a given survey             REDIRECT
  # -----------------------------------------------------------
  def answers_create
    Survey.create(
      :parent_id   => params[:id],
      :location_id => $conf.default_location_id,
      :voters      => Array.new
    )

    redirect_to '/admin/surveys'
  end

  # DELETE /admin/answers/delete/:id
  # Delete given answer                               REDIRECT
  # ----------------------------------------------------------
  def answers_delete
    Survey.find(params[:id]).destroy

    redirect_to '/admin/surveys'
  end

  # PUT /admin/occupation
  # Set occupation rate for given location                                   AJAX
  # -----------------------------------------------------------------------------
  def occupation
    Location.find(params[:location_id]).update_attributes(:occupation=>params[:rate].to_i)

    render :text=>'success'
  end

end
