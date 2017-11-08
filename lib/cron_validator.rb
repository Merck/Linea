# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# CronValidator
# Implements a validator for Cron job syntax (Quartz Scheduler)
# (EXCEPTION Middlaget doesn't support seconds granularity, so this validator
# doesn't accept seconds).
# http://quartz-scheduler.org/generated/2.2.1/html/qs-all/#page/Quartz_Scheduler_Documentation_Set%2Fco-trg_crontriggers.html%23
#
# Usage example:
#
# CronValidator.job_syntax_valid?(
#   '  14,18,3-39,52 * ? JAN,MAR,SEP MON-FRI 2002-2010  '
# ) # => true
#
module CronValidator
  SEC_MINS_RE = %r{
    \A
    (\d{1,2})
    (?:
      (?:-(\d{1,2})) |
      \/(?:\d+)
    )?
    \z
  }xi

  HOURS_RE = %r{
    \A
    (\d{1,2})
    (?:
      (?:-(\d{1,2})) |
      \/(?:\d+)
    )?
    \z
  }xi

  DAY_OF_MONTH_RE = %r{
    \A
    (?:
      LW? |
      (\d)?W |
      (\d{1,2})
      (?:
        (?:-(\d{1,2})) |
        \/(?:\d+)
      )?
    )
    \z
  }xi

  MONTHS = 'JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC'

  MONTH_RE = %r{
    \A
    (?:
      (?:
        (\d{1,2})
        (?:
          (?:-(\d{1,2})) |
          \/(?:\d+)
        )?
      ) |
      (?:
        (?:#{MONTHS})
        (?:-(?:#{MONTHS}))?
      )
    )
    \z
  }xi

  WEEK_DAYS = 'MON|TUE|WED|THU|FRI|SAT|SUN'

  DAY_OF_WEEK_RE = %r{
    \A
    (?:
      (\d)?L |
      (?:
        (?:
          (\d)
          (?:
            (?:-(\d)) |
            \/(?:\d+)
          )?
        ) |
        (?:
          (?:#{WEEK_DAYS})
          (?:-(?:#{WEEK_DAYS}))?
        )
      ) |
      (?:
        (\d)\#(\d)
      )
    )
    \z
  }xi

  YEAR_RE = %r{
    \A
    (\d{4,4})
    (?:
      (?:-(\d{4,4})) |
      \/(?:\d+)
    )?
    \z
  }xi

  SYNTAX_RULES = [
    # Middlegate doesn't support seconds
    # { re: SEC_MINS_RE,     special_values: %w(*),     valid_ints_values: 0..59      },

    { re: SEC_MINS_RE,     special_values: %w(*),     valid_ints_values: 0..59      },
    { re: HOURS_RE,        special_values: %w(*),     valid_ints_values: 0..23      },
    { re: DAY_OF_MONTH_RE, special_values: %w(? *),   valid_ints_values: 1..31      },
    { re: MONTH_RE,        special_values: %w(*),     valid_ints_values: 1..12      },
    { re: DAY_OF_WEEK_RE,  special_values: %w(? *),   valid_ints_values: 1..7       },
    { re: YEAR_RE,         special_values: ['', '*'], valid_ints_values: 1970..2099 }
  ]

  class << self
    def job_syntax_valid?(job_str)
      parts = job_str.strip.split(/\s+/)
      return false if parts.size > SYNTAX_RULES.size

      SYNTAX_RULES.each_with_index do |rule, i|
        return false unless part_valid?(parts[i], rule)
      end

      true
    end

    private

    def part_valid?(part_str, rule)
      part_str ||= ''
      return true if rule[:special_values].include?(part_str)

      part_str.split(',').each do |item|
        match = item.match(rule[:re])
        return false unless match

        match[1..-1].compact.each do |matched_int|
          return false unless rule[:valid_ints_values].include?(matched_int.to_i)
        end
      end

      true
    end
  end
end
