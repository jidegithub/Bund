Feature: Account Manager Accesses Sign In Form

   As an account Manager, I want to access the Sign In Form so that I can perform operations

   Scenario: Account Manager Accesses Home Page 
       Given that Account Manager is on a browser

        When the root path is accessed
        Then the home page is displayed with a Sign In form with heading Sign Into Account 
         And with fields (Email Address,Password,a Sign In button)
         And a link to Forgot Password? and a button Register

#    Scenario: Account Manager Signs In Successfully
#        Given that Account Manager accesses the Sign In form 
#         When the mandatory fields (Email Address,Password) are correctly filled
#         Then the page displays a dashboard with tabs Accounts,Leads,Report,Opportunities
#          And Icons at the top is displayed with tabs Mail,Alarm,Support
#          And a drop down for Account Managers with an icon Profile Picture,First Name will be displayed

#    Scenario: Account Manager Unsuccessfully Signs In 
#        Given that Account Manager accesses the Sign In form
#         When the Sign In form fields (Email Address,Password) is incorrectly filled
#         Then the page displays Couldn't find your Email Address
#          And the page displays Wrong password.Try again or click Forgot password to reset it. for wrong password 