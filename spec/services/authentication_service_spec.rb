# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'

xdescribe AuthenticationService do
  describe '.authenticated_user' do
    context 'when the env key doesnt exist' do
      it 'raises an exception' do
        stub_const('ENV', { 'IAM_URI' => 'http://127.0.0.1:8888' })

        expect do
          described_class.authenticated_user('usr1', 'pwd')
        end.to raise_error(described_class::ApiKeyIsNotDefinedError)
      end
    end

    context 'when api key is invalid' do
      it 'logs an fatal error and raises an exception' do
        stub_const('ENV', { 'IAM_API_KEY' => 'not_valid' ,'IAM_URI' => 'http://localhost:8888' })
        stub_request(
          :post,
          'http://localhost:8888/api/v2/authentication'
        ).with(
          body: { 'api_key' => 'not_valid', 'password' => 'pwd', 'username' => 'usr1' }
        ).to_return(
          status: 200,
          body: { 'error' => 'Invalid api_key' }.to_json
        )
        expect(Rails.logger).to receive(:fatal).with(
          'AuthenticationService: IAM_API_KEY is invalid.'
        )
        expect do
          described_class.authenticated_user('usr1', 'pwd')
        end.to raise_error(described_class::InvalidApiKeyError)
      end
    end

    context 'when api key is valid' do
      context 'if credentials are wrong' do
        it 'logs info and returns nil' do
          stub_env_variables
          stub_request(
            :post,
            'http://127.0.0.1:8888/api/v2/authentication'
          ).with(
            body: { 'api_key' => 'some_api_key', 'password' => 'pwd', 'username' => 'usr2' }
          ).to_return(
            status: 200,
            body: { 'error' => 'Invalid username or password' }.to_json
          )

          expect(Rails.logger).to receive(:info).with(
            'Authentication failure. Username: "usr2", error: Invalid username or password'
          )
          expect(described_class.authenticated_user('usr2', 'pwd')).to be_nil
        end
      end

      context 'when unknows error returned from api' do
        it 'logs fatal error and raises an exception' do
          stub_env_variables
          stub_request(
            :post,
            'http://127.0.0.1:8888/api/v2/authentication'
          ).with(
            body: { 'api_key' => 'some_api_key', 'password' => 'pwd', 'username' => 'usr2' }
          ).to_return(
            status: 200,
            body: { 'error' => 'blah' }.to_json
          )

          expect(Rails.logger).to receive(:fatal).with(
            'AuthenticationService: unknown authentication error. Error: blah'
          )

          expect do
            described_class.authenticated_user('usr2', 'pwd')
          end.to raise_error(described_class::UnknownError)
        end
      end

      context 'if credentials are correct' do
        context 'when the user doesnt exist in sampleDatabase' do
          it 'creates and returns a new user with data returned by iam' do
            stub_const(
              'ENV',
              'IAM_API_KEY' => 'some_api_key', 'IAM_URI' => 'http://localhost:8888'
            )

            stub_request(
              :post,
              'http://localhost:8888/api/v2/authentication'
            ).with(
              body: { api_key: 'some_api_key', password: 'pwd', username: 'usr2' }
            ).to_return(
              status: 200,
              body: { user: true }.to_json
            )

            profile_fields = {
              'email' => 'usr3@company.com',
              'full_name' => 'fullname',
              'first_name' => 'firstname',
              'last_name' => 'lname',
            }

            stub_request(
              :get,
              'http://localhost:8888/api/v2/profile/usr2?api_key=some_api_key&isid=usr2'
            ).to_return(
              status: 200,
              body: { profile: profile_fields }.to_json
            )

            time_now = Time.new(2015, 1, 1, 9, 0)
            allow(Time).to receive(:now) { time_now }

            user = described_class.authenticated_user('usr2', 'pwd')

            expect(user).to be_persisted
            expect(user.username).to eq('usr2')
            expect(user.attributes.slice(*profile_fields.keys)).to eq(profile_fields)
            expect(user.last_login).to eq(time_now)
            expect(User.count).to eq(1)
          end
        end

        context 'when the user exists' do
          it 'authenticates and returns existing user' do
            existing_user = create(:user, username: 'usr4')
            stub_const(
              'ENV',
              'IAM_API_KEY' => 'some_api_key', 'IAM_URI' => 'http://localhost:8888'
            )

            stub_request(
              :post,
              'http://localhost:8888/api/v2/authentication'
            ).with(
              body: { api_key: 'some_api_key', password: 'pwd', username: 'usr4' }
            ).to_return(
              status: 200,
              body: { user: true }.to_json
            )

            profile_fields = {
              'email' => 'usr4@company.com',
              'full_name' => 'fullname',
              'first_name' => 'firstname',
              'last_name' => 'lname',
            }

            stub_request(
              :get,
              'http://localhost:8888/api/v2/profile/usr4?api_key=some_api_key&isid=usr4'
            ).to_return(
              status: 200,
              body: { profile: profile_fields }.to_json
            )

            time_now = Time.new(2015, 1, 1, 9, 0)
            allow(Time).to receive(:now) { time_now }

            user = described_class.authenticated_user('usr4', 'pwd')

            expect(user).to be_persisted
            expect(user.username).to eq('usr4')
            expect(user.attributes.slice(*profile_fields.keys)).to eq(profile_fields)
            expect(user.last_login).to eq(time_now)

            expect(user.id).to eq(existing_user.id)
            expect(User.count).to eq(1)
          end
        end
      end
    end
  end
  def stub_env_variables
    stub_const(
      'ENV',
      'IAM_API_KEY' => 'some_api_key', 'IAM_URI' => 'http://127.0.0.1:8888'
    )
  end
end
