# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
class TermsOfUseController < ApplicationController
  skip_before_filter :authenticate_user, only: [:actual]
  skip_before_filter :accept_terms_of_use
  skip_before_action :store_location
  before_action :terms_of_use

  def accept
  end

  def create
    if current_user.terms_acceptances.create(terms_of_use_id: @terms_of_use.id, accepted_at: Time.now)
      redirect_back_or_default
    else
      redirect_to accept_terms_of_use_path
    end
  end

  def actual
  end

  private

  def terms_of_use
    @terms_of_use ||= TermsOfUse.latest.first
  end
end
