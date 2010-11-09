# hack stylesheet paths for hassle and rails 3....
current_locations = Sass::Plugin.options[:template_location] 
new_locations = current_locations.map{ |(loc, target)| [ loc, target.sub(/\/compiled$/, '') ] }
Sass::Plugin.options[:template_location] = new_locations
