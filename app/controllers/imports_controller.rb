class ImportsController < ApplicationController
  def new
    @default_dataset_path = Rails.root.join("data", "Overall MoU list.xlsx")
  end

  def create
    file_path =
      if params[:file].present?
        params[:file].tempfile.path
      else
        Rails.root.join("data", "Overall MoU list.xlsx").to_s
      end

    unless File.exist?(file_path)
      redirect_to new_import_path, alert: "Excel file not found."
      return
    end

    result = MouExcelImporter.import(file_path)
    message = "Import complete: #{result.created} created, #{result.updated} updated, #{result.skipped} skipped."

    if result.errors.any?
      flash[:alert] = "#{message} (#{[ result.errors.first, '...' ].compact.join})"
    else
      flash[:notice] = message
    end

    redirect_to mous_path
  end
end
