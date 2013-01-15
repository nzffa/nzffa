if RAILS_ENV == 'production'
  px_pay_user_id = 'NZFFAOnline'
  px_pay_key = 'b8580cfd75ca98821043b830f6ec2b4b68858bf8cb0ba225bc3758b52dc5725c'
else
  px_pay_user_id = 'NZFFA_dev'
  px_pay_key = '0edb744f3d87e729ae22dc66dcdd7db8bc52ac5dbcb6ca613ef99d457481ad35'
end

PX_PAY_PARTY_SETTINGS = { :currency => 'NZD',
                          :px_pay_user_id => px_pay_user_id,
                          :px_pay_key => px_pay_key}
