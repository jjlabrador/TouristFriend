# encoding: UTF-8
require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'TouristFriend' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
    it { should have_selector('h2')}

    it "links del home" do
      click_link "Registrar Usuario"
      page.should have_selector 'title', text: "Registro - Usuarios"
    end     


    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        sign_in user
        visit root_path
      end
    end
 end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Ayuda' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Ayuda' }
    it { should have_selector('p')} 
 end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'Acerca de' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Acerca de nosotros' }
    it { should have_selector('p')}
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contacto' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Contacto' }
    it { should have_selector('p')}
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Acerca de"
    page.should have_selector 'title', text: full_title('')
    click_link "Ayuda"
    page.should have_selector 'title', text: full_title('')
    click_link "Contacto"
    page.should have_selector 'title', text: full_title('')
    click_link "Inicio"
    page.should have_selector 'title', text: full_title('')
    click_link "Iniciar sesión"
    page.should have_selector 'title', text: full_title('')
    click_link "TouristFriend"
    page.should have_selector 'title', text: full_title('')
  end
end
