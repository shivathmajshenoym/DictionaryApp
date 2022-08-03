require 'rails_helper'


describe 'Users API', type: :request do 
   
    before do
        
        FactoryBot.create(:admin, words: 'dog')
        
    end 

    describe 'GET /admins' do
        it 'return all words' do
            get '/admins' # com: this line makes an actual request which goes through routes and finally goes to the controller and execute code
            expect(response).to have_http_status(:success) # Here response is the response we get from the previous line request. It is checking if 200 status came with resposne
            expect(JSON.parse(response.body).size).to eq(2) # resposne body is json. after persing it is converted to ruby hash/array. It is checking if the array size is 2. Coz, in the before block we just created 2 users with factory bot.
            # to know more about what can be checked with expect keyword, visit: https://github.com/rspec/rspec-expectations
        end
    end

    describe 'POST /admins' do
        it 'creates a new user' do
            # note in following line we passed parameters with post command
            # also the post is added inside block expect
            # it is checking when we run the post '/api/users' hits the app
            # the total number of user in DB should increase by 1 
            expect { 
                post '/api/admins', params: { admin: { words: 'cat' } }
            }.to change { Admin.count }.by(+1)

            expect(response).to have_http_status(:created)
        end

        # This is checking if creating user fails then will we get expected outcome
        # context is like describe. You can nest it as well. it is as like describe.
        context 'When saving fails' do 
            before do
                # only for this context block's test code 
                # if any instace of User model gets the save request
                # it will return false instead of true.

                # we are doing this, coz in app/controllers/api/users_controller on line 33 user.save is called
                # but to perform our test this should return false.
                # so follwing line will ensure that
                allow_any_instance_of(Admin).to receive(:save).and_return(false)
            end
        
            it 'It should respond as unprocessable_entity' do
                post '/admins', params: { admin: { words: 'dog' } }
                expect(response).to have_http_status(:unprocessable_entity) # here it is checking that instead of getting success are we getting unprocessable_entity according to the code
            end
        end
    end

    describe 'GET /admins/:id' do
        it 'return user with specific ID' do 
            get '/admins/1'
            # this should return user with id 1
            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body)['id']).to eq(1) # here we are checking resonse body's id key's value which should be 1, coz we are sending 1 as parameter
        end
    end

    describe 'PATCH /admins/:id' do
        it 'Updates admin with specific ID' do 
            patch '/admins/1', params: { user: { firstName: 'test11', lastName: 'last11', email: 'test11@gmail.com' } } # with this line the user should be edited successfully
            admin = Admin.find 1 # we fetch the user from the DB
            expect(admin.words).to eq('cat') # here checking if the firstName is DB is equal to parameter firstName
            
            expect(response).to have_http_status(:success)
        end
    end

    describe 'PUT /admins/:id' do
        it 'Updates user with specific ID' do 
            put '/admins/2', params: { user: { words: 'cat' } }
            admin = Admin.find 2
            expect(admin.firstName).to eq('test22')
            
            expect(response).to have_http_status(:success)
        end

        context 'When updating fails' do 
            before do 
                allow_any_instance_of(Admin).to receive(:update).and_return(false)
            end
        
            it 'It should respond as unprocessable_entity' do
                put '/admins/2', params: { admin: { words: 'test22' } }
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe 'DELETE /admins/:id' do
        it 'delete the user with specific ID' do
            # as explained b4
            # it is checking
            # after getting this delete request
            # it should reduce one user from the DB
            expect { 
                delete 'admins/1'
            }.to change { Admin.count }.by(-1)

            expect(response).to have_http_status(:success)
        end
    end

    describe 'GET /typeahead/:input' do
        it 'return the users matching the input string' do
            input = 'bird'
            get "/typeahead/#{input}" # this means the request is /api/typeahead/gmail
            response_hash = JSON.parse(response.body)

           
            response_hash.each do |single_response|
                
                matched_result = single_response.values.any? { |a| a.to_s =~ /#{input}/i }
                expect(matched_result).to eq(true) # for each response checking with expect
            end                    

            expect(response).to have_http_status(:success) # overall there should be succcess response
        end
    end
end
