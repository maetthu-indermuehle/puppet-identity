require 'spec_helper'

describe 'identity::user', :type => :define do
  let(:title) { 'testuser'}

  it { should contain_user('testuser') }
  it { should contain_group('testuser') }

  context 'with ensure => absent' do
    let(:params) { { 'ensure' => 'absent' } }
    it { should contain_user('testuser').with_ensure('absent') }
    it { should contain_group('testuser').with_ensure('absent') }
    context 'with ensure => absent and manage_home => true' do
      it { should contain_file('/home/testuser').with_ensure('absent') }
    end
  end

  # ignore_uid_gid functionality
  context 'with ignore_uid_gid => false and uid define' do
    let(:params) { { 'ignore_uid_gid' => false, 'uid' => 1000 } }
    it { should contain_user('testuser').with_uid(1000) }
    it { should contain_group('testuser').with_gid(1000) }
  end
  context 'with ignore_uid_gid => true and uid defined' do
    let(:params) { { 'ignore_uid_gid' => true, 'uid' => 1000 } }
    it { should contain_user('testuser').with_uid(nil) }
    it { should contain_group('testuser').with_gid(nil) }
  end

  # manage_dotfiles
  context 'with manage_dotfiles => true' do
    let(:params) { { 'manage_dotfiles' => true } }
    it { should contain_file('/home/testuser').with_ensure('directory') }
  end
  context 'with manage_dotfiles => true and manage_home => false' do
    let(:params) { { 'manage_dotfiles' => true, 'manage_home' => false } }
    it { should_not contain_file('/home/testuser') }
  end

  # ssh keys
  describe "with ssh keys" do
    let(:params) {{
      :ssh_keys => { 'main' => { 'key' => 'thisisnotakey' } }
    }}
    it { is_expected.to have_ssh_authorized_key_resource_count(1) }
  end

end
