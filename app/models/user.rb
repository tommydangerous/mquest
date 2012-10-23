class User < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: :slugged

	has_attached_file :photo,
					  default_url: '/assets/default_image.jpg',
					  storage: :s3,
					  s3_credentials: "#{Rails.root}/config/s3.yml",
					  path: "/:style/:id/:filename"

	attr_accessor :password
	attr_accessible :name,
					:email,
					:password,
					:password_confirmation,
					:photo,
					:department_id

	# Name
	validate :name_validation	
	def name_validation
		if name.blank?
			errors.add(:name, "cannot be blank")
		elsif name.length < 1
			errors.add(:name, "is too short (minimum is 1 character")
		elsif name.length > 20
			errors.add(:name, "is too long (maximum is 20 characters)")
		elsif name.match(/^[A-Za-z]{1,}[A-Za-z0-9]+[-_ ]?[A-Za-z0-9]{1,}$/).nil?
			errors.add(:name, "is invalid (can contain A-Z, 0-9, -, _, or 1 space)")
		end
	end
	validates_uniqueness_of :name, :case_sensitive => false, :message => "is already taken"

	# Email
	validate :email_validation	
	def email_validation
		if email.blank?
			errors.add(:email, "cannot be blank")
		elsif email.match(/^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$/i).nil?
			errors.add(:email, "is not in a valid format (e.g. jane_doe@gmail.com)")
		end
	end
	validates_uniqueness_of :email, :case_sensitive => false, :message => "is already registered"

	# Password
	validates :password, :confirmation => true
	validates :password, :length => { :within => 2..40 }, :on => :create

	# Photo
	validates_attachment_content_type :photo, 
									  :message => "is not in the correct format.", 
									  :content_type => %w( image/jpeg image/png image/gif image/pjpeg image/x-png image/bmp )
	validates_attachment_size :photo, :message => "is too large. (Max size: 5mb)", :in => 0..1.megabyte

	# Department
	validates :department_id, presence: true

	before_save :encrypt_password

	has_many :events, dependent: :destroy
	has_many :requests, dependent: :destroy

	belongs_to :department

	def self.search(search)
		if search
			if Rails.env.production?
				where("name ILIKE ?", "%#{search}%")
			else
				where("name LIKE ?", "%#{search}%")
			end
		else
			scoped
		end
	end

	def first_name
		self.name.split(' ')[0]
	end

	def has_password?(submitted_password)
		encrypted_password == encrypt(submitted_password)
	end

	def self.authenticate(email, submitted_password)
		user = find_by_email(email)
		return nil if user.nil?
		return user if user.has_password?(submitted_password)
	end

	def self.authenticate_with_salt(id, cookie_salt)
		user = find_by_id(id)
		(user && user.salt == cookie_salt) ? user : nil
	end

	private

		def encrypt_password
			unless password.blank?
				self.salt = make_salt unless has_password?(password)
				self.encrypted_password = encrypt(self.password)
			end
		end

		def encrypt(string)
			secure_hash("#{salt}--#{string}")
		end

		def make_salt
			secure_hash("#{Time.now.utc}--#{password}")
		end

		def secure_hash(string)
			Digest::SHA2.hexdigest(string)
		end
end