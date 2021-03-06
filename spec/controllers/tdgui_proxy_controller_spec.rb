
require 'rspec'
require 'spec_helper'

describe TdguiProxyController do

	before :all do
		@target_label = 'TP53-regulated inhibitor of apoptosis 1'
	end


	it "should be ok" do
		get :test

		resp = response.body
		resp.should_not be_nil

		response.code.to_i.should be == 200
	end


#	it "interactions retrieval should return a json" do
#		get :interactions_retrieval, :target => 'Q76MZ3' # 'Q13362'
#puts "interactions:\n#{response.body}\n"
#		json_resp = JSON.parse(response.body)
#
#		json_resp.should be_kind_of Array
#		json_resp.length.should be > 0
#
#		experiments = json_resp.pop()
#		experiments.should be_kind_of Hash
#
#		json_resp[0].should be_kind_of Hash
#
#	end


	describe "single target retrieval methods" do
		it "should retrieve an uniprot result from a name" do
	#		thelabel = 'TP53-regulated inhibitor of apoptosis 1'
	#		thelabel = 'Next to BRCA1 gene 1 protein (Homo sapiens)'
			params = {:thelabel => 'TP53-regulating kinase',
								:uuid => '2e7a6477-b144-4911-942d-4ccd3ecfbb1a'}
			thelabel = params[:thelabel]
			uuid = params[:uuid]
			get :get_uniprot_by_name, :label => thelabel, :uuid => uuid

	# puts "result from name:\n#{response.body}\n"
			json_resp = JSON.parse(response.body)
			json_resp.should_not be_nil
			json_resp.length.should be > 0

			json_resp['accessions'].length.should be > 0
			json_resp['proteinFullName'].should_not be_empty
			json_resp['proteinFullName'].index(thelabel).should_not be_nil
		end


		it "should retrieve an uniprot result from an uuid and no label" do
	#		thelabel = 'TP53-regulated inhibitor of apoptosis 1'
	#		thelabel = 'Next to BRCA1 gene 1 protein (Homo sapiens)'
			params = {:thelabel => '',
								:uuid => '2e7a6477-b144-4911-942d-4ccd3ecfbb1a'}
			thelabel = params[:thelabel]
			uuid = params[:uuid]
			get :get_uniprot_by_name, :label => thelabel, :uuid => uuid

	# puts "result from name:\n#{response.body}\n"
			json_resp = JSON.parse(response.body)
			json_resp.should_not be_nil
			json_resp.length.should be > 0

			json_resp['accessions'].length.should be > 0
			json_resp['proteinFullName'].should_not be_empty
			json_resp['proteinFullName'].index(thelabel).should_not be_nil
		end


		it "should retrieve an uniprot result from an accession" do
			params = {:acc => 'Q5H943'}
			get :get_uniprot_by_acc, :acc => params[:acc]

			response.should_not be_nil

			json_resp = JSON.parse(response.body)
			json_resp['accessions'].length.should be > 0
			json_resp['proteinFullName'].should_not be_empty
			json_resp['pdbimg'].should_not be_empty

		end

	end


	describe "multiple targets retrieval" do

		it "should retrieve information for multiple targets, last one with no uniprot counterpart" do
			accs = 'P08913,Q14596,Q5H943,P29274,-'
			uuids = 'd593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d,31dd02fa-3522-438e-bef5-da14902f6c1b'
	#		accs = 'P08913,Q14596,Q5H943,P29274'
	#		uuids = '59aabd64-bee9-45b7-bbe0-9533f6a1f6bc,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,'
	#		uuids += 'eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d'

			uuids_arr = uuids.split(',')
			target_ids = []
			index = 0
			accs.split(',').each { |acc|
				target_ids << acc+';'+(uuids_arr[index] ? uuids_arr[index]: '')
				index += 1
			}

			target_ids = ["P08913;59aabd64-bee9-45b7-bbe0-9533f6a1f6bc",
				"Q14596;ec79efff-65cb-45b1-a9f5-dddfc1c4025c",
				"Q5H943;eeaec894-d856-4106-9fa1-662b1dc6c6f1",
				"P29274;979f02c6-3986-44d6-b5e8-308e89210c8d",
				"-;d7ebde23-00cc-4797-80a2-7688d0d63836"]

	#		get :multiple_entries_retrieval, :entries => 'P08913,Q14596,Q5H943,P29274,-',
	#				:uuids => 'd593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d,31dd02fa-3522-438e-bef5-da14902f6c1b'

			get :multiple_entries_retrieval, :entries => target_ids.join(',')
	puts "\n\nentries: #{target_ids.join(',')}\n";
	puts "\n#{response.body}\n\n"
			json_resp = JSON.parse(response.body)
			json_resp.should_not be_nil
			json_resp['ops_records'].should_not be_empty
			json_resp['metaData']['fields'][0]['name'].should be == 'pdbimg'

		end


		it 'should retreive info for multiple targets out of the uniprot accesions ONLY' do
			accs = 'P08913,Q14596,Q5H943,P29274,-'
			uuids = ''

			uuids_arr = uuids.split(',')
			target_ids = []
			index = 0
			accs.split(',').each { |acc|
				target_ids << acc+';'+(uuids_arr[index] ? uuids_arr[index]: '')
				index += 1
			}
	#		get :multiple_entries_retrieval, :entries => 'P08913,Q14596,Q5H943,P29274,-',
	#				:uuids => 'd593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d,31dd02fa-3522-438e-bef5-da14902f6c1b'

			get :multiple_entries_retrieval, :entries => target_ids.join(',')
	puts "\n#{response.body}\n"
			json_resp = JSON.parse(response.body)
			json_resp.should_not be_nil
			json_resp['ops_records'].should_not be_empty
			json_resp['metaData']['fields'][0]['name'].should be == 'pdbimg'
		end

=begin
		it "should retrieve information  for multiple targets, one of them with no uniprot counterpart" do
				accs = 'P08913,Q14596,Q5H943,-,P29274'
				uuids = 'd593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,31dd02fa-3522-438e-bef5-da14902f6c1b,979f02c6-3986-44d6-b5e8-308e89210c8d'
				uuids_arr = uuids.split(',')
				target_ids = []
				index = 0
				accs.split(',').each { |acc|
					target_ids << acc+';'+uuids_arr[index]
					index += 1
				}
		#		get :multiple_entries_retrieval, :entries => 'P08913,Q14596,Q5H943,P29274,-',
		#				:uuids => 'd593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d,31dd02fa-3522-438e-bef5-da14902f6c1b'

				get :multiple_entries_retrieval, :entries => target_ids.join(',')
	# puts "\n#{response.body}\n"
				json_resp = JSON.parse(response.body)
				json_resp.should_not be_nil
				json_resp['ops_records'].should_not be_empty
				json_resp['metaData']['fields'][0]['name'].should be == 'pdbimg'
		end
=end

# =begin
		it "should retrieve info from multiple targets, but the first of them does not have uniprot counterpart" do
			accs = '-,P08913,Q14596,Q5H943,P29274'
			uuids = '31dd02fa-3522-438e-bef5-da14902f6c1b,d593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d'
			uuids_arr = uuids.split(',')
			target_ids = []
			index = 0
			accs.split(',').each { |acc|
				target_ids << acc+';'+uuids_arr[index]
				index += 1
			}
	#		get :multiple_entries_retrieval, :entries => 'P08913,Q14596,Q5H943,P29274,-',
	#				:uuids => 'd593db45-e954-4e97-94f7-c039350f97f4,ec79efff-65cb-45b1-a9f5-dddfc1c4025c,eeaec894-d856-4106-9fa1-662b1dc6c6f1,979f02c6-3986-44d6-b5e8-308e89210c8d,31dd02fa-3522-438e-bef5-da14902f6c1b'

			get :multiple_entries_retrieval, :entries => target_ids.join(',')
	# puts "\n#{response.body}\n"
			json_resp = JSON.parse(response.body)
			json_resp.should_not be_nil
			json_resp['ops_records'].should_not be_empty
			json_resp['metaData']['fields'][0]['name'].should be == 'pdbimg'
		end
# =end
	end



	it "should send an email" do
		params = Hash.new
		params[:from] = 'manolo@eldelbombo.com'
		params[:subject] = 'The subject does not matter'
		params[:msg] = 'This is another place to place loren ipsum planet motherfocker'

		get :send_feedback, params

# puts "EMAIL sent: #{response.body}\n"
		json_resp = JSON.parse(response.body)

		json_resp['success'].should_not be_nil
		json_resp['success'].should be_true
	end

end
