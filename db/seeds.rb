# Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License. 
# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

## Default seed data
SubjectArea.where(name: "Business Strategy", description: "Business Strategy").first_or_create
SubjectArea.where(name: "Commercial", description: "Commercial").first_or_create
SubjectArea.where(name: "Finance", description: "Finance").first_or_create
SubjectArea.where(name: "Human Resources", description: "Human Resources").first_or_create
SubjectArea.where(name: "Information Technology", description: "Information Technology").first_or_create
SubjectArea.where(name: "Legal, Safety and Environment", description: "Legal, Safety and Environment").first_or_create
SubjectArea.where(name: "Manufacturing and Supply Chain", description: "Manufacturing and Supply Chain").first_or_create
SubjectArea.where(name: "Procurement and Payment", description: "Procurement and Payment").first_or_create
SubjectArea.where(name: "R&D", description: "Research and Development").first_or_create
SubjectArea.where(name: "Site Services", description: "Site Services").first_or_create
SubjectArea.where(name: "None", description: "None").first_or_create
SubjectArea.where(name: "Real World Evidence", description: "Real World Evidence").first_or_create

User.create(username: 'admin', full_name: "Administrator", is_admin: true)
User.create(
  username: 'chattarn', full_name: "Arnaub Chatterjee", is_admin: false, email: "arnaub.chatterjee@Linea.com",
  first_name: "Arnaub", last_name: "Chatterjee")

Tag.where(name: "chpl", created_by_id: "1").first_or_create
Tag.where(name: "electronic health", created_by_id: "1").first_or_create
Tag.where(name: "health information", created_by_id: "1").first_or_create
Tag.where(name: "meaningful use", created_by_id: "1").first_or_create
Tag.where(name: "mu", created_by_id: "1").first_or_create
Tag.where(name: "acute care hospital", created_by_id: "1").first_or_create
Tag.where(name: "covered services", created_by_id: "1").first_or_create
Tag.where(name: "expenditures", created_by_id: "1").first_or_create
Tag.where(name: "hospital", created_by_id: "1").first_or_create
Tag.where(name: "inpatient", created_by_id: "1").first_or_create
Tag.where(name: "medicare", created_by_id: "1").first_or_create
Tag.where(name: "national", created_by_id: "1").first_or_create
Tag.where(name: "part-a", created_by_id: "1").first_or_create
Tag.where(name: "research", created_by_id: "1").first_or_create
Tag.where(name: "general information", created_by_id: "1").first_or_create
Tag.where(name: "nhc", created_by_id: "1").first_or_create
Tag.where(name: "nursing home", created_by_id: "1").first_or_create
Tag.where(name: "food", created_by_id: "1").first_or_create
Tag.where(name: "inspection", created_by_id: "1").first_or_create
Tag.where(name: "oph", created_by_id: "1").first_or_create
Tag.where(name: "public health", created_by_id: "1").first_or_create
Tag.where(name: "restaurant", created_by_id: "1").first_or_create
Tag.where(name: "violation", created_by_id: "1").first_or_create
Tag.where(name: "bmi", created_by_id: "1").first_or_create
Tag.where(name: "childhood obesity", created_by_id: "1").first_or_create
Tag.where(name: "chronic disease", created_by_id: "1").first_or_create
Tag.where(name: "swscr", created_by_id: "1").first_or_create
Tag.where(name: "hospital", created_by_id: "1").first_or_create
Tag.where(name: "infection", created_by_id: "1").first_or_create
Tag.where(name: "oph", created_by_id: "1").first_or_create
Tag.where(name: "public health", created_by_id: "1").first_or_create
Tag.where(name: "surgery", created_by_id: "1").first_or_create
Tag.where(name: "patient", created_by_id: "1").first_or_create
Tag.where(name: "sparcs", created_by_id: "1").first_or_create
Tag.where(name: "cabg", created_by_id: "1").first_or_create
Tag.where(name: "cardiac", created_by_id: "1").first_or_create
Tag.where(name: "cardiac surgery", created_by_id: "1").first_or_create
Tag.where(name: "coronary", created_by_id: "1").first_or_create
Tag.where(name: "pci", created_by_id: "1").first_or_create
Tag.where(name: "valve", created_by_id: "1").first_or_create
Tag.where(name: "enrollment", created_by_id: "1").first_or_create
Tag.where(name: "medicaid", created_by_id: "1").first_or_create
Tag.where(name: "death", created_by_id: "1").first_or_create
Tag.where(name: "City", created_by_id: "1").first_or_create
Tag.where(name: "State", created_by_id: "1").first_or_create
Tag.where(name: "National", created_by_id: "1").first_or_create
Tag.where(name: "hospital compare", created_by_id: "1").first_or_create
Tag.where(name: "medicare payment", created_by_id: "1").first_or_create
Tag.where(name: "claims", created_by_id: "1").first_or_create
Tag.where(name: "end of life", created_by_id: "1").first_or_create
Tag.where(name: "hospice", created_by_id: "1").first_or_create
Tag.where(name: "medicare", created_by_id: "1").first_or_create
Tag.where(name: "community health", created_by_id: "1").first_or_create
Tag.where(name: "hospital", created_by_id: "1").first_or_create
Tag.where(name: "medicare", created_by_id: "1").first_or_create
Tag.where(name: "part-d", created_by_id: "1").first_or_create
Tag.where(name: "pde", created_by_id: "1").first_or_create
Tag.where(name: "utilization", created_by_id: "1").first_or_create
Tag.where(name: "cancer", created_by_id: "1").first_or_create
Tag.where(name: "observational data", created_by_id: "1").first_or_create
Tag.where(name: "blinded study", created_by_id: "1").first_or_create
Tag.where(name: "breast cancer", created_by_id: "1").first_or_create
Tag.where(name: "survival length", created_by_id: "1").first_or_create
Tag.where(name: "gdi", created_by_id: "1").first_or_create
Tag.where(name: "bridge to data", created_by_id: "1").first_or_create

TermsOfService.where(name: "Unknown", description: "Data use restrictions unknown. Contact data owner for details").first_or_create
TermsOfService.where(name: "Free License", description: "You are free to copy, distribute, adapt, display or include the data in other products for commercial and noncommercial purposes at no cost subject to certain limitations summarized below. You must include attribution for the data you use in the manner indicated in the metadata included with the data. You must not claim or imply that Linea endorses your use of the data by or use Linea’s logo(s) or trademark(s) in conjunction with such use. Other parties may have ownership interests in some of the materials contained on Linea Web site. For example, we maintain a list of some specific data within the Datasets that you may not redistribute or reuse without first contacting the original content provider, as well as information regarding how to contact the original content provider. Before incorporating any data in other products, please check the list: Terms of use: Restricted Data").first_or_create
TermsOfService.where(name: "Proprietary", description: "Linea Information intended only for internal distribution within Linea. Unauthorized disclosure of which could cause undesirable effects to Linea.").first_or_create

Datasource.where(name: "TERADATA").first_or_create
Datasource.where(name: "SAP").first_or_create
Datasource.where(name: "External").first_or_create
Datasource.where(name: "A&R Platform").first_or_create
Datasource.where(name: "Middlegate").first_or_create