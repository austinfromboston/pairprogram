# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork', :cucumber => false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.*\.rb$})
  watch(%r{^config/initializers/.*\.rb$})
  watch('spec/spec_helper.rb')
end

guard 'rspec', :drb => true, :version => 2, :wait => 30 do
  watch('^spec/(.*)_spec.rb')
  watch('^lib/(.*)\.rb')                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('^spec/spec_helper.rb')                       { "spec" }

  # Rails example
  watch('^app/(.*)\.rb')                              { |m| "spec/#{m[1]}_spec.rb" }
  # watch('^lib/(.*)\.rb')                              { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('^config/routes.rb')                          { "spec/routing" }
  watch('^app/controllers/application_controller.rb') { "spec/controllers" }
  watch('^spec/factories.rb')                         { "spec/models" }
end
