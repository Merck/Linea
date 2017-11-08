# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module ControllerExtensions
  module MustAcceptTermsOfUse
    def self.included(base)
      base.before_filter(:accept_terms_of_use)
    end

    def accept_terms_of_use
      return unless current_user
      return unless latest_terms_of_use
      # check if user has accepted the latest, if not, redirect to accept
      unless current_user.accepted_latest_terms_of_use?
        store_location
        redirect_to accept_terms_of_use_path and return
      end
    end

    private

    def latest_terms_of_use
      @latest_terms_of_use ||= TermsOfUse.latest.first
    end
  end
end
