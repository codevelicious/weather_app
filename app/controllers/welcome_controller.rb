class WelcomeController < ApplicationController
  def test
  	 	response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/WA/Bellingham.json")

  	 	@location = response['location'] ['city']
  	 	@temp_f = response ['current_observation'] ['temp_f']
  	 	@temp_c = response ['current_observation'] ['temp_c']
  	 	@weather_icon = response ['current_observation'] ['icon_url']
  	 	@weather_words = response ['current_observation'] ['weather']
  	 	@weather_link = response ['current_observation'] ['forecast_url']
  	 	@real_feel = response ['current_observation'] ['feelslike_f']

  end

  def index
  	@states = %w(HI AK CA OR WA ID UT NV AZ NM CO WY MT ND SD NE KS OK TX LA AR MO IA MN WI IL IN MI OH KY TN MS AL GA FL SC NC VA WV DE MD PA NY NJ CT RI MA VT NH ME DC PR)
		@states.sort!

		@locations = Location.all
		
		if params[:city] != nil
			city = params[:city].gsub(" ", "_")

			response = HTTParty.get("http://api.wunderground.com/api/#{ENV['wunderground_api_key']}/geolookup/conditions/q/#{params[:state]}/#{city}.json")

		 	@location = response['location'] ['city']
		 	@temp_f = response ['current_observation'] ['temp_f']
		 	@temp_c = response ['current_observation'] ['temp_c']
		 	@weather_icon = response ['current_observation'] ['icon_url']
		 	@weather_words = response ['current_observation'] ['weather']
		 	@weather_link = response ['current_observation'] ['forecast_url']
		 	@real_feel = response ['current_observation'] ['feelslike_f']

		 


		 	count = 0
		 	@locations.each do |loc|
		 		if params[:city] == loc.city && params[:state] == loc.state
		 			count += 1

				end
			end

			if count == 0
				location = Location.new
				location.city = params[:city]
				location.state = params[:state]
				location.save
				@locations = Location.all
			end
		end
	end
end