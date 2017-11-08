# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
require 'spec_helper'
require 'cron_validator'

describe CronValidator do
  it 'validates a cron job syntax' do
    expect(CronValidator.job_syntax_valid?('* * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * * * *')).to be false

    # Minutes
    expect(CronValidator.job_syntax_valid?('0 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('59 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('60 * * * * *')).to be false

    expect(CronValidator.job_syntax_valid?('0,1,2 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('0-10 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('0-10,20,30 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('1/5 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('1,2-4,1/100 * * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('1,2-60,1/5 * * * * *')).to be false

    # Hours
    expect(CronValidator.job_syntax_valid?('* 0 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 23 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 24 * * * *')).to be false

    expect(CronValidator.job_syntax_valid?('* 0,1,2 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 0-10 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 0-10,20,21 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 1/5 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 1,2-4,1/100 * * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* 1,2-24,1/5 * * * *')).to be false

    # Day of month
    expect(CronValidator.job_syntax_valid?('* * ? * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 0 * * *')).to be false
    expect(CronValidator.job_syntax_valid?('* * 31 * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 32 * * *')).to be false

    expect(CronValidator.job_syntax_valid?('* * 1,2,3 * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1-10 * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1-10,20,21 * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1/5 * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1,2-4,1/100 * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1,2-32,1/5 * * *')).to be false
    expect(CronValidator.job_syntax_valid?('* * L * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * LW * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 3W * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1,4W * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * l * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * lw * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 3w * * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * 1,4w * * *')).to be true

    # Month
    expect(CronValidator.job_syntax_valid?('* * * 0 * *')).to be false
    expect(CronValidator.job_syntax_valid?('* * * 1 * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 12 * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 13 * *')).to be false

    expect(CronValidator.job_syntax_valid?('* * * 1,2,3 * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 1-10 * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 1-3,4-7,JAN,feb * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 1/5 * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 1,2-4,1/100 * *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * 1,2-13,1/5 * *')).to be false
    expect(CronValidator.job_syntax_valid?('* * * FEB,MAR,AUG-OCT,mar,12 * *')).to be true

    # Day of week
    expect(CronValidator.job_syntax_valid?('* * * * 0 *')).to be false
    expect(CronValidator.job_syntax_valid?('* * * * 1 *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 7 *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 8 *')).to be false

    expect(CronValidator.job_syntax_valid?('* * * * 1,2,3 *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 1-7 *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 1-3,4-7,FRI *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 1/5 *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 1,2-4,1/100 *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 1,2-32,1/5 *')).to be false
    expect(CronValidator.job_syntax_valid?('* * * * MON,TUE,THU-FRI,3,wed *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 2L *')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * 2l *')).to be true

    # Year
    expect(CronValidator.job_syntax_valid?('* * * * * 1969')).to be false
    expect(CronValidator.job_syntax_valid?('* * * * * 2100')).to be false
    expect(CronValidator.job_syntax_valid?('* * * * * 2015')).to be true

    expect(CronValidator.job_syntax_valid?('* * * * * 2015-2016')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * * 2015,2016')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * * 2015/3')).to be true
    expect(CronValidator.job_syntax_valid?('* * * * * 15')).to be false

    expect(
      CronValidator.job_syntax_valid?('  14,18,3-39,52 * ? JAN,MAR,SEP MON-FRI 2002-2010  ')
    ).to be true

    # Let's check all examples from Quartz Scheduler tutorial (exclude seconds)
    # http://quartz-scheduler.org/documentation/quartz-1.x/tutorials/crontrigger

    expect(CronValidator.job_syntax_valid?('0 12 * * ?')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 ? * *')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 * * ?')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 * * ? *')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 * * ? 2005')).to be true
    expect(CronValidator.job_syntax_valid?('* 14 * * ?')).to be true
    expect(CronValidator.job_syntax_valid?('0/5 14 * * ?')).to be true
    expect(CronValidator.job_syntax_valid?('0/5 14,18 * * ?')).to be true
    expect(CronValidator.job_syntax_valid?('0-5 14 * * ?')).to be true
    expect(CronValidator.job_syntax_valid?('10,44 14 ? 3 WED')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 ? * MON-FRI')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 15 * ?')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 L * ?')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 ? * 6L')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 ? * 6L')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 ? * 6L 2002-2005')).to be true
    expect(CronValidator.job_syntax_valid?('15 10 ? * 6#3')).to be true
    expect(CronValidator.job_syntax_valid?('0 12 1/5 * ?')).to be true
    expect(CronValidator.job_syntax_valid?('11 11 11 11 ?')).to be true
  end
end
