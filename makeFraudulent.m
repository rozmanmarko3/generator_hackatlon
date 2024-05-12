function fraudulentTransaction = makeFraudulent(transaction, Locations, user_model)
%UNTITLED Summary of this function goes here
%which type
tp = randi([1,2]);
%
if tp == 1
    %sumljiva drzava
    this_loc = Locations(find(Locations.location_id == transaction.location_id),:);
    for i = 1:10
        loc_inx = randi([1,height(Locations)]);
        rand_loc = Locations(loc_inx,:);
        if(rand_loc.country_id ~= this_loc.country_id)
            transaction.location_id = rand_loc.location_id;
            transaction.fraudulent = 1;
            fraudulentTransaction = transaction;
            return
        end
        fraudulentTransaction = transaction;
    end
end
if tp == 2
    %sumljiv transaction type
    gp = [user_model.payment_type{:}];
    min_c_inx = find(gp == min(gp),1);

    transaction.TransactionType = min_c_inx;
    fraudulentTransaction = transaction;
end

end

