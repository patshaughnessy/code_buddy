###
# CodeBuddy uses backbone to provide an enhanced veriosn of the Rails ShowExceptions page
###


###
MODELS
###
class Address extends Backbone.Model
  selected: ->
    codeBuddy.stack.selectedAddress() == @


class Addresses extends Backbone.Collection
  model: Address

  bookmarked: =>
    @select (address) ->
      address.get 'bookmarked'


class Stack extends Backbone.Model
  initialize: ->
    @bind('change:selected', @selectionChanged)
    @set(addresses: new Addresses(@get('stack_frames')))

  setSelection: (newSelected) ->
    @set(selected: newSelected) if (newSelected >= 0) && (newSelected < @addresses().size())

  selectPrevious: ->
    @setSelection(@get('selected') - 1)

  selectNext: ->
    @setSelection(@get('selected') + 1)

  addresses: ->
    @get('addresses')

  selectedAddress: ->
    selected = @get('selected')
    @addresses().at(selected)

  selectionChanged: (x) ->
    @addresses().at(x.previousAttributes().selected).view.render()
    @addresses().at(x.changedAttributes().selected).view.render()
    codeBuddy.codeView.render()

  toggleBookmark: =>
    @selectedAddress().set( bookmarked: !@selectedAddress().get('bookmarked') )
    @selectedAddress().view.render

  selectNextBookmark: =>
    bookmarked = @addresses().bookmarked()
    length = bookmarked.length;
    toSelect;
    if(length > 0)
      current = _.indexOf(bookmarked, @selectedAddress())
      if(current > -1 && current < length - 1)
        toSelect = bookmarked[current + 1]
      else
        toSelect = bookmarked[0]
      @setSelection(toSelect.cid.substr(1)-1)



###
VIEWS
###
class AddressView extends Backbone.View
  tagName:  "li"

  template: _.template("<span class='container'><%= path %>:<%= line%><span class='overlay'></span></span>")

  initialize: ->
    @model.view = @

  events:
    click: "open"
    dblclick: "toggleBookmark"

  open: () =>
    address_id = @model.cid.substr(1) - 1
    codeBuddy.stack.set
      selected: address_id

  toggleBookmark: () ->
    @open()
    codeBuddy.stack.toggleBookmark()

  render: () =>
    html = @template(@model.toJSON())

    $(@el).html(html);
    $(@el).removeClass('selected bookmarked')
    $(@el).addClass('selected')   if @model.selected()
    $(@el).addClass('bookmarked') if @model.get('bookmarked')
    @


class StackView extends Backbone.View
  el: $("#stack")

  initialize: ->
    @model.view = @
    for address in @model.get('addresses').toArray()
      @addOneAddress address

  addOneAddress: (address, index) =>
    view = new AddressView(model: address)
    $(@el).append(view.render().el)

  selectPrevious: =>
    @model.selectPrevious()
    @ensureVisibility()
    false

  selectNext: =>
    @model.selectNext()
    @ensureVisibility()
    false

  ensureVisibility: =>
    offset = $(@model.selectedAddress().view.el).offset()
    windowHeight = $(window).height()
    if offset.top > windowHeight + $(window).scrollTop() - 10
      $('html,body').animate({scrollTop: offset.top - 200}, 500) # scroll down
    else if offset.top < $(window).scrollTop() + 100
      $('html,body').animate({scrollTop: offset.top - 500}, 500) # scroll up
    false



class CodeView extends Backbone.View
  el:$("#code-viewer")

  initialize: () ->
    @code = @.$("#code")
    @current = @.$("#current")
    @opacity = parseFloat(@el.css("opacity"))

  render: () ->
    @current.html('<div>' + codeBuddy.stack.selectedAddress().get('path') + '</div>')
    @code.html(codeBuddy.stack.selectedAddress().get('code'))

  toggleCommands: =>
    @.$("#legend").toggle()

  toggle: =>
    @el.toggle()

  editCode: ->
    return alert 'Editing code only works when CodeBuddy is running on localhost.' unless codeBuddy.editCodeEnabled()
    $.get('../edit/' + codeBuddy.stack.get('selected'))

  setOpacity: (newOpacity) ->
    newOpacity = 0 if newOpacity < 0
    newOpacity = 1 if newOpacity > 1
    @el.css("opacity", newOpacity)
    @opacity = newOpacity

  increaseOpacity: =>
    @setOpacity(@opacity + 0.1)

  decreaseOpacity: =>
    @setOpacity(@opacity - 0.1)

class FormView extends Backbone.View
  el: $(".form")

  initialize: ->
    @el.find('textarea').bind('keydown', 'esc', @hide)

  show: =>
    return alert 'Pasting an arbitrary stack is only permitted when CodeBuddy is running on localhost.' unless codeBuddy.pasteStackEnabled()

    @el.show()
    codeBuddy.codeView.el.hide()
    codeBuddy.stackView.el.hide()
    @el.find("textarea").focus()
    false

  hide: =>
    @el.hide()
    codeBuddy.codeView.el.show()
    codeBuddy.stackView.el.show()
    false

###
CodeBuddy Namespace
###
class CodeBuddy
  localhost:
    window.location.hostname == 'localhosttt2'

  pasteStackEnabled: =>
    @localhost

  editCodeEnabled: =>
    @localhost

  setStackKeyBindings: =>
    $(document).bind('keydown', 'up',         @stackView.selectPrevious)
    $(document).bind('keydown', 'down',       @stackView.selectNext)
    $(document).bind('keydown', 'right',      @codeView.increaseOpacity)
    $(document).bind('keydown', 'left',       @codeView.decreaseOpacity)
    $(document).bind('keydown', 'a',          @stack.toggleBookmark)
    $(document).bind('keydown', 's',          @stack.selectNextBookmark)
    $(document).bind('keydown', 'h',          @codeView.toggle)
    $(document).bind('keydown', 'e',          @codeView.editCode)

  setGlobalKeyBindings: =>
    $(document).bind('keydown', 'n',   @form.show) if @pasteStackEnabled()
    $(document).bind('keydown', 'esc', @codeView.toggleCommands)

  setup: (stackJson) =>
    @form = new FormView if @pasteStackEnabled()

    @stack = new Stack(stackJson)
    @stackView = new StackView(model: @stack)
    @codeView = new CodeView
    if stackJson
      @codeView.render()
      @setStackKeyBindings()
      @form.hide() if @pasteStackEnabled()
    else
      @form.show() if @pasteStackEnabled()
    @setGlobalKeyBindings()
    $('#new_stack').click () -> @form.show()

# a global reference to all our views
codeBuddy = new CodeBuddy

# expose our setup function to the outside world
window.CodeBuddy =
  setup: codeBuddy.setup
