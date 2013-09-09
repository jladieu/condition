module StatusHelper

  def status_code(status)
    color, message = "orange", "UNKNOWN"
    if status
      message = [status.code, status.message].compact.join(" - ")
      if status.up?
        color = "green"
      else
        color = "red"
      end
    end

    content_tag :span, message, :style => "color:#{color}"
  end

end
