# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'zip'

module Support
  module FixturesHelper
    def load_fixture(name)
      path = File.expand_path("../../fixtures/#{name}", __FILE__)
      File.open(path).read
    end

    def uploaded_fixture_file(file_name)
      ActionDispatch::Http::UploadedFile.new(
        tempfile: File.new(Rails.root.join('spec', 'fixtures', file_name)),
        filename: file_name
      )
    end

    def zipped_fixture_file(file_name, options = {})
      basename = options[:basename] || 'zip'
      path = File.expand_path("../../fixtures/#{file_name}", __FILE__)
      zip = Tempfile.new([basename, '.zip'])
      Zip::OutputStream.open(zip.path) do |zos|
        # Create a new entry with some arbitrary name
        zos.put_next_entry(file_name)
        # Add the contents of the file, don't read the stuff linewise if its binary, instead use direct IO
        zos.print IO.read(path)
      end
      zip
    end
  end
end

RSpec.configure do |config|
  config.include Support::FixturesHelper
end
