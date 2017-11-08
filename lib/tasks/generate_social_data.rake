# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
namespace :social do
  REVIEW_TEXT = [
    "Offices parties lasting outward nothing age few resolve. Impression to discretion understood to we interested he excellence. Him remarkably use projection collecting. Going about eat forty world has round miles. Attention affection at my preferred offending shameless me if agreeable. Life lain held calm and true neat she. Much feet each so went no from. Truth began maids linen an mr to after.",
    "No depending be convinced in unfeeling he. Excellence she unaffected and too sentiments her. Rooms he doors there ye aware in by shall. Education remainder in so cordially. His remainder and own dejection daughters sportsmen. Is easy took he shed to kind. ",
    "Ferrars all spirits his imagine effects amongst neither. It bachelor cheerful of mistaken. Tore has sons put upon wife use bred seen. Its dissimilar invitation ten has discretion unreserved. Had you him humoured jointure ask expenses learning. Blush on in jokes sense do do. Brother hundred he assured reached on up no. On am nearer missed lovers. To it mother extent temper figure better.",
    "Now seven world think timed while her. Spoil large oh he rooms on since an. Am up unwilling eagerness perceived incommode. Are not windows set luckily musical hundred can. Collecting if sympathize middletons be of of reasonably. Horrible so kindness at thoughts exercise no weddings subjects. The mrs gay removed towards journey chapter females offered not. Led distrusts otherwise who may newspaper but. Last he dull am none he mile hold as. ",
    "Had strictly mrs handsome mistaken cheerful. We it so if resolution invitation remarkably unpleasant conviction. As into ye then form. To easy five less if rose were. Now set offended own out required entirely. Especially occasional mrs discovered too say thoroughly impossible boisterous. My head when real no he high rich at with. After so power of young as. Bore year does has get long fat cold saw neat. Put boy carried chiefly shy general. "
  ]

  SHARE_COMMENT = [
    "Awesome dataset here.", "Stellar job collecting all that data", "Not quite perfect, but not bad either", "Helped me solve my problem",
    "Needs more info on the flux generator output", "Great into on Alderans population", "I'll buy a hoggie for whoever cleans up this data"
  ]

  desc "Generate Random Social Data"
  task generate: :environment do
    number_of_users = User.count
    number_of_datasets = Dataset.count

    puts "There is #{number_of_users} users and #{number_of_datasets} datasets "

    prng = Random.new(DateTime.now.strftime('%Q').to_i)

    100.times do
      days_ago = prng.rand(365)
      minutes_ago = prng.rand(0..1440)

      created_at = days_ago.days.ago - minutes_ago.minutes

      dataset_id = prng.rand(number_of_datasets) + 1
      user_id = prng.rand(number_of_users) + 1

      operation = prng.rand(4)

      if operation == 0
        puts "User #{user_id} liked #{dataset_id} at #{created_at}"
        LikeActivity.create({ user_id: user_id, dataset_id: dataset_id, created_at: created_at })
      elsif operation == 1
        puts "User #{user_id} shared #{dataset_id} at #{created_at}"
        share_id = prng.rand(SHARE_COMMENT.length)
        ShareActivity.create({ user_id: user_id, dataset_id: dataset_id, created_at: created_at, comment: SHARE_COMMENT[share_id] })
      elsif operation == 2
        puts "User #{user_id} reviewed #{dataset_id} at #{created_at}"
        text_id = prng.rand(REVIEW_TEXT.length)
        rating = prng.rand(5) + 1
        ReviewActivity.create({ user_id: user_id, dataset_id: dataset_id, created_at: created_at, review: REVIEW_TEXT[text_id], rating: rating })
      elsif operation == 3
        puts "User #{user_id} updated #{dataset_id} at #{created_at}"
        UpdateActivity.create({ user_id: user_id, dataset_id: dataset_id, created_at: created_at })
      end

    end
  end

  desc "Clears all social activities"
  task clear_all_activities: :environment do

    LikeActivity.all.each(&:destroy)
    ShareActivity.all.each(&:destroy)
    ReviewActivity.all.each(&:destroy)
    UpdateActivity.all.each(&:destroy)
    IngestActivity.all.each(&:destroy)

  end

  desc "Ensures there is a ingest activity for each dataset"
  task ensure_ingest_activities: :environment do

    prng = Random.new(DateTime.now.strftime('%Q').to_i)

    Dataset.all.each do |d|
      next if IngestActivity.exists?({ dataset_id: d.id, user_id: d.owner.id })
      puts "Creating new ingest for #{d.name}"

      days_ago = prng.rand(60)
      minutes_ago = prng.rand(0..1440)

      created_at = days_ago.days.ago - minutes_ago.minutes

      IngestActivity.create({ dataset_id: d.id, user_id: d.owner.id, created_at: created_at })
    end

  end
end
