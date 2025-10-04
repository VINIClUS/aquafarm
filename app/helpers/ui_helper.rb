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

  def ui_btn_primary
    "text-white bg-blue-700 hover:bg-blue-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-blue-600 dark:hover:bg-blue-700 dark:focus:ring-blue-800"
  end

  def ui_btn_danger
    "text-white bg-red-700 hover:bg-red-800 focus:ring-4 focus:outline-none focus:ring-red-300 font-medium rounded-lg text-sm px-5 py-2.5 text-center dark:bg-red-600 dark:hover:bg-red-700 dark:focus:ring-red-800"
  end

  def ui_title_classes
    "text-2xl font-semibold text-neutral-700"
  end

    # container
  def t_table
    "w-full text-sm text-left rtl:text-right text-gray-500 dark:text-gray-400"
  end

  # head
  def t_thead
    "text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
  end

  def t_th
    "px-6 py-3 text-center"
  end

  def t_th_small
    "px-4 py-2 text-center text-xs font-medium"
  end

  # body/rows/cells
  def t_tr
    "bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600"
  end

  def t_td
    "px-6 py-4 text-center"
  end

  def t_td_small
    "px-4 py-2 text-center text-sm"
  end

  # ações (opcional)
  def t_actions
    "flex gap-2 justify-center"
  end

  def t_link_primary
    "font-medium text-blue-600 dark:text-blue-500 hover:underline"
  end

  def t_link_danger
    "font-medium text-red-600 dark:text-red-500 hover:underline"
  end
end
