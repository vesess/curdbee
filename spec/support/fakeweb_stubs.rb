def fixture_file(filename)
  return '' if filename == ''
  file_path = File.join(File.dirname(__FILE__), '..', 'fixtures', filename)
  File.read(file_path)
end

def stub_get(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?

  FakeWeb.register_uri(:get, url, options)
end

def stub_post(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?

  FakeWeb.register_uri(:post, url, options)
end

def stub_put(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?

  FakeWeb.register_uri(:put, url, options)
end

def stub_delete(url, filename, status=nil)
  options = {:body => fixture_file(filename)}
  options.merge!({:status => status}) unless status.nil?

  FakeWeb.register_uri(:delete, url, options)
end
