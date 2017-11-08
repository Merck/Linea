# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module FacebookFormatedCreatedAt
  extend ActiveSupport::Concern

  def at_time
    if less_than_one_day # its less than a day ago do special print
      if less_than_one_hour
        return minutes
      else
        return hours
      end
    else # Print standard date time
      return created_at.strftime('%B %e at %l:%M%P')
    end
  end

  private

  def less_than_one_hour
    (Time.now - created_at) < (60 * 60)
  end

  def less_than_one_day
    (Time.now - created_at) < (60 * 60 * 24)
  end

  def minutes
    "#{((Time.now - created_at) / 60).round} mins"
  end

  def hours
    "#{((Time.now - created_at) / 60 / 60).round} hrs"
  end
end
