require 'spec_helper'

describe "Static pages" do
  
  it "should have the right links on the layout" do
      visit root_path
      
      click_link "About"
      page.should have_selector 'title', text: 'About'
      
      click_link "Help"
      page.should have_selector 'title', text: 'Help'
      
      click_link "Contact"
      page.should have_selector 'title', text: 'Contact'
      
      click_link "Home"
      
      click_link "Sign up now!"
      page.should have_selector 'title', text: 'Sign up'
      
      click_link "sample app"
      page.should have_selector 'title', text: 'Home'
  end
  
  subject {page}
  
  shared_examples_for "all static pages" do
      it { should have_selector('h1',    text: heading) }
      it { should have_selector('title', text: page_title) }
  end
  
  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { ' | Home' }
    
    it_should_behave_like "all static pages"
    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
        
      before(:all) { 30.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") } }
      after(:all)  { User.delete_all }
        
      before(:each) do
        sign_in user
        visit root_path
      end
      
      it "should contain the # of microposts" do
        page.should have_content("#{user.microposts.count} microposts")
      end
      
      describe "pagination" do
        it {should have_selector('div.pagination')}
        
        it "should list each feed" do
          user.feed.paginate(page: 1).each do |f|
            page.should have_selector('li', text: f.content)
          end
        end
      end
    end
  end
  
  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { ' | Help' }

    it_should_behave_like "all static pages"
  end
  
  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { ' | About' }

    it_should_behave_like "all static pages"
  end
    
  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { ' | Contact' }

    it_should_behave_like "all static pages"
  end
  
end
