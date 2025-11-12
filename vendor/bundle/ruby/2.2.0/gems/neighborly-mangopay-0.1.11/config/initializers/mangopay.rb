MangoPay.configure do |c|
  c.preproduction     = Configuration[:mangopay_preproduction] == 'TRUE' ? true : false
  c.client_id         = Configuration[:mangopay_client_id]
  c.client_passphrase = Configuration[:mangopay_client_passphrase]
end
