# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module ApplicationHelper
  def size_formatted
    temp_size = size || 0
    # return size in B, KB, MB, GB, TB as string
    units = %w(B KB MB GB TB)

    units.each do |u|
      if (temp_size / 1000.0) < 1
        return format("%.2f %s", temp_size, u)
      else
        temp_size /= 1000.0
      end
    end
    size
  end

  def dataset_options(selected = [])
    # @my_datasets.map { |dataset| [dataset.name, dataset.id] }
    grouped_options_for_select([["Owned datasets:", owned_datasets], ['Admined datasets', admin_datasets]], selected)
  end

  def grouped_datasets
    @my_datasets.group_by { |dataset| dataset.owner_id == current_user.id }.values
  end

  def owned_datasets
    (grouped_datasets[0] || []).map { |dataset| [dataset.name, dataset.id] }
  end

  def admin_datasets
    (grouped_datasets[1] || []).map { |dataset| [dataset.name, dataset.id] }
  end

  # http://getbootstrap.com/components/#alerts
  # success  warning  danger  info
  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
    when :success, :notice, :info
      'alert-success' # green
    when :alert, :warning
      'alert-warning' # yellow
    when :error, :danger
      'alert-danger'  # red
    else
      flash_type.to_s
    end
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    file = assets.find_asset(filename).to_s.force_encoding("UTF-8")
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    svg = doc.at_css('svg')

    svg['class'] = options[:class] if options[:class].present?

    raw(doc)
  end

  def find_by_country_code(country_code)
    ISO3166::Country.find_country_by_alpha2(country_code) || ISO3166::Country.find_country_by_gec(country_code) || 'None'
  end

  def countries_for_select
    ISO3166::Country.all.map { |c| [c.name, c.alpha2] }.sort_by { |p| ActiveSupport::Inflector.transliterate(p[0]) }
  end

  def active_controller_class(ctrl, klass = 'active')
    klass if request[:controller] == ctrl
  end

  def add_or_update(object)
    return 'Add' if object && object.new_record?
    'Update'
  end

  def formatted_date(date, format = "%b %e, %Y")
    date.strftime(format) if date
  end
end
