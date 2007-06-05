module Redwood

class Tagger
  def initialize mode
    @mode = mode
    @tagged = {}
  end

  def tagged? o; @tagged[o]; end
  def toggle_tag_for o; @tagged[o] = !@tagged[o]; end
  def drop_all_tags; @tagged.clear; end
  def drop_tag_for o; @tagged.delete o; end

  def apply_to_tagged
    targets = @tagged.select_by_value
    num_tagged = targets.size
    if num_tagged == 0
      BufferManager.flash "No tagged threads!"
      return
    end

    noun = num_tagged == 1 ? "thread" : "threads"
    c = BufferManager.ask_getch "apply to #{num_tagged} tagged #{noun}:"
    return if c.nil? # user cancelled

    if(action = @mode.resolve_input(c))
      tagged_sym = "multi_#{action}".intern
      if @mode.respond_to? tagged_sym
        @mode.send tagged_sym, targets
      else
        BufferManager.flash "That command cannot be applied to multiple threads."
      end
    else
      BufferManager.flash "Unknown command #{c.to_character}."
    end
  end

end

end
