require 'spec_helper'

describe Patient do
	before { @patient = Patient.new(name: "Example patient", email: "patient@example.com", 
				 password: "foobar", password_confirmation: "foobar",isFirstLogin:false)}
	subject{ patient}
#testing variables specific to patient
	
#check polymorphic elements of the object
	it { should respond_to(:name)}
	it { should respond_to(:email)}
	it { should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:isFirstLogin)}
	it { should respond_to(:password_confirmation)}
	it { should respond_to(:remember_token)}
	it { should respond_to(:authenticate)}
	it {should be_valid}
	it {should respond_to(:authenticate)}
	describe "when name is not present" do
		before { @patient.name = " "}
		it {should_not be_valid}

	end
	describe "when email is not present" do
		before { @patient.email= " " }
		it {should_not be_valid}

	end
	describe "when name is to long" do
		before { @patient.name = "a" *51}
		it {should_not be_valid}
		
	end

	describe "when isFirstLogin is not present" do
		before { @patient.isFirstLogin = " "}
		it {should_not be_valid}
		
	end
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses= %w[patient@foo,com patient_at_foo.org example.patient@foo. 
			foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|

				@patient.email = invalid_address
				expect(@patient).not_to be_valid
			end
		end
	end
	describe "when email format is valid" do
		it "should be valid" do

			addresses = %w[patient@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@patient.email = valid_address
				expect(@patient).to be_valid
			end

		end
	end
	describe "when email address is already taken" do
		before do
			patient_with_same_email = @patient.dup
			patient_with_same_email.email = @patient.email.upcase
			patient_with_same_email.save
		end
		it{should_not be_valid}
	end
	describe "when password is not present" do
		before do

			@patient = patient.new(name: "Example patient", email: "patient@example.com",
					 password: " ", password_confirmation: " ")
		end
		it { should_not be_valid}
	end
	describe "when password does not match confirmation" do
		before { @patient.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end
	describe "with a password that is to short" do
		before {@patient.password = @patient.password_confirmation = "a" * 5 }
		it {should be_invalid}
	end
	describe "return value of the authenticate method" do
		before {@patient.save}
		let(:found_patient){patient.find_by(email: @patient.email)}
		describe "with valid password" do
			it{should eq found_patient.authenticate(@patient.password)}
		end
		describe "with invalid password" do
			let(:patient_for_invalid_password){found_patient.authenticate("invalid")}
			it{should_not eq patient_for_invalid_password}
			specify { expect(patient_for_invalid_password).to be_false}
		end

	end

	describe "remember token" do
		before{@patient.save}
		its(:remember_token){ should_not be_blank}
	end
	
end
end