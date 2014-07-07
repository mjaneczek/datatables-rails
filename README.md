# DatatablesRails [![Code Climate](https://codeclimate.com/github/mjaneczek/datatables-rails.png)](https://codeclimate.com/github/mjaneczek/datatables-rails)

Want to use DataTables in your rails project? This gem can help you!
DatatablesRails is a wrapper that makes DataTables easier to use, provides configuration file, AJAX support, eliminates duplicates.

## Installation

#### 1) Bundle

Add this lines to your application's Gemfile:
```rb
gem 'datatables-rails', github: 'mjaneczek/datatables-rails'
```

And then execute:

    $ bundle

#### 2) Configurations
You can use generator for create config file and initializer which loads it.
```rb 
rails generate datatables_rails:install
```

#### 3) CoffeeScript
Add to your global coffee file:
```coffee
#= require datatables_rails
```

After loading page you need to initialize table. 
```coffee
initialize_datatables_rails = ->
  data_tables_rails = new DatatablesRails("/datatables_pl.txt")
  data_tables_rails.init()
```
As you can see, you can pass file path with translation but this is not necessary.

#### 4) View helper
Add to your ```ApplicationController```:
```rb
helper DatatablesRails::ViewHelper
```

## Getting Started

### Background
Assume that you have a model like this:

```rb
class Product
  attr_accessor :name, :description, :price
end
```
DatatablesRails supports two source type - ```Array``` or ```ActiveRecord::Relation```.

You want to: 
- display all members of class
- search only by name and description
- default sort by price (DESC)
- disable sorting in description column

Add: 
- formatting to price 
- additional column for "order" button
- additional filter for showing only cheap (fewer than 10$) products


### Display table with all elements and search option
##### View:
```erb
<%= datatable_tag Product %>
```

##### Controller:
Default - javascript sends request for json to the same controller and action like view 
so your controller action can looks like:
```rb
  def index
    ...
    respond_to do |format|
      format.html { respond_with @products }
      format.json { render json: datatables_rails.generate_json(@products) }
    end
  end
  
  def datatables_rails
    DatatablesRails::DataManager.new(self.view_context.params)
  end
```
Of course you can put datatables_rails method in better place - e.g base class (like ```ApplicationController```).

##### Configuration file 

```yml
# /config/datatables_config.yml
Product:
  columns: [ name, description, price ]
  search_columns: [ name, description ]
  filter_module: DatatablesRails::ArraySource
```
Default filter_module is ```ActiveRecordSource```, we are using array so we needed to change it.

### Sorting options

```yml
# /config/datatables_config.yml
Product:
  ...
  columns_without_sorting: [1]
  sorting_column: 2
  sorting_type: "desc"
```

For now you need to pass index of columns (not its names).

### Custom formatting

```rb
# datatables_rails method
datatable.templates.register("price") do |item|
  "$#{item.price}" 
end
```

### Additional columns

```yml
# /config/datatables_config.yml
Product:
  ...
  additional_columns:
    last: "Item options"
```

```rb
# datatables_rails method
datatable.additional_columns.register(:last) do |item|
  some_way_to_generate_html(item)
end
```

### Additonal filters

```coffee
# coffee script
initialize_datatables_rails = ->
  data_tables_rails = new DatatablesRails()

  data_tables_rails.additional_params = (aoData) ->
    aoData.push({name: "cheap_items_only", value: $("#cheap_only").val()})

  data_tables_rails.init()
```

```rb
# datatables_rails method
datatable.additional_filters.register("product") do |source, params|
  if params[:cheap_items_only] == true
    source = source.select do |product|
      product.price =< 10
    end
  end
  source
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
