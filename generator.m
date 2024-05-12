clear all;

users_num = 50;
locations_num = 10;
trasactions_num = 100;

%users_num = 5;
%locations_num = 10;
%trasactions_num = 20;

% Merchant types
merchants = {
    1, 1, 'Fresh Mart';
    2, 1, 'Green Basket';
    3, 1, 'Organic Oasis';
    4, 1, 'Farm to Fork Market';
    5, 1, 'Nature''s Pantry';
    6, 2, 'Trendy Threads Boutique';
    7, 2, 'Fashion Avenue';
    8, 2, 'Tech Haven';
    9, 2, 'Home Essentials Emporium';
    10, 2, 'Bookworm''s Den';
    11, 3, 'Taste of Italy Trattoria';
    12, 3, 'Spice Junction';
    13, 3, 'Fusion Bistro';
    14, 3, 'Seafood Sensation';
    15, 3, 'Veggie Delight Cafe';
    16, 4, 'Wanderlust Travel Agency';
    17, 4, 'Globe Trotters';
    18, 4, 'Jet Set Tours';
    19, 4, 'Adventure Seekers Expeditions';
    20, 4, 'Destination Dreamers';
    21, 5, 'Swift Cabs';
    22, 5, 'Metro Movers';
    23, 5, 'AeroRide Airways';
    24, 5, 'Urban Cruise Lines';
    25, 5, 'Express Shuttle Service';
    26, 6, 'Starlight Cinemas';
    27, 6, 'Fun Zone Arcade';
    28, 6, 'Melody Music Hall';
    29, 6, 'Comedy Club Central';
    30, 6, 'Adventure Park';
    31, 7, 'Wellness Clinic';
    32, 7, 'Harmony Health Center';
    33, 7, 'Care Plus Medical';
    34, 7, 'Holistic Healing Haven';
    35, 7, 'Vitality Wellness Center';
    36, 8, 'PowerPro Electric';
    37, 8, 'AquaFlow Water Services';
    38, 8, 'GasGenie';
    39, 8, 'ConnectTel Internet';
    40, 8, 'Speedy Solutions Plumbing';
};
merchants_var_names = {'merchant_id' 'merchant_type_id', 'merchant_name'};
Merchants = cell2table(merchants, 'VariableNames', merchants_var_names);

merchant_types = {
    1 'Groceries'
    2 'Shopping'
    3 'Restaurants'
    4 'Travel'
    5 'Transport'
    6 'Entertainment'
    7 'Health Services'
    8 'General Utilities'
};
merchant_types_var_names = {'merchant_type_id', 'merchant_type_name'};
Merchant_types = cell2table(merchant_types, 'VariableNames', merchant_types_var_names);


%mesta
mesta = {
    1 1 'Slovenija', 'Ljubljana', '46.05108N', '14.50513E';
    2 1 'Slovenija', 'Maribor', '46.561523614011534N','15.64271046004723E';
    3 1 'Slovenija', 'Celje', '46.22921451153578N','15.259795373005222E';
    4 1 'Slovenija', 'Kranj', '46.24278405855847N','14.355690306378417E';
    5 2 'Egipt', 'Kairo', '30.055852688755486N','31.21436031038726E';
    6 3 'Indija', 'Mumbai', '18.72907700067099N','72.89541774475408E';
    7 4 'USA', 'NYC', '40.85936029260566N','-73.99593940814296W'
};

mesta_varNames = {'mesto_id' 'country_id' 'country', 'city', 'latitude', 'longitude'};
Mesta = cell2table(mesta, 'VariableNames', mesta_varNames);


Merchants_Types = join(Merchants,Merchant_types,"Keys","merchant_type_id");



disp('start generateing locations')

%Cartesian product
[ii,jj] = meshgrid(1:height(Merchants_Types),1:height(Mesta));
Locations =  [Merchants_Types(ii,:) Mesta(jj,:)];
Locations = addvars(Locations, zeros(height(Locations), 1), 'NewVariableName', 'location_id');

%Nudge coordinates 13 km, add ids
for i = 1:height(Locations)
    row = Locations(i, :);
    [new_lat, new_lon] = moveCoordinates(row.latitude, row.longitude);
    row.latitude = new_lat;
    row.longitude = new_lon;
    Locations(i, :) = row;
    Locations(i, :).location_id = i;
end


%users
user = {
    1 'Bojan' 30
};
user_varNames = {'user_id' 'ime', 'age'};
User = cell2table(user, 'VariableNames', user_varNames);
for i=2:users_num
    User = [User;{i,'Bojan',randi([18,90])}];
end




transactions_num_all = users_num * locations_num * trasactions_num;

transactions=cell(transactions_num_all,14);

%transactions_t = cell(transactions_num_all,10)
transactions_t = {0,0,0,0,0,0,0,0,0,0};


transactions_varNames = {'transaction_id' 'user_id' 'amount' 'location_id' 'date' 'time_since_last_here' 'merchant_frequency' 'TransactionType' 'TransactionDevice' 'fraudulent'};


Transactions = cell2table(transactions_t, 'VariableNames', transactions_varNames);




%typical users
%merchants 8, tipi kartice 3, časi 6, medij, velikost, država
users_types = {
  %nakupovalec na netu,popoldne, slovenija
  [0.1,0.37,0.03,0.1,0.1,0.1,0.1,0.1],[0.98, 0.01, 0.01],[0.01,0.01,0.01,0.17,0.7,0.1] ,[0.5,0.45,0.05],[0.2,0.5,0.3],'Slovenija' 
  %nakupovalec na netu, popoldne, egipt
  [0.1,0.37,0.03,0.1,0.1,0.1,0.1,0.1],[0.98, 0.01, 0.01],[0.01,0.01,0.01,0.17,0.7,0.1] ,[0.5,0.45,0.05],[0.2,0.5,0.3],'Egipt'
  %nakupovalec na netu, popoldne, indija
  [0.1,0.37,0.03,0.1,0.1,0.1,0.1,0.1],[0.98, 0.01, 0.01],[0.01,0.01,0.01,0.17,0.7,0.1] ,[0.5,0.45,0.05],[0.2,0.5,0.3],'Indija'   
};

%check probabilities
% Initialize a new cell array to store the sums
sumCellArray = cell(size(users_types));

% Loop over each cell and calculate the sum
for i = 1:size(users_types,1)
        for j = 1:size(users_types,2)
            sumCellArray{i,j} = sum(users_types{i,j});
        end 
end

user_weights_varNames = {'merchant_type' 'payment_type' 'shopping_hours', 'payment_method', 'amaunt', 'country'};

Transactions_User_models = cell2table(cell(1,7), 'VariableNames', {'transaction_id', 'merchant_type' 'payment_type' 'shopping_hours', 'payment_method', 'amaunt', 'country'});

UserWeights = cell2table(users_types, 'VariableNames', user_weights_varNames);

index = 1;

s = RandStream('mlfg6331_64','Seed', 420 );


%for time to unix
format longG

disp('start generateing')

%users
for i = 1:height(User)
    %chose random type of user
    user = UserWeights(randi([1,size(users_types,1)]),:);

    merchant_type_ids = datasample(s, unique(Merchant_types.merchant_type_id)  , locations_num ,'Weights',user.merchant_type);
    
    %locations
        for j = 1:locations_num
                locations_in_country_and_type =  Locations(Locations.merchant_type_id == merchant_type_ids(j) & strcmp(Locations.country, user.country) , :);
                
                %locations

                transaction_sizes = datasample(s, [1,2,3]  , trasactions_num ,'Weights',user.amaunt);

                transaction_times = datasample(s, [1,2,3,4,5,6]  , trasactions_num ,'Weights',user.shopping_hours);
                
                transaction_payment_methods = datasample(s, [1,2,3]  , trasactions_num ,'Weights',user.payment_method);

                transaction_payment_types = datasample(s, [1,2,3]  , trasactions_num ,'Weights',user.payment_type);

                for k = 1:trasactions_num
                    rand_location_index = randi([1,height(locations_in_country_and_type)]);

                    rand_location = locations_in_country_and_type(rand_location_index,:);

                    transaction_size = 0;

                    if transaction_sizes(k) == 1
                        transaction_size = randi([0,1000])/100;
                    end
                    if transaction_sizes(k) == 2
                        transaction_size = randi([1000,5000])/100;
                    end
                    if transaction_sizes(k) == 3
                        transaction_size = randi([5000,10000])/100;
                    end
                    

                    transaction_time = '';
                    if transaction_times(k) == 1
                        transaction_time = datetime(['2024-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([0,6])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 2
                       transaction_time = datetime(['2024-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([6,12])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 3
                        transaction_time = datetime(['2024-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([12,14])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                     if transaction_times(k) == 4
                       transaction_time = datetime(['2024-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([14,16])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 5
                       transaction_time = datetime(['2024-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([16,18])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 6
                       transaction_time = datetime(['2024-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([18,23])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end

                    transaction_payment_method = transaction_payment_methods(k);

                    transaction_payment_type = transaction_payment_types(k);

                    transaction_time.TimeZone = 'America/New_York';
                    time_temp = posixtime(transaction_time);

                    %'transaction_id' 'user_id' 'amount' 'location_id' 'date' 'time_since_last_here' 'merchant_frequency' 'fraudulent'
                    
                    Transactions = [Transactions; {index,i,transaction_size,rand_location.location_id, time_temp, 0,0, transaction_payment_type, transaction_payment_method 0}];
                    
                    Transactions_User_models{index,:} = [{index} table2cell(user)];

                    index = index + 1;
                end

            disp(index)
        end
end
%%
Transactions(1,:) = [];

%Make me some frauds
% %Nakupi v drugi državi 0.5%
% number_of_fraudsters = floor(height(Transactions) * 0.005);
% if number_of_fraudsters > 0
%     indices = randi([1, height(Transactions)], number_of_fraudsters, 1);
% 
%     samples = Transactions(indices, :);
%     samples.fraudulent = ones(number_of_fraudsters, 1); % Update this line
% 
%     for i = 1:number_of_fraudsters % Correct the loop condition
%         current_location_location_id = samples.location_id(i); % Correct indexing
%         current_location = Locations(Locations.location_id == current_location_location_id, :);
% 
%         found_valid_location = false; % Initialize flag
% 
%         for j = 1:100 % Loop to try random locations
%             try_me = randi([1, height(Locations)]);
%             try_me_location = Locations(try_me, :);
% 
%             if try_me_location.country_id ~= current_location.country_id
%                 samples.location_id(i) = try_me_location.location_id; % Update the location
%                 found_valid_location = true; % Set flag to true
%                 break; % Exit the loop once a valid location is found
%             end
%         end
% 
%         if ~found_valid_location % If no valid location found, display a message
%             disp('Warning: Could not find a valid location outside the country.');
%         end
%     end
% 
%     % Save the updated samples back to Transactions
%     Transactions(indices, :) = samples;
% end
% 
% %Nenavadne naprave 0.5%
% number_of_fraudsters = floor(height(Transactions) * 0.005);
% if number_of_fraudsters > 0
%     indices = randi([1, height(Transactions)], number_of_fraudsters, 1);
% 
%     samples = Transactions(indices, :);
%     samples.fraudulent = ones(number_of_fraudsters, 1); 
% 
%     for i = 1:number_of_fraudsters 
%         %get all previous 
%         previous_user_transactions = Transactions(Transactions.user_id == samples.user_id(i),:);
%         [cnt, gr] = groupcounts(previous_user_transactions.TransactionDevice);
%         least_likley_td = cnt(find(gr == min(gr),1));
%         samples.user_id(i) = least_likley_td;
%     end
% 
%     % Save the updated samples back to Transactions
%     Transactions(indices, :) = samples;
% end
% 
% Temp_Transactions = join(Transactions,Locations,"Keys","location_id");
% 
% %Nenavadne merchanti 0.5%
% number_of_fraudsters = floor(height(Transactions) * 0.005);
% if number_of_fraudsters > 0
%     indices = randi([1, height(Transactions)], number_of_fraudsters, 1);
% 
%     samples = Transactions(indices, :);
%     samples_temp = Temp_Transactions(indices, :);
%     samples.fraudulent = ones(number_of_fraudsters, 1); 
% 
%     for i = 1:number_of_fraudsters 
%         %get all previous 
%         previous_user_transactions = Temp_Transactions(Temp_Transactions.merchant_type_id == samples_temp.merchant_type_id(i),:);
%         [cnt, gr] = groupcounts(previous_user_transactions.merchant_type_id);
%         samples.location_id(i) = samples.location_id(find(gr == min(gr),1));
%     end
% 
%     % Save the updated samples back to Transactions
%     Transactions(indices, :) = samples;
% end
% 
% %Nenavadne velikosti 0.5%
% number_of_fraudsters = floor(height(Transactions) * 0.005);
% if number_of_fraudsters > 0
%     indices = randi([1, height(Transactions)], number_of_fraudsters, 1);
% 
%     samples = Transactions(indices, :);
%     samples.fraudulent = ones(number_of_fraudsters, 1); 
% 
%     for i = 1:number_of_fraudsters 
%         %get all previous 
%         previous_user_transactions = Transactions(Transactions.amount == samples.amount(i),:);
%         [cnt, gr] = groupcounts(previous_user_transactions.amount);
%         least_likley_td = cnt(find(gr == min(gr),1));
%         samples.amount(i) = least_likley_td+randi([1,10]);
%     end
% 
%     % Save the updated samples back to Transactions
%     Transactions(indices, :) = samples;
% end
% 
% 
% 
% 
% %order the Transactions
% disp('wait for sorting please')
% Transactions  = sortrows(Transactions , 'date');
% disp('omg done')
% 
% 
% %Majhne zaporedne 1%
% number_of_fraudsters = floor(height(Transactions) * 0.005);
% if number_of_fraudsters > 0
%     indices = randi([1, height(Transactions)], number_of_fraudsters, 1);
% 
%     samples = Transactions(indices, :);
%     samples.fraudulent = ones(number_of_fraudsters, 1); 
% 
%     for i = 1:number_of_fraudsters 
% 
%         number = randi([1,5]);
%         fr = samples(i,:);
% 
%         for j =2:number+1
%             if(size(samples,1)>= j)
%                 fr.date = fr.date + randi([60000,600000]);
%                 samples(j,:) = fr;
%             end
%         end
%     end
% 
%     % Save the updated samples back to Transactions
%     Transactions(indices, :) = samples;
% end


AllTransactions = table();
%za vsakega userja
transakcije_na_userja = floor(locations_num*trasactions_num);

for i = 1:users_num
    User_Transactions = Transactions(Transactions.user_id == i,:);
    User_Transactions  = sortrows(User_Transactions , 'date', 'descend');
    for j = 1:10:transakcije_na_userja
        if j+10 > height(User_Transactions)
            break
        end
        Frame_Transactions = User_Transactions(j:j+9,:);

        choose_fraud = randi([1,3]);
        if(i > size(Frame_Transactions,2))
            break
        end
        t_id = Frame_Transactions(i,:).transaction_id;
        aaa = find([Transactions_User_models.transaction_id{:}] == t_id);
        user_model = Transactions_User_models(aaa,:);

        if choose_fraud == 1
            
        end

        if choose_fraud == 2
            for k = 1:3
                in = randi([2,10]);
                temp = makeFraudulent(Frame_Transactions(in,:),Locations,user_model);
                Frame_Transactions(in,:) = temp;
            end
            Frame_Transactions(1,:) = makeFraudulent(Frame_Transactions(1,:),Locations,user_model);
        end
        
        if choose_fraud == 3
            for k = 1:3
                in = randi([2,10]);
                temp = makeFraudulent(Frame_Transactions(in,:),Locations,user_model);
                Frame_Transactions(in,:) = temp;
            end
        end

        if choose_fraud == 4
            num = randi([2,5],1);
            first_t = Frame_Transactions(1,:);
            for k = 2:num
                tem_t = Frame_Transactions(k,:);
                temp_t.location = first_t.location;
                temp_t.amount = first_t.amount;
                temp_t.date = first_t.date + randi([60,120]);
                temp_t.fraudulent = 1;
                Frame_Transactions(k,:) = Frame_Transactions(k,:);
            end
        end

        AllTransactions = vertcat(AllTransactions,Frame_Transactions);
    end
end


%order the Transactions
disp('wait for sorting please')
Transactions  = sortrows(AllTransactions , 'date', 'descend');
disp('omg done')



%calculate last time here
% disp('wait for additional calculations')
% 
% all_user_ids = Temp_Transactions.user_id;
% all_locations = Temp_Transactions.location_id;
% all_merchants = Temp_Transactions.merchant_type_id;
% 
% frequencies = zeros(size(Transactions, 1), 1);
% for i = 1:size(Transactions, 1)
%     previous_indices = find(all_user_ids(1:i-1) == all_user_ids(i));
%     if ~isempty(previous_indices)
%         previous_merchants = all_merchants(previous_indices);
%         frequencies(i) = sum(previous_merchants == all_merchants(i)) / numel(previous_merchants);
%     end
% end
% Transactions(:, 'merchant_frequency') = num2cell(frequencies);
% 
% 
% 
% disp('omg done')




for i = 1:height(Transactions)
    Transactions.merchant_frequency = num2str(Transactions.merchant_frequency);
end


%"TransactionId", "UserId", "Amount", "LocationId", "DateTime", "TimeSince", "MerchantFreq", "MerchantType", "TransactionDevice"

writetable(Transactions,'transactions.csv')
writetable(User,'users.csv')
writetable(Mesta,'mesta.csv')
writetable(Locations,'locations.csv')




% Define the columns you want to include in Transactions_2
newColumns =      {  'TransactionId', 'UserId',  'Amount', 'LocationId', 'DateTime', 'TimeSince',          'MerchantFreq', 'TransactionType', 'TransactionDevice',  'Fraudulent'    }; %        'MerchantType', 'TransactionType', 'TransactionDevice'};
selectedColumns = {  'transaction_id','user_id', 'amount', 'location_id', 'date', 'time_since_last_here', 'merchant_frequency', 'TransactionType', 'TransactionDevice','fraudulent' };

% Create Transactions_2 with only the selected columns
Transactions_sven = Transactions(:, selectedColumns);
Transactions_sven.Properties.VariableNames = newColumns;


Transactions_Locations = join(Transactions,Locations,"Keys","location_id");

Transactions_sven = addvars(Transactions_sven, Transactions_Locations.merchant_type_id, 'NewVariableName', 'MerchantType');


writetable(Transactions_sven,'transactions_sven.csv')