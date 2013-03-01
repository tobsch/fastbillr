require File.expand_path("../test_helper", __FILE__)

describe Fastbillr::Customer do
  after do
    Excon.stubs.clear
  end

  describe "find methods" do

    describe "customers" do
      before do
        Excon.stub({:method => :post}, {:body => fixture_file("customers.json"), :status => 200})
      end

      it "#all" do
        customers = Fastbillr::Customer.all
        customers.length.must_equal 2
        expected_ids = JSON.parse(fixture_file("customers.json"))["RESPONSE"]["CUSTOMERS"].map { |c| c["CUSTOMER_ID"] }
        customers.map { |c| c.id }.must_equal expected_ids
      end

      it "#find_by_country" do
        expected_ids = JSON.parse(fixture_file("customers.json"))["RESPONSE"]["CUSTOMERS"].map { |c| c["CUSTOMER_ID"] }
        Fastbillr::Customer.find_by_country("de").map(&:id).must_equal expected_ids
      end

      it "#find_by_customer_number" do
        expected_id = JSON.parse(fixture_file("customers.json"))["RESPONSE"]["CUSTOMERS"].first['CUSTOMER_ID']
        Fastbillr::Customer.find_by_customer_number("2").id.must_equal expected_id
      end
    end

    describe "customer" do
      before do
        Excon.stub({:method => :post}, {:body => fixture_file("customer.json"), :status => 200})
      end

      it 'should have a model name' do
        Fastbillr::Customer.model_name.must_equal 'customer'
      end

      it 'should have a model name' do
        Fastbillr::Customer.model_name_plural.must_equal 'customers'
      end
      
      it "#find_by_id" do
        expected_customer_id = JSON.parse(fixture_file("customer.json"))["RESPONSE"]["CUSTOMERS"][0]["CUSTOMER_ID"]
        Fastbillr::Customer.find_by_id(expected_customer_id).id.must_equal expected_customer_id
      end

      it "#search" do
        expected_id = JSON.parse(fixture_file("customer.json"))["RESPONSE"]["CUSTOMERS"][0]["CUSTOMER_ID"]
        Fastbillr::Customer.search("foo").first.id.must_equal expected_id
      end
    end

  end

  describe "create, delete, update" do
    it "#create" do
      Excon.stub({:method => :post}, {:body => fixture_file("created_customer.json"), :status => 200})
      customer = Fastbillr::Customer.create(last_name: "foo", first_name: "bar", city: "dummy", customer_type: "business", organization: "foobar")
      customer.id.must_equal JSON.parse(fixture_file("created_customer.json"))["RESPONSE"]["CUSTOMER_ID"]
    end
    
    it '#create or update' do
      flunk
    end
    
    it '#update' do
      Excon.stub({:method => :post}, {:body => fixture_file("updated_customer.json"), :status => 200})
      customer = Fastbillr::Customer.new
      customer.organization = 'hyper compu global mega net'
      customer.save
    end
  end

end
