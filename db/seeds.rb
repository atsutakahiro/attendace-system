# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",    
             affiliation: "管理部門",
             employee_number: 1,
             uid: 1,
             password: "password",
             password_confirmation: "password",
             admin: true)

User.create!(name: "上長A",
            email: "sampleA@email.com",
            password: "password",
            password_confirmation: "password",
            affiliation: "役員",
            employee_number: 1,
            uid: 1,
            superior: true)

User.create!(name: "上長B",
            email: "sampleB@email.com",
            password: "password",
            password_confirmation: "password",
            affiliation: " 役員",
            employee_number: 2,
            uid: 2,
            superior: true)

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,     
               password: password,
               password_confirmation: password)
end
