clear all;

users_num = 10;
locations_num = 10;
trasactions_num = 10;

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

transactions_t = {0,0,0,0,0,0,0,0};


transactions_varNames = {'transaction_id' 'user_id' 'amount' 'location_id' 'date' 'time_since_last_here' 'merchant_frequency' 'fraudulent'};


Transactions = cell2table(transactions_t, 'VariableNames', transactions_varNames);


%typical users
%merchants 8, tipi kartice 3, časi 6, medij, velikost, država
users_types = {
  %nakupovalec na netu,popoldne, slovenija
  [0.1,0.11,0.03,0.1,0.1,0.1,0.1,0.1],[0.98, 0.01, 0.01],[0.01,0.01,0.01,0.1,0.7,0.1] ,[0.5,0.45,0.05],[0.2,0.5,0.3],'Slovenija' 
  %nakupovalec na netu, popoldne, egipt
  [0.1,0.11,0.03,0.1,0.1,0.1,0.1,0.1],[0.98, 0.01, 0.01],[0.01,0.01,0.01,0.1,0.7,0.1] ,[0.5,0.45,0.05],[0.2,0.5,0.3],'Egipt'
  %nakupovalec na netu, popoldne, indija
  [0.1,0.11,0.03,0.1,0.1,0.1,0.1,0.1],[0.98, 0.01, 0.01],[0.01,0.01,0.01,0.1,0.7,0.1] ,[0.5,0.45,0.05],[0.2,0.5,0.3],'Indija'   
};


index = 1;

s = RandStream('mlfg6331_64','Seed', 420 );


%for time to unix
format longG


%users
for i = 1:height(User)
    %chose random type of user
    user = users_types(randi([1,size(users_types,1)]),:);

    merchant_type_ids = datasample(s, Merchant_types.merchant_type_id  , locations_num ,'Weights',user{1});
    
    %locations
        for j = 1:locations_num
            locations_in_country_and_type =  Locations(Locations.merchant_type_id == merchant_type_ids(j) & strcmp(Locations.country, user{6}) , :);
            
            %locations

                transaction_sizes = datasample(s, [1,2,3]  , trasactions_num ,'Weights',user{5});

                transaction_times = datasample(s, [1,2,3,4,5,6]  , trasactions_num ,'Weights',user{3});
                
                transaction_times = datasample(s, [1,2,3,4,5,6]  , trasactions_num ,'Weights',user{3});
                
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
                        transaction_time = datetime(['2016-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([0,6])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 2
                       transaction_time = datetime(['2016-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([6,12])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 3
                        transaction_time = datetime(['2016-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([12,14])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                     if transaction_times(k) == 4
                       transaction_time = datetime(['2016-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([14,16])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 5
                       transaction_time = datetime(['2016-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([16,18])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end
                    if transaction_times(k) == 6
                       transaction_time = datetime(['2016-' num2str(randi([1,12])) '-' num2str(randi([1,28])) ' ' num2str(randi([18,23])) ':' num2str(randi([0,59])) ':' num2str(randi([0,59]))]);
                    end

                    transaction_time.TimeZone = 'America/New_York';
                    time_temp = posixtime(transaction_time);

                    %'transaction_id' 'user_id' 'amount' 'location_id' 'date' 'time_since_last_here' 'merchant_frequency' 'fraudulent'
                    
                    Transactions = [Transactions; {index,i,transaction_size,rand_location.location_id, time_temp, 0,0,0}];

                    index = index + 1;
                end
        end
       disp(index)
end

Transactions(1,:) = [];

%Make me some frauds
%Nakupi v drugi državi 0.5%
number_of_fraudsters = floor(height(Transactions) * 0.005);
if number_of_fraudsters > 0
    indices = randi([1, height(Transactions)], number_of_fraudsters, 1);
    
    samples = Transactions(indices, :);
    samples.fraudulent = ones(number_of_fraudsters, 1); % Update this line

    for i = 1:number_of_fraudsters % Correct the loop condition
        current_location_location_id = samples.location_id(i); % Correct indexing
        current_location = Locations(Locations.location_id == current_location_location_id, :);
        
        found_valid_location = false; % Initialize flag
        
        for j = 1:100 % Loop to try random locations
            try_me = randi([1, height(Locations)]);
            try_me_location = Locations(try_me, :);
            
            if try_me_location.country_id ~= current_location.country_id
                samples.location_id(i) = try_me_location.location_id; % Update the location
                found_valid_location = true; % Set flag to true
                break; % Exit the loop once a valid location is found
            end
        end
        
        if ~found_valid_location % If no valid location found, display a message
            disp('Warning: Could not find a valid location outside the country.');
        end
    end
    
    % Save the updated samples back to Transactions
    Transactions(indices, :) = samples;
end


%%
%order the Transactions
disp('wait for sorting please')
Transactions  = sortrows(Transactions , 'date');
disp('omg done')
%%
Temp_Transactions = join(Transactions,Locations,"Keys","location_id");
%calculate last time here
disp('wait for additional calculations')

all_user_ids = Temp_Transactions.user_id;
all_locations = Temp_Transactions.location_id;
all_merchants = Temp_Transactions.merchant_type_id;

frequencies = zeros(size(Transactions, 1), 1);
for i = 1:size(Transactions, 1)
    previous_indices = find(all_user_ids(1:i-1) == all_user_ids(i));
    if ~isempty(previous_indices)
        previous_merchants = all_merchants(previous_indices);
        frequencies(i) = sum(previous_merchants == all_merchants(i)) / numel(previous_merchants);
    end
end
Transactions(:, 'merchant_frequency') = num2cell(frequencies);

% for n = 1:height(Transactions)
% 
%     %find user Transactions
%     user_indexes = cell2mat(Transactions(1:n, 2));
% 
%     matching_user_indexes = find(user_indexes(1:n-1) == cell2mat(Transactions(n,2)));
% 
%     userTransactions_before = Transactions(matching_user_indexes,:);
%     userTransaction_current = cell2mat(Transactions(n,:));
% 
%     if ~isempty(userTransactions_before)
% 
%         location_indexes = cell2mat(userTransactions_before(:, 4));
%         matchingIndices = find(location_indexes == userTransaction_current(4));
% 
%         merchant_indexes = cell2mat(userTransactions_before(:, 5));
%         merchant_index_current = userTransaction_current(5);
%         frequency = (sum(merchant_indexes(:)==merchant_index_current))/height(merchant_indexes);
%         Transactions{n,8} = frequency;
%     end
% end

disp('omg done')

%%


for i = 1:height(Transactions)
    Transactions.merchant_frequency = num2str(Transactions.merchant_frequency);
end

%%
%"TransactionId", "UserId", "Amount", "LocationId", "DateTime", "TimeSince", "MerchantFreq", "MerchantType", "TransactionDevice"

writetable(Transactions,'transactions.csv')
writetable(User,'users.csv')
writetable(Mesta,'mesta.csv')
writetable(Locations,'locations.csv')

%%


% Define the columns you want to include in Transactions_2
newColumns =      {  'TransactionId', 'UserId',  'Amount', 'LocationId', 'DateTime', 'TimeSince',          'MerchantFreq',   'Fraudulent'    }; %        'MerchantType', 'TransactionType', 'TransactionDevice'};
selectedColumns = {  'transaction_id','user_id', 'amount', 'location_id', 'date', 'time_since_last_here', 'merchant_frequency','fraudulent' };

% Create Transactions_2 with only the selected columns
Transactions_sven = Transactions(:, selectedColumns);
Transactions_sven.Properties.VariableNames = newColumns;


Transactions_Locations = join(Transactions,Locations,"Keys","location_id");

Transactions_sven = addvars(Transactions_sven, Transactions_Locations.merchant_type_id, 'NewVariableName', 'MerchantType');
Transactions_sven =  addvars(Transactions_sven, zeros(height(Transactions_sven), 1), 'NewVariableName', 'TransactionType');
Transactions_sven =  addvars(Transactions_sven, zeros(height(Transactions_sven), 1), 'NewVariableName', 'TransactionDevice');


writetable(Transactions_sven,'transactions_sven.csv')