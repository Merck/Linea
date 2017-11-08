# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
module AppName

  # fetch git revision only when development/test env
  # otherwise use REVISION file in app root (from capistrano)
  def self.get_revision
    return git_revision if %w(test development).include?(Rails.env)
    rev_file = Rails.root.join('REVISION')
    File.read(rev_file).chomp if File.exists?(rev_file)
  end

  def self.git_revision
    `git rev-parse --short HEAD`.chomp
  end

  REVISION = get_revision
end
