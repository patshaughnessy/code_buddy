var Line = Backbone.Model.extend({});

var LineView = Backbone.View.extend({
  render: function(models) {
    data = models.map(function(line) {
      if (line.get('highlighted') == true) {
        return '<span class="container">' + line.get('code') + '<span class="overlay"></span></span>';
      } else {
        return '' + line.get('code');
      }
    })
    var result = data.reduce(function(memo,str) { return memo + str }, '');
    $(this.el).html(result);
    return this;
  }
});

var StackLine = Backbone.Model.extend({});

var StackLineView = Backbone.View.extend({
  render: function(models) {
    data = models.map(function(stack_line) {
      if (stack_line.get('highlighted') == true) {
        return '<span class="stack_selected">' + stack_line.get('path') + '</span>\n'+
               '<div id="code_content" style="white-space:pre"></div>'
      } else if (stack_line.get('visible') == true) {
        return '<span class="stack_unselected" target_counter="' + stack_line.get('id') + '">' + stack_line.get('path') + '</span>\n';
      } else {
        return ''
      }
    })
    var result = data.reduce(function(memo,str) { return memo + str }, '');
    $(this.el).html(result);
    return this;
  }
});

