def safe_load(name)
  begin
    yield
  rescue LoadError
     task name.to_sym do
       abort "#{name} is not available. You need to install a corresponding gem first"
     end
  end
end