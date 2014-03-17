require File.expand_path '../spec_helper.rb', __FILE__

describe "Default pages" do

  it 'redirects to the index page' do
    get '/'

    expect(last_response.status).to eql 302
  end

  it 'has an index page' do
    get '/v1/'

    expect(last_response.status).to eql 200
    expect(last_response.body).to eql "Test234 home page"
  end

  it 'has a healthcheck page' do
    get '/healthcheck'

    expect(last_response.status).to eql 200
    expect(last_response.body).to eql "OK"
  end

end