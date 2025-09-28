module UiHelper
  def ui_label_classes
    "block text-sm font-medium text-neutral-700 mb-1"
  end

  def ui_input_classes
    [
      "w-full rounded-xl border border-neutral-300 bg-white px-3 py-2",
      "placeholder:text-neutral-400",
      "focus:outline-none focus:ring-4 focus:ring-indigo-100 focus:border-indigo-500",
      "transition"
    ].join(" ")
  end

  def ui_error_text_classes
    "mt-1 text-sm text-rose-600"
  end

  def ui_btn_primary_classes
    [
      "inline-flex w-full items-center justify-center gap-2",
      "rounded-xl px-4 py-2.5 font-medium",
      "bg-indigo-600 text-white hover:bg-indigo-700",
      "focus:outline-none focus:ring-4 focus:ring-indigo-100",
      "disabled:opacity-50 disabled:cursor-not-allowed",
      "transition"
    ].join(" ")
  end

  def ui_btn_ghost_classes
    "inline-flex w-full items-center justify-center rounded-xl px-4 py-2.5 font-medium text-neutral-700 hover:bg-neutral-100 transition"
  end

  def ui_link_classes
    "font-medium text-indigo-600 hover:text-indigo-700 hover:underline"
  end
end
