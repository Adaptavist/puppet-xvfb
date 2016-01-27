require 'spec_helper'

describe 'xvfb', :type => 'class' do

  let(:facts) {{
    :osfamily => 'Debian'
  }}

  context "Should install xvfb and create init script with default params" do
    it do
      should contain_package('xvfb')
      should contain_file('/etc/init.d/xvfb')
        .with(
          'mode' => '0755'
        )
        .with_content(/USER=hosting/)
        .with_content(/XVFBARGS=":99 -ac"/)
      should contain_service('xvfb')
    end
  end

  context "Should install xvfb and create init script with params" do
    let(:params) {{
      :user    => 'spec',
      :options => ':20 -once'
    }}

    it do
      should contain_package('xvfb')
      should contain_file('/etc/init.d/xvfb')
        .with(
          'mode' => '0755'
        )
        .with_content(/USER=spec/)
        .with_content(/XVFBARGS=":20 -once"/)
      should contain_service('xvfb')
    end
  end

  context "Should fail with unsupported OS family" do
    let(:facts) {
     { :osfamily     => 'Solaris' }
    }

    it do
      should raise_error(Puppet::Error, /xvfb - Unsupported Operating System family: Solaris/)
    end
  end

  context "Redhat should use systemd" do
    let(:facts) {
      { :osfamily => 'RedHat' }
    }
    let(:params) {{
        :user    => 'spec',
        :options => ':20 -once'
    }}
    it do
      should contain_package('xorg-x11-server-Xvfb')
      should contain_file('/etc/systemd/system/xvfb.service')
                 .with(
                     'mode' => '0644'
                 )
                 .with_content(/User=spec/)
                 .with_content(/ExecStart.*Xvfb :20 -once/)
      should contain_service('xvfb')
    end
  end
end
