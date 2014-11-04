require 'spec_helper'

describe Administrator do
	before { @administrator = Administrator.new(name: "Example administrator", email: "administrator@example.com", 
				 password: "foobar", password_confirmation: "foobara", isFirstLogin:false)}
	subject{ administrator}
#test variables specific to administrator
	it { should respond_to(:index)}
	it { should respond_to(:controlsManyPools)}
	
	describe "when index is not present" do
		before { @administrator.index = " "}
		it {should_not be_valid}

	end
	describe "when controlsManyPools is not present" do
		before { @administrator.controlsManyPools= " " }
		it {should_not be_valid}
#test polymorphic variables
	end
	it { should respond_to(:name)}
	it { should respond_to(:email)}
	it { should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:hasInstitution)}
	it {should respond_to(:isFirstLogin)}
	it { should respond_to(:password_confirmation)}
	it { should respond_to(:remember_token)}
	it { should respond_to(:authenticate)}
	it {should be_valid}
	it {should respond_to(:authenticate)}
	describe "when name is not present" do
		before { @administrator.name = " "}
		it {should_not be_valid}

	end
	describe "when email is not present" do
		before { @administrator.email= " " }
		it {should_not be_valid}

	end
	describe "when name is to long" do
		before { @administrator.name = "a" *51}
		it {should_not be_valid}
		
	end
	describe "when institution is not present" do
		before { @administrator.hasInstitution = " "}
		it {should_not be_valid}
		
	end
	describe "when isFirstLogin is not present" do
		before { @administrator.isFirstLogin = " "}
		it {should_not be_valid}
		
	end
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses= %w[administrator@foo,com administrator_at_foo.org example.administrator@foo. 
			foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|

				@administrator.email = invalid_address
				expect(@administrator).not_to be_valid
			end
		end
	end
	describe "when email format is valid" do
		it "should be valid" do

			addresses = %w[administrator@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@administrator.email = valid_address
				expect(@administrator).to be_valid
			end

		end
	end
	describe "when email address is already taken" do
		before do
			administrator_with_same_email = @administrator.dup
			administrator_with_same_email.email = @administrator.email.upcase
			administrator_with_same_email.save
		end
		it{should_not be_valid}
	end
	describe "when password is not present" do
		before do

			@administrator = administrator.new(name: "Example administrator", email: "administrator@example.com",
					 password: " ", password_confirmation: " ")
		end
		it { should_not be_valid}
	end
	describe "when password does not match confirmation" do
		before { @administrator.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end
	describe "with a password that is to short" do
		before {@administrator.password = @administrator.password_confirmation = "a" * 5 }
		it {should be_invalid}
	end
	describe "return value of the authenticate method" do
		before {@administrator.save}
		let(:found_administrator){administrator.find_by(email: @administrator.email)}
		describe "with valid password" do
			it{should eq found_administrator.authenticate(@administrator.password)}
		end
		describe "with invalid password" do
			let(:administrator_for_invalid_password){found_administrator.authenticate("invalid")}
			it{should_not eq administrator_for_invalid_password}
			specify { expect(administrator_for_invalid_password).to be_false}
		end

	end

	describe "remember token" do
		before{@administrator.save}
		its(:remember_token){ should_not be_blank}
	end
end
